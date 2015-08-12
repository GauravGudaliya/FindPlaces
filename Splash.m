//
//  Splash.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "Splash.h"
#import "AppDelegate.h"
@interface Splash ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@implementation Splash

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    _lblname.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
     [[AppDelegate sharedInstance] showHUD];
    

    
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(Displaylist) userInfo:nil repeats:NO];
}
-(void)Displaylist
{
    [self performSegueWithIdentifier:@"catagory" sender:self];
    [[AppDelegate sharedInstance] hideHUD];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
