//
//  IngredientController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 PROCH Technology. All rights reserved.
//

#import "IngredientController.h"
#import "IngredientCell.h"
#import "IngredientItemCell.h"
@interface IngredientController ()
@property (nonatomic, strong) NSMutableDictionary *searchFoodWithTitleOptions; //輸入狀態中的結果
@property (nonatomic, strong) NSArray             *mostSearchOptions;          //沒有輸入文字的結果
@property (nonatomic, strong) NSMutableDictionary *recommendFoodSearchOption;  //按下Enter的結果
@property (nonatomic, strong) NSMutableDictionary *mostDictionary;             //沒有輸入文字的Dic
@property (nonatomic, strong) UIFont              *cellLabelFont;              // will copy style from assigned textfield
//@property (nonatomic, strong) Meal                *currentMeal;
@end

@implementation IngredientController
//@synthesize currentMeal = _currentMeal;

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
    // NSLog(@"IngredientController viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.scrollEnabled    = YES;
    self.itemTableView.delegate         = self;
    self.itemTableView.dataSource       = self;
    self.itemTableView.scrollEnabled    = YES;
    
    // hide the barButton
    self.barButton.style = UIBarButtonItemStylePlain;
    self.barButton.title=nil;
    self.barButton.enabled=NO;
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
        [self.tableView reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
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
    if(tableView == self.tableView) {
        //如果文字輸入長度=0 就有兩個title , 有文字輸入就只有一個title
        if (![self.searchBar.text length])
        {
            return 2;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tableView)
        return [self searchTableViewNumberOfRowsInSection:section];
    else if(tableView==self.itemTableView)
        return [self itemTableViewNumberOfRowsInSection:section];
    else
        return 0;
}
- (NSInteger)itemTableViewNumberOfRowsInSection:(NSInteger)section
{
    Meal *currentMeal=[OmniTool getCurrentMeal];
    if ([currentMeal countOfIngredients] > 0) {
        self.foodAddedLabel.hidden = NO;
    }else{
        self.foodAddedLabel.hidden = YES;
    }
    
    return [currentMeal countOfIngredients];
}


- (NSInteger)searchTableViewNumberOfRowsInSection:(NSInteger)section
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
    if(tableView != self.tableView) return 0.0;
    
    return 22.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    headerView.backgroundColor = IPHONE11_LIGHT_GREEN_COLOR;
    
    // currently it's used for 'search' table view only
    if(tableView != self.tableView) return headerView;
    
    UILabel *titleGroup = [[UILabel alloc] init];
    [titleGroup setBackgroundColor:[UIColor clearColor]];
    [titleGroup setFrame:CGRectMake(15.0f, 0.0f, 290.0f , 22.0f)];
    titleGroup.textColor = [UIColor whiteColor];
//    titleGroup.font = [UIFont systemFontOfSize:17];
    [titleGroup setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
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
        }else if ([self.searchFoodWithTitleOptions objectForKey:@"Search Result"]){  //Search Result
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
    if(tableView==self.tableView)
        return [self searchTableViewCellForRowAtIndexPath:indexPath];
    else
    	// if(tableView==self.itemTableView)
        return [self itemTableViewCellForRowAtIndexPath:indexPath];
}
- (UITableViewCell *)itemTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IngredientItemCell";
    IngredientItemCell *cell = [self.itemTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[IngredientItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.descriptionLabel.adjustsFontSizeToFitWidth = NO;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.alpha=1.0;
    
    Meal *currentMeal = [OmniTool getCurrentMeal];
    Ingredient *ingredient = [currentMeal getIngredientAtIndex:(unsigned int)indexPath.row];
    
	cell.weightLabel.text = [NSString stringWithFormat:@"%.0f",[ingredient weight]];
    [cell.descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
    cell.descriptionLabel.text = [ingredient.food longDescription];
    
    return cell;
}


- (UITableViewCell *)searchTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
    static NSString *CellIdentifier = @"IngredientCell";
    IngredientCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Food *food;
    NSMutableArray *foodArray;
    
//    UIView *selectionColor = [[UIView alloc] init];
//    selectionColor.backgroundColor = [UIColor colorWithRed:(116/255.0) green:(196/255.0) blue:(151/255.0) alpha:1];
//    cell.selectedBackgroundView = selectionColor;

    
    // Configure the cell...
    if (cell == nil) {
        cell = [[IngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.options valueForKey:ACOUseSourceFont])
    {
        cell.cellTitle.font = [self.options valueForKey:ACOUseSourceFont];
    } else
    {
        cell.cellTitle.font = self.cellLabelFont;
    }
    cell.cellTitle.adjustsFontSizeToFitWidth = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.alpha=1.0;
    
    //沒有輸入文字
    if (!self.searchBar.text.length) {
        if (indexPath.section == 0) {
            foodArray = [self.mostDictionary objectForKey:@"Recent Searched"];
        }else if (indexPath.section == 1){
            foodArray = [self.mostDictionary objectForKey:@"Most Searched"];
        }
    }else{
        if ([self.searchFoodWithTitleOptions objectForKey:@"Search Result"]) { //KeyWord Search 搜尋中
        	foodArray=[self.searchFoodWithTitleOptions objectForKey:@"Search Result"];
        }else if ([self.searchFoodWithTitleOptions objectForKey:@"Recommend Search"]){//Search Result 搜尋結果
        	foodArray=[self.searchFoodWithTitleOptions objectForKey:@"Recommend Search"];
        }else{
            NSLog(@"     cellForRowAtIndexPath no match");
        }
    }
    if(foodArray){
	    food=[foodArray objectAtIndex:indexPath.row];
		if(indexPath.row < [foodArray count]){
            [cell.cellTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
	        cell.cellTitle.text = [food longDescription];
	    }
	}
    Meal *currentMeal=    [OmniTool getCurrentMeal];
	if([currentMeal containsFood:food]){
        [cell.cellButton setSelected:YES];
	}else
        [cell.cellButton setSelected:NO];
    
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
    /*
    if (!self.searchBar.text.length) {
        if (indexPath.section == 0) {
            
            NSMutableArray *recentArray = [self.mostDictionary objectForKey:@"Recent Searched"];
            nutritionViewSelectedFood=[recentArray objectAtIndex:indexPath.row];
        }else if (indexPath.section == 1){
            NSMutableArray *mostArray = [self.mostDictionary objectForKey:@"Most Searched"];
            nutritionViewSelectedFood=[mostArray objectAtIndex:indexPath.row];
        }
    }else{
        NSMutableDictionary *keywordSearch = [self substringIsInDictionary:self.searchBar.text];
        if ([self substringIsInDictionary:self.searchBar.text]) {
            if ([keywordSearch objectForKey:@"Search Result"]) { //keywords Search
                NSMutableArray *keywordArray = [keywordSearch objectForKey:@"Search Result"];
                nutritionViewSelectedFood=[keywordArray objectAtIndex:indexPath.row];
            }else if ([keywordSearch objectForKey:@"Recommend Search"]){ //Search Result
                NSMutableArray *keywordArray = [keywordSearch objectForKey:@"Recommend Search"];
                [OmniTool getFoodNutrient:[[keywordArray objectAtIndex:indexPath.row] foodNumber]];
            }
        }
    }
     */
    if(tableView==self.itemTableView){
        Meal *currentMeal = [OmniTool getCurrentMeal];
        selectedIngredient = [currentMeal getIngredientAtIndex:(unsigned int)indexPath.row];
        nutritionViewSelectedFood=[selectedIngredient food];
        [self performSegueWithIdentifier:@"IngredientToNutrition" sender:selectedIngredient];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Meal *currentMeal=    [OmniTool getCurrentMeal];
    
    if (tableView == self.itemTableView) {
        NSUInteger row = [indexPath row];
        NSUInteger count = [currentMeal countOfIngredients];
        //    [posts count];
        
        if (row < count) {
            return UITableViewCellEditingStyleDelete;
        } else {
            return UITableViewCellEditingStyleNone;
        }
    }else{
        return UITableViewCellEditingStyleNone;
    }
   
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Meal *currentMeal=    [OmniTool getCurrentMeal];
    
    if (tableView == self.itemTableView) {
        NSMutableDictionary *keywordArray = [currentMeal ingredientDictionary];
        NSArray *array = [keywordArray allValues];
        
        nutritionViewSelectedFood=[array objectAtIndex:indexPath.row];
        Ingredient *ing=[[Ingredient alloc] initializeWithFood:nutritionViewSelectedFood withWeight:100];
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            [currentMeal removeIngredient:ing];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.kcalLabel.text = [NSString stringWithFormat:@"%.0f",[currentMeal getKcal]];
            [self reloadSegmentTitle];
//            [tableView reloadData];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }else{
        // do nothing.
    }
    
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == self.itemTableView) {
//        NSUInteger row = [indexPath row];
//        NSUInteger count = [__currentMeal countOfIngredients];
//        
//        NSMutableDictionary *keywordArray = [__currentMeal ingredientDictionary];
//        NSArray *array = [keywordArray allValues];
//        
//        //    nutritionViewSelectedFood=[tableAraray objectAtIndex:indexPath.row];
//        nutritionViewSelectedFood=[array objectAtIndex:indexPath.row];
//        Ingredient *ing=[[Ingredient alloc] initializeWithFood:nutritionViewSelectedFood withWeight:100];
//        
//        if (row < count) {
//            [__currentMeal removeIngredient:ing];
//            self.kcalLabel.text = [NSString stringWithFormat:@"%.0f",[__currentMeal getKcal]];
//            [self reloadSegmentTitle];
//            [tableView reloadData];
//            //		[posts removeObjectAtIndex:row];
//        }
//    }else{
//        //Do nothing.
//    }
//}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.itemTableView) {
        //	[self updateViewTitle];
        [tableView reloadData];
    }else{
        //Do nothing.
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // NSLog(@"prepareForSegue IngredientController, %@",[segue identifier]);
    // ensure this is the Seque which is leading to the detail view
    if ([[segue identifier] isEqualToString:@"IngredientToNutrition"])
    {
         NutritionAnalyzer *detail = [segue destinationViewController];
         
         [detail setDetailItem:sender];
    }

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
    NSLog(@"IngredientController viewWillAppear");
    Meal *currentMeal=    [OmniTool getCurrentMeal];
    
    //恢復右划返回。
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
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
    [self.itemTableView reloadData];
    self.kcalLabel.text = [NSString stringWithFormat:@"%.0f",[currentMeal getKcal]];
    [self reloadSegmentTitle];
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    
    [self.tableView reloadData];
    [self.itemTableView reloadData];
    
    //利用獲得的選項Index來判斷所選項目
    switch ([sender selectedSegmentIndex]) {
        case 0:
            // search
            self.ingredientView.alpha=0.0f;
            self.searchView.alpha=1.0f;
            break;
            
        case 1:
            // Item
            self.ingredientView.alpha=1.0f;
            self.searchView.alpha=0.0f;
            [self.searchBar resignFirstResponder];
            break;
        default:
            NSLog(@"Something Error");
            break;
    }
}

- (IBAction)addFoodAsIngredient:(id)sender
{
    id grandpa=((UIButton *)sender).superview.superview.superview;
/*
    if([grandpa isKindOfClass:[IngredientCell class]])
    {
        NSLog(@"It's a IngredientCell");
    }else{
        NSLog(@"It's NOT a IngredientCell. Desc=%@",[grandpa description]);
    }
*/
    IngredientCell *tableViewCell = (IngredientCell *)grandpa;
    
    NSIndexPath* pathOfTheCell = [self.tableView indexPathForCell:tableViewCell];
//    NSInteger rowOfTheCell = pathOfTheCell.row;
//    NSLog(@"addFoodAsIngredient, name=%@, section=%d, row= %d",[[tableViewCell cellTitle] text],(int)pathOfTheCell.section, (int) rowOfTheCell );
    
    if (!self.searchBar.text.length) {
        if (pathOfTheCell.section == 0) {
            NSMutableArray *recentArray = [self.mostDictionary objectForKey:@"Recent Searched"];
            nutritionViewSelectedFood=[recentArray objectAtIndex:pathOfTheCell.row];
        }else if (pathOfTheCell.section == 1){
            NSMutableArray *mostArray = [self.mostDictionary objectForKey:@"Most Searched"];
            nutritionViewSelectedFood=[mostArray objectAtIndex:pathOfTheCell.row];
        }
    }else{
        NSMutableDictionary *keywordSearch = [self substringIsInDictionary:self.searchBar.text];
        if ([self substringIsInDictionary:self.searchBar.text]) {
            if ([keywordSearch objectForKey:@"Search Result"]) { //keywords Search
                NSMutableArray *keywordArray = [keywordSearch objectForKey:@"Search Result"];
                nutritionViewSelectedFood=[keywordArray objectAtIndex:pathOfTheCell.row];
            }else if ([keywordSearch objectForKey:@"Recommend Search"]){ //Search Result
                NSMutableArray *keywordArray = [keywordSearch objectForKey:@"Recommend Search"];
                nutritionViewSelectedFood=[keywordArray objectAtIndex:pathOfTheCell.row];
            }
        }
    }
    
    Ingredient *ing=[[Ingredient alloc] initializeWithFood:nutritionViewSelectedFood withWeight:100];
    Meal *currentMeal=    [OmniTool getCurrentMeal];
    if(!currentMeal)
        [OmniTool initialCurrentMeal];
    
    if (!tableViewCell.cellButton.selected) {
        [currentMeal addIngredient:ing];
    }else{
        [currentMeal removeIngredient:ing];
    }
    
    [self.tableView reloadData];
    [self.itemTableView reloadData];
    [self reloadSegmentTitle];
    self.kcalLabel.text = [NSString stringWithFormat:@"%.0f",[currentMeal getKcal]];
    
    // increase the search log
    [OmniTool updateSearchCount:nutritionViewSelectedFood.foodNumber];
    [OmniTool logSearch:nutritionViewSelectedFood.foodNumber];

}
-(void) reloadSegmentTitle
{
    NSString *newTitle;
    Meal *currentMeal=    [OmniTool getCurrentMeal];
    if([currentMeal countOfIngredients] > 1)
        newTitle=[NSString stringWithFormat:@"%d Items",[currentMeal countOfIngredients]];
    else
        newTitle=[NSString stringWithFormat:@"%d Item",[currentMeal countOfIngredients]];
    [self.segmentControl setTitle:newTitle forSegmentAtIndex:1];
}
@end
