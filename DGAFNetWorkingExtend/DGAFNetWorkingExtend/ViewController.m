//
//  ViewController.m
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import "ViewController.h"
#import "DGAFNetWorking.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听网络请求
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkChanged:) name:DG_NOTI_NETWORK_CHANGE object:nil];
    
//    [DGAFNetWorking POST:@"http://url" parameters:@{} versionCache:@"123" durtionCache:6 success:^(id responseObject) {
//        
//    } failure:^(id error) {
//        
//    }];
//    //带缓存的POST
//    [DGAFNetWorking POST:@"http://url" parameters:@{} responseCache:^(id cacheObject) {
//        
//    } success:^(id responseObject) {
//        
//    } failure:^(id error) {
//        
//    }];
    

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)netWorkChanged:(NSNotification*)cender{
    NSNumber *values =  cender.object;
    NSLog(@"values===%@",values);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
