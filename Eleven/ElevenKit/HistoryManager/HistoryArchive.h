//
//  HistoryArchive.h
//  Eleven
//
//  Created by coderyi on 15/8/24.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryArchive : NSObject
- (void)saveArr:(NSArray *)array;//保存数组与归档
- (NSArray *)loadArchives;//解档得到数组
@end
