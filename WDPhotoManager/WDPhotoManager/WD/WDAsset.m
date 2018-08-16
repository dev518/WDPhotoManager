//
//  WDAsset.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/15.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDAsset.h"

@implementation WDAsset

+ (instancetype)initWithFileDirectoty:(NSString *)fileDirectoty{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:fileDirectoty];
    WDAsset *asset = [WDAsset new];

    if(success) {
        NSError *error;
        NSArray *files = [fileManager contentsOfDirectoryAtPath:fileDirectoty error:&error];
        for (NSString *file in files) {
            if ([file hasSuffix:WDThumbSuffix]) {
                asset.thumbnailImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",fileDirectoty,file]];
            }else{
                asset.filePath = [NSString stringWithFormat:@"%@/%@",fileDirectoty,file];
            }
        }
    }
    return asset;
}
@end
