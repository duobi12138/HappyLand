//
//  MainViewController.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/31.
//

#import "MainViewController.h"
//#import "HomeViewController.h"
#import "DYVideoController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建TabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    
    //创建三个视图控制器
    DYVideoController *homeVC = [[DYVideoController alloc] init];
    homeVC.view.backgroundColor = [UIColor whiteColor];
    
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    messageVC.view.backgroundColor = [UIColor whiteColor];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    profileVC.view.backgroundColor = [UIColor whiteColor];
    
    //设置TabBar的标题和图标
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil tag:101];
    messageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:nil tag:102];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:nil tag:103];
    
    //将视图控制器添加到TabBarController
    NSArray *arrayVC = [NSArray arrayWithObjects:homeVC, messageVC, profileVC, nil];
    tabBarController.viewControllers = arrayVC;
    
    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
    [appearance configureWithDefaultBackground];
    
    appearance.backgroundColor = [UIColor blackColor]; // 浅灰色背景
    
    // 设置分栏标题字体大小和颜色
    // 设置未选中状态的样式
    [appearance.stackedLayoutAppearance.normal setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:16], // 字体大小
        NSForegroundColorAttributeName: [UIColor grayColor] // 字体颜色
    }];

    // 设置选中状态的样式
    [appearance.stackedLayoutAppearance.selected setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:18], // 字体大小
        NSForegroundColorAttributeName: [UIColor whiteColor] // 字体颜色
    }];
    
//    tabBarController.tabBar.hidden = YES; // 隐藏系统分栏
    
    // 应用样式
    tabBarController.tabBar.standardAppearance = appearance;
    tabBarController.tabBar.scrollEdgeAppearance = appearance;

    // 将TabBarController添加为子控制器
    [self addChildViewController:tabBarController];
    [self.view addSubview:tabBarController.view];
    [tabBarController didMoveToParentViewController:self];
    
    // 设置frame确保填满整个视图
    tabBarController.view.frame = self.view.bounds;
    tabBarController.selectedIndex = 0;
    // Do any additional setup after loading the view.
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
