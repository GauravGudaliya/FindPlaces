//
//  AppDelegate.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong , nonatomic) UINavigationController *navController;
-(void)showHUD;
-(void)hideHUD;
+(AppDelegate *)sharedInstance;
@end

