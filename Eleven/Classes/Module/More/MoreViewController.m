//
//  MoreViewController.m
//  Eleven
//
//  Created by coderyi on 15/8/24.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "MoreViewController.h"
#import "BaseNavigationController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"More", nil);
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(BaseNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-310)/2, 150, 310, 150)];
    [self.view addSubview:label];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=YiTextGray;
    label.numberOfLines=0;
    label.text=@"Eleven是“十一”,“十一”二字取自“德”字。，由彳(chi)、十、目、一、心组成。\n十，指代直线，正确的标的方向。一，惟初太始。道立于一，造分天地，化成万物。\n\nEleven open source：\nhttps://github.com/coderyi/Eleven\n\nemail:coderyi@foxmail.com";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
