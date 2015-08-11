//
//  catagorylist.m
//  FindPlaces
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//
#import "Database.h"
#import "catagorylist.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "selectedcatagory.h"
@interface catagorylist ()<CLLocationManagerDelegate>
{
    UIButton *barbutton;
    UIView *display;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *selectDrower;

@end

@implementation catagorylist

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationController.navigationBar.hidden=NO;
    
        allTypearr =[[NSArray alloc]initWithObjects:@"accounting",
      @"airport",
      @"amusement_park",
      @"aquarium",
      @"art_gallery",
      @"atm",
      @"bakery",
      @"bank",
      @"bar",
      @"beauty_salon",
      @"bicycle_store",
      @"book_store",
      @"bowling_alley",
      @"bus_station",
      @"cafe",
      @"campground",
      @"car_dealer",
      @"car_rental",
      @"car_repair",
      @"car_wash",
      @"casino",
      @"cemetery",
      @"church",
      @"city_hall",
      @"clothing_store",
      @"convenience_store",
      @"courthouse",
      @"dentist",
      @"department_store",
      @"doctor",
      @"electrician",
      @"electronics_store",
      @"embassy",
      @"establishment",
      @"finance",
      @"fire_station",
      @"florist",
      @"food",
      @"funeral_home",
      @"furniture_store",
      @"gas_station",
      @"general_contractor",
      @"grocery_or_supermarket",
      @"gym",
      @"hair_care",
      @"hardware_store",
      @"health",
      @"hindu_temple",
      @"home_goods_store",
      @"hospital",
      @"insurance_agency",
      @"jewelry_store",
      @"laundry",
      @"lawyer",
      @"library",
      @"liquor_store",
      @"local_government_office",
      @"locksmith",
      @"lodging",
      @"meal_delivery",
      @"meal_takeaway",
      @"mosque",
      @"movie_rental",
      @"movie_theater",
      @"moving_company",
      @"museum",
      @"night_club",
      @"painter",
      @"park",
      @"parking",
      @"pet_store",
      @"pharmacy",
      @"physiotherapist",
      @"place_of_worship",
      @"plumber",
      @"police",
      @"post_office",
      @"real_estate_agency",
      @"restaurant",
      @"roofing_contractor",
      @"rv_park",
      @"school",
      @"shoe_store",
      @"shopping_mall",
      @"spa",
      @"stadium",
      @"storage",
      @"store",
      @"subway_station",
      @"synagogue",
      @"taxi_stand",
      @"train_station",
      @"travel_agency",
      @"university",
      @"veterinary_care",
      @"zoo",nil];
   
    locationManger=[[CLLocationManager alloc]init];
    locationManger.delegate=self;
    if([locationManger respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManger requestWhenInUseAuthorization];
    }
    [locationManger startUpdatingLocation];
        
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_selectDrower setTarget: self.revealViewController];
        [_selectDrower setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    barbutton=[[UIButton alloc]initWithFrame:CGRectMake(250, 20,70 ,20)];
    [barbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [barbutton addTarget:self action:@selector(btntypeAction) forControlEvents:UIControlEventTouchUpInside];
    [barbutton setTitle:@"Option" forState:UIControlStateNormal];
    UIBarButtonItem *Leftbarbutton=[[UIBarButtonItem alloc]initWithCustomView:barbutton];
    
    self.navigationItem.rightBarButtonItem=Leftbarbutton;
    _mainView.hidden=YES;
    
    
    typeArr=[[NSMutableArray alloc]initWithArray:allTypearr];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"List"])
    {
       _actioncatagory.selected=NO;
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"Grid"])
    {
        _actioncatagory.selected=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return typeArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell1=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *image=(UIImageView*)[cell1 viewWithTag:101];
    image.image=[UIImage imageNamed:[typeArr objectAtIndex:indexPath.row]];
    image.clipsToBounds=YES;
    UILabel *lbl=(UILabel *)[cell1 viewWithTag:100];
    lbl.text=[[[typeArr objectAtIndex:indexPath.row] capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];

    return cell1;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[typeArr objectAtIndex:indexPath.row]isEqualToString:@"add"])
    {
        selectedcatagory *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"tableView"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        catagorydetailview *Catagorydetailview=[self.storyboard instantiateViewControllerWithIdentifier:@"catagoryDetailviewSegue"];
        [self.navigationController pushViewController:Catagorydetailview animated:YES];
        
        Catagorydetailview.title=[[[typeArr objectAtIndex:indexPath.row] capitalizedString]     stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        _type=[typeArr objectAtIndex:indexPath.row];
        Catagorydetailview.latitude=_latitude;
        Catagorydetailview.longitude=_longitude;
        Catagorydetailview.type=_type;
    
        Catagorydetailview.row=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
       
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    location=[locations lastObject];
    _latitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    _longitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
}
#pragma mark -Table View Deleget
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return typeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *image=(UIImageView*)[cell1 viewWithTag:200];
    image.image=[UIImage imageNamed:[typeArr objectAtIndex:indexPath.row]];
    image.clipsToBounds=YES;

    UILabel *lbl=(UILabel *)[cell1 viewWithTag:201];
    lbl.text=[[[typeArr objectAtIndex:indexPath.row] capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    return cell1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[typeArr objectAtIndex:indexPath.row]isEqualToString:@"add"])
    {
        selectedcatagory *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"tableView"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        catagorydetailview *Catagorydetailview=[self.storyboard instantiateViewControllerWithIdentifier:@"catagoryDetailviewSegue"];
        [self.navigationController pushViewController:Catagorydetailview animated:YES];
    
        Catagorydetailview.title=[[[typeArr objectAtIndex:indexPath.row] capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        _type=[typeArr objectAtIndex:indexPath.row];
        Catagorydetailview.latitude=_latitude;
        Catagorydetailview.longitude=_longitude;
        Catagorydetailview.type=_type;
    
        Catagorydetailview.row=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
      
    }
}
- (IBAction)btntypeAction
{
    if (barbutton.selected == NO)
    {
        _mainView.hidden=NO;
        barbutton.selected=YES;
    }
    else
    {
        _mainView.hidden=YES;
        barbutton.selected=NO;
    }

}
- (IBAction)btnDisplay:(id)sender
{
   
    if(_actionDisplay.selected)
    {
        _colview.hidden=NO;
        _tabview.hidden=YES;
        _actionDisplay.selected=!_actionDisplay.selected;
    }
    else
    {
       
        _colview.hidden=YES;
        _tabview.hidden=NO;
        _actionDisplay.selected=!_actionDisplay.selected;
    }
}
- (IBAction)catagorylist:(id)sender
{
    if(_actioncatagory.selected)
    {
        typeArr=[[NSMutableArray alloc]initWithArray:allTypearr];
        _actioncatagory.selected=!_actioncatagory.selected;
        [_tabview reloadData];
        [_colview reloadData];
    }
    else
    {
        NSString *str=@"select catagoryname from favorite where state=1";
        NSArray *arr=[[Database sharedDatabase]SelectAllFromTable:str];
        [typeArr removeAllObjects];
        for (int i=0; i<arr.count; i++)
        {
            [typeArr addObject:[[arr objectAtIndex:i]objectForKey:@"catagoryname"]];
        }
        if ([arr lastObject]||arr.count==0) {
            [typeArr addObject:@"add"];
        }
        _actioncatagory.selected=!_actioncatagory.selected;
        [_tabview reloadData];
          [_colview reloadData];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _mainView.hidden=YES;
     barbutton.selected=NO;
    
}
@end
