//
//  LoginViewController.m
//  wangchenyu_ios
//
//  Created by wangchenyu on 17/3/27.
//  Copyright © 2017年 wangchenyu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong) UIImageView *backImageView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
     self.backImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(UIImageView *)backImageView{
    if (_backImageView == nil) {
        NSString *imagePath=[[NSBundle mainBundle]pathForResource:@"back" ofType:@"jpg"];
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imagePath]];
        [self.view addSubview:_backImageView];
    }
    return _backImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
