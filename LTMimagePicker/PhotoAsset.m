//
//  PhotoAsset.m
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/20.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "PhotoAsset.h"

@implementation PhotoAsset
-(UIImage *)thumbImage{
    if (SYSTEMVERSION>=9) {
        return [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    } else {
        return [UIImage imageWithCGImage:[self.asset thumbnail]];
    }
}
-(NSURL *)assetURL{
    return [[self.asset defaultRepresentation] url];
}
@end
