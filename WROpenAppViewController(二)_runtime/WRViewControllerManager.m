//
//  WRViewControllerManager.m
//  WROpenAppViewController(一)
//
//  Created by zhang_rongwu on 16/1/13.
//  Copyright © 2016年 zhang_rongwu. All rights reserved.
//

#import "WRViewControllerManager.h"
@interface WRViewControllerManager()
@property (nonatomic, strong)NSArray *WR_TabViewController_List;
// 一组viewController
@property (nonatomic, strong)NSArray *WR_ViewController_List_1;

@property (nonatomic, strong)NSArray *WR_ViewController_List_2;

@end

@implementation WRViewControllerManager
+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


@end
