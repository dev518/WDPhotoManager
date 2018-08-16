//
//  WDAssetFileUtil.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/2.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDAssetFileUtil.h"
#import <Photos/Photos.h>
#import "UIImage+GIF.h"
#import "NSString+AssetUtil.h"
#import "TZImageManager.h"
#import "PHAsset+AssetUtil.h"

typedef void (^gifassetToDataBlock)(NSData *data);
typedef void (^Result)(NSData *data,NSString *fileName);
@implementation WDAssetFileUtil

+ (NSString *)defaultPath{
    BOOL success;
    NSError *error;
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imgCacheAbsolutePath = [NSString stringWithFormat:@"%@/resources",documentsDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //判断是否存在改文件夹，不存在创建
    success = [fileManager fileExistsAtPath:imgCacheAbsolutePath];
    
    if(!success) {
        [fileManager createDirectoryAtPath:imgCacheAbsolutePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return imgCacheAbsolutePath;
    
}

+ (PHAssetResource *)getVideoResource:(PHAsset *)asset{
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    return resource;
}

+ (NSString *)directoryForAsset:(PHAsset *)asset{
    NSString *defaultPath = [self defaultPath];
    
    NSString *directory = [NSString stringWithFormat:@"%@/%@",defaultPath,asset.fileNameWithOutSuffix];
    return directory;
}

+ (NSString *)pathForAsset:(PHAsset *)asset{
    NSString *defaultPath = [self defaultPath];
    NSString *fileName = [asset valueForKey:@"filename"];

    BOOL isVideo = asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive;
    if (isVideo) {
        PHAssetResource *resource = [self getVideoResource:asset];
        fileName = @"tempAssetVideo.mov";
        if (resource.originalFilename) {
            fileName = resource.originalFilename;
        }
    }
    
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@/%@",defaultPath,asset.fileNameWithOutSuffix,fileName];
    return imgPath;
}

+ (void)getImageFromPHAsset:(PHAsset *)asset Complete:(Result)result {
    __block NSData *data;
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             data = [NSData dataWithData:imageData];
         }];
    }
    
    if (result) {
        if (data.length <= 0) {
            result(nil, nil);
        } else {
            result(data, resource.originalFilename);
        }
    }
}

+ (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result {

    PHAssetResource *resource = [self getVideoResource:asset];
    NSString *fileName = [asset valueForKey:@"filename"];
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }

    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [WDAssetFileUtil pathForAsset:asset];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 result(PATH_MOVIE_FILE, fileName);
                                                             }
                                                         }];
    } else {
        result(nil, nil);
    }
}

+ (void)saveAssets:(NSArray <PHAsset *> *)assets  thumbnailImgs:(NSArray <UIImage *>*)thumbnailImgs completion:(void (^)(NSError *))completion{
    __block NSError *haserror = nil;
    NSInteger index = 0;
    for (PHAsset *asset in assets) {
        [WDAssetFileUtil saveAsset:asset  thumbnailImg:[thumbnailImgs objectAtIndex:index] completion:^(NSError * error) {
            if (!haserror && error) {
                haserror = error;
            }
        }];
        index++;
    }
    completion(haserror);
}


+ (void)saveAsset:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg  completion:(void (^)(NSError *))completion{
    BOOL isVideo = asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive;
    
    if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
        [self saveGif:asset thumbnailImg:thumbnailImg  completion:^(NSError * error) {
            completion(error);
        }];
    } else if (isVideo) {
        [self saveVideo:asset thumbnailImg:thumbnailImg completion:^(NSError * error) {
            
        }];
    }else{
        [self saveImg:asset thumbnailImg:thumbnailImg completion:^(NSError *error) {
            
        }];

    }
}

+ (void)loadAssetWithFilePath:(NSString *)filePath completion:(void (^)(NSData *))completion{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [fileManager contentsAtPath:filePath];
  
    if ([filePath isVideoFilePath]) {
        completion(filePath);
        return;
    }
    completion([UIImage sd_animatedGIFWithData:data]);
}

+ (void)nsdataForGifAsset:(PHAsset *)asset completion:(gifassetToDataBlock)completion{
    NSArray *resourceList = [PHAssetResource assetResourcesForAsset:asset];
    [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetResource *resource = obj;
        PHAssetResourceRequestOptions *option = [[PHAssetResourceRequestOptions alloc]init];
        option.networkAccessAllowed = YES;
        if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
            // 首先,需要获取沙盒路径
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            // 拼接图片名为resource.originalFilename的路径
            NSString *imageFilePath = [path stringByAppendingPathComponent:resource.originalFilename];
            __block NSData *data = [[NSData alloc]init];
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:imageFilePath]  options:option completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error:%@",error);
                    if(error.code == -1){//文件已存在
                        data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imageFilePath]];
                    }
                    //NSLog(@"data%@",data);
                    if (completion) completion(data);
                } else {
                    data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imageFilePath]];
                    //NSLog(@"data%@",data);
                    if (completion) completion(data);
                }
            }];
            
        }else{
            NSLog(@"jepg大爷");
        }
    }];
    
}

+ (void)saveThumbnail:(UIImage *)thumbnailImg  ForAsset:(PHAsset *)asset{
    NSString *directoryPath = [self directoryForAsset:asset];
    //判断是否存在改文件夹，不存在创建
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];
    NSError *error = nil;
    if(!success) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",directoryPath,asset.fileNameWithOutSuffix,WDThumbSuffix];
    NSData *imageData = UIImageJPEGRepresentation(thumbnailImg, 1);
    [imageData writeToFile:filePath atomically:YES];
}


+ (void)saveAseetBasicInfo:(PHAsset *)asset{
    NSString *directoryPath = [self directoryForAsset:asset];
    //判断是否存在改文件夹，不存在创建
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];
    NSError *error = nil;
    if(!success) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",directoryPath,asset.fileNameWithOutSuffix,WDBaseInfoSuffix];
    [asset.basicJsonObject writeToFile:filePath atomically:YES];
   
}

#pragma mark - ------------- file save'

+ (void)saveImg:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg  completion:(void (^)(NSError *))completion{
    [self saveThumbnail:thumbnailImg ForAsset:asset];
    [self saveAseetBasicInfo:asset];
    [self getImageFromPHAsset:asset Complete:^(NSData * _Nonnull fileData, NSString * _Nonnull fileName) {
        NSString *filePath = [WDAssetFileUtil pathForAsset:asset];
        [fileData writeToFile:filePath atomically:YES];
        completion(nil);
    }];
}

+ (void)saveGif:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg  completion:(void (^)(NSError *))completion{
    NSString *filePath = [WDAssetFileUtil pathForAsset:asset];
    [self saveThumbnail:thumbnailImg ForAsset:asset];
    [self saveAseetBasicInfo:asset];
    [self nsdataForGifAsset:asset completion:^(NSData *data) {
        [data writeToFile:filePath atomically:YES];
        completion(nil);
    }];
}
     
+ (void)saveVideo:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg completion:(void (^)(NSError *))completion{
    PHAssetResource *resource = [self getVideoResource:asset];
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        [self saveThumbnail:thumbnailImg ForAsset:asset];
        [self saveAseetBasicInfo:asset];
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [WDAssetFileUtil pathForAsset:asset];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 completion(error);
                                                             } else {
                                                                 completion(nil);
                                                             }
                                                         }];
    }
}

@end
