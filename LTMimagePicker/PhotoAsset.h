//
//  PhotoAsset.h
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/20.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface PhotoAsset : NSObject
@property(nonatomic,strong)ALAsset *asset;
/**
 *  缩略图
 */
- (UIImage *)thumbImage;
/**
 *  获取相册的URL
 */
- (NSURL *)assetURL;
@end
