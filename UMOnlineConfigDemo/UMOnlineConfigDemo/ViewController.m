//
//  ViewController.m
//  UMOnlineConfigDemo
//
//  Created by zhangjunhua on 2020/9/1.
//  Copyright © 2020 zhangjunhua. All rights reserved.
//

#import "ViewController.h"

#import <UMCommon/UMRemoteConfig.h>
#import <UMCommon/UMRemoteConfigSettings.h>

@interface ViewController ()

@property(nonatomic,strong)UILabel* configlabelValueLablel;

@end

@implementation ViewController

-(void)showViewForNewConfig{
    NSString* configtestValue =  [UMRemoteConfig configValueForKey:@"configtest"];
    self.configlabelValueLablel.text = configtestValue;
}

-(void)handleRemoteConfigActivated:(NSNotification *)notification{
    [self showViewForNewConfig];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel* configlabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 60, 100,50)];
    configlabelTitle.text = @"configtest:";
    [self.view addSubview:configlabelTitle];
    
    UILabel* configlabelValueLablel = [[UILabel alloc] initWithFrame:CGRectMake(150, 60, 150, 50)];
    configlabelValueLablel.text = @"unknown";
    configlabelValueLablel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:configlabelValueLablel];
    self.configlabelValueLablel = configlabelValueLablel;
    
    [self showViewForNewConfig];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteConfigActivated:) name:@"remoteConfigActivated" object:nil];
}


@end
