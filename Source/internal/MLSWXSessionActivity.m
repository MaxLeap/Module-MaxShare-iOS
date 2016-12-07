//
//  MLSWXSessionActivity.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/15/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSWXSessionActivity.h"

@implementation MLSWXSessionActivity

+ (void)load {
    [self registerActivityClass:self];
}

+ (MLSActivityType)type {
    return MLSActivityTypeWXSession;
}

- (nullable NSString *)title {
    return NSLocalizedString(@"微信", nil);
}

- (nullable UIImage *)image {
    return [UIImage imageNamed:@"MaxSocialShare.bundle/share_icon_wechat_session"];
}

- (void)prepareWithActivityItem:(MLShareItem *)activityItem {
    [super prepareWithActivityItem:activityItem];
    self.request.scene = WXSceneSession;
}

@end
