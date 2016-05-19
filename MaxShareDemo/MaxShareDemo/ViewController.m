//
//  ViewController.m
//  MaxShareDemo
//
//  Created by Sun Jin on 16/5/17.
//  Copyright © 2016年 maxleap. All rights reserved.
//

#import "ViewController.h"
#import <MaxSocialShare/MaxSocialShare.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareText:(id)sender {
    
    // 创建一个 MLShareItem 对象
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeText];
    // item.title = @"title";
    item.detail = @"MaxLeap is awesome!";
    
    // fromView 参数是为 iPad 准备的
    [MaxSocialShare shareItem:item fromView:sender completion:^(MLSActivityType activityType, BOOL completed, NSError * _Nullable activityError) {
        NSLog(@"share with type: %d", activityType);
        if (completed) {
            // 调用分享接口成功
        } else {
            // ...
        }
    }];
}

- (IBAction)shareImage:(id)sender {
    // 创建一个 MLShareItem 对象
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeImage];
    // required，支持 fileURL 和 远程图片链接
    item.attachmentURL = [[NSBundle mainBundle] URLForResource:@"5lightning5" withExtension:@"jpg"];
    
    item.title = @"闪电"; // optional, 只有QQ支持
    item.detail = @"漂亮的闪电"; // optional, 只有QQ支持
    item.previewImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"5lightning5_thumbnail" ofType:@"jpg"]]; // optional, 只有QQ支持
    
    // fromView 参数是为 iPad 准备的
    [MaxSocialShare shareItem:item fromView:sender completion:^(MLSActivityType activityType, BOOL completed, NSError * _Nullable activityError) {
        NSLog(@"share with type: %d", activityType);
        if (completed) {
            // 调用分享接口成功
        } else {
            // ...
        }
    }];
}

- (IBAction)shareWebpage:(id)sender {
    // 创建一个 MLShareItem 对象
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeWebpage];
    
    // 腾讯，微博，微信都支持以下字段
    item.title = @"MaxLeap";
    item.detail = @"MaxLeap 重新定义应用开发";
    item.webpageURL = [NSURL URLWithString:@"https://maxleap.cn/s/web/zh_cn/index.html"];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"maxleap" ofType:@"jpeg"];
    item.previewImageData = [NSData dataWithContentsOfFile:imgPath]; // 预览图
    
    // fromView 参数是为 iPad 准备的
    [MaxSocialShare shareItem:item fromView:sender completion:^(MLSActivityType activityType, BOOL completed, NSError * _Nullable activityError) {
        NSLog(@"share with type: %d", activityType);
        if (completed) {
            // 调用分享接口成功
        } else {
            // ...
        }
    }];
}

- (IBAction)shareMusic:(id)sender {
    // 创建一个 MLShareItem 对象
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeMusic];
    
    item.title = @"Eggs is Eggs";
    item.detail = @"还不错哟";
    item.previewImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eggs_is_eggs" ofType:@"jpg"]]; // 预览图
    item.attachmentURL = [NSURL URLWithString:@"http://freemusicarchive.org/music/download/0d15b1f79965f3165b1ac8b795228ef0e6193247"];
    
    // 音乐网页地址，微博，微信支持，QQ不支持
    item.webpageURL = [NSURL URLWithString:@"http://freemusicarchive.org/music/Dr_Sparkles/YUM_-_Look_Back_in_Hunger/Dr_Sparkles_-_Eggs_is_Eggs"];
    
    // fromView 参数是为 iPad 准备的
    [MaxSocialShare shareItem:item fromView:sender completion:^(MLSActivityType activityType, BOOL completed, NSError * _Nullable activityError) {
        NSLog(@"share with type: %d", activityType);
        if (completed) {
            // 调用分享接口成功
        } else {
            // ...
        }
    }];
}

- (IBAction)shareVideo:(id)sender {
    // 创建一个 MLShareItem 对象
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeVideo];
    
    // 以下字段三个平台都支持
    item.title = @"Up & Up -- Coldplay";
    item.detail = @"【首播】Coldplay奇幻新单《Up&Up》MV完整版 MV由Vania Heymann和Gal Muggia执导 来自《A Head Full of Dreams》的打单新曲 MV 的创意令歌迷惊喜 这绝对是一首与MV搭配 食用更佳的单曲 在今夜Coldplay所创造的梦境时空下 分不清奇幻的梦想与另一个平行宇宙的现实又有什么所谓呢？跟着MV导演一起大开脑洞吧！";
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"up & up" ofType:@"jpg"];
    item.previewImageData = [NSData dataWithContentsOfFile:imgPath]; // 预览图像
    
    // 视频网页地址，微信，微博支持，QQ 不支持
    item.webpageURL = [NSURL URLWithString:@"http://v.yinyuetai.com/video/2572234"];
    // 视频数据流地址，QQ, 微博支持，微信不支持
    item.attachmentURL = [NSURL URLWithString:@"http://115.231.144.56/12/x/q/x/q/xqxqcwrypzdsbjdwxhonvfqsphxurn/hc.yinyuetai.com/781C0154B9ED7FDFE8D5E9EC13DB4004.flv?sc=90270f8fd4c4a378&br=780&vid=2572234&aid=123&area=US&vst=0"];
    
    // fromView 参数是为 iPad 准备的
    [MaxSocialShare shareItem:item fromView:sender completion:^(MLSActivityType activityType, BOOL completed, NSError * _Nullable activityError) {
        NSLog(@"share with type: %d", activityType);
        if (completed) {
            // 调用分享接口成功
        } else {
            // ...
        }
    }];
}

@end
