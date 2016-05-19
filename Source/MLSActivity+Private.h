//
//  MLSActivity+Private.h
//  MaxSocialShare
//
//  Created by Sun Jin on 3/22/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSActivity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLSActivity ()

@property (nonatomic, copy) void (^completionHandler)(NSError *error);

@end

NS_ASSUME_NONNULL_END
