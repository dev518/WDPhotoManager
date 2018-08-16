//
//  NSString+AssetUtil.m
//  TZImagePickerController
//
//  Created by wudi on 2018/8/2.
//  Copyright © 2018 谭真. All rights reserved.
//

#import "NSString+AssetUtil.h"

@implementation NSString (AssetUtil)

- (BOOL)isVideoFilePath{
    NSString *lowerStr = [self lowercaseString];
    return ([lowerStr containsString:@".mov"] || [lowerStr containsString:@".mp4"] );
}
@end
