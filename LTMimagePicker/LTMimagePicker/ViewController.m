//
//  ViewController.m
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/19.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "ViewController.h"
#import "adViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 80)];
    btn.backgroundColor=[UIColor grayColor];
    [btn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)pushAction:(UIButton *)sender{
    adViewController *vc=[[adViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
