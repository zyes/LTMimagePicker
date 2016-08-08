//
//  adViewController.m
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/21.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "adViewController.h"
#import "PhotoPickerCell.h"
#import "YYKit.h"
#import "YYFPSLabel.h"
static CGFloat CELL_ROW = 4;
static CGFloat CELL_MARGIN = 2;
static CGFloat CELL_LINE_MARGIN = 2;
static CGFloat TOOLBAR_HEIGHT = 44;
@interface adViewController (){
    NSMutableArray * _assetsArr;
    NSMutableArray * _selectArr;
}
@property(nonatomic,strong)PhotoPickerCollectionView *collectionview;
@property(nonatomic,strong)ALAssetsLibrary * assetsLibrary;
@property(nonatomic ,strong)UIView *buttomview;
@property(nonatomic,strong)ALAssetsGroup *assetgroup;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation adViewController

#pragma mark -传入一个组获取组里面的Asset
- (void) getGroupPhotosWithGroup : (ALAssetsGroup *) pickerGroup finished : (groupCallBackBlock ) callBack{
    
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset , NSUInteger index , BOOL *stop){
        if (asset) {
            [assets addObject:asset];
        }else{
            callBack(assets);
        }
    };
    [pickerGroup enumerateAssetsUsingBlock:result];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _fpsLabel = [[YYFPSLabel alloc]initWithFrame:CGRectMake(10, 0, 30, 40)];
//    _fpsLabel.backgroundColor=[UIColor greenColor];
    _fpsLabel.alpha = 1;
    [self.view addSubview:_fpsLabel];
    //获取相册的数据
    [self setupAssets];
    //初始化
    [self initobject];
   
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.backgroundColor=[UIColor greenColor];
    _fpsLabel.bottom = self.view.height - 12;
    _fpsLabel.left = 12;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    // Do any additional setup after loading the view.
}
-(void)configbuttomView{
  
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)initobject{
    _assetsArr=[NSMutableArray array];
    _selectArr=[NSMutableArray array];
}
-(void)setupAssets{
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // 相册分组
        if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == 16) {
            
            // 存储相册信息的数组
            __block   NSMutableArray * photos = [NSMutableArray array];
            __weak typeof(self) weakself=self;
            // 表示默认的是系统的相册
//            [self getGroupPhotosWithGroup:group finished:^(id obj) {
//                NSArray *arrasset=(NSArray *)obj;
//                [arrasset enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    ALAsset *result=(ALAsset *)obj;
//                    if (result) {
//                    PhotoAsset *lgAsset = [[PhotoAsset alloc] init];
//                    lgAsset.asset = result;
//                    [photos addObject:lgAsset];
//                    }
//                }];
//                weakself.collectionview.dataArr=photos;
//                _assetsArr=[photos mutableCopy];
//            }];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    
                    PhotoAsset *lgAsset = [[PhotoAsset alloc] init];
                    lgAsset.asset = result;
                    [photos addObject:lgAsset];
                }
            }];
            weakself.collectionview.dataArr=photos;
            _assetsArr=[photos mutableCopy];
        }
    }failureBlock:^(NSError *error) {
        
    }];
    });
}

-(PhotoPickerCollectionView *)collectionview{
if (!_collectionview) {
        CGFloat cellW = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, TOOLBAR_HEIGHT * 2);
    //滚动的方向
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.collectionview=[[PhotoPickerCollectionView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44-44) collectionViewLayout:layout];
    self.collectionview.backgroundColor=[UIColor redColor];
        self.collectionview.collectdelegate=self;
        self.collectionview.translatesAutoresizingMaskIntoConstraints = NO;

        [self.collectionview registerClass:[PhotoPickerCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:self.collectionview];

}
    return _collectionview;
}
//点击这个按钮的协议方法
-(void)pickerCollectionViewDidSelected:(PhotoPickerCollectionView *)pickerCollectionView deleteAsset:(PhotoAsset *)deleteAssets{
    if (deleteAssets) {
        NSArray *arr=[_selectArr copy];
        for (PhotoAsset *asset in arr) {
            if ([asset.assetURL isEqual:deleteAssets.assetURL]) {
                [_selectArr removeObject:asset];
            }
        }
    }else if (!deleteAssets){
        [_selectArr addObject:[pickerCollectionView.selectArr lastObject]];
    }
}
-(void)pickerCollectionCellTouchedIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
