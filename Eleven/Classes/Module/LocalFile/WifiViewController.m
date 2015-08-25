
//
//  WifiViewController.m
//  Eleven
//
//  Created by coderyi on 15/8/24.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "WifiViewController.h"
#import "HTTPServer.h"
#import "BaseNavigationController.h"
#import "WifiManager.h"
@interface WifiViewController ()<WebFileResourceDelegate>{
    UILabel *urlLabel;
    HTTPServer *httpServer;
    NSMutableArray *fileList;
}


@end

@implementation WifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"wifi transfer", @"");
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 50)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.numberOfLines=0;
    //    titleLabel.text=@"可以通过itunes或者wifi传输视频\n支持mp3,caff,aiff,ogg,wma,m4a,m4v,wmv,3gp,mp4,mov,avi,mkv,mpeg,mpg,flv,vob等格式";
    titleLabel.font=[UIFont systemFontOfSize:13];
    titleLabel.textColor=YiTextGray;
    titleLabel.text=NSLocalizedString(@"Open button, and then enter the address in the browser address bar\nClose button Remember when the transfer is complete", nil);
    [self.view addSubview:titleLabel];
    self.view.backgroundColor = [UIColor whiteColor];

    UISwitch *serviceSwitch=[[UISwitch alloc] initWithFrame:CGRectMake((ScreenWidth-60)/2, 150, 60, 40)];
    [self.view addSubview:serviceSwitch];
    
    serviceSwitch.on=[WifiManager sharedInstance].serverStatus;
    
    [serviceSwitch addTarget:self action:@selector(toggleService:) forControlEvents:UIControlEventValueChanged];
    
    urlLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, 40)];
    [self.view addSubview:urlLabel];
    urlLabel.textAlignment=NSTextAlignmentCenter;
    urlLabel.textColor=[UIColor blueColor];
//    fileList = [[NSMutableArray alloc] init];
//    [self loadFileList];
//    
//    // set up the http server
//    httpServer = [[HTTPServer alloc] init];
//    [httpServer setType:@"_http._tcp."];
//    [httpServer setPort:8080];
//    [httpServer setName:@"CocoaWebResource"];
//    [httpServer setupBuiltInDocroot];
//    httpServer.fileResourceDelegate = self;
    
    if (serviceSwitch.on) {
        [urlLabel setText:[NSString stringWithFormat:@"http://%@:%d", [[WifiManager sharedInstance].httpServer hostName], [[WifiManager sharedInstance].httpServer port]]];
    }else{
        
        [urlLabel setText:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    httpServer.fileResourceDelegate = nil;
    
}
- (void)toggleService:(id)sender
{
    NSError *error;
    if ([(UISwitch*)sender isOn])
    {
//        BOOL serverIsRunning = [httpServer start:&error];
        BOOL serverIsRunning ;
         [[WifiManager sharedInstance] operateServer:YES];
        [WifiManager sharedInstance].serverStatus=YES;
        if(!serverIsRunning)
        {
            NSLog(@"Error starting HTTP Server: %@", error);
        }
        [urlLabel setText:[NSString stringWithFormat:@"http://%@:%d", [[WifiManager sharedInstance].httpServer hostName], [[WifiManager sharedInstance].httpServer port]]];
    }
    else
    {
//        [httpServer stop];
        [[WifiManager sharedInstance] operateServer:NO];
[WifiManager sharedInstance].serverStatus=NO;
        [urlLabel setText:@""];
    }
}

// load file list
- (void)loadFileList
{
    [fileList removeAllObjects];
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
                                      enumeratorAtPath:docDir];
    NSString *pname;
    while (pname = [direnum nextObject])
    {
        [fileList addObject:pname];
    }
}

#pragma mark WebFileResourceDelegate
// number of the files
- (NSInteger)numberOfFiles
{
    return [fileList count];
}

// the file name by the index
- (NSString*)fileNameAtIndex:(NSInteger)index
{
    return [fileList objectAtIndex:index];
}

// provide full file path by given file name
- (NSString*)filePathForFileName:(NSString*)filename
{
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    return [NSString stringWithFormat:@"%@/%@", docDir, filename];
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString*)name inTempPath:(NSString*)tmpPath
{
    if (name == nil || tmpPath == nil)
        return;
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, name];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if (![fm moveItemAtPath:tmpPath toPath:path error:&error])
    {
        NSLog(@"can not move %@ to %@ because: %@", tmpPath, path, error );
    }
    
    [self loadFileList];
    
}

// implement this method to delete requested file and update the file list
- (void)fileShouldDelete:(NSString*)fileName
{
    NSString *path = [self filePathForFileName:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if(![fm removeItemAtPath:path error:&error])
    {
        NSLog(@"%@ can not be removed because:%@", path, error);
    }
    [self loadFileList];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
