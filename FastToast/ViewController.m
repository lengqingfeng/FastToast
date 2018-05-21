//
//  ViewController.m
//  FastToast
//
//  Created by lengshengren on 2018/4/27.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import "ViewController.h"
#import "FastToast.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FastToast shareinstance].circleColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)loading:(id)sender {
    //[FastToast showToastLoadingWithView:self.view graceTime:3];
    //[FastToast showToastLoadingMsg:@"请稍等.."];
    //[FastToast showToastLoadingMsg:@"请稍等..."];
    [FastToast showToastMsg:@"hello world"];
}
- (IBAction)toastMsg:(id)sender {
    [FastToast hideToast];
    // [FastToast showToastMsg:@"hello world"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
