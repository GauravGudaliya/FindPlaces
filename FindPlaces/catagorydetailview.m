//
//  catagorydetailview.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "catagorydetailview.h"
#import "catagortSubDetailview.h"
#import "catagoryDetailviewmap.h"
#import "catagorySubDetailviewmap.h"
#import "MBProgressHUD.h"
@interface catagorydetailview ()<UIAlertViewDelegate>
{
    NSString *radius;
    UIButton *leftbarbutton;
    UIButton *rightbarbutton;
}
@end

@implementation catagorydetailview
#pragma mark
#pragma mark-Initialization
- (void)viewDidLoad
{
    [super viewDidLoad];
    result=[[NSMutableDictionary alloc]init];
    
    rightbarbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,35 ,35)];
    [rightbarbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightbarbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(selectorBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbarbutton];
    
    leftbarbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,35 ,35)];
    [leftbarbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftbarbutton setImage:[UIImage imageNamed:@"radius"] forState:UIControlStateNormal];
    [leftbarbutton addTarget:self action:@selector(changeradius) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *Leftbarbutton=[[UIBarButtonItem alloc]initWithCustomView:leftbarbutton];
    
    self.navigationItem.rightBarButtonItem=Leftbarbutton;
    radius=[[NSUserDefaults standardUserDefaults] objectForKey:@"rediusvalue"];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=%@&types=%@&key=%@",_latitude,_longitude,radius, _type,APIKey]];
    

    NSMutableURLRequest *aUrlRequst=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [aUrlRequst setHTTPMethod:@"GET"];
    [aUrlRequst setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[AppDelegate sharedInstance] showHUD];
    
    NSURLConnection *aconnection=[NSURLConnection connectionWithRequest:aUrlRequst delegate:self];
    if (aconnection) {
        webdata=[NSMutableData data];
        
    }
    else
    {
        NSLog(@"Connection is Fail");
    }
    _notFoundicon.hidden=YES;
    _mainView.hidden=YES;
    _sliderRdiuse.value=[[[NSUserDefaults standardUserDefaults] objectForKey:@"rediusvalue"] integerValue];
    _txtRdius.text=[NSString stringWithFormat:@"%d km",(int)_sliderRdiuse.value];
    _subView.layer.cornerRadius=5;
   
}
#pragma mark
#pragma mark-Connection Delegets
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [[AppDelegate sharedInstance] hideHUD];
    result=[NSJSONSerialization JSONObjectWithData:webdata options:NSJSONReadingMutableContainers error:nil];
   
    placesArr=[result objectForKey:@"results"] ;
    if (placesArr.count > 0)
    {
        _tabview.hidden=NO;
        [_tabview reloadData];
    } else
    {
        _tabview.hidden=YES;
        _notFoundicon.hidden=NO;
    }
    
}
#pragma mark
#pragma mark-TableView Delegets
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return placesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"tabCell" forIndexPath:indexPath];
    UILabel *lbltitle=(UILabel *)[cell1 viewWithTag:100];
    lbltitle.text=[[placesArr objectAtIndex:indexPath.row]objectForKey:@"name"];
    UILabel *lbladdress=(UILabel *)[cell1 viewWithTag:101];
    NSArray *arr=[[[placesArr objectAtIndex:indexPath.row]objectForKey:@"vicinity"] componentsSeparatedByString:@","];
    
    lbladdress.text=[NSString stringWithFormat:@"%@",[[placesArr objectAtIndex:indexPath.row]objectForKey:@"vicinity"]];
    
    UILabel *lblcity=(UILabel *)[cell1 viewWithTag:102];
    lblcity.text=[arr lastObject];
  
    UIImageView *imgicon=(UIImageView *)[cell1 viewWithTag:105];
    UIView *view=(UIView*)[cell1 viewWithTag:22];
    view.layer.cornerRadius=10;
    
    NSURL *imageUrl = [NSURL URLWithString:[[placesArr objectAtIndex:indexPath.row]objectForKey:@"icon"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    imgicon.image = [UIImage imageWithData:imageData];
    
    
    return  cell1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    catagortSubDetailview *CatagortSubDetailview=[self.storyboard instantiateViewControllerWithIdentifier:@"catagortSubDetailview"];
    CatagortSubDetailview.title=[[placesArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    CatagortSubDetailview.placeid=[[placesArr objectAtIndex:indexPath.row]objectForKey:@"place_id"];

   
        [self.navigationController pushViewController:CatagortSubDetailview animated:YES];
    
}
-(void)selectorBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark
#pragma mark-Change Radius Method
-(void)changeradius
{
    _mainView.hidden=NO;
    leftbarbutton.selected=NO;
}
- (IBAction)actionRadius:(id)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%f",_sliderRdiuse.value]  forKey:@"rediusvalue"];
    [defaults synchronize];
    _mainView.hidden=YES;
    leftbarbutton.selected=NO;
    [self viewDidLoad];
}

#pragma mark
#pragma mark-TextField Delegets
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtRdius resignFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self radiusvalue];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark
#pragma mark-Select Map Action Method

- (IBAction)selectmap:(id)sender
{
    catagoryDetailviewmap *Catagorydetailviewmap=[self.storyboard instantiateViewControllerWithIdentifier:@"catagoryDetailviewmap"];
    Catagorydetailviewmap.title=self.title;
    Catagorydetailviewmap.adata=placesArr;
    [self.navigationController pushViewController:Catagorydetailviewmap animated:YES];
}
#pragma mark
#pragma mark-Alert View Delegets
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10)
    {
        if (buttonIndex==0)
        {
           [self.navigationController popViewControllerAnimated:YES]; 
        }
    }
}
#pragma mark
#pragma mark-Slider Methods
- (IBAction)sliderradiusAction:(id)sender
{
    _txtRdius.text=[NSString stringWithFormat:@"%d km",(int)_sliderRdiuse.value];
    [self radiusvalue];
}
-(void)radiusvalue
{
    if (-1 < _sliderRdiuse.value &&[_txtRdius.text integerValue] <1001)
    {
        _sliderRdiuse.value=[_txtRdius.text integerValue];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Enter the between 0 to 1000" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        _txtRdius.text=[NSString stringWithFormat:@"%d km",(int)_sliderRdiuse.value];
    }
}
@end
