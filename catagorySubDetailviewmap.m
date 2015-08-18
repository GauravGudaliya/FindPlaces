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
    UIButton *rightbarbutton;
}
@end

@implementation catagorySubDetailviewmap
#pragma mark
#pragma mark-Initialization
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
    
    rightbarbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,35 ,35)];
    [rightbarbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightbarbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(selectorBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbarbutton];
    
    _latitude=[[[_result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    _longitude=[[[_result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"maptype"] isEqualToString:@"google"])
    {
        _mapView.hidden=YES;
        GMSMarker *marker=[GMSMarker markerWithPosition:CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue])];
        
        marker.icon=[UIImage imageNamed:[NSString stringWithFormat:@"pin_%@",[[_result objectForKey:@"types"] objectAtIndex:0]]];
        _mapview.myLocationEnabled=YES;
        marker.map=_mapview;
        marker.title=[_result objectForKey:@"name"];
        [self droepath:CLLocationCoordinate2DMake(locationManger.location.coordinate.latitude, locationManger.location.coordinate.longitude) :CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue])];
        _mapview.settings.myLocationButton=YES;
        _mapview.settings.compassButton=YES;
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"maptype"] isEqualToString:@"apple"])
    {
        _mapview.hidden=YES;
        [self makeMapInCenter];
        sourceCord=locationManger.location.coordinate;
        destCord=CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
        
        MKPointAnnotation *pinAnotation = [[MKPointAnnotation alloc] init];
        pinAnotation.coordinate = destCord;
        pinAnotation.title =[_result objectForKey:@"name"];
        pinAnotation.subtitle = [_result objectForKey:@"vicinity"];
        
        [_mapView addAnnotation:pinAnotation];

         [self getTheDirections];
        [[AppDelegate sharedInstance] showHUD];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark-Apple MAP Methods
- (void)makeMapInCenter
{
    CLLocationCoordinate2D currentCord = locationManger.location.coordinate;
    
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(currentCord, 1000, 1000);
    
    [_mapView setRegion:reg];
    
}
- (void)getTheDirections
{
    @try {
        MKPlacemark *aPlcSource = [[MKPlacemark alloc] initWithCoordinate:sourceCord addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil]];
        
        MKPlacemark *aPlcDest = [[MKPlacemark alloc] initWithCoordinate:destCord addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil]];
        
        MKMapItem *mpItemSource = [[MKMapItem alloc] initWithPlacemark:aPlcSource];
        [mpItemSource setName:@"Source"];
        
        MKMapItem *mpItemDest  = [[MKMapItem alloc] initWithPlacemark:aPlcDest];
        [mpItemDest setName:@"Dest"];
        
        MKDirectionsRequest *aDirectReq = [[MKDirectionsRequest alloc] init];
        [aDirectReq setSource:mpItemSource];
        [aDirectReq setDestination:mpItemDest];
        [aDirectReq setTransportType:MKDirectionsTransportTypeAutomobile];
        
        MKDirections *aDirections = [[MKDirections alloc] initWithRequest:aDirectReq];
        
        [aDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            [[AppDelegate sharedInstance] hideHUD];
            if (error) {
                NSLog(@"Error :: %@",error);
            }
            else{
                NSArray *aArrRoutes = [response routes];
                NSLog(@"Routes :: %@",aArrRoutes);
                
                [_mapView removeOverlays:_mapView.overlays];
                
                [aArrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    MKRoute *aRoute = obj;
                    
                    [_mapView addOverlay:aRoute.polyline];
                    
                    NSLog(@"Rout Name : %@",aRoute.name);
                    NSLog(@"Total Distance (in Meters) :%f",aRoute.distance);
                    
                    NSArray *aArrSteps = [aRoute steps];
                    
                    NSLog(@"Total Steps : %lu",(unsigned long)[aArrSteps count]);
                    
                    [aArrSteps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSLog(@"Rout Instruction : %@",[obj instructions]);
                        NSLog(@"Rout Distance : %f",[obj distance]);
                    }];
                    
                }];
            }
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Method :: %s  Exception :: %@",__FUNCTION__,exception.description);
    }
    @finally {
        
    }
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    @try {
        if ([overlay isKindOfClass:[MKPolyline class]]) {
            MKPolylineRenderer *aPolyLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
            
            aPolyLineRenderer.strokeColor = [UIColor redColor];
            aPolyLineRenderer.lineWidth = 3.0;
            return aPolyLineRenderer;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Method :: %s  Exception :: %@",__FUNCTION__,exception.description);
    }
    @finally {
        
    }
}
#pragma mark-
#pragma mark-CLLocationManager delegets
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *locat=[locations firstObject];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"maptype"] isEqualToString:@"google"])
    {
        
        GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:locat.coordinate zoom:15];
        _mapview.camera=camera;
        CLLocationCoordinate2D circleCenter = locat.coordinate;
        GMSCircle *circ = [GMSCircle circleWithPosition:circleCenter
                                                 radius:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rediusvalue"] integerValue]];
        circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0.25 alpha:0.15];
        circ.strokeColor = [UIColor blueColor];
        circ.strokeWidth = 5;
        circ.map = _mapview;
    }
    else
    {
        
    }
    [locationManger stopUpdatingLocation];
}
#pragma mark-
#pragma mark-Google map Methods
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
#pragma mark
#pragma  mark-Segment Control Methods
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

@end
