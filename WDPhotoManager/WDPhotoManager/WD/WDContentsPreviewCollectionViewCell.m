//
//  WDContentsPreviewCollectionViewCell.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/9.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDContentsPreviewCollectionViewCell.h"
#import "WDPreviewCollectionViewFlowLayout.h"

@interface WDContentsPreviewCollectionViewCell()

@property(nonatomic, strong) UIImageView *preImgView;

@end

@implementation WDContentsPreviewCollectionViewCell


- (void)setData:(WDAsset *)asset{
    [self.preImgView setImage:asset.thumbnailImage];
    
}

#pragma mark - getter setter

- (UIImageView *)preImgView{
    if (!_preImgView) {
        CGSize size = [WDPreviewCollectionViewFlowLayout previewCollectionViewFlowLayoutSize];
        _preImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _preImgView.contentMode = UIViewContentModeScaleAspectFill;
        _preImgView.layer.masksToBounds = YES;
        _preImgView.backgroundColor = CTColorHex(0x82d8c8);
        [self addSubview:_preImgView];

    }
    return _preImgView;
}
@end
