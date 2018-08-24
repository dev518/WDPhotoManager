//
//  ActionViewController.m
//  share
//
//  Created by wudi on 2018/8/20.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WDAssetFileUtil.h"


@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *atr = [NSMutableArray new];
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [atr addObject:image];
                    }
                }];

                break;
            }
        }

    }
    
    [WDAssetFileUtil saveImages:atr completion:^(NSError * error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"   " message:@"ok" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
