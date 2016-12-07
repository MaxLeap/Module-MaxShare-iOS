//
//  MLSQZoneActivity.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/15/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSQZoneActivity.h"

@implementation MLSQZoneActivity


+ (void)load {
    [self registerActivityClass:self];
}

+ (MLSActivityType)type {
    return MLSActivityTypeQZone;
}

- (nullable NSString *)title {
    return NSLocalizedString(@"QQ空间", nil);
}

- (nullable UIImage *)image {
    return [UIImage imageNamed:@"MaxSocialShare.bundle/share_icon_qzone"];
}

- (void)prepareWithActivityItem:(MLShareItem *)activityItem {
    [super prepareWithActivityItem:activityItem];
    [self.obj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
}

@end
