//
//  UINavigationController+Extention.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/10.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "UINavigationController+Extention.h"

@implementation UINavigationController (Extention)

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
- (void)setBackgroundImage:(UIColor *)color{
    UIImage *img = [[self class] createImageWithColor:color size:CGSizeMake(1, 1)];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}
@end
