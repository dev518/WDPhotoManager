//
//  PHAsset+AssetUtil.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/16.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "PHAsset+AssetUtil.h"

@implementation PHAsset (AssetUtil)

- (NSString *)fileNameWithOutSuffix{
    NSString *fileName = [self valueForKey:@"filename"];
    NSArray *components = [fileName componentsSeparatedByString:@"."];
    NSString *name = components[0];
    return name;
}
@end
