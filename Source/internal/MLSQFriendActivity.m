//
//  MLSQFriendActivity.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/22/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSQFriendActivity.h"

@implementation MLSQFriendActivity

+ (void)load {
    [self registerActivityClass:self];
}

+ (MLSActivityType)type {
    return MLSActivityTypeQQ;
}

- (nullable NSString *)title {
    return NSLocalizedString(@"QQ", nil);
}

- (nullable UIImage *)image {
    return [UIImage imageNamed:@"MaxSocialShare.bundle/share_icon_qq"];
}

@end
