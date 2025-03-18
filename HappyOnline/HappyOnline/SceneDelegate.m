//
//  SceneDelegate.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    
    //创建TabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    //创建三个视图控制器
    HomeViewController *homeVC = [[HomeViewController alloc] init];
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
    
    // 设置分栏标题字体大小和颜色
    // 设置未选中状态的样式
    [appearance.stackedLayoutAppearance.normal setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:16], // 字体大小
        NSForegroundColorAttributeName: [UIColor lightGrayColor] // 字体颜色
    }];

    // 设置选中状态的样式
    [appearance.stackedLayoutAppearance.selected setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:18], // 字体大小
        NSForegroundColorAttributeName: [UIColor blackColor] // 字体颜色
    }];
    
    // 应用样式
    tabBarController.tabBar.standardAppearance = appearance;
    tabBarController.tabBar.scrollEdgeAppearance = appearance;
    
    //设置根视图
    self.window.rootViewController = tabBarController;
    tabBarController.selectedIndex = 0;
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
    NSLog(@"创建成功");
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
