//
//  WDPreviewCollectionViewFlowLayout.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/9.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDPreviewCollectionViewFlowLayout.h"
#import "WDDefine.h"

//#define WDPreviewCollectionViewFlowLayoutWidth 80
//#define WDPreviewCollectionViewFlowLayoutHeight 80
#define WDPreviewCollectionViewFlowLayoutLineSpacing 5
#define WDPreviewCollectionViewFlowLayoutInteritemSpacing 5

@implementation WDPreviewCollectionViewFlowLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake([[self class] WDPreviewCollectionViewFlowLayoutWidth], [[self class] WDPreviewCollectionViewFlowLayoutHeight]);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = WDPreviewCollectionViewFlowLayoutLineSpacing;
        self.minimumInteritemSpacing = WDPreviewCollectionViewFlowLayoutInteritemSpacing;
    }
    return self;
}

+ (CGFloat)WDPreviewCollectionViewFlowLayoutWidth{
    return CTScreenWidth/4;
}

+ (CGFloat)WDPreviewCollectionViewFlowLayoutHeight{
    return CTScreenWidth/4;
}


+ (CGSize)previewCollectionViewFlowLayoutSize{
    return CGSizeMake([self WDPreviewCollectionViewFlowLayoutWidth], [self WDPreviewCollectionViewFlowLayoutHeight]);
}
@end