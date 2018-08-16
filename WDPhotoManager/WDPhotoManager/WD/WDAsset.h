//
//  WDAsset.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/15.
//  Copyright © 2018 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDAsset : NSObject
@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, copy) NSString *fileDirectoty;
@property(nonatomic, strong) UIImage *thumbnailImage;


#pragma mark - load those props from file in json format
@property (nonatomic, assign, readonly) PHAssetMediaType mediaType;
@property (nonatomic, assign, readonly) PHAssetMediaSubtype mediaSubtypes;
@property (nonatomic, assign, readonly) NSUInteger pixelWidth;
@property (nonatomic, assign, readonly) NSUInteger pixelHeight;
@property (nonatomic, strong, readonly, nullable) NSDate *creationDate;
@property (nonatomic, strong, readonly, nullable) NSDate *modificationDate;
@property (nonatomic, assign, readonly) NSTimeInterval duration;

+ (instancetype)initWithFileDirectoty:(NSString *)fileDirectoty;
@end

NS_ASSUME_NONNULL_END
