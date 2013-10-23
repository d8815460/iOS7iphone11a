//
//  NutritionViewController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "NutritionViewController.h"
#import "NutritionCell.h"
#import "MinnaMessageView.h"

@interface NutritionViewController ()
@property (nonatomic, strong) NSMutableDictionary *searchFoodWithTitleOptions; //輸入狀態中的結果
@property (nonatomic, strong) NSArray             *mostSearchOptions;          //沒有輸入文字的結果
@property (nonatomic, strong) NSMutableDictionary *recommendFoodSearchOption;  //按下Enter的結果
@property (nonatomic, strong) NSMutableDictionary *mostDictionary;             //沒有輸入文字的Dic
@property (nonatomic, strong) UIFont              *cellLabelFont;              // will copy style from assigned textfield
@property (nonatomic, strong) MinnaMessageView *messageView;
@end

@implementation NutritionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.scrollEnabled    = YES;
    
    /*
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
     self.tableView.contentOffset = CGPointMake(0, 0);
     self.tableView.contentSize = CGSizeMake(320, 60);
     cell.contentView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
     */
    
    // add default food for debug usage
    
	// add into minna message Listener list
    [OmniTool addMinnaListener:self];
    self.messageView=[[MinnaMessageView alloc] initWithFrame:CGRectMake(0,-45,320,44)];
    [self.view addSubview:self.messageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // NSLog(@"searchBar TextDidBeginEditing");
}

// 處理Search鍵被按下時要做的事情
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // NSLog(@"searchBar SearchButtonClicked");
    /*
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
     self.tableView.contentOffset = CGPointMake(0, 0);
     self.tableView.contentSize = CGSizeMake(320, 60);
     cell.contentView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
     [self.searchDisplayController.searchResultsTableView reloadData];
     */
    [searchBar resignFirstResponder];
}
- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // NSLog(@"did end edit 0");
}
// 處理當Search字串改變時要做的事
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //    NSLog(@"searchBar textDidChange");
    if (![searchText length])
    {
        // search text empty
    } else if ([self substringIsInDictionary:searchText])
    {
        [self.tableView reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
    };
}
//處理Cancel按鈕按下後要做的事情
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBar CancelButtonClicked");
}
#pragma mark - Logic staff
- (NSMutableDictionary *)substringIsInDictionary:(NSString *)subString
{
    NSMutableDictionary *dic = [OmniTool searchFoodWithTitle:subString];
    self.searchFoodWithTitleOptions = dic;
    return dic;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //如果文字輸入長度=0 就有兩個title , 有文字輸入就只有一個title
    if (![self.searchBar.text length])
    {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //沒有文字，就有兩個title,每個title有各自的cell數量
    if (![self.searchBar.text length])
    {
        if (![self.mostDictionary objectForKey:@"Most Searched"] ) {
            
        }else{
            if (section ==  1) {
                NSMutableArray *mostArray = [self.mostDictionary objectForKey:@"Most Searched"];
                // NSLog(@"Most Searched %d",mostArray.count);
                return mostArray.count; //因為most searched 跟 recent Searched 數量一樣，這裡就不分開處理
            }else if (section   ==  0){
                NSMutableArray *mostArray = [self.mostDictionary objectForKey:@"Recent Searched"];
                return mostArray.count;
            }
        }
    }else{
        if ([self.searchFoodWithTitleOptions objectForKey:@"Search Result"]) { //KeyWord Search.
            NSMutableArray *keywordArray = [self.searchFoodWithTitleOptions objectForKey:@"Search Result"];
            return keywordArray.count;
        }else if ([self.searchFoodWithTitleOptions objectForKey:@"Recommend Search"]){  //Search Result
            NSMutableArray *keywordArray = [self.searchFoodWithTitleOptions objectForKey:@"Recommend Search"];
            return keywordArray.count;
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    headerView.backgroundColor = IPHONE11_LIGHT_GREEN_COLOR;
    
    UILabel *titleGroup = [[UILabel alloc] init];
    [titleGroup setBackgroundColor:[UIColor clearColor]];
    [titleGroup setFrame:CGRectMake(15.0f, 0.0f, 290.0f , 22.0f)];
    titleGroup.textColor = [UIColor whiteColor];
    titleGroup.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    [titleGroup setTextAlignment:NSTextAlignmentLeft];
    
    if (![self.searchBar.text length])
    {
        //        NSLog(@"most count 1 = %i", self.mostDictionary.count);
        if (![self.mostDictionary objectForKey:@"Most Searched"]) {
            if (section ==  1) {
                [titleGroup setText:@"for food."];
                [titleGroup setTextAlignment:NSTextAlignmentCenter];
            }else if (section   ==  0){
                [titleGroup setText:@"Use the Search Bar to search "];
                [titleGroup setTextAlignment:NSTextAlignmentCenter];
            }
        }else{
            if (section ==  1) {
                [titleGroup setText:@"Most Searched"];
                [titleGroup setTextAlignment:NSTextAlignmentLeft];
            }else if (section   ==  0){
                [titleGroup setText:@"Recent Searches"];
                [titleGroup setTextAlignment:NSTextAlignmentLeft];
            }
        }
    }else{
        if ([self.searchFoodWithTitleOptions objectForKey:@"Recommend Search"]) { //KeyWord Search.
            [titleGroup setText:@"Recommend Search"];
            [titleGroup setTextAlignment:NSTextAlignmentLeft];
        }else if ([self.searchFoodWithTitleOptions objectForKey:@"Search Result"]){  //Search Result
            NSLog(@"%@", [self.searchFoodWithTitleOptions objectForKey:@"Search Result"]);
            
            if ([[self.searchFoodWithTitleOptions objectForKey:@"Search Result"] count] > 0) {
                [titleGroup setText:@"Search Results"];
                [titleGroup setTextAlignment:NSTextAlignmentLeft];
            }else{
                [titleGroup setText:@"No Matching Results"];
                [titleGroup setTextAlignment:NSTextAlignmentLeft];
            }
            
        }
    }
    
    [headerView addSubview:titleGroup];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     static NSString *simpleTableIdentifer=@"SimpleTableItem";
     
     UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifer];
     if(cell==nil){
     cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifer];
     }
     NSMutableArray *searchResultArray=[self.searchFoodWithTitleOptions objectForKey:@"Search Result"];
     if(indexPath.row < [searchResultArray count]){
     cell.textLabel.text=[[searchResultArray objectAtIndex:indexPath.row] longDescription];
     }
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     cell.backgroundColor = [UIColor clearColor];
     cell.contentView.backgroundColor = [UIColor clearColor];
     cell.alpha=1.0;
     
     return cell;
     */
    
    // NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    NutritionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[NutritionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.options valueForKey:ACOUseSourceFont])
    {
        cell.cellTitle.font = [self.options valueForKey:ACOUseSourceFont];
    } else
    {
        cell.cellTitle.font = self.cellLabelFont;
    }
    cell.cellTitle.adjustsFontSizeToFitWidth = NO;
    // use Image as the arrow, so this accessory is no longer used here.
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.alpha=1.0;
    
    //沒有輸入文字
    if (!self.searchBar.text.length) {
        if (indexPath.section == 0) {
            NSMutableArray *mostArray = [self.mostDictionary objectForKey:@"Recent Searched"];
			if(indexPath.row < [mostArray count]){
                [cell.cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
	            cell.cellTitle.text = [[mostArray objectAtIndex:indexPath.row] longDescription];
            }
        }else if (indexPath.section == 1){
            NSMutableArray *mostArray = [self.mostDictionary objectForKey:@"Most Searched"];
			if(indexPath.row < [mostArray count]){
                [cell.cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
	            cell.cellTitle.text = [[mostArray objectAtIndex:indexPath.row] longDescription];
	        }
        }
    }else{
        if ([self.searchFoodWithTitleOptions objectForKey:@"Search Result"]) { //KeyWord Search 搜尋中
        	NSMutableArray *searchResultArray=[self.searchFoodWithTitleOptions objectForKey:@"Search Result"];
        	if(indexPath.row < [searchResultArray count]){
                [cell.cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
	            cell.cellTitle.text = [[searchResultArray objectAtIndex:indexPath.row] longDescription];
	        }
        }else if ([self.searchFoodWithTitleOptions objectForKey:@"Recommend Search"]){//Search Result 搜尋結果
            // NSLog(@"     cellForRowAtIndexPath Recommend Search");
        	NSMutableArray *recommendSearcArray=[self.searchFoodWithTitleOptions objectForKey:@"Recommend Search"];
        	if(indexPath.row < [recommendSearcArray count]){
                [cell.cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
	            cell.cellTitle.text     = 	[[recommendSearcArray objectAtIndex:indexPath.row] longDescription];
            }
        }else{
            NSLog(@"     cellForRowAtIndexPath no match");
            
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    if (!self.searchBar.text.length) {
        if (indexPath.section == 0) {
            
            NSMutableArray *recentArray = [self.mostDictionary objectForKey:@"Recent Searched"];
            nutritionViewSelectedFood=[recentArray objectAtIndex:indexPath.row];
            [self.delegate NutritionViewController:self didSelectFood:[recentArray objectAtIndex:indexPath.row]];
        }else if (indexPath.section == 1){
            NSMutableArray *mostArray = [self.mostDictionary objectForKey:@"Most Searched"];
            nutritionViewSelectedFood=[mostArray objectAtIndex:indexPath.row];
            [self.delegate NutritionViewController:self didSelectFood:[mostArray objectAtIndex:indexPath.row]];
        }
    }else{
        NSMutableDictionary *keywordSearch = [self substringIsInDictionary:self.searchBar.text];
        if ([self substringIsInDictionary:self.searchBar.text]) {
            if ([keywordSearch objectForKey:@"Search Result"]) { //keywords Search
                NSMutableArray *keywordArray = [keywordSearch objectForKey:@"Search Result"];
                [self.delegate NutritionViewController:self didSelectFood:[keywordArray objectAtIndex:indexPath.row]];
                nutritionViewSelectedFood=[keywordArray objectAtIndex:indexPath.row];
            }else if ([keywordSearch objectForKey:@"Recommend Search"]){ //Search Result
                NSMutableArray *keywordArray = [keywordSearch objectForKey:@"Recommend Search"];
                [OmniTool getFoodNutrient:[[keywordArray objectAtIndex:indexPath.row] foodNumber]];
                [self.delegate NutritionViewController:self didSelectFood:[keywordArray objectAtIndex:indexPath.row]];
            }
        }
    }
    [self performSegueWithIdentifier:@"searchToNutrition" sender:nil];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // NSLog(@"Will begin dragging");
    [self.searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NSLog(@"Did Scroll");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    // NSLog(@" view will appear");
    self.mostDictionary = [OmniTool getMostRecentSearched];
	NSEnumerator *enumerator = [self.mostDictionary keyEnumerator];
	NSString *groupTitle;
    int totalCount=0;
	while ((groupTitle = [enumerator nextObject])) {
		NSMutableArray *foodArray = [self.mostDictionary valueForKey:groupTitle];
        totalCount += [foodArray count];
        /*
         NSLog(@"====== %@ ======",groupTitle);
         id food;
         for(int i = 0; i < foodArray.count; i++){
         food = [foodArray objectAtIndex:i];
         [food printFoodInfo];
         }
         */
	}
    if(!totalCount)
        self.mostDictionary =nil;
    
    //如果沒有輸入文字以及一開始點擊時，出現的Table顯示的是最長搜尋根最多搜尋的Table
    [self.tableView reloadData];

        // hide the barButton
        self.barButton.style = UIBarButtonItemStylePlain;
        self.barButton.title=nil;
        self.barButton.enabled=NO;
}

- (IBAction)closeFoodSearch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MinnaNotificationProtocol

-(void) MinnaMessage:(NSString *)message
{
	// NSLog(@"Got Minna Broadcast message: %@",message);
    [self.messageView setMessage:message];
}

-(NSNumber *) MinnaListenerID
{
	return [[NSNumber alloc] initWithInt:9];
}

@end
