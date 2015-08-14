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
    NSMutableArray *aTempArr=[[NSMutableArray alloc]init];
    NSArray *arr=[[Database sharedDatabase]SelectAllFromTable:@"select catagoryname from favorite"];
   
    for (int i=0; i<arr.count; i++)
    {
        [aTempArr addObject:[[arr objectAtIndex:i]objectForKey:@"catagoryname"]];
    }
 
    selectedCatagory=[[NSMutableArray alloc]init];
    typeArr = [NSMutableArray array];
    [aTempArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *aStrCate = obj;
        [self addCategoryDictFor:aStrCate toArr:typeArr];
//        [[Database sharedDatabase]Insert:[NSString stringWithFormat:@"insert into favorite (catagoryname,state,imagename)values('%@','%@','%@')",aStrCate,@0,[NSString stringWithFormat:@"pin_%@",aStrCate]]];
//        
    }];
    
}

-(void)addCategoryDictFor:(NSString*)strCateGory toArr:(NSMutableArray*)mutArr
{
  
    NSArray *arr=[[Database sharedDatabase]SelectAllFromTable:[NSString stringWithFormat:@"select state from favorite where catagoryname='%@'",strCateGory]];
    NSString *str=[[arr objectAtIndex:0] objectForKey:@"state"];
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:strCateGory,@"category",str,@"isSelected", nil];
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
    UIView *view=(UIView*)[cell1 viewWithTag:33];
    view.layer.cornerRadius=10;
    BOOL isSelected = [aMutDict[@"isSelected"] boolValue];
    
    lblname.text=[[aStrCategoryName capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    icon.image=[UIImage imageNamed:[NSString stringWithFormat:@"pin_%@",[typeArr objectAtIndex:indexPath.row][@"category"]]];
    btncheck=(UIButton*)[cell1 viewWithTag:103];
    btncheck.selected = isSelected;
    [btncheck addTarget:self action:@selector(btnchechaction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *str=[NSString stringWithFormat:@"select * from favorite where catagoryname='%@'",[aMutDict objectForKey:@"category"]];
    [[Database sharedDatabase]SelectAllFromTable:str];
  
    return cell1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (IBAction)btnHidetableview:(id)sender
{
    [typeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDict = obj;
        if ([[aDict objectForKey:@"isSelected"] intValue]==1)
        {
            NSString *str=[NSString stringWithFormat:@"update favorite set state=1 where catagoryname='%@'",[aDict objectForKey:@"category"]];
            [[Database sharedDatabase]Update:str];
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"update favorite set state=0 where catagoryname='%@'",[aDict objectForKey:@"category"]];
            [[Database sharedDatabase]Update:str];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)btnchechaction:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblView];
    NSIndexPath *aIndexPath = [self.tblView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *aDict = [typeArr objectAtIndex:aIndexPath.row];
    
    sender.selected = !sender.selected;
    [aDict setObject:[NSNumber numberWithBool:sender.selected] forKey:@"isSelected"];
}


@end
