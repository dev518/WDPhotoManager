//
//  ViewController.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/9.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WD/WDAssetFileUtil.h"
#import "TZImagePickerController/TZImagePickerController.h"
#import "UINavigationController+Extention.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNav];


      
}

- (void)initNav{
    self.title = @"相册管家";
    [self.navigationController setBackgroundImage:CTColorHex(0xe9eaeb)];
    [[UINavigationBar appearance] setTintColor:CTColorHex(0x333333)];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:CTColorHex(0x333333),NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:CTColorHex(0x333333),NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}

- (IBAction)loadPhotoFromGallery:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingMultipleVideo = YES;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.isSelectOriginalPhoto = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [WDAssetFileUtil saveAssets:assets completion:^(NSError * error) {
            if (!error) {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:@"存储成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [view show];
            }
        }];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}

- (IBAction)loadPhotoFromLocal:(id)sender {
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
