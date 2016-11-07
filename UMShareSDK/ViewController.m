//
//  ViewController.m
//  UMShareSDK
//
//  Created by Sam Liu on 2016/11/4.
//  Copyright © 2016年 Sam Liu. All rights reserved.
//

#import "ViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"
#import "UMSocialSinaHandler.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(IBAction)login:(UIButton *)sender{
    NSInteger a =sender.tag;
//    NSLog(@"%ld",(long)a);
    UMSocialPlatformType platformType;
    switch (a) {
        case 1:
            platformType = UMSocialPlatformType_WechatSession;
            break;
        case 2:
            platformType = UMSocialPlatformType_QQ;
            break;
        case 3:
            platformType = UMSocialPlatformType_Sina;
            break;
        case 4:
            platformType = UMSocialPlatformType_AlipaySession;
        default:
            break;
    }
    
    
    //如果需要获得用户信息直接跳转的话，需要先取消授权
    //step1 取消授权
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        
        //step2 获得用户信息(获得用户信息中包含检查授权的信息了)
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
            
            NSString *message = nil;
            
            if (error) {
                message = @"Get user info fail";
                NSLog(@"Get user info fail with error %@",error);
            }else{
                if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                    UMSocialUserInfoResponse *resp = result;
                    // 授权信息
                    NSLog(@"UserInfoAuthResponse uid: %@", resp.uid);
                    NSLog(@"UserInfoAuthResponse accessToken: %@", resp.accessToken);
                    NSLog(@"UserInfoAuthResponse refreshToken: %@", resp.refreshToken);
                    NSLog(@"UserInfoAuthResponse expiration: %@", resp.expiration);
                    
                    // 用户信息
                    NSLog(@"UserInfoResponse name: %@", resp.name);
                    NSLog(@"UserInfoResponse iconurl: %@", resp.iconurl);
                    NSLog(@"UserInfoResponse gender: %@", resp.gender);
                    
                    // 第三方平台SDK源数据,具体内容视平台而定
                    NSLog(@"OriginalUserProfileResponse: %@", resp.originalResponse);
                    
                    message = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n",resp.name,resp.iconurl,resp.gender];
                }else{
                    message = @"Get user info fail";
                    NSLog(@"Get user info fail with  unknow error");
                }
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserInfo"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }];
}

-(IBAction)makeShare:(id)sender{
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //设置文本
        messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    NSLog(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    NSLog(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    NSLog(@"response data is %@",data);
                }
            }
            [self alertWithError:error];
        }];
#import "UMSocialSinaHandler.h"
        
        [UMSocialSinaHandler defaultManager].authCompletionBlock = ^(id authResponse,NSError *error) {
            
        };
    }];
}

-(void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)getAuthInfoFromWechat
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
