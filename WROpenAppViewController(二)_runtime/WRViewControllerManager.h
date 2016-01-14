//
//  WRViewControllerManager.h
//  WROpenAppViewController(一)
//
//  Created by zhang_rongwu on 16/1/13.
//  Copyright © 2016年 zhang_rongwu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ViewController.h"
#import "WRMeViewController.h"
#import "WRMe_1ViewController.h"
#import "WRMe_2ViewController.h"

#import "WRHomeViewController.h"
#import "WRHome_1ViewController.h"
#import "WRHome_2ViewController.h"

@interface WRViewControllerManager : NSObject
+(instancetype) sharedInstance;

-(UIViewController *) compareWithTabBarIndex:(NSInteger)index pushInfo:(NSDictionary *)info;

@end
