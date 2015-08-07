//
//  catagorySubDetailviewmap.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "catagorySubDetailviewmap.h"
#import "catagorydetailview.h"
#import <Foundation/Foundation.h>
@interface catagorySubDetailviewmap ()
{
    CLLocationManager *location;
    CLLocation *loca;
}
@end

@implementation catagorySubDetailviewmap

- (void)viewDidLoad {
    [super viewDidLoad];
    location=[[CLLocationManager alloc]init];

    [location startUpdatingLocation];
    _latitude=[[[_result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    _longitude=[[[_result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    GMSMarker *marker=[GMSMarker markerWithPosition:CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue])];
    
    
    _mapview.myLocationEnabled=YES;
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:_mapview.myLocation.coordinate zoom:10];
    _mapview.camera=camera;
    marker.map=_mapview;
    [self droepath:_mapview.myLocation.coordinate :CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue])];
   

}
-(void)droepath:(CLLocationCoordinate2D)fromlocation :(CLLocationCoordinate2D)tolocation
{
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", fromlocation.latitude,  fromlocation.longitude, tolocation.latitude,  tolocation.longitude];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *aDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *aStrPoints = [[[[aDict objectForKey:@"routes"] firstObject] objectForKey:@"overview_polyline"] objectForKey:@"points"];
        
        GMSPath *path =  [GMSPath pathFromEncodedPath:aStrPoints];
        GMSPolyline *polyLine = [GMSPolyline polylineWithPath:path];
        polyLine.strokeWidth = 3.0;
        polyLine.strokeColor =  [UIColor redColor];
        polyLine.map= _mapview;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    loca=[locations firstObject];
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