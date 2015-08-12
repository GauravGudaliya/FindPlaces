//
//  catagortSubDetailview.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "catagortSubDetailview.h"
#import "catagorySubDetailviewmap.h"
#import "Constant.h"
#import <Social/Social.h>
@interface catagortSubDetailview ()
{
    UIButton *barbutton;
}
@end

@implementation catagortSubDetailview

- (void)viewDidLoad {
    [super viewDidLoad];
    results=[[NSMutableDictionary alloc]init];
    UIBarButtonItem *Back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(selectorBack)];
   
    self.navigationItem.leftBarButtonItem= Back;
    
    barbutton=[[UIButton alloc]initWithFrame:CGRectMake(250, 20,70 ,20)];
    [barbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [barbutton addTarget:self action:@selector(btntypeAction) forControlEvents:UIControlEventTouchUpInside];
    [barbutton setTitle:@"Share" forState:UIControlStateNormal];
    UIBarButtonItem *Leftbarbutton=[[UIBarButtonItem alloc]initWithCustomView:barbutton];
    
    self.navigationItem.rightBarButtonItem= Leftbarbutton;
     _mainView.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",_placeid,APIKey]];

    NSMutableURLRequest *aUrlRequst=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [aUrlRequst setHTTPMethod:@"GET"];
    [aUrlRequst setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *aconnection=[NSURLConnection connectionWithRequest:aUrlRequst delegate:self];
    if (aconnection) {
        webdata=[NSMutableData data];
    }
    else
    {
        NSLog(@"Connection is Fail");
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webdata appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSMutableDictionary *result=[NSJSONSerialization JSONObjectWithData:webdata options:NSJSONReadingMutableContainers error:nil];
    results=[result objectForKey:@"result"];
    _lbladdress.text=[results objectForKey:@"formatted_address"];
    _lblwebsite.text=[results objectForKey:@"url"];
    _lblcontact.text=[results objectForKey:@"name"];
   
    
    _lblopne.text=[[[results objectForKey:@"opening_hours"] objectForKey:@"weekday_text"]objectAtIndex:0 ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)selectorBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)displayMap:(id)sender
{
    catagorySubDetailviewmap *Catagorydetailviewmap=[self.storyboard instantiateViewControllerWithIdentifier:@"catagortSubDetailviewmap"];
    Catagorydetailviewmap.title=self.title;
    
    Catagorydetailviewmap.result=results;
    [self.navigationController pushViewController:Catagorydetailviewmap animated:YES];
    
}
- (IBAction)redirectWeb:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[results objectForKey:@"url"]]];
}
- (IBAction)FBshare:(id)sender
{
     [self dismissOptions];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *aSLCVCFacebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler completionBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultDone)
            {
                [[[UIAlertView alloc]initWithTitle:@"Share with me" message:@"Shared on facebook successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                
            } else {
                
                NSLog(@"Error...");
            }
            [aSLCVCFacebook dismissViewControllerAnimated:YES completion:Nil];
        };
        aSLCVCFacebook.completionHandler = completionBlock;
        [aSLCVCFacebook setInitialText:[NSString stringWithFormat:@"Name :%@\n Address :%@",[results objectForKey:@"name"],[results objectForKey:@"formatted_address"]]];
        [aSLCVCFacebook addImage:[UIImage imageNamed:@"iTunesArtwork@2x"]];
        
        [self presentViewController:aSLCVCFacebook animated:YES completion:^{
        }];
    } else {
        UIAlertView *aUIAlert = [[UIAlertView alloc]initWithTitle:@"Share with me" message:@"Your facebook account is not configured. Please configure it from your iphone's settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aUIAlert show];
    }
}
-(IBAction)TWShare:(id)sender
{
     [self dismissOptions];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *aSLCVCTwitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler completionBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultDone) {
                
            } else {
                NSLog(@"Error...");
               
            }
            [aSLCVCTwitter dismissViewControllerAnimated:YES completion:Nil];
        };
        aSLCVCTwitter.completionHandler = completionBlock;
        [aSLCVCTwitter setInitialText:[NSString stringWithFormat:@"Name :%@\n Address :%@",[results objectForKey:@"name"],[results objectForKey:@"formatted_address"]]];
        [aSLCVCTwitter addImage:[UIImage imageNamed:@"iTunesArtwork@2x"]];
        [self presentViewController:aSLCVCTwitter animated:YES completion:^{
        }];
    } else {
        UIAlertView *aUIAlert = [[UIAlertView alloc]initWithTitle:@"Share with me" message:@"Your twitter account is not configured. Please configure it from your iphone's settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aUIAlert show];
    }
}
- (IBAction)btntypeAction
{
    if (barbutton.selected == NO)
    {
        [self presentOptions];
        barbutton.selected=YES;
    }
    else
    {
        [self dismissOptions];
        barbutton.selected=NO;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissOptions];
    barbutton.selected=NO;
    
}

-(void)presentOptions{
    _mainView.hidden = NO;
    _mainView.backgroundColor = [UIColor clearColor];
    _subView.transform = CGAffineTransformTranslate(_subView.transform, 0, -_subView.frame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        _mainView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _subView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)dismissOptions{
    
    [UIView animateWithDuration:0.4 animations:^{
        _subView.transform = CGAffineTransformTranslate(_mainView.transform, 0.0, -_subView.frame.size.height);
        _mainView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        _mainView.hidden =  YES;
    }];
    
}

@end
