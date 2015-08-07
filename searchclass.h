//
//  searchclass.h
//  FindPlaces
//
//  Created by indianic on 29/07/15.
//  Copyright (c) 2015 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MVPlaceSearchTextField.h"
@interface searchclass : UIViewController<PlaceSearchTextFieldDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtPlaceSearch;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *maptype;
@property(strong,nonatomic)NSString *flag;
- (IBAction)maptypeaction:(id)sender;

@end
