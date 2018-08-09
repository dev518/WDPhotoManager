//
//  WDContenstsFileTableViewController.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/2.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDContenstsFileTableViewController.h"
#import "WDAssetFileUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface WDContenstsFileTableViewController ()
@property(nonatomic, strong) NSMutableArray *contentFiles;
@property(nonatomic, strong) AVPlayerLayer *preVideoLayer;
@end
static NSString *const tableViewCellID = @"tableViewCellID";
#define PREVIEWTAG  100998
@implementation WDContenstsFileTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentFiles = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellID];
    [self loadContents];
    
    self.navigationItem.rightBarButtonItem = nil;

}

- (void)initRightbarItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(quitPreView)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)quitPreView{
    UIView *view = [self.view  viewWithTag:PREVIEWTAG];
    if (view) {
        [view removeFromSuperview];
    }else if (_preVideoLayer){
        [_preVideoLayer removeFromSuperlayer];
        [_preVideoLayer.player pause];
    }
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
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentFiles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
    
    cell.textLabel.text = self.contentFiles[indexPath.row];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[WDAssetFileUtil defaultPath],self.contentFiles[indexPath.row]];
    [self initRightbarItem];
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


@end
