//
//  WDAssetFileUtil.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/2.
//  Copyright © 2018 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IMGSUFFIX @".jpg"
#define GIFSUFFIX @".gif"
#define MOVSUFFIX @".MOV"



NS_ASSUME_NONNULL_BEGIN

typedef void(^Result)(NSData *fileData, NSString *fileName);
typedef void(^ResultPath)(NSString *filePath, NSString *fileName);


@class PHAsset;
@interface WDAssetFileUtil : NSObject
+ (NSString *)defaultPath;
+ (NSString *)pathForAsset:(PHAsset *)asset;


+ (void)getImageFromPHAsset:(PHAsset *)asset Complete:(Result)result;
+ (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result;

+ (void)saveAsset:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg filePath:(NSString *)filePath completion:(void (^)(NSError *))completion;

+ (void)saveAssets:(NSArray <PHAsset *> *)assets  thumbnailImgs:(NSArray <UIImage *>*)thumbnailImgs completion:(void (^)(NSError *))completion;

+ (void)loadAssetWithFilePath:(NSString *)filePath completion:(void (^)(NSData *))completion;
@end

NS_ASSUME_NONNULL_END
