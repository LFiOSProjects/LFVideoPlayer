//
//  PTVideoDetailController.m
//  PTApp
//
//  Created by 王林芳 on 2018/4/20.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "PTVideoDetailController.h"

@interface PTVideoDetailController ()

@end

@implementation PTVideoDetailController
- (void)viewWillAppear:(BOOL)animated{
    self.player.isHideReturnBtn = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    self.player.isHideReturnBtn = YES;
    [self.view_playerFather addSubview:self.player];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self)weakSelf = self;
    self.player.returnLastpage = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self prefersStatusBarHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden{
    return YES;
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
