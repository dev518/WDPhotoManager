//
//  WDContensFilesCollectionViewController.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/9.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDContensFilesCollectionViewController.h"
#import "WDAssetFileUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "WDContentsPreviewCollectionViewCell.h"
#import "WDPreviewCollectionViewFlowLayout.h"


@interface WDContensFilesCollectionViewController ()
@property(nonatomic, strong) NSMutableArray *contentFiles;

@end

#define PREVIEWTAG  100998


@implementation WDContensFilesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[WDContentsPreviewCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self loadContents];
    
}

- (void)initView{    
    self.collectionView.collectionViewLayout = [WDPreviewCollectionViewFlowLayout new];
    [self initRightbarItem];
}

- (void)initRightbarItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"清除全部" style:UIBarButtonItemStylePlain target:self action:@selector(clearFile)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clearFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:[WDAssetFileUtil defaultPath] error:&error];
    if (!error) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:@"清除成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [view show];
    }
}

- (void)creatQuitRightbarItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(quitPreView)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)quitPreView{
    UIView *view = [self.view  viewWithTag:PREVIEWTAG];
    if (view) {
        [view removeFromSuperview];
    }
    [self initRightbarItem];
}

- (void)loadContents{
    BOOL success;
    
    NSString *path = [WDAssetFileUtil defaultPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:path];
    
    if(success) {
        NSError *error;
        NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:&error];
        self.contentFiles = [NSMutableArray arrayWithArray:files];
        [self.collectionView reloadData];
    }
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentFiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WDContentsPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[WDAssetFileUtil defaultPath],self.contentFiles[indexPath.row]];
    [cell setData:filePath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[WDAssetFileUtil defaultPath],self.contentFiles[indexPath.row]];
    [self creatQuitRightbarItem];
    [WDAssetFileUtil loadAssetWithFilePath:filePath completion:^(NSData * data) {
        if ([data isKindOfClass:[NSString class]]) {
            NSURL *videoURL = [NSURL fileURLWithPath:filePath];
            AVPlayer *player = [AVPlayer playerWithURL:videoURL];
            AVPlayerViewController *vc = [AVPlayerViewController new];
            vc.player = player;
            vc.showsPlaybackControls = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [player play];
        }else if ([data isKindOfClass:[UIImage class]]){
            UIImageView *preViewImg = [[UIImageView alloc] initWithImage:(UIImage *)data];
            preViewImg.frame = self.view.bounds;
            preViewImg.tag = PREVIEWTAG;
            [self.view addSubview:preViewImg];
        }
    }];

}




#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
