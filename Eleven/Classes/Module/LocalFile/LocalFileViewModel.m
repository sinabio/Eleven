//
//  LocalFileViewModel.m
//  Eleven
//
//  Created by coderyi on 15/8/21.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "LocalFileViewModel.h"
#import "FileModel.h"
@implementation LocalFileViewModel
- (NSArray *)getLocalVideoFiles{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:ducumentsDirectory error:NULL];
    FileModel *fileModel;
    NSMutableArray *videoArrays=[NSMutableArray array];
    for (int i=0; i<contents.count; i++) {
        fileModel=[[FileModel alloc] init];
        NSString *testPath=contents[i];
        
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[[NSString alloc] initWithFormat:@"%@/%@",ducumentsDirectory,testPath] error:nil];
        fileModel.fileSize=[[fileAttributes objectForKey:@"NSFileSize"] longValue]/1000000;
        NSDate *modificationDate=[fileAttributes objectForKey:@"NSFileModificationDate"];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *modificationDateString=[formatter stringFromDate:modificationDate];
        

        
        NSString *fileCreationDateString=[formatter stringFromDate:[fileAttributes objectForKey:@"NSFileCreationDate"]];
        
        fileModel.fileModificationDate=modificationDateString;
        fileModel.fileCreationDate=fileCreationDateString;

        fileModel.path=[[NSString alloc] initWithFormat:@"%@/%@",ducumentsDirectory,testPath] ;
        fileModel.name=testPath;
        NSArray *range=[testPath componentsSeparatedByString:@"."];
        if (range.count>0) {
            fileModel.fileType=[range lastObject];

        }
        fileModel.title=fileModel.name;
        [videoArrays addObject:fileModel];
        
        
    }

    return videoArrays;
    
}
- (NSArray *)getLocalFiles{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:ducumentsDirectory error:NULL];

    return contents;

}

- (BOOL)removeLocalFile:(NSString *)localFile{

    NSFileManager *fileManager = [NSFileManager defaultManager];
 
    BOOL res=[fileManager removeItemAtPath:localFile error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    }else
        NSLog(@"文件删除失败");
    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:localFile]?@"YES":@"NO");
    
    
    return ![fileManager isExecutableFileAtPath:localFile];

}
@end
