//
//  WifiManager.h
//  Eleven
//
//  Created by coderyi on 15/8/25.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"
@interface WifiManager : NSObject
@property(strong,nonatomic) HTTPServer *httpServer;
@property(assign,nonatomic) BOOL serverStatus;
+ (instancetype)sharedInstance;
- (void)operateServer:(BOOL)status;
@end
