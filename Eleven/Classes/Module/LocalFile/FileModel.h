//
//  FileModel.h
//  Eleven
//
//  Created by coderyi on 15/8/21.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject

@property(nonatomic,assign) long fileSize;
@property(nonatomic,strong) NSString *fileModificationDate;
@property(nonatomic,strong) NSString *fileCreationDate;
@property(nonatomic,strong) NSString *path;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *fileType;
@end
