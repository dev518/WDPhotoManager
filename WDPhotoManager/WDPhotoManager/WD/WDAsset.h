//
//  WDAsset.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/15.
//  Copyright © 2018 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDAsset : NSObject
@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, copy) NSString *fileDirectoty;
@property(nonatomic, strong) UIImage *thumbnailImage;

+ (instancetype)initWithFileDirectoty:(NSString *)fileDirectoty;
@end

NS_ASSUME_NONNULL_END
