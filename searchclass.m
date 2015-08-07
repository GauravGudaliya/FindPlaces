//
//  searchclass.m
//  FindPlaces
//
//  Created by indianic on 29/07/15.
//  Copyright (c) 2015 Heart. All rights reserved.
//

#import "searchclass.h"
#import "SWRevealViewController.h"
#import "Constant.h"
@interface searchclass ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectDrower;
@end

@implementation searchclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([_flag isEqual:@"0"]) {
//        _txtPlaceSearch.hidden=YES;
//    }
//    else if([_flag isEqual:@"1"])
//    {
//        _txtPlaceSearch.hidden=NO;
//    }
    _mapView.myLocationEnabled=YES;
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:_mapView.myLocation.coordinate zoom:10];
    _mapView.camera=camera;
    
    _txtPlaceSearch.placeSearchDelegate                 = self;
    _txtPlaceSearch.strApiKey                           = APIKey;
    _txtPlaceSearch.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    _txtPlaceSearch.autoCompleteShouldHideOnSelection   = YES;
    _txtPlaceSearch.maximumNumberOfAutoCompleteRows     = 5;

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_selectDrower setTarget: self.revealViewController];
        [_selectDrower setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    //Optional Properties
    _txtPlaceSearch.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _txtPlaceSearch.autoCompleteBoldFontName = @"HelveticaNeue";
    _txtPlaceSearch.autoCompleteTableCornerRadius=0.0;
    _txtPlaceSearch.autoCompleteRowHeight=35;
    _txtPlaceSearch.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _txtPlaceSearch.autoCompleteFontSize=14;
    _txtPlaceSearch.autoCompleteTableBorderWidth=1.0;
    _txtPlaceSearch.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _txtPlaceSearch.autoCompleteShouldHideOnSelection=YES;
    _txtPlaceSearch.autoCompleteShouldHideClosingKeyboard=YES;
    _txtPlaceSearch.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _txtPlaceSearch.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-_txtPlaceSearch.frame.size.width)*0.5, _txtPlaceSearch.frame.size.height+100.0, _txtPlaceSearch.frame.size.width, 200.0);
}
-(void)placeSearchResponseForSelectedPlace:(NSMutableDictionary*)responseDict
{
    [self.view endEditing:YES];
    NSLog(@"%@",responseDict);
    
    NSDictionary *aDictLocation=[[[responseDict objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
    NSLog(@"SELECTED ADDRESS :%@",aDictLocation);
   GMSMarker *marker=[GMSMarker markerWithPosition:CLLocationCoordinate2DMake([[aDictLocation objectForKey:@"lat"] floatValue],[[aDictLocation objectForKey:@"lng"] floatValue])];
   
    marker.map=_mapView;
    _mapView.myLocationEnabled=YES;
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake([[aDictLocation objectForKey:@"lat"] floatValue],[[aDictLocation objectForKey:@"lng"] floatValue]) zoom:10];
    _mapView.camera=camera;

}
-(void)placeSearchWillShowResult
{
    
}
-(void)placeSearchWillHideResult
{
    
}
-(void)placeSearchResultCell:(UITableViewCell *)cell withPlaceObject:(PlaceObject *)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}


- (IBAction)maptypeaction:(id)sender
{
    
    if(_maptype.selectedSegmentIndex==0)
    {
        _mapView.mapType=kGMSTypeNormal;
    }
    else if (_maptype.selectedSegmentIndex==1)
    {
        _mapView.mapType=kGMSTypeSatellite;
    }
    else if (_maptype.selectedSegmentIndex==2)
    {
        _mapView.mapType=kGMSTypeHybrid;
    }
    else if (_maptype.selectedSegmentIndex==3)
    {
        _mapView.mapType=kGMSTypeTerrain;
    }
   
    
}
@end
