//
//  settingView.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingView : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *displayname;
@property (weak, nonatomic) IBOutlet UITextField *txtRdius;
@property (weak, nonatomic) IBOutlet UISlider *sliderRdiuse;
- (IBAction)displaynameAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtusername;
- (IBAction)sliderradiusAction:(id)sender;

@end
