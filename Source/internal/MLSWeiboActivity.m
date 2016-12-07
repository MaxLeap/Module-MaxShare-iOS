//
//  MLSWeiboActivity.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/15/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSWeiboActivity.h"

@implementation MLSWeiboActivity

+ (void)load {
    [self registerActivityClass:self];
}

+ (MLSActivityType)type {
    return MLSActivityTypeWeibo;
}

+ (BOOL)canPerformWithActivityItem:(MLShareItem *)activityItem {
    NSArray<NSNumber*> *supportedTypes = @[@(MLSContentMediaTypeText), @(MLSContentMediaTypeImage), @(MLSContentMediaTypeMusic), @(MLSContentMediaTypeVideo), @(MLSContentMediaTypeWebpage)];
    return [supportedTypes containsObject:@(activityItem.mediaType)];
}

- (nullable NSString *)title {
    return NSLocalizedString(@"新浪微博", nil);
}

- (nullable UIImage *)image {
    return [UIImage imageNamed:@"MaxSocialShare.bundle/share_icon_weibo"];
}

- (void)prepareWithActivityItem:(MLShareItem *)activityItem {
    if ( ! activityItem) {
        return;
    }
    
    Class WBMessageObjectClass = NSClassFromString(@"WBMessageObject");
    Class WBImageObjectClass = NSClassFromString(@"WBImageObject");
    Class WBWebpageObjectClass = NSClassFromString(@"WBWebpageObject");
    Class WBMusicObjectClass = NSClassFromString(@"WBMusicObject");
    Class WBVideoObjectClass = NSClassFromString(@"WBVideoObject");
    
    // 准备消息体
    switch (activityItem.mediaType) {
        case MLSContentMediaTypeText: {
            self.message = [WBMessageObjectClass message];
            self.message.text = activityItem.detail;
            break;
        }
        case MLSContentMediaTypeImage: {
            WBImageObject *imgObj = [WBImageObjectClass object];
            imgObj.imageData = [NSData dataWithContentsOfURL:activityItem.attachmentURL];
            self.message = [WBMessageObjectClass message];
            self.message.imageObject = imgObj;
            break;
        }
        case MLSContentMediaTypeWebpage: {
            WBWebpageObject *webpage = [WBWebpageObjectClass object];
            webpage.objectID = activityItem.objectId.UUIDString;
            webpage.webpageUrl = activityItem.webpageURL.absoluteURL.absoluteString;
            webpage.title = activityItem.title;
            webpage.description = activityItem.detail;
            webpage.thumbnailData = activityItem.previewImageData;
            self.message = [WBMessageObjectClass message];
            self.message.mediaObject = webpage;
            break;
        }
        case MLSContentMediaTypeMusic: {
            WBMusicObject *musicObj = [WBMusicObjectClass object];
            musicObj.objectID = activityItem.objectId.UUIDString;
            musicObj.musicUrl = activityItem.webpageURL.absoluteURL.absoluteString;
            musicObj.musicStreamUrl = activityItem.attachmentURL.absoluteURL.absoluteString;
            musicObj.title = activityItem.title;
            musicObj.description = activityItem.detail;
            musicObj.thumbnailData = activityItem.previewImageData;
            self.message = [WBMessageObjectClass message];
            self.message.mediaObject = musicObj;
            break;
        }
        case MLSContentMediaTypeVideo: {
            WBVideoObject *videoObj = [WBVideoObjectClass object];
            videoObj.objectID = activityItem.objectId.UUIDString;
            videoObj.videoUrl = activityItem.webpageURL.absoluteURL.absoluteString;
            videoObj.videoStreamUrl = activityItem.attachmentURL.absoluteURL.absoluteString;
            videoObj.title = activityItem.title;
            videoObj.description = activityItem.detail;
            videoObj.thumbnailData = activityItem.previewImageData;
            self.message = [WBMessageObjectClass message];
            self.message.mediaObject = videoObj;
            break;
        }
    }
}

- (void)perform {
    Class WBAuthorizeRequestClass = NSClassFromString(@"WBAuthorizeRequest");
    Class WBSendMessageToWeiboRequestClass = NSClassFromString(@"WBSendMessageToWeiboRequest");
    Class WeiboSDKClass = NSClassFromString(@"WeiboSDK");
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequestClass request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *req = [WBSendMessageToWeiboRequestClass requestWithMessage:self.message authInfo:authRequest access_token:nil];
    if ([WeiboSDKClass sendRequest:req]) {
        [self activityDidFinishWithError:nil];
    } else {
        [self activityDidFinishWithError:[NSError errorWithDomain:@"MLSocialShareErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"分享失败", nil)}]];
    }
}

@end
