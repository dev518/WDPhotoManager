//
//  WDPasswordView.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/3.
//  Copyright © 2018 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDPasswordView : UIView

+ (void)showPassword:(BOOL (^)(NSString *))finishPassWordStr;

@end

NS_ASSUME_NONNULL_END
