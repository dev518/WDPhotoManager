//
//  WDPasswordView.m
//  WDPhotoManager
//
//  Created by wudi on 2018/8/3.
//  Copyright © 2018 wudi. All rights reserved.
//

#import "WDPasswordView.h"
#import "WDDefine.h"

@interface WDPasswordView()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *passWordInputTF;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@property(nonatomic, copy) BOOL (^finishPassWordBlock)(NSString *passWordStr);
@end

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 45  //每一个输入框的高度
#define WDPasswordViewTag 12333

@implementation WDPasswordView

+ (void)showPassword:(BOOL (^)(NSString * _Nonnull))finishPassWordStr{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    WDPasswordView *psView = [[WDPasswordView alloc] initWith:finishPassWordStr];
    psView.tag = WDPasswordViewTag;
    [window addSubview:psView];
}


- (instancetype)initWith:(BOOL (^)(NSString * _Nonnull))finishPassWordStr{
    self = [super initWithFrame:CGRectMake(0, 0, CTScreenWidth, CTScreenHeight)];
    if (self) {
        self.finishPassWordBlock = finishPassWordStr;
        [self initPwdTextField];
        [self.passWordInputTF becomeFirstResponder];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = (CTScreenWidth - 32) / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passWordInputTF.frame) + (i + 1) * width, CGRectGetMinY(self.passWordInputTF.frame), 1, K_Field_Height)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passWordInputTF.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.passWordInputTF.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.passWordInputTF.text = @"";
    [self textFieldDidChange:self.passWordInputTF];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕");
        BOOL result =  self.finishPassWordBlock(self.passWordInputTF.text);
        if (result) {
            [self remove];
        }
    }
}

- (void)remove{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:WDPasswordViewTag] removeFromSuperview];
}



#pragma mark - getter

- (UITextField *)passWordInputTF{
    if (!_passWordInputTF) {
        _passWordInputTF = [[UITextField alloc] initWithFrame:CGRectMake(16, 100, CTScreenWidth - 32, K_Field_Height)];
        _passWordInputTF.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _passWordInputTF.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _passWordInputTF.tintColor = [UIColor whiteColor];
        _passWordInputTF.delegate = self;
        _passWordInputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passWordInputTF.keyboardType = UIKeyboardTypeNumberPad;
        _passWordInputTF.layer.borderColor = [[UIColor grayColor] CGColor];
        _passWordInputTF.layer.borderWidth = 1;
        [_passWordInputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_passWordInputTF];
    }
    return _passWordInputTF;
}

@end
