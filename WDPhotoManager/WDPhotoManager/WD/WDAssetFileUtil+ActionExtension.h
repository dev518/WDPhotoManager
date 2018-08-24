//
//  WDAssetFileUtil+ActionExtension.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/23.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDAssetFileUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDAssetFileUtil (ActionExtension)
#pragma mark - api for action extension
+ (void)saveImages:(NSArray <UIImage *> *)images completion:(void (^)(NSError *))completion;
@end

NS_ASSUME_NONNULL_END
