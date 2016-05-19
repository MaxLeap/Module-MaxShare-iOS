//
//  MLSActivity.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/15/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSActivity+Private.h"

@implementation MLSActivity

+ (MLSActivityType)type {
    return MLSActivityTypeOther;
}

+ (BOOL)canPerformWithActivityItem:(MLShareItem *)activityItem {
    return NO;
}

- (NSString *)title {
    return nil;
}

- (UIImage *)image {
    return nil;
}

- (void)prepareWithActivityItem:(MLShareItem *)activityItem {
    
}

- (UIViewController *)activityViewController {
    return nil;
}

- (void)perform {
    [self activityDidFinishWithError:nil];
}

- (void)activityDidFinishWithError:(NSError *)error {
    // dismiss activity view controller
    // trigger activity view controller's completion handler
    self.completionHandler(error);
}

#pragma mark -

+ (NSMutableDictionary<NSNumber*, Class> *)registeredSubclasses {
    static NSMutableDictionary<NSNumber*, Class> *activitySubclasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activitySubclasses = [NSMutableDictionary dictionary];
    });
    return activitySubclasses;
}


+ (void)registerActivityClass:(Class)activityClass {
    NSParameterAssert([activityClass isSubclassOfClass:[MLSActivity class]]);
    
    [self registeredSubclasses][@([activityClass type])] = activityClass;
}

+ (NSArray<MLSActivity *> *)activitiesCanPerformWithActivityItem:(MLShareItem *)activityItem excludedActivityTypes:(NSArray<NSNumber *> *)excludedActivityTypes {
    
    if (activityItem == nil) {
        return @[];
    }
    
    NSMutableArray *results = [NSMutableArray array];
    [[self registeredSubclasses] enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        if ( ! [excludedActivityTypes containsObject:key]
            && [obj canPerformWithActivityItem:activityItem])
        {
            [results addObject:[obj new]];
        }
    }];
    return [results copy];
}

@end

