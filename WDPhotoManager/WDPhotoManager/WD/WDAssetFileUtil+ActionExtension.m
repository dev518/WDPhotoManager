//
//  WDAssetFileUtil+ActionExtension.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/23.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDAssetFileUtil+ActionExtension.h"

@implementation WDAssetFileUtil (ActionExtension)
+ (void)saveImages:(NSArray <UIImage *> *)images completion:(void (^)(NSError *))completion{
    for (UIImage *img in images) {
        [self saveImage:img completion:^(NSError * error) {
            
        }];
    }
    completion(nil);
}

+ (void)saveImage:(UIImage *)images completion:(void (^)(NSError *))completion{
    
}

@end
