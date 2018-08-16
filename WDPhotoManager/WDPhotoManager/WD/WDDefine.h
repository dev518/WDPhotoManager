//
//  WDDefine.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/3.
//  Copyright © 2018 wudi. All rights reserved.
//

#ifndef WDDefine_h
#define WDDefine_h

#define CTScreenHeight              [[UIScreen mainScreen] bounds].size.height     //屏幕的高
#define CTScreenWidth               [[UIScreen mainScreen] bounds].size.width     //屏幕的宽
/** RGB颜色 */
#define CTColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define CTColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/** HEX颜色 */
#define CTColorHex(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]
#define CTColorHexA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:(a)]


#define WDThumbSuffix @"_thumb.jpg"


#endif /* WDDefine_h */
