//
//  catagoryDetailviewmap.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "catagoryDetailviewmap.h"
#import "catagoryDetailview.h"
#import <CoreLocation/CoreLocation.h>

@interface catagoryDetailviewmap ()

@end

@implementation catagoryDetailviewmap

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSLog(@"%@",_adata);
    UIBarButtonItem *Back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(selectorBack)];
    
    self.navigationItem.leftBarButtonItem= Back;
    
    UIBarButtonItem *List = [[UIBarButtonItem alloc]initWithTitle:@"List" style:UIBarButtonItemStyleDone target:self action:@selector(selectorList)];
    
    self.navigationItem.rightBarButtonItem= List;
     _mapview.myLocationEnabled=YES;
    locationManger=[[CLLocationManager alloc]init];
    locationManger.delegate=self;
    if([locationManger respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManger requestWhenInUseAuthorization];
    }
    [locationManger startUpdatingLocation];
    for (int i=0; i<_adata.count; i++)
    {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position =CLLocationCoordinate2DMake([[[[[_adata objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue], [[[[[_adata objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]);
        marker.appearAnimation = kGMSMarkerAnimationPop;
     
        marker.map = _mapview;
        marker.icon = [UIImage imageNamed:@"pin_bank.png"];
        marker.title=[[_adata objectAtIndex:i] objectForKey:@"name"];
        
    }
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *locat=[locations firstObject];
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:locat.coordinate zoom:18];
    _mapview.camera=camera;
    [locationManger stopUpdatingLocation];
}
-(void)selectorBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)selectorList
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    catagorydetailview *Catagorydetailview=[self.storyboard instantiateViewControllerWithIdentifier:@"catagoryDetailviewSegue"];
//    [self.navigationController pushViewController:Catagorydetailview animated:YES];
    
}
- (IBAction)maptypeaction:(id)sender
{
    
    if(_maptype.selectedSegmentIndex==0)
    {
        _mapview.mapType=kGMSTypeNormal;
    }
    else if (_maptype.selectedSegmentIndex==1)
    {
        _mapview.mapType=kGMSTypeSatellite;
    }
    else if (_maptype.selectedSegmentIndex==2)
    {
        _mapview.mapType=kGMSTypeHybrid;
    }
    else if (_maptype.selectedSegmentIndex==3)
    {
        _mapview.mapType=kGMSTypeTerrain;
    }
    
    
}

@end
