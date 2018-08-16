//
//  PHAsset+AssetUtil.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/16.
//  Copyright © 2018 wudi. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (AssetUtil)
//file name not suffix
- (NSString *)fileNameWithOutSuffix;
@end

NS_ASSUME_NONNULL_END
