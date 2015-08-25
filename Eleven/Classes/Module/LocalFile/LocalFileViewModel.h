//
//  LocalFileViewModel.h
//  Eleven
//
//  Created by coderyi on 15/8/21.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalFileViewModel : NSObject
- (NSArray *)getLocalVideoFiles;

- (NSArray *)getLocalFiles;

- (BOOL)removeLocalFile:(NSString *)localFile;
@end
