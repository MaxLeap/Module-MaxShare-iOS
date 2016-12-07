//
//  MLSQQActivity.m
//  MaxSocialShare
//

#import "MLSQQActivity.h"

@implementation MLSQQActivity

+ (BOOL)canPerformWithActivityItem:(MLShareItem *)activityItem {
    NSArray<NSNumber*> *supportedTypes = @[@(MLSContentMediaTypeText), @(MLSContentMediaTypeImage), @(MLSContentMediaTypeMusic), @(MLSContentMediaTypeVideo), @(MLSContentMediaTypeWebpage)];
    BOOL support = [supportedTypes containsObject:@(activityItem.mediaType)];
    BOOL qqInstalled = [NSClassFromString(@"TencentOAuth") iphoneQQInstalled];
    return support && qqInstalled;
}

- (void)prepareWithActivityItem:(MLShareItem *)activityItem {
    Class QQApiTextObject = NSClassFromString(@"QQApiTextObject");
    Class QQApiImageObject = NSClassFromString(@"QQApiImageObject");
    Class QQApiNewsObject = NSClassFromString(@"QQApiNewsObject");
    Class QQApiAudioObject = NSClassFromString(@"QQApiAudioObject");
    Class QQApiVideoObject = NSClassFromString(@"QQApiVideoObject");
    
    // 准备腾讯消息体
    switch (activityItem.mediaType) {
        case MLSContentMediaTypeText: {
            self.obj = [QQApiTextObject objectWithText:activityItem.detail];
            break;
        }
        case MLSContentMediaTypeImage: {
            NSData *attachmentData = [NSData dataWithContentsOfURL:activityItem.attachmentURL];
            self.obj = [QQApiImageObject objectWithData:attachmentData
                                  previewImageData:activityItem.previewImageData
                                             title:activityItem.title
                                       description:activityItem.detail
                                    imageDataArray:nil];
            break;
        }
        case MLSContentMediaTypeWebpage: {
            self.obj = [QQApiNewsObject objectWithURL:activityItem.webpageURL title:activityItem.title description:activityItem.detail previewImageData:activityItem.previewImageData];
            break;
        }
        case MLSContentMediaTypeMusic: {
            self.obj = [QQApiAudioObject objectWithURL:activityItem.attachmentURL title:activityItem.title description:activityItem.detail previewImageData:activityItem.previewImageData];
            break;
        }
        case MLSContentMediaTypeVideo: {
            self.obj = [QQApiVideoObject objectWithURL:activityItem.attachmentURL title:activityItem.title description:activityItem.detail previewImageData:activityItem.previewImageData];
            break;
        }
    }
}

- (NSError *)handleSendResult:(QQApiSendResultCode)sendResult {
    NSString *errMsg = nil;
    switch (sendResult) {
        case 6: //EQQAPIAPPNOTREGISTED:
            errMsg = NSLocalizedString(@"App未注册", nil);
            break;
        case 5: //EQQAPIMESSAGECONTENTINVALID:
        case 4: //EQQAPIMESSAGECONTENTNULL:
        case 3: //EQQAPIMESSAGETYPEINVALID:
            errMsg = NSLocalizedString(@"发送参数错误", nil);
            break;
        case 1: //EQQAPIQQNOTINSTALLED:
            errMsg = NSLocalizedString(@"未安装手Q", nil);
            break;
        case 2: //EQQAPIQQNOTSUPPORTAPI:
            errMsg = NSLocalizedString(@"API接口不支持", nil);
            break;
        case -1: //EQQAPISENDFAILD:
            errMsg = NSLocalizedString(@"发送失败", nil);
            break;
        default:
            break;
    }
    if (errMsg) {
        return [NSError errorWithDomain:@"MLSocialShareErrorDomain" code:sendResult userInfo:@{NSLocalizedDescriptionKey:errMsg}];
    }
    return nil;
}

- (void)perform {
    Class SendMessageToQQReq = NSClassFromString(@"SendMessageToQQReq");
    Class QQApiInterface = NSClassFromString(@"QQApiInterface");
    
    QQApiSendResultCode code = [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:self.obj]];
    NSError *error = [self handleSendResult:code];
    [self activityDidFinishWithError:error];
}

@end
