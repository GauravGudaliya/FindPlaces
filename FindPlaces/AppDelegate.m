//
//  AppDelegate.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Constant.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate *)sharedInstance
{
    
    AppDelegate *sharedinstance=[[UIApplication sharedApplication]delegate];
    return sharedinstance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Helvetica Neue-Bold" size:20],
      NSFontAttributeName,
      nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    Reachability *reachibility=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reachibility currentReachabilityStatus];
    [reachibility startNotifier];
    if (status == !NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" message:@"Newtwork is Not Available \n Please Check ?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        alert.tag=001;
        [alert show];
    }
    _navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.2 green:1 blue:1 alpha:0.5]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navController setNavigationBarHidden:YES];
    [GMSServices provideAPIKey:APIKey];
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)showHUD
{
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // Do something...
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.window animated:YES];
//        });
//    });
}
-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}
@end
