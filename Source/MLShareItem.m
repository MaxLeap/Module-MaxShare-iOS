//
//  MLSActivityItem.m
//  MaxSocialShare
//

#import "MLShareItem.h"


@interface MLShareItem ()
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end

@implementation MLShareItem

- (instancetype)initWithMediaType:(MLSContentMediaType)mediaType {
    if (self = [super init]) {
        _objectId = [NSUUID UUID];
        self.mediaType = mediaType;
    }
    return self;
}

- (void)setLocationWithLatitude:(double)latitude longitude:(double)longitude {
    self.latitude = latitude;
    self.longitude = longitude;
}

#pragma mark -
#pragma mark Convenience

+ (instancetype)itemWithMediaType:(MLSContentMediaType)mediaType {
    return [[MLShareItem alloc] initWithMediaType:mediaType];
}

+ (instancetype)textItemWithTitle:(nullable NSString *)title detail:(NSString *)detail {
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeText];
    item.title = title;
    item.detail = detail;
    return item;
}

+ (instancetype)imageItemWithImageURL:(NSURL *)imageURL title:(NSString *)title detail:(NSString *)detail {
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeImage];
    item.title = title;
    item.detail = detail;
    item.attachmentURL = imageURL;
    return item;
}

+ (instancetype)webpageItemWithURL:(NSURL *)url title:(NSString *)title detail:(NSString *)detail {
    MLShareItem *item = [MLShareItem itemWithMediaType:MLSContentMediaTypeWebpage];
    item.webpageURL = url;
    item.title = title;
    item.detail = detail;
    return item;
}

@end


