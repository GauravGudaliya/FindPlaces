//
//  catagorylist.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "catagorydetailview.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface catagorylist : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *typeArr;
    NSArray *allTypearr;
    CLLocationManager *locationManger;
    CLLocation *location;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *actionDisplay;
@property (weak, nonatomic) IBOutlet UIButton *actioncatagory;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnselectedImg;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UICollectionView *colview;
@property (weak, nonatomic) IBOutlet UITableView *tabview;
@property(strong,nonatomic)NSString *longitude;
@property(strong,nonatomic)NSString *latitude;
@property(strong,nonatomic)NSString *type;


@end
