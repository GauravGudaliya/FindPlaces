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
@interface catagortSubDetailview ()

@end

@implementation catagortSubDetailview

- (void)viewDidLoad {
    [super viewDidLoad];
    results=[[NSMutableDictionary alloc]init];
    UIBarButtonItem *Back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(selectorBack)];
   
    self.navigationItem.leftBarButtonItem= Back;
    
    UIBarButtonItem *Map = [[UIBarButtonItem alloc]initWithTitle:@"Map" style:UIBarButtonItemStyleDone target:self action:@selector(selectorMap)];
    
    self.navigationItem.rightBarButtonItem= Map;
//    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",_placeid,APIKey]];
//    
//    
//    NSMutableURLRequest *aUrlRequst=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
//    [aUrlRequst setHTTPMethod:@"GET"];
//    [aUrlRequst setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    NSURLConnection *aconnection=[NSURLConnection connectionWithRequest:aUrlRequst delegate:self];
//    if (aconnection) {
//        webdata=[NSMutableData data];
//    }
//    else
//    {
//        NSLog(@"Connection is Fail");
//    }

   
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
-(void)selectorMap
{
    catagorySubDetailviewmap *Catagorydetailviewmap=[self.storyboard instantiateViewControllerWithIdentifier:@"catagortSubDetailviewmap"];
    Catagorydetailviewmap.title=self.title;
 
    Catagorydetailviewmap.result=results;
    [self.navigationController pushViewController:Catagorydetailviewmap animated:YES];
    
}

@end
