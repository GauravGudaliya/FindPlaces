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
    UIButton *barbutton;
}
@end

@implementation catagorydetailview

- (void)viewDidLoad
{
    [super viewDidLoad];
    result=[[NSMutableDictionary alloc]init];
    UIBarButtonItem *Back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(selectorBack)];
    
    self.navigationItem.leftBarButtonItem= Back;
    
    barbutton=[[UIButton alloc]initWithFrame:CGRectMake(250, 20,70 ,20)];
    [barbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [barbutton addTarget:self action:@selector(changeradius) forControlEvents:UIControlEventTouchUpInside];
    [barbutton setTitle:@"Radius" forState:UIControlStateNormal];
    [barbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    barbutton.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    UIBarButtonItem *Leftbarbutton=[[UIBarButtonItem alloc]initWithCustomView:barbutton];
    
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
-(void)changeradius
{
    _mainView.hidden=NO;
    barbutton.selected=NO;
}
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
- (IBAction)selectmap:(id)sender
{
    catagoryDetailviewmap *Catagorydetailviewmap=[self.storyboard instantiateViewControllerWithIdentifier:@"catagoryDetailviewmap"];
    Catagorydetailviewmap.title=self.title;
    Catagorydetailviewmap.adata=placesArr;
    [self.navigationController pushViewController:Catagorydetailviewmap animated:YES];
}

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
- (IBAction)actionRadius:(id)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%f",_sliderRdiuse.value]  forKey:@"rediusvalue"];
    [defaults synchronize];
    _mainView.hidden=YES;
    barbutton.selected=NO;
    [self viewDidLoad];
}
@end
