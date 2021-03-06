//
//  WDPreviewCollectionViewFlowLayout.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/9.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDPreviewCollectionViewFlowLayout.h"
#import "WDDefine.h"

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
        self.sectionInset = UIEdgeInsetsMake(0, WDPreviewCollectionViewFlowLayoutLineSpacing, 0, WDPreviewCollectionViewFlowLayoutLineSpacing);
    }
    return self;
}

+ (CGFloat)WDPreviewCollectionViewFlowLayoutWidth{
    return (CTScreenWidth - 2 * WDPreviewCollectionViewFlowLayoutLineSpacing - 3 * WDPreviewCollectionViewFlowLayoutInteritemSpacing)/4;
}

+ (CGFloat)WDPreviewCollectionViewFlowLayoutHeight{
    return [[self class] WDPreviewCollectionViewFlowLayoutWidth];
}


+ (CGSize)previewCollectionViewFlowLayoutSize{
    return CGSizeMake([self WDPreviewCollectionViewFlowLayoutWidth], [self WDPreviewCollectionViewFlowLayoutHeight]);
}
@end
