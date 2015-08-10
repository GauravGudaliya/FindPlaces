//
//  selectedcatagory.m
//  catagorydemo
//
//  Created by Heart on 1/1/08.
//  Copyright (c) 2008 Heart. All rights reserved.
//

#import "selectedcatagory.h"
#import "Database.h"
@interface selectedcatagory ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView *tblView;
@end

@implementation selectedcatagory

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableArray *aTempArr =[[NSMutableArray alloc]initWithObjects:@"accounting",
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
              @"church"
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
    selectedCatagory=[[NSMutableArray alloc]init];
    typeArr = [NSMutableArray array];
    [aTempArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *aStrCate = obj;
        [self addCategoryDictFor:aStrCate toArr:typeArr];
        
    }];
    NSArray *arr=[[Database sharedDatabase]SelectAllFromTable:@"select * from favorite"];
    NSLog(@"%@",arr);
}

-(void)addCategoryDictFor:(NSString*)strCateGory toArr:(NSMutableArray*)mutArr{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:strCateGory,@"category",@0,@"isSelected", nil];
    [mutArr addObject:aDict];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return typeArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lblname=(UILabel*)[cell1 viewWithTag:102];
    UIImageView *icon=(UIImageView*)[cell1 viewWithTag:101];
    NSMutableDictionary *aMutDict = [typeArr objectAtIndex:indexPath.row];
    
    NSString *aStrCategoryName = aMutDict[@"category"];
    BOOL isSelected = [aMutDict[@"isSelected"] boolValue];
    
    lblname.text=aStrCategoryName;
    btncheck=(UIButton*)[cell1 viewWithTag:103];
    btncheck.selected = isSelected;
    [btncheck addTarget:self action:@selector(btnchechaction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *str=[NSString stringWithFormat:@"select * from favorite where catagoryname='%@'",[aMutDict objectForKey:@"category"]];
    [[Database sharedDatabase]SelectAllFromTable:str];
    NSLog(@"data %@",[[Database sharedDatabase]SelectAllFromTable:str]);
    return cell1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (IBAction)btnHidetableview:(id)sender
{
    NSArray *arr=[[Database sharedDatabase]SelectAllFromTable:@"select * from favorite"];
    NSLog(@"%@",arr);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)btnchechaction:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblView];
    NSIndexPath *aIndexPath = [self.tblView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *aDict = [typeArr objectAtIndex:aIndexPath.row];
    sender.selected = !sender.selected;
    [aDict setObject:[NSNumber numberWithBool:sender.selected] forKey:@"isSelected"];
    NSLog(@"%@",aDict);
    
    if ([[aDict objectForKey:@"isSelected"] intValue]==1)
    {
        NSString *str=[NSString stringWithFormat:@"update favorite set state=1 where catagoryname='%@'",[aDict objectForKey:@"category"]];
        [[Database sharedDatabase]Update:str];
        NSLog(@"on");
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"update favorite set state=0 where catagoryname='%@'",[aDict objectForKey:@"category"]];
        [[Database sharedDatabase]Update:str];
        NSLog(@"off");
    }
}


@end
