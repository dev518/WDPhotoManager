//
//  WDContentsPreviewCollectionViewCell.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/9.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDContentsPreviewCollectionViewCell.h"
#import "WDPreviewCollectionViewFlowLayout.h"
#import "TZImagePickerController.h"

@interface WDContentsPreviewCollectionViewCell()

@property(nonatomic, strong) UIImageView *preImgView;
@property(nonatomic, strong) UIImageView *playImgView;

@end

@implementation WDContentsPreviewCollectionViewCell


- (void)setData:(WDAsset *)asset{
    [self.preImgView setImage:asset.thumbnailImage];
    self.playImgView.hidden = asset.mediaType != PHAssetMediaTypeVideo;
    
}

#pragma mark - getter setter

- (UIImageView *)preImgView{
    if (!_preImgView) {
        CGSize size = [WDPreviewCollectionViewFlowLayout previewCollectionViewFlowLayoutSize];
        _preImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _preImgView.contentMode = UIViewContentModeScaleAspectFill;
        _preImgView.layer.masksToBounds = YES;
        _preImgView.backgroundColor = CTColorHex(0x82d8c8);
        [_preImgView addSubview:self.playImgView];
        self.playImgView.center = _preImgView.center;
        [self addSubview:_preImgView];
    }
    return _preImgView;
}

- (UIImageView *)playImgView{
    if (!_playImgView) {
        _playImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.width/2)];
//        _playImgView.center = self.center;
        _playImgView.contentMode = UIViewContentModeScaleAspectFill;
        _playImgView.layer.masksToBounds = YES;
        [_playImgView setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"]];
    }
    return _playImgView;
}
@end
