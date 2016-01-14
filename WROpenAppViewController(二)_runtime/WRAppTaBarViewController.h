//
//  WRAppTaBarViewController.h
//  WROpenAppViewController(一)
//
//  Created by zhang_rongwu on 16/1/13.
//  Copyright © 2016年 zhang_rongwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "WRMeViewController.h"
#import "WRHomeViewController.h"
#import "WRViewControllerManager.h"
@interface WRAppTaBarViewController : UITabBarController
@property (nonatomic, strong)WRMeViewController *meVc;
@property (nonatomic, strong)WRHomeViewController *homeVc;

/** 外部启动*/
- (void)openViewControllerWithURL:(NSURL *)pushUrl;

@end
