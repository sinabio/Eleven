//
//  LocalFileViewController.m
//  Eleven
//
//  Created by coderyi on 15/8/18.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "LocalFileViewController.h"
#import "BaseNavigationController.h"
#import "LocalFileViewModel.h"
#import "FileModel.h"
#import "KxMovieViewController.h"
#import "WifiViewController.h"
#import "YiRefreshHeader.h"
#import "WifiManager.h"

@interface LocalFileViewController ()<UITableViewDataSource,UITableViewDelegate,WebFileResourceDelegate>{
    UITableView *tableView1;
    LocalFileViewModel *localFileViewModel;
    NSMutableArray *localFileArray;
    YiRefreshHeader *refreshHeader;
    NSMutableArray *fileList;
}

@end

@implementation LocalFileViewController
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    localFileViewModel=[[LocalFileViewModel alloc] init];
    localFileArray=[NSMutableArray array];
    localFileArray=(NSMutableArray *)[localFileViewModel getLocalVideoFiles];
    self.title = NSLocalizedString(@"Local Video", nil);
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(BaseNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:tableView1];
    
    tableView1.dataSource=self;
    tableView1.delegate=self;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"wifi" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction)];
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.numberOfLines=0;
    titleLabel.font=[UIFont systemFontOfSize:13];
    titleLabel.textColor=YiTextGray;
    //    titleLabel.text=@"可以通过itunes或者wifi传输视频\n支持mp3,caff,aiff,ogg,wma,m4a,m4v,wmv,3gp,mp4,mov,avi,mkv,mpeg,mpg,flv,vob等格式";
    titleLabel.text=NSLocalizedString(@"You can transfer video files via itunes or wifi\nSupport m4v, wmv, 3gp, mp4, mov, avi, mkv, mpeg, mpg, flv, vob format", nil);
    //来自kxmovie项目的MainViewController类
//    
    tableView1.tableHeaderView=titleLabel;
    [self addHeader];
    
    fileList = [[NSMutableArray alloc] init];
    [self loadFileList];
    [WifiManager sharedInstance].httpServer.fileResourceDelegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [WifiManager sharedInstance].httpServer.fileResourceDelegate = nil;
    
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
    
    localFileArray=(NSMutableArray *)[localFileViewModel getLocalVideoFiles];
    [tableView1 reloadData];
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
    localFileArray=(NSMutableArray *)[localFileViewModel getLocalVideoFiles];
    [tableView1 reloadData];
}



#pragma mark - Actions

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

- (void)rightBarAction{
    
    WifiViewController *viewController=[[WifiViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
#pragma mark - Private

- (void)addHeader{
    
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=tableView1;
    [refreshHeader header];
    __weak typeof(self) weakSelf = self;
    refreshHeader.beginRefreshingBlock=^(){
        localFileArray=(NSMutableArray *)[localFileViewModel getLocalVideoFiles];
        [tableView1 reloadData];
        [refreshHeader endRefreshing];
        
        
    };
    
    //    是否在进入该界面的时候就开始进入刷新状态
    
    //    [refreshHeader beginRefreshing];
}


#pragma mark - UITableViewDataSource  &UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return localFileArray.count;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    NSString *cellId=@"CellId1";
    cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    FileModel *file=localFileArray[indexPath.row];
    cell.textLabel.text=file.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld MB        %@",file.fileSize,file.fileCreationDate];
    return cell;
    
    
    
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        FileModel *file=localFileArray[indexPath.row];
        
        
        if ([localFileViewModel removeLocalFile:file.path]) {
            //删除数组里的数据    删除对应数据的cell
            NSMutableArray *arr=localFileArray;
            [arr removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FileModel *file=localFileArray[indexPath.row];
    
    
    
    NSString *path =file.path;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    
    // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    // disable buffering
    //parameters[KxMovieParameterMinBufferedDuration] = @(0.0f);
    //parameters[KxMovieParameterMaxBufferedDuration] = @(0.0f);
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                               parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    
    //    LoggerApp(1, @"Playing a movie: %@", path);
    
    
    
}
#pragma mark - Tool Methods

/**
 *  当tableview中 数据源数量很少不足以填满当前区域  比如只有1一个数据  那么它将隐藏 空cell的分割线
 */
- (void)setExtraCellLineHidden{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView1 setTableFooterView:view];
    [tableView1 setTableHeaderView:view];
    
}


@end
