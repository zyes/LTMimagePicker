//
//  PhotoPickerImageView.m
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/20.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "PhotoPickerImageView.h"
@interface PhotoPickerImageView ()
@property (nonatomic, strong) UIImageView *tickImageView;
@end
@implementation PhotoPickerImageView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}
-(UIImageView *)tickImageView{
    if (!_tickImageView) {
        UIImageView *tickImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 28, 5, 21, 21)];
        tickImageView.image = [UIImage imageNamed:@"checkbox_pic_non"];
        [self addSubview:tickImageView];
        _tickImageView=tickImageView;
    }
    return  _tickImageView;
}
-(void)setMaskViewFlag:(BOOL)maskViewFlag{
    _maskViewFlag=maskViewFlag;
    if (!self.maskViewFlag) {
        [self.tickImageView setImage:[UIImage imageNamed:@"checkbox_pic_non"]];
    }else{
        [self.tickImageView setImage:[UIImage imageNamed:@"checkbox_pic"]];
    }
}
@end
