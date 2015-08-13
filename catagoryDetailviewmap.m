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
        marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"pin_%@",[[[_adata objectAtIndex:i]objectForKey:@"types"] objectAtIndex:0]]];
       
        marker.title=[[_adata objectAtIndex:i] objectForKey:@"name"];
        
    }
    _mapview.settings.myLocationButton=YES;
    _mapview.settings.compassButton=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *locat=[locations firstObject];
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:locat.coordinate zoom:15];
    _mapview.camera=camera;
    CLLocationCoordinate2D circleCenter = locat.coordinate;
    GMSCircle *circ = [GMSCircle circleWithPosition:circleCenter
                                             radius:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rediusvalue"] integerValue]];
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0.25 alpha:0.50];
    circ.strokeColor = [UIColor blueColor];
    circ.strokeWidth = 5;
    circ.map = _mapview;

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
}

@end
