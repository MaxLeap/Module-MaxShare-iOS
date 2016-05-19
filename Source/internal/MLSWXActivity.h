//
//  MLSWXActivity.h
//  MaxSocialShare
//
//  Created by Sun Jin on 3/21/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSActivity.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface MLSWXActivity : MLSActivity

@property (nonatomic, strong) SendMessageToWXReq *request;

@end
