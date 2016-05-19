//
//  MLSQQActivity.h
//  MaxSocialShare
//
//  Created by Sun Jin on 3/15/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSActivity.h"
#import <TencentOpenApi/QQApiInterfaceObject.h>
#import <TencentOpenApi/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface MLSQQActivity : MLSActivity

@property (nonatomic, strong) QQApiObject *obj;

@end
