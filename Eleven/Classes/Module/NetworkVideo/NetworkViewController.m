//
//  NetworkViewController.m
//  Eleven
//
//  Created by coderyi on 15/8/21.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "NetworkViewController.h"
#import "BaseNavigationController.h"
#import "KxMovieViewController.h"
#import "HistoryArchive.h"
@interface NetworkViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *tableView1;

    NSMutableArray *historyArchiveArray;
    UITextField *textField;
    HistoryArchive *historyArchive;

}

@end

@implementation NetworkViewController
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=NSLocalizedString(@"Network Video", nil);

    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(BaseNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView1];
    
    tableView1.dataSource=self;
    tableView1.delegate=self;
    tableView1.rowHeight=40;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"clear", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction)];
 
    historyArchiveArray=[NSMutableArray arrayWithCapacity:1];
    historyArchive=[[HistoryArchive alloc] init];
    historyArchiveArray=(NSMutableArray *)[historyArchive loadArchives];
    if (historyArchiveArray.count<1) {
        historyArchiveArray=[NSMutableArray arrayWithCapacity:1];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions

- (void)rightBarAction{
    [historyArchiveArray removeAllObjects];
    [historyArchive saveArr:nil];
    [tableView1 reloadData];
    
    
}

- (void)textAction:(UITextField *)textField1{
    if ([textField1 isFirstResponder]) {
        [textField1 resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField1
{
    [textField1 resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
#pragma mark - UITableViewDataSource  &UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];

    if (section==0) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        label.textColor=YiTextGray;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:13];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=NSLocalizedString(@"Enter any HTTP, RTSP, RTMP, RTP address play network streaming or live", nil);
//       来自wikipedia和https://www.vitamio.org/docs/Basic/2013/0429/3.html
        label.numberOfLines=0;
         [view addSubview:label];
    }
    
   
    
    return view;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return historyArchiveArray.count;
    }
    return 0;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell;
        
        NSString *cellId=@"CellId1";
        cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            if (indexPath.row==0){
                textField=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                [cell.contentView addSubview:textField];
                textField.backgroundColor=YiGray;
                textField.font=[UIFont systemFontOfSize:13];
                textField.delegate=self;
                [textField addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventTouchUpInside];
            }else if (indexPath.row==1) {
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                [cell.contentView addSubview:label];
                
                label.text=NSLocalizedString(@"play", nil);
                label.textAlignment=NSTextAlignmentCenter;
            }
        }
        
        return cell;
    }else if (indexPath.section==1){
    
        UITableViewCell *cell;
        
        NSString *cellId=@"CellId1";
        cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.textLabel.text=historyArchiveArray[indexPath.row];
        return cell;
    }
    
    
    return nil;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *path;
//    path =@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";

    if (indexPath.section==0) {
        if (indexPath.row==1) {
            if (textField.text.length>0) {
                [historyArchiveArray addObject:textField.text];
                [historyArchive saveArr:historyArchiveArray];
                path=textField.text;
                [tableView1 reloadData];
            }
        }
    }else if (indexPath.section==1){
        path=historyArchiveArray[indexPath.row];
    
    }
    
    if (path.length<1 || !path) {
        return;
    }
 
    
    

    
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



@end
