//
//  catagoryDetailviewmap.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
@interface catagoryDetailviewmap : UIViewController<CLLocationManagerDelegate>
{
    NSMutableArray *alocation;
    CLLocationManager *locationManger;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *maptype;
@property (weak, nonatomic) IBOutlet GMSMapView *mapview;
- (IBAction)maptypeaction:(id)sender;
@property(strong,nonatomic)NSMutableArray *adata;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
