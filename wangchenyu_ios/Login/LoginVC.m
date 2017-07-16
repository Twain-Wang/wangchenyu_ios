//
//  LoginVC.m
//  wangchenyu_ios
//
//  Created by wangchenyu on 17/3/27.
//  Copyright © 2017年 wangchenyu. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBord)];
    [gr setNumberOfTapsRequired:1];
    [self.backImageView setUserInteractionEnabled:YES];
    [self.backImageView addGestureRecognizer:gr];
    
    self.userPassword.delegate = self;
    self.userName.delegate = self;
}
-(void)hiddenKeyBord{
    [self.userName resignFirstResponder];
    [self.userPassword resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {
        [self.userPassword resignFirstResponder];
        [self sendLoginInfo];
        
    }else{
        [self.userPassword becomeFirstResponder];
    }
    return YES;
}

-(void)sendLoginInfo{
    [self showProgressHUD:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%@",self.userName.text] forKey:@"name"];
    [dic setValue:[NSString stringWithFormat:@"%@",self.userPassword.text] forKey:@"password"];
    [HeyHaHttpManager dataRequestWithStrOfUrl:@"http://localhost:8080/wangchenyu/Login" beAsynchronous:NO GET_OR_POST:NO postBodyDict:dic completionBlock:^(id dic) {
        [self hideProgressHUD:YES];
        BOOL success = [WCYBaseDevice showPromptMessageResult:dic];
    } errorBlock:^{
        [self hideProgressHUD:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
