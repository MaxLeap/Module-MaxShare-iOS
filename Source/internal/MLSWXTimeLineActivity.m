//
//  MLSWXTimeLineActivity.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/15/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSWXTimeLineActivity.h"

@implementation MLSWXTimeLineActivity

+ (void)load {
    [self registerActivityClass:self];
}

+ (MLSActivityType)type {
    return MLSActivityTypeWXTimeLine;
}

- (nullable NSString *)title {
    return NSLocalizedString(@"微信朋友圈", nil);
}

- (nullable UIImage *)image {
    return [UIImage imageNamed:@"MaxSocialShare.bundle/share_icon_wechat_timeline"];
}

- (void)prepareWithActivityItem:(MLShareItem *)activityItem {
    [super prepareWithActivityItem:activityItem];
    self.request.scene = WXSceneTimeline;
}

@end


