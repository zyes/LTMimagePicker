//
//  PhotoPickerCollectionView.m
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/20.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "PhotoPickerCollectionView.h"
#import "PhotoPickerCell.h"
#import "PhotoPickerImageView.h"

@interface PhotoPickerCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)PhotoAsset *asset;
@property(nonatomic,strong)NSArray *assests;
@property(nonatomic,strong)UIImage *assetimage;
@end
@implementation PhotoPickerCollectionView
-(void)setDataArr:(NSArray *)dataArr{
   
    _dataArr=dataArr;
    self.assests=_dataArr;
//    NSMutableArray *selectArr=[NSMutableArray array];
//    for (PhotoAsset *asset in self.selectArr) {
//        for (PhotoAsset *asset1 in self.dataArr) {
//            if ([asset isKindOfClass:[UIImage class]] || [asset1 isKindOfClass:[UIImage class]]) {
//                continue;
//            }
//            if ([asset.asset.defaultRepresentation.url isEqual:asset1.asset.defaultRepresentation.url]) {
//                [selectArr addObject:asset1];
//                break;
//            }
//        }
//        self.selectArr=selectArr;
//    }
    [self reloadData];
    
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self=[super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor=[UIColor clearColor];
        self.delegate=self;
        self.dataSource=self;
        self.selectArr=[NSMutableArray array];
    }
    return self;
}
//给cell设置图片以及选择的状态
-(void)setCellWithImage:(PhotoPickerCell *)cell Atindex:(NSIndexPath *)indexPath{
    PhotoPickerImageView *cellimage=nil;
  
    if (cell.contentView.subviews.count==2&&[cell.contentView.subviews[0] isKindOfClass:[UIView class]]) {
        cellimage=cell.contentView.subviews[0];
    }else{
        cellimage=[[PhotoPickerImageView alloc]initWithFrame:cell.bounds];
        [cell.contentView addSubview:cellimage];
    }
    
//    self.assetimage=self.asset.thumbImage;
//    self.assetimage=[self cutImage:self.assetimage];
        cellimage.image=self.asset.thumbImage;
    cellimage.backgroundColor=[UIColor grayColor];
    cellimage.maskViewFlag=NO;
    for (NSInteger i=0; i<self.selectArr.count; i++) {
        PhotoAsset *selectasset=self.selectArr[i];
        if ([selectasset.assetURL isEqual:self.asset.assetURL]) {
            cellimage.maskViewFlag=YES;
        }
    }
}
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((image.size.width / image.size.height) < 1) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * 1;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * 1;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *maskview=nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        maskview=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerview" forIndexPath:indexPath];
//        UILabel *l=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        l.backgroundColor=[UIColor redColor];
//        [maskview addSubview:l];
//    }
//    return maskview;
//}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectdelegate respondsToSelector:@selector(pickerCollectionCellTouchedIndexPath:)]) {
        [self.collectdelegate pickerCollectionCellTouchedIndexPath:indexPath];
    }
}
//设置选中按钮
-(void)setupPickButton:(PhotoPickerCell *)cell Atindex:(NSIndexPath *)index{
    UIButton  *tickbtn=nil;
    if (cell.contentView.subviews.count==2&&[cell.contentView.subviews[1] isKindOfClass:[UIButton class]]) {
        tickbtn=cell.contentView.subviews[1];
    }else{
        tickbtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-40, 0, 40, 40)];
        [tickbtn setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:tickbtn];
        [tickbtn addTarget:self action:@selector(touchbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    tickbtn.tag=index.item;
}
-(void)touchbtn:(UIButton *)sender{
    NSIndexPath *index=[NSIndexPath indexPathForItem:sender.tag inSection:0];
    PhotoPickerCell *cell=(PhotoPickerCell *)[self cellForItemAtIndexPath:index];
    PhotoAsset *asset=(PhotoAsset *)self.dataArr[index.item];
    PhotoPickerImageView *imageview=cell.contentView.subviews[0];
    if ([imageview isKindOfClass:[PhotoPickerImageView class]] &&imageview.maskViewFlag) {
        [self.selectArr removeObject:asset];
    }else{
        if (self.selectArr.count>=9) {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"最多只能选9张图片" message:@"提醒" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的 ", nil];
            [av show];
            return;
        }
        [self.selectArr addObject:asset];
    }
    //触发代理事件
    if ([self.collectdelegate respondsToSelector:@selector(pickerCollectionViewDidSelected:deleteAsset:)]) {
        if (imageview.maskViewFlag) {
            [self.collectdelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
        }else{
            [self.collectdelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
        }
        
    }
    imageview.maskViewFlag=!imageview.maskViewFlag;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoPickerCell *cell=[PhotoPickerCell cellWithCollectionview:collectionView cellForItemAtindex:indexPath];
    cell.contentView.backgroundColor=[UIColor blackColor];
    self.asset=self.assests[indexPath.item];
    
    [self setCellWithImage:cell Atindex:indexPath];
    [self setupPickButton:cell Atindex:indexPath];
    return cell;
}
//让clooection从最下面开始展示
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 时间置顶的话
    // 滚动到最底部（最新的）
//    if (self.dataArr.count!=0) {
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArr.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
//        // 展示图片数
//        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 100);
//    }
    

}

@end
