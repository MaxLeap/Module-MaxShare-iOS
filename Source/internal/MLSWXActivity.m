//
//  MLSWXActivity.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/21/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSWXActivity.h"

@implementation MLSWXActivity

+ (BOOL)canPerformWithActivityItem:(MLShareItem *)activityItem {
    NSArray<NSNumber*> *supportedTypes = @[@(MLSContentMediaTypeText), @(MLSContentMediaTypeImage), @(MLSContentMediaTypeMusic), @(MLSContentMediaTypeVideo), @(MLSContentMediaTypeWebpage)];
    BOOL support = [supportedTypes containsObject:@(activityItem.mediaType)];
    BOOL installed = [NSClassFromString(@"WXApi") isWXAppInstalled];
    return support && installed;
}

- (void)prepareWithActivityItem:(MLShareItem *)activityItem {
    if ( ! activityItem) {
        return;
    }
    
    Class SendMessageToWXReqClass = NSClassFromString(@"SendMessageToWXReq");
    Class WXImageObjectClass = NSClassFromString(@"WXImageObject");
    Class WXMediaMessageClass = NSClassFromString(@"WXMediaMessage");
    Class WXWebpageObjectClass = NSClassFromString(@"WXWebpageObject");
    Class WXMusicObjectClass = NSClassFromString(@"WXMusicObject");
    Class WXVideoObjectClass = NSClassFromString(@"WXVideoObject");
    
    self.request = [SendMessageToWXReqClass new];
    self.request.bText = NO;
    self.request.scene = 0; //WXSceneSession;
    
    // 准备消息体
    switch (activityItem.mediaType) {
        case MLSContentMediaTypeText: {
            self.request.text = activityItem.detail;
            self.request.bText = YES;
            break;
        }
        case MLSContentMediaTypeImage: {
            WXImageObject *imgObj = [WXImageObjectClass object];
            imgObj.imageData = [NSData dataWithContentsOfURL:activityItem.attachmentURL];
            
            WXMediaMessage *message = [WXMediaMessageClass message];
            message.mediaObject = imgObj;
            
            self.request.message = message;
            break;
        }
        case MLSContentMediaTypeWebpage: {
            WXWebpageObject *webpage = (WXWebpageObject *)[WXWebpageObjectClass object];
            webpage.webpageUrl = activityItem.webpageURL.absoluteURL.absoluteString;
            
            WXMediaMessage *message = [WXMediaMessageClass message];
            message.title = activityItem.title;
            message.description = activityItem.detail;
            message.thumbData = activityItem.previewImageData;
            message.mediaObject = webpage;
            
            self.request.message = message;
            break;
        }
        case MLSContentMediaTypeMusic: {
            WXMusicObject *musicObj = (WXMusicObject *)[WXMusicObjectClass object];
            musicObj.musicUrl = activityItem.webpageURL.absoluteURL.absoluteString;
            musicObj.musicLowBandUrl = activityItem.webpageURL.absoluteURL.absoluteString;
            musicObj.musicDataUrl = activityItem.attachmentURL.absoluteURL.absoluteString;
            musicObj.musicLowBandDataUrl = activityItem.attachmentURL.absoluteURL.absoluteString;
            
            WXMediaMessage *message = (WXMediaMessage *)[WXMediaMessageClass message];
            message.title = activityItem.title;
            message.description = activityItem.detail;
            message.thumbData = activityItem.previewImageData;
            message.mediaObject = musicObj;
            
            self.request.message = message;
            break;
        }
        case MLSContentMediaTypeVideo: {
            WXVideoObject *videoObj = (WXVideoObject *)[WXVideoObjectClass object];
            videoObj.videoUrl = activityItem.webpageURL.absoluteURL.absoluteString;
            videoObj.videoLowBandUrl = videoObj.videoUrl;
            
            WXMediaMessage *message = [WXMediaMessageClass message];
            message.title = activityItem.title;
            message.description = activityItem.detail;
            message.thumbData = activityItem.previewImageData;
            message.mediaObject = videoObj;
            
            self.request.message = message;
            break;
        }
    }
}

- (void)perform {
    Class WXApi = NSClassFromString(@"WXApi");
    if ([WXApi sendReq:self.request]) {
        [self activityDidFinishWithError:nil];
    } else {
        [self activityDidFinishWithError:[NSError errorWithDomain:@"MLSocialShareErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"分享失败"}]];
    }
}

@end
