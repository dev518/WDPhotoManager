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

+ (NSString *)pathForAsset:(PHAsset *)asset{
    NSString *defaultPath = [self defaultPath];
    NSString *fileName = [asset valueForKey:@"filename"];
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@",defaultPath,fileName];
    return imgPath;
}

+ (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                                 result(data, fileName);
                                                             }
                                                             [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         }];
    } else {
        result(nil, nil);
    }
}

+ (void)saveAssets:(NSArray <PHAsset *> *)assets  thumbnailImgs:(NSArray <UIImage *>*)thumbnailImgs completion:(void (^)(NSError *))completion{
    __block NSError *haserror = nil;
    NSInteger index = 0;
    for (PHAsset *asset in assets) {
        [WDAssetFileUtil saveAsset:asset  thumbnailImg:[thumbnailImgs objectAtIndex:index] filePath:[WDAssetFileUtil pathForAsset:asset] completion:^(NSError * error) {
            if (!haserror && error) {
                haserror = error;
            }
        }];
        index++;
    }
    completion(haserror);
}


+ (void)saveAsset:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg filePath:(NSString *)filePath completion:(void (^)(NSError *))completion{
    BOOL isVideo = asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive;
    
    if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
        [self saveGif:asset thumbnailImg:thumbnailImg filePath:filePath completion:^(NSError * error) {
            completion(error);
        }];
    } else if (isVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
       
        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
        PHAssetResource *resource;
        
        for (PHAssetResource *assetRes in assetResources) {
            if (assetRes.type == PHAssetResourceTypePairedVideo ||
                assetRes.type == PHAssetResourceTypeVideo) {
                resource = assetRes;
            }
        }

        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:filePath]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                             } else {
                                                                 
                                                            
                                                             }
                                                         }];
    }else{
        [[TZImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            NSData *imageData = UIImageJPEGRepresentation(photo, 1);
            [imageData writeToFile:filePath atomically:YES];
            completion(nil);
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
            NSLog(@"gif大爷");
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

#pragma mark - ------------- file save

+ (void)saveGif:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg filePath:(NSString *)filePath completion:(void (^)(NSError *))completion{
    [self nsdataForGifAsset:asset completion:^(NSData *data) {
        [data writeToFile:filePath atomically:YES];
        completion(nil);
    }];
}
     
+ (void)saveVideo:(PHAsset *)asset  thumbnailImg:(UIImage *)thumbnailImg filePath:(NSString *)filePath completion:(void (^)(NSError *))completion{
    [self nsdataForGifAsset:asset completion:^(NSData *data) {
        [data writeToFile:filePath atomically:YES];
        completion(nil);
    }];
}

@end
