//
//  catagortSubDetailview.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface catagortSubDetailview :UIViewController
{
    NSMutableData *webdata;
    NSMutableDictionary *results;
   
}
@property (weak, nonatomic) IBOutlet UILabel *lbladdress;
@property (weak, nonatomic) IBOutlet UILabel *lblcontact;
@property (weak, nonatomic) IBOutlet UILabel *lblopne;
@property (weak, nonatomic) IBOutlet UILabel *lblwebsite;
@property(strong,nonatomic) CLLocation *location;
@property(strong ,nonatomic) NSString *placeid;
@end
