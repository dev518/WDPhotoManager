//
//  WDContentsPreviewCollectionViewCell.h
//  WDPhotoManager
//
//  Created by wudi on 2018/8/9.
//  Copyright © 2018 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDContentsPreviewCollectionViewCell : UICollectionViewCell

- (void)setData:(WDAsset *)asset;
@end

NS_ASSUME_NONNULL_END
