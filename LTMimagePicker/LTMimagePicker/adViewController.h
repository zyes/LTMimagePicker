//
//  adViewController.h
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/21.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPickerCollectionView.h"
// 回调
typedef void(^groupCallBackBlock)(id obj);
@interface adViewController : UIViewController<PhotoPickerCollectionViewDelegate>

@end
