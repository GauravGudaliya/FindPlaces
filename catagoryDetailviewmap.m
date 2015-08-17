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
{
    //CLGeocoder *geoCoder;

}
@end

@implementation catagoryDetailviewmap

- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    UIBarButtonItem *Back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(selectorBack)];
    self.navigationItem.leftBarButtonItem= Back;
    
     _mapview.myLocationEnabled=YES;
    locationManger=[[CLLocationManager alloc]init];
    locationManger.delegate=self;
    if([locationManger respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManger requestWhenInUseAuthorization];
    }
    [locationManger startUpdatingLocation];
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"maptype"] isEqualToString:@"google"])
    {
        _mapView.hidden=YES;
        for (int i=0; i<_adata.count; i++)
        {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position =CLLocationCoordinate2DMake([[[[[_adata objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue], [[[[[_adata objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]);
            marker.appearAnimation = kGMSMarkerAnimationPop;
            
            marker.map = _mapview;
            marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"pin_%@",[[[_adata objectAtIndex:i]objectForKey:@"types"] objectAtIndex:0]]];
            
            marker.title=[[_adata objectAtIndex:i] objectForKey:@"name"];
            
        }
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"maptype"] isEqualToString:@"apple"])
    {
        _mapview.hidden=YES;
        for (int i=0; i<_adata.count; i++)
        {
            MKPointAnnotation *pinAnotation = [[MKPointAnnotation alloc] init];
            pinAnotation.coordinate = CLLocationCoordinate2DMake([[[[[_adata objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue], [[[[[_adata objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]);
            pinAnotation.title =[[_adata objectAtIndex:i] objectForKey:@"name"];
            pinAnotation.subtitle = [[_adata objectAtIndex:i] objectForKey:@"vicinity"];
            
            [_mapView addAnnotation:pinAnotation];
             [self makeMapInCenter];
        }

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
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"maptype"] isEqualToString:@"google"])
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
    }
    else
    {
       
    }
    [locationManger stopUpdatingLocation];
}
- (void)makeMapInCenter
{
    CLLocationCoordinate2D currentCord = locationManger.location.coordinate;
    
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(currentCord, 1000, 1000);
    
    [_mapView setRegion:reg];
    
}
-(void)selectorBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
