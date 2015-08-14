//
//  catagortSubDetailview.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
@interface catagortSubDetailview :UIViewController
{
    NSMutableData *webdata;
    NSMutableDictionary *results;
   
}
@property (weak, nonatomic) IBOutlet UIView *backGoundView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView1;
@property (weak, nonatomic) IBOutlet UIView *backGoundView2;
@property (weak, nonatomic) IBOutlet UIView *backGoundView3;
@property (weak, nonatomic) IBOutlet GMSMapView *backGroundView4;


@property (weak, nonatomic) IBOutlet UILabel *lbladdress;
@property (weak, nonatomic) IBOutlet UILabel *lblcontact;
@property (weak, nonatomic) IBOutlet UILabel *lblopne;
@property (weak, nonatomic) IBOutlet UILabel *lblwebsite;
@property(strong,nonatomic) CLLocation *location;
@property(strong ,nonatomic) NSString *placeid;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *subView;
@end
