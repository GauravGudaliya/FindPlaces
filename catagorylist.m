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
#pragma mark
#pragma mark-Initialization
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

    barbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,35 ,35)];
    barbutton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [barbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [barbutton addTarget:self action:@selector(btntypeAction) forControlEvents:UIControlEventTouchUpInside];
    [barbutton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    
    UIBarButtonItem *Leftbarbutton=[[UIBarButtonItem alloc]initWithCustomView:barbutton];
    
    self.navigationItem.rightBarButtonItem=Leftbarbutton;
    
    _mainView.hidden=YES;
    
    
    typeArr=[[NSMutableArray alloc]initWithArray:allTypearr];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"List"])
    {
        _colview.hidden=YES;
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"Grid"])
    {
        _tabview.hidden=YES;
    }
    _btnImage.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController].navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0.74 blue:0.83 alpha:0.5]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
#pragma mark
#pragma mark - CollectionView deleget
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
    cell1.layer.cornerRadius=10;
    if (indexPath.row==60)
    {
        _btnselectedImg.hidden=NO;
        _btnImage.hidden=YES;
    }
    if (indexPath.row==95)
    {
        _btnselectedImg.hidden=YES;
        _btnImage.hidden=NO;
    }

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
#pragma mark
#pragma mark-CLLocationManager Delegets
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    location=[locations lastObject];
    _latitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    _longitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
}
#pragma mark
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
    image.layer.cornerRadius=10;
    image.clipsToBounds=YES;

    UILabel *lbl=(UILabel *)[cell1 viewWithTag:201];
    lbl.text=[[[typeArr objectAtIndex:indexPath.row] capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    UIView *view=(UIView *)[cell1 viewWithTag:11];
    if (indexPath.row==85)
    {
        _btnselectedImg.hidden=NO;
        _btnImage.hidden=YES;
    }

    view.layer.cornerRadius=10;
    if (indexPath.row==95)
    {
        _btnselectedImg.hidden=YES;
        _btnImage.hidden=NO;
    }
    return cell1;
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSLog(@"%@",indexPath);
    NSLog(@"%ld",(long)scrollPosition);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[AppDelegate sharedInstance]networkCheck])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" message:@"Newtwork is Not Available \n Please Check ?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        alert.tag=001;
        [alert show];
    }
    else
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
}
#pragma mark
#pragma mark- Bar Button Action
- (IBAction)btntypeAction
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"List"])
    {
        _actioncatagory.selected=!_actioncatagory.selected;
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"displaytype"] isEqualToString:@"Grid"])
    {
        _actioncatagory.selected=NO;
    }

    if (barbutton.selected == NO)
    {
        [self presentOptions];
        barbutton.selected=YES;
    }
    else
    {
        [self dismissOptions];
        barbutton.selected=NO;
    }
}
-(void)presentOptions{
    _mainView.hidden = NO;
    _mainView.backgroundColor = [UIColor clearColor];
    _subView.transform = CGAffineTransformTranslate(_subView.transform, 0, -_subView.frame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        _mainView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _subView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)dismissOptions{
    
    [UIView animateWithDuration:0.4 animations:^{
        _subView.transform = CGAffineTransformTranslate(_mainView.transform, 0.0, -_subView.frame.size.height);
        _mainView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        _mainView.hidden =  YES;
    }];
    
}
#pragma mark
#pragma mark-Sub View Option Button Action
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
#pragma mark
#pragma mark-TextField Delegets
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissOptions];
     barbutton.selected=NO;
    
}

@end
