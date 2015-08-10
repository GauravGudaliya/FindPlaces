//
//  catagorySubDetailviewmap.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
@interface catagorySubDetailviewmap : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
       CLLocationManager *locationManger;
   
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *maptype;
- (IBAction)maptypeaction:(id)sender;
@property (weak, nonatomic) IBOutlet GMSMapView *mapview;
@property(strong,nonatomic)NSString *longitude;
@property(strong,nonatomic)NSString *latitude;
@property(strong,nonatomic)NSMutableDictionary *result;
@property(strong,nonatomic)CLLocation *loca;
@end
