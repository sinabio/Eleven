//
//  HistoryArchive.m
//  Eleven
//
//  Created by coderyi on 15/8/24.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "HistoryArchive.h"
static NSString * const kHistoryArchiveKey = @"historyArchive";
@implementation HistoryArchive
- (NSString *)cacheDir{
    
    NSString *addressPath=[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject],@"cache1"];
    return addressPath;
    
}

//保存数组与归档
- (void)saveArr:(NSArray *)array {
    
    
    //归档
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:array forKey:kHistoryArchiveKey]; // archivingData的encodeWithCoder
    
    [archiver finishEncoding];
    //写入文件
    [data writeToFile:[self cacheDir] atomically:YES];
}


//解档得到数组
- (NSArray *)loadArchives{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self cacheDir]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //获得数组
    NSArray *archivingData = [unarchiver decodeObjectForKey:kHistoryArchiveKey];// initWithCoder方法被调用
    [unarchiver finishDecoding];
    
    return archivingData;
}


@end
