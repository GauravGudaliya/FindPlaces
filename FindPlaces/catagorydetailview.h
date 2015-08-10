//
//  catagorydetailview.h
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GetNearBy.h"
#import "Constant.h"
#import "AppDelegate.h"

@interface catagorydetailview : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *parameter;
    NSMutableArray *placesArr;
    NSMutableData *webdata;
    NSMutableDictionary *result;
}
@property(strong,nonatomic)NSString *row;
@property(strong,nonatomic)NSString *longitude;
@property(strong,nonatomic)NSString *latitude;
@property(strong,nonatomic)NSString *type;
@property (weak, nonatomic) IBOutlet UITableView *tabview;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UISlider *sliderRdiuse;
@property (weak, nonatomic) IBOutlet UITextField *txtRdius;
@property (weak, nonatomic) IBOutlet UIImageView *notFoundicon;

@end
