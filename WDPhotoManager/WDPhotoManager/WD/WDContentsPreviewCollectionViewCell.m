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

- (void)setData:(NSString *)filePath{
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    [self.preImgView setImage:img];
    
}

#pragma mark - getter setter

- (UIImageView *)preImgView{
    if (!_preImgView) {
        CGSize size = [WDPreviewCollectionViewFlowLayout previewCollectionViewFlowLayoutSize];
        _preImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _preImgView.contentMode = UIViewContentModeScaleAspectFill;
        _preImgView.layer.masksToBounds = YES;
        [self addSubview:_preImgView];
    }
    return _preImgView;
}
@end
