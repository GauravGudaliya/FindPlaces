//
//  settingView.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "settingView.h"
#import "MVRadioButton.h"
#import "SWRevealViewController.h"
#import "selectedcatagory.h"
@interface settingView ()<UITextFieldDelegate>
{
    MVRadioButton *radioDefaultView;
    MVRadioButton *radioDefaultView1;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectDrower;
@end

@implementation settingView

- (void)viewDidLoad {
    [super viewDidLoad];
       SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_selectDrower setTarget: self.revealViewController];
        [_selectDrower setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    _txtusername.hidden=YES;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"usernamestatus"]isEqualToString:@"yes"])
    {
        _displayname.on=YES;
        _txtusername.hidden=NO;
         _txtusername.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    else
    {
        _displayname.on=NO;
    }
    _sliderRdiuse.value=[[[NSUserDefaults standardUserDefaults] objectForKey:@"rediusvalue"] integerValue];
    _txtRdius.text=[NSString stringWithFormat:@"%d",(int)_sliderRdiuse.value];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -  Default View
- (IBAction)radioGrid:(MVRadioButton *)sender
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"List"])
    {
      radioDefaultView.isOn = NO;
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"Grid"])
    {
        radioDefaultView.isOn = YES;
    }

    
    
    if (sender.tag==1)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"List"forKey:@"displaytype"];
        [defaults synchronize];
    }
    else if(sender.tag==2)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Grid"forKey:@"displaytype"];
        [defaults synchronize];
    }
    if(sender!=radioDefaultView)
    {
        radioDefaultView.isOn = NO;
    }
    radioDefaultView =  sender;
    radioDefaultView.isOn = YES;
    
}

- (IBAction)radioMap:(MVRadioButton*)sender
{
    sender.isOn=!sender.isOn;
    if(sender!=radioDefaultView1){
        radioDefaultView1.isOn = NO;
    }
    radioDefaultView1 =  sender;
    radioDefaultView1.isOn = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self saveUserName];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtRdius resignFirstResponder];
    [_txtusername resignFirstResponder];
    [self saveUserName];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self saveUserName];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self radiusvalue];
    return YES;
}
-(void)saveUserName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:_txtusername.text forKey:@"username"];
    [defaults synchronize];

}
-(void)radiusvalue
{
    if (-1 < _sliderRdiuse.value &&[_txtRdius.text integerValue] <1001)
    {
        _sliderRdiuse.value=[_txtRdius.text integerValue];
  
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%f",_sliderRdiuse.value]  forKey:@"rediusvalue"];
        [defaults synchronize];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Enter the between 0 to 1000" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
      _txtRdius.text=[NSString stringWithFormat:@"%d",(int)_sliderRdiuse.value];  
    }
}
- (IBAction)displaynameAction:(id)sender
{
    if (_displayname.isOn)
    {
        _txtusername.hidden=NO;
        _txtusername.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"yes" forKey:@"usernamestatus"];

        [defaults synchronize];
    }
    else
    {
        _txtusername.hidden=YES;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"no" forKey:@"usernamestatus"];
        [defaults setObject:@"" forKey:@"username"];
        [defaults synchronize];

    }
}
- (IBAction)sliderradiusAction:(id)sender
{
    _txtRdius.text=[NSString stringWithFormat:@"%d",(int)_sliderRdiuse.value];
    [self radiusvalue];

}
- (IBAction)openTableView:(id)sender
{
    selectedcatagory *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"tableView"];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
