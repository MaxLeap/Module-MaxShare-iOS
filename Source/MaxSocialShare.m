//
//  MaxSocialShare.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/15/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MaxSocialShare.h"

@interface MaxSocialContainer ()
@property (nonatomic) CGRect rect;
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIBarButtonItem *item;

@property (nonatomic) UIPopoverArrowDirection arrowDirections; // default is UIPopoverArrowDirectionAny
@end

@implementation MaxSocialContainer

+ (instancetype)containerWithRect:(CGRect)rect inView:(UIView *)view {
    return [self containerWithRect:rect inView:view permittedArrowDirectioins:UIPopoverArrowDirectionAny];
}

+ (instancetype)containerWithRect:(CGRect)rect inView:(UIView *)view permittedArrowDirectioins:(UIPopoverArrowDirection)arrowDirections {
    MaxSocialContainer *container = [MaxSocialContainer new];
    container.rect = rect;
    container.view = view;
    container.arrowDirections = arrowDirections;
    return container;
}

+ (instancetype)containerWithBarButtonItem:(UIBarButtonItem *)item {
    return [self containerWithBarButtonItem:item permittedArrowDirectioins:UIPopoverArrowDirectionAny];
}

+ (instancetype)containerWithBarButtonItem:(UIBarButtonItem *)item permittedArrowDirectioins:(UIPopoverArrowDirection)arrowDirections {
    MaxSocialContainer *container = [MaxSocialContainer new];
    container.item = item;
    container.arrowDirections = arrowDirections;
    return container;
}

@end

@implementation MaxSocialShare

+ (UIViewController *)topmostViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (void)shareItem:(MLShareItem *)item completion:(MLSActivityViewControllerCompletionBlock)block {
    [self shareItem:item withContainer:nil completion:block];
}

+ (void)shareItem:(MLShareItem *)item
         fromView:(nullable UIView *)view
       completion:(nonnull MLSActivityViewControllerCompletionBlock)block
{
    UIView *containerView = view.window.subviews.firstObject;
    CGRect rect = [containerView convertRect:view.bounds fromView:view];
    MaxSocialContainer *container = [MaxSocialContainer containerWithRect:rect inView:containerView];
    [self shareItem:item withContainer:container completion:block];
}

+ (void)shareItem:(MLShareItem *)item
fromBarButtonItem:(nullable UIBarButtonItem *)barButtonItem
       completion:(nonnull MLSActivityViewControllerCompletionBlock)block
{
    MaxSocialContainer *container = [MaxSocialContainer containerWithBarButtonItem:barButtonItem];
    [self shareItem:item withContainer:container completion:block];
}

+ (void)shareItem:(MLShareItem *)item withContainer:(MaxSocialContainer *)container completion:(MLSActivityViewControllerCompletionBlock)block {
    
    dispatch_block_t b = ^{
        MLSActivityViewController *avc = [[MLSActivityViewController alloc] initWithItem:item];
        avc.completionHandler = block;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
            && container) {
            avc.modalPresentationStyle = UIModalPresentationFullScreen;
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:avc];
            if (container.item) {
                [popover presentPopoverFromBarButtonItem:container.item permittedArrowDirections:container.arrowDirections animated:YES];
            } else if (container.view) {
                [popover presentPopoverFromRect:container.rect inView:container.view permittedArrowDirections:container.arrowDirections animated:YES];
            }
        } else {
            [[self topmostViewController] presentViewController:avc animated:YES completion:nil];
        }
    };
    
    if ([NSThread isMainThread]) {
        b();
    } else {
        dispatch_async(dispatch_get_main_queue(), b);
    }
}

+ (void)shareText:(NSString *)text completion:(MLSActivityViewControllerCompletionBlock)block {
    MLShareItem *item = [MLShareItem textItemWithTitle:nil detail:text];
    [self shareItem:item completion:block];
}

+ (void)shareWebpageURL:(NSURL *)url completion:(MLSActivityViewControllerCompletionBlock)block {
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeWebpage];
    item.webpageURL = url;
    [self shareItem:item completion:block];
}

+ (void)shareImageAtURL:(NSURL *)imageURL completion:(MLSActivityViewControllerCompletionBlock)block {
    MLShareItem *item = [MLShareItem imageItemWithImageURL:imageURL title:nil detail:nil];
    [self shareItem:item completion:block];
}

@end


