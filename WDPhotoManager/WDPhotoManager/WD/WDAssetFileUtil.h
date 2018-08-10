//
//  WDAssetFileUtil.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/2.
//  Copyright © 2018 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMGSUFFIX @".jpg"
#define GIFSUFFIX @".gif"
#define MOVSUFFIX @".MOV"



NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@interface WDAssetFileUtil : NSObject
+ (NSString *)defaultPath;
+ (NSString *)pathForAsset:(PHAsset *)asset;

+ (void)saveAsset:(PHAsset *)asset filePath:(NSString *)filePath completion:(void (^)(NSError *))completion;

+ (void)saveAssets:(NSArray <PHAsset *> *)assets completion:(void (^)(NSError *))completion;

+ (void)loadAssetWithFilePath:(NSString *)filePath completion:(void (^)(NSData *))completion;
@end

NS_ASSUME_NONNULL_END
