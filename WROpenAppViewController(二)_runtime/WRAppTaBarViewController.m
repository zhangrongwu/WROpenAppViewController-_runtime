//
//  WRAppTaBarViewController.m
//  WROpenAppViewController(一)
//
//  Created by zhang_rongwu on 16/1/13.
//  Copyright © 2016年 zhang_rongwu. All rights reserved.
//

#import "WRAppTaBarViewController.h"
#import <objc/runtime.h>

@interface WRAppTaBarViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSArray *viewCtrs;

@end

@implementation WRAppTaBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWRViewController];
    
    NSString *url = @"qcrl://qcrlapp.com/push?text=饿了么与你一起热炼&url=http%3A%2F%2Fmp&id=2&class=WRMeViewController&subClass=WRMe_2ViewController";
    NSURL *openURL = [NSURL URLWithString:url];
    [self openViewControllerWithURL:openURL];
}

- (void)initWRViewController {
    self.meVc = [[WRMeViewController alloc]init];
    self.homeVc = [[WRHomeViewController alloc] init];
    NSArray *viewControllers = @[self.meVc, self.homeVc];
    self.viewCtrs = viewControllers;
    NSMutableArray *navigationCtrs = [NSMutableArray arrayWithCapacity:viewControllers.count];
    for (UIViewController *viewController in viewControllers) {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        //右拉返回功能(自定义了leftBarButtonItem后功能会消失,加上这个就ok了)
        nav.interactivePopGestureRecognizer.delegate = self;
        nav.delegate = self;
        [navigationCtrs addObject:nav];
    }
    self.viewControllers = navigationCtrs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 外部启动*/
- (void)openViewControllerWithURL:(NSURL *)pushUrl {
    // 外部启动一般是以urlSchemes形式启动app，所以处理得处理url例如：（qcrl://qcrlapp.com/push?text=饿了么与你一起热炼&url=http%3A%2F%2Fmp）
//    NSString *scheme = pushUrl.scheme;
//    NSString *path =pushUrl.path;
//    NSString *query = pushUrl.query;
//    
//    NSMutableDictionary *queryStrings = [NSMutableDictionary dictionary];
//    for (NSString *qs in [query componentsSeparatedByString:@"&"]) {
//        NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
//        NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
//        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        queryStrings[key] = value;
//    }
//    NSString *url = @"qcrl://qcrlapp.com/push?text=饿了么与你一起热炼&url=http%3A%2F%2Fmp&id=2&class=WRMeViewController&subClass=WRMe_2ViewController";
//    NSDictionary *dic = @{@"path":path,
//                          @"id":queryStrings[@"id"],
//                          @"class":queryStrings[@"class"],
//                          @"subClass":queryStrings[@"subClass"]};
    

    /**
     *
     *
     *
     * 以上代码为外部启动或者推送传入的字符串（url）,需要对url进行处理,得到以下dic
     *
     *
     *
     *
     *
     *
     *path: url地址
     *property: 进入页面的可能必要的参数
     *class: 一级页面对应的字段
     *
     **/
    NSDictionary *dic = @{@"path":@"qcrlapp.com/push",
                          @"property":@{@"ID": @"123",
                                        @"type": @"13121536034"
                                        },
                          @"class":@"WRHome_2ViewController"};
    /**
     *
     * 缺陷:
     * 只能进入二级页面，如果进入一级页面（tabbar上的页面）会涉及到无法返回的问题
     * 需要与安卓等端使用相同的类名（你们丢弃安卓，没话说）
     * 必须先跟服务端商量好，定义跳转规则
     *
     **/
    [self push:dic];
}

- (void)push:(NSDictionary *)params {
    // 服务器定义好的类名
    NSString *class = params[@"class"];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    Class newClass = objc_getClass(className);
    if (!newClass) {
        // 创建一个viewController
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        
        // 注册viewController
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    
    // 进入某个界面传入的必要参数由后台返回，利用kvc进行赋值
    NSDictionary *VCPropertys = params[@"property"];
    [VCPropertys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      
        //遍历，动态的检测所选的viewController是否有该属性
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
          
            // 如果这个对象中有对应的属性，则利用kvc赋值
            [instance setValue:obj forKey:key];
        }
    }];
    
    // 对应界面有值时，只需要通过导航控制器跳转到指定的界面
    // 获取当前控制器以及所在位置
    UINavigationController *pushClass = (UINavigationController *)self.viewControllers[self.selectedIndex];
    [pushClass pushViewController:instance animated:YES];
}

//  检测所选的viewController是否有该属性
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t *properties = class_copyPropertyList([instance class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
      
        // 获取的属性转为字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}

@end


















