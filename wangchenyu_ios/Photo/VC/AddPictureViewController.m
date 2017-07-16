//
//  AddPictureViewController.m
//  wangchenyu_ios
//
//  Created by wangchenyu on 17/6/29.
//  Copyright © 2017年 wangchenyu. All rights reserved.
//

#import "AddPictureViewController.h"
#import "CBPhotoSelecterController.h"
#import "AlubmScrollView.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "ZLCameraViewController.h"
#import "PhotoView.h"
@interface AddPictureViewController ()<CBPickerControllerDelegate>
@property (nonatomic,strong) UIButton *albumBtn;//相册选取
@property (nonatomic,strong) UIButton *cameraBtn;//相机拍照
@property (nonatomic,strong) UIView *uploadView;//上传
@property (nonatomic,strong) AlubmScrollView *alubmSV;//滚动图
@property (nonatomic,strong) YLImageView *albumBackView;//动态背景图
@property (nonatomic,strong) YLImageView *albumLoadView;//动态上传
@property (nonatomic,strong) UILabel     *loadLabel;//正在上传...
@property (nonatomic,strong) NSString   *group_id;
@end

@implementation AddPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.group_id = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.albumBtn];
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.uploadView];
    [self.view addSubview:self.albumBackView];
    [self setLoadView:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBackView) name:@"deleteallphotos" object:nil];
}

#pragma mark 获取相册信息
-(void)getAlbumInfo{
    [self showProgressHUD:YES];
    [HeyHaHttpManager dataRequestWithStrOfUrl:WCY_GET_GROUPID_URL beAsynchronous:NO GET_OR_POST:NO postBodyDict:nil completionBlock:^(id dic) {
        [self hideProgressHUD:YES];
        NSInteger success = [[dic objectForKey:@"success"] intValue];
        if (success == 1) {
            self.group_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"result"]];
            CBPhotoSelecterController *selectPicture = [[CBPhotoSelecterController alloc]initWithDelegate:self];
            selectPicture.maxSlectedImagesCount = 6;
            selectPicture.columnNumber = 4;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectPicture];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [WCYBaseDevice showPromptMessageResult:dic];
        }
        
    } errorBlock:^{
        [self hideProgressHUD:YES];
    }];
    
}


#pragma mark CBPickerControllerDelegate
-(void)photoSelecterController:(CBPhotoSelecterController *)pickerController sourceAsset:(NSArray *)sourceAsset{
    [self.albumBackView removeFromSuperview];
    [self.view addSubview:self.alubmSV];
    [self.alubmSV setPhotoViewsWithAssetArray:sourceAsset];
}
-(void)photoSelecterDidCancelWithController:(CBPhotoSelecterController *)pickerController{
    
}

#pragma mark 获取拍照图片
-(void)getCameraInfo{
    [self showProgressHUD:YES];
    [HeyHaHttpManager dataRequestWithStrOfUrl:WCY_GET_GROUPID_URL beAsynchronous:NO GET_OR_POST:NO postBodyDict:nil completionBlock:^(id dic) {
        [self hideProgressHUD:YES];
        NSInteger success = [[dic objectForKey:@"success"] intValue];
        if (success == 1) {
            self.group_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"result"]];
            ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
            // 拍照最多个数
            cameraVC.maxCount = 5;
            // 连拍
            cameraVC.cameraType = ZLCameraContinuous;
            cameraVC.callback = ^(NSArray *cameras){
                //在这里得到拍照结果
                //数组元素是ZLCamera对象
                /*
                 @exemple
                 ZLCamera *canamerPhoto = cameras[0];
                 UIImage *image = canamerPhoto.photoImage;
                 */
                [self.albumBackView removeFromSuperview];
                [self.view addSubview:self.alubmSV];
                [self.alubmSV setPhotoViewsWithPhotoArray:cameras];
            };
            [cameraVC showPickerVc:self];
        }else{
            [WCYBaseDevice showPromptMessageResult:dic];
        }
        
    } errorBlock:^{
        [self hideProgressHUD:YES];
    }];
    
}




#pragma mark 上传图片
-(void)uploadPhotos{
    if ([self.group_id isEqualToString:@""]) {
        [self.navigationController.view makeToast:@"图片组为空!"];
    }else{
        __block int successCount = 0;
        __block int count = 0;
        if (self.alubmSV.photoViewArray.count >0) {
            [self setLoadView:NO];
            //[self showProgressHUDWithMessage:@"正在上传"];
            for (int i = 0; i < self.alubmSV.photoViewArray.count; i++) {
                [self.navigationController.view makeToast:[NSString stringWithFormat:@"正在上传第%i张照片",i+1]];
                PhotoView *photoView = (PhotoView*)self.alubmSV.photoViewArray[i];
                UIImage *image = photoView.photoImageView.image;
                image = [UIImage makeImageSize:image withSize:CGSizeMake(ScreenWidth, ScreenHeight)];
                NSData *imageData = [UIImage makeImageData:image withByteNum:1024 withQuality:1.0];
                NSMutableDictionary * pdic=[[NSMutableDictionary alloc] init];
                [pdic setValue:self.menu_id      forKey:@"menu_id"];
                [pdic setValue:self.group_id forKey:@"group_id"];
                [pdic setValue:[NSString stringWithFormat:@"%i",i+1] forKey:@"sort"];
                NSString *imageStr = [imageData base64EncodedStringWithOptions:0];
                [pdic setValue:imageStr forKey:@"image"];
                [HeyHaHttpManager dataRequestWithStrOfUrl:WCY_UPLOAD_PHOTO_URL beAsynchronous:NO GET_OR_POST:NO postBodyDict:pdic completionBlock:^(id dic) {
                    count++;
                    if (count == self.alubmSV.photoViewArray.count) {
                        [self setLoadView:YES];
                    }
                    NSInteger success = [[dic objectForKey:@"success"] intValue];
                    int sort = [[dic objectForKey:@"result"] intValue];
                    if (success) {
                        successCount++;
                        if (successCount == self.alubmSV.photoViewArray.count) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"addphotosuccess" object:self.menu_id];
                        }
                        [self.navigationController.view makeToast:[NSString stringWithFormat:@"第%i张照片上传成功",sort]];
                        [photoView.deleteBtn setImage:[UIImage imageNamed:@"success.png"] forState:UIControlStateNormal];
                    }else{
                        [self.navigationController.view makeToast:[NSString stringWithFormat:@"第%i张照片上传失败",sort]];
                    }
                    
                } errorBlock:^{
                }];
            }
        }else{
            [self.navigationController.view makeToast:@"照片列表为空!"];
        }
    }
}
-(void)setLoadView:(BOOL)hid{
    [self.view addSubview:self.albumLoadView];
    [self.view bringSubviewToFront:self.albumLoadView];
    self.albumLoadView.hidden = hid;
    [self.view addSubview:self.loadLabel];
    [self.view bringSubviewToFront:self.loadLabel];
    self.loadLabel.hidden = hid;
}
#pragma mark 所选图片全部删除
-(void)setBackView{
    [self.alubmSV removeFromSuperview];
    [self.view addSubview:self.albumBackView];
}

-(UIButton *)albumBtn{
    if (_albumBtn == nil) {
        _albumBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth/5*2, 50)];
        [_albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        _albumBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _albumBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _albumBtn.backgroundColor = UI_NAVI_COLOR;
        _albumBtn.tintColor = [UIColor whiteColor];
        [_albumBtn addTarget:self action:@selector(getAlbumInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumBtn;
}
-(UIButton *)cameraBtn{
    if (_cameraBtn == nil) {
        _cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/5*3, ScreenHeight-50, ScreenWidth/5*2, 50)];
        [_cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
        _cameraBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cameraBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _cameraBtn.backgroundColor = UI_NAVI_COLOR;
        _cameraBtn.tintColor = [UIColor whiteColor];
        [_cameraBtn addTarget:self action:@selector(getCameraInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}
-(UIView *)uploadView{
    if (_uploadView == nil) {
        _uploadView =[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/5*2, ScreenHeight-50, ScreenWidth/5, 50)];
        _uploadView.backgroundColor = UI_NAVI_COLOR;
        UIButton *uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/5, 50)];
        [uploadBtn setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [uploadBtn addTarget:self action:@selector(uploadPhotos) forControlEvents:UIControlEventTouchUpInside];
        [_uploadView addSubview:uploadBtn];
        
    }
    return _uploadView;
}

-(AlubmScrollView *)alubmSV{
    if (_alubmSV == nil) {
        _alubmSV = [[AlubmScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-114)];
    }
    return _alubmSV;
}

-(YLImageView *)albumBackView{
    if (_albumBackView == nil) {
        _albumBackView = [[YLImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-114)];
        _albumBackView.image = [YLGIFImage imageNamed:@"addphotoback.gif"];
    }
    return _albumBackView;
}
-(YLImageView *)albumLoadView{
    if (_albumLoadView == nil) {
        _albumLoadView =[[YLImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-150, ScreenHeight/2-170, 300, 200)];
        _albumLoadView.image = [YLGIFImage imageNamed:@"loading.gif"];
    }
    return _albumLoadView;
}

-(UILabel *)loadLabel{
    if (_loadLabel == nil) {
        _loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2+40, ScreenWidth, 20)];
        _loadLabel.text = @"正在上传照片中...";
        _loadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loadLabel;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
