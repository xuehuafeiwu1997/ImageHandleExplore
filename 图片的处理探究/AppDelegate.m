//
//  AppDelegate.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/9.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"
#import "MainViewController.h"
#import "SixthViewController.h"
#import "SeventhViewController.h"
#import "EighthViewController.h"
#import "NinthViewController.h"
#import "TenthViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
//    ViewController *vc = [[ViewController alloc] init];
//    FirstViewController *vc = [[FirstViewController alloc] init];
//    SecondViewController *vc = [[SecondViewController alloc] init];
//    ThirdViewController *vc = [[ThirdViewController alloc] init];
//    FourthViewController *vc = [[FourthViewController alloc] init];
//    FifthViewController *vc = [[FifthViewController alloc] init];
//    MainViewController *vc = [[MainViewController alloc] init];
//    SixthViewController *vc = [[SixthViewController alloc] init];
//    SeventhViewController *vc = [[SeventhViewController alloc] init];
//    EighthViewController *vc = [[EighthViewController alloc] init];
//    NinthViewController *vc = [[NinthViewController alloc] init];
    TenthViewController *vc = [[TenthViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    return YES;
}

@end
