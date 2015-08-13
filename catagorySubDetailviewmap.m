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
    
}
@end

@implementation catagorySubDetailviewmap

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapview.myLocationEnabled=YES;
    locationManger=[[CLLocationManager alloc]init];
    locationManger.delegate=self;
    if([locationManger respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManger requestWhenInUseAuthorization];
    }
    [locationManger startUpdatingLocation];
    
    UIBarButtonItem *Back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(selectorBack)];
    
    self.navigationItem.leftBarButtonItem= Back;
    
    UIBarButtonItem *List = [[UIBarButtonItem alloc]initWithTitle:@"List" style:UIBarButtonItemStyleDone target:self action:@selector(selectorList)];
    
    self.navigationItem.rightBarButtonItem= List;
    _latitude=[[[_result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    _longitude=[[[_result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    GMSMarker *marker=[GMSMarker markerWithPosition:CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue])];
    
    marker.icon=[UIImage imageNamed:[NSString stringWithFormat:@"pin_%@",[[_result objectForKey:@"types"] objectAtIndex:0]]];
    _mapview.myLocationEnabled=YES;
//    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:_mapview.myLocation.coordinate zoom:10];
//    _mapview.camera=camera;
    marker.map=_mapview;
    [self droepath:CLLocationCoordinate2DMake(23.027148, 72.508516) :CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue])];
    _mapview.settings.myLocationButton=YES;
    _mapview.settings.compassButton=YES;

   
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
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0.25 alpha:0.25];
    circ.strokeColor = [UIColor blueColor];
    circ.strokeWidth = 5;
    circ.map = _mapview;
    
    [locationManger stopUpdatingLocation];
}

-(void)droepath:(CLLocationCoordinate2D)fromlocation :(CLLocationCoordinate2D)tolocation
{
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", fromlocation.latitude,  fromlocation.longitude, tolocation.latitude,  tolocation.longitude];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 
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
-(void)selectorBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)selectorList
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
