//
//  FoodViewController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "FoodViewController.h"
#import "CustomDetailCell.h"
#import "IngredientItemCell.h"
#import "NutrientOverview.h"

@interface FoodViewController ()

@end

@implementation FoodViewController
@synthesize detailItem = _detailItem;
@synthesize getArray = _getArray;
@synthesize overview100, overview101, overview102, overview103;

- (void)setDetailItem:(id)detailItem{
    if (_detailItem != detailItem) {
        _detailItem = detailItem;
    }
}

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
    
    self.ingredientsTable.hidden = YES;
    self.ingredientsView.hidden = YES;
    self.ingredientsTable.delegate = self;
    self.detailTable.hidden = NO;
    self.detailView.hidden = NO;
    self.detailTable.delegate = self;
    
    [OmniTool initialHardcodedMeals];
    
	// Do any additional setup after loading the view.
    NSLog(@"get ChickenVegetablesSalad = %i", [ChickenVegetablesSalad countOfIngredients]);
    switch ([_detailItem tag]) {
        case 100:
            //第1筆食物數值, CapreseSalad
            [self capressSalad];
            break;
        case 101:
            //第2筆食物數值, TomatoSpaghetti
            [self tomatoSpaghetti];
            break;
        case 102:
            //第3筆食物數值, Chicken Vegetable Salad
            [self chickenVegtablesSalad];
            break;
        case 103:
            //第4筆食物數值, Freshberriesicecream
            [self freshBerriesIceCream];
            break;
            
        default:
            break;
    }
}

- (void) capressSalad {
    self.navigationItem.title = @"Caprese Salad";
    self.foodImageView.image = [UIImage imageNamed:@"data_foodCapreseSalad.png"];
    //第1筆食物數值, Caprese Salad
    self.overview100 = [CapreseSalad getNutrientOverviewForUserType:1];
    Nutrient *fat=[self.overview100 getNutrientWithInt:NUTRIENT_TOTALLIPID];
    self.fatValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [fat rdaRatio]*100*3];
    Nutrient *salt=[self.overview100 getNutrientWithInt:NUTRIENT_SODIUM];
    self.saltValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [salt rdaRatio]*100*3];
    Nutrient *protein=[self.overview100 getNutrientWithInt:NUTRIENT_PROTEIN];
    self.proteinValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [protein rdaRatio]*100*3];
    Nutrient *carbs=[self.overview100 getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
    self.carbsValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [carbs rdaRatio]*100*3];
    Nutrient *calories = [self.overview100 getNutrientWithInt:NUTRIENT_ENERGYKCAL];
    self.caloriesValueLabel.text = [NSString stringWithFormat:@"%.0f Kcal", [calories nutrientValue]];
    self.TotalCarloriesLabel.text = [NSString stringWithFormat:@"%.0f", [calories nutrientValue]];
    
    [self updateBoxLayOut:[fat rdaRatio]*3 AndInforGraphicView:self.fatInforGraphicView AndValueLabel:self.fatValueLabel AndNutritionLabel:self.fatLabel AndZeroView:self.fatZero];
    [self updateBoxLayOut:[salt rdaRatio]*3 AndInforGraphicView:self.saltInforGraphicView AndValueLabel:self.saltValueLabel AndNutritionLabel:self.saltLabel AndZeroView:self.saltZero];
    [self updateBoxLayOut:[protein rdaRatio]*3 AndInforGraphicView:self.proteinInforGraphicView AndValueLabel:self.proteinValueLabel AndNutritionLabel:self.proteinLabel AndZeroView:self.proteinZero];
    [self updateBoxLayOut:[carbs rdaRatio]*3 AndInforGraphicView:self.carbsInforGraphicView AndValueLabel:self.carbsValueLabel AndNutritionLabel:self.carbsLabel AndZeroView:self.carbsZero];
    [self updateCarloriesBoxLayOut:[calories rdaRatio]*3 AndInforGraphicView:self.caloriesInforGraphicView AndValueLabel:self.caloriesValueLabel AndNutritionLabel:self.caloriesLabel AndTriableImage:self.caloriesTriableImage andZeroView:self.caloriesZero];
}

- (void) tomatoSpaghetti {
    self.navigationItem.title = @"Tomato Spaghetti";
    self.foodImageView.image = [UIImage imageNamed:@"data_foodTomatoSpaghetti.png"];
    //第2筆食物數值, TomatoSpaghetti
    self.overview101 = [TomatoSpaghetti getNutrientOverviewForUserType:1];
    Nutrient *fat=[self.overview101 getNutrientWithInt:NUTRIENT_TOTALLIPID];
    self.fatValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [fat rdaRatio]*100*3];
    Nutrient *salt=[self.overview101 getNutrientWithInt:NUTRIENT_SODIUM];
    self.saltValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [salt rdaRatio]*100*3];
    Nutrient *protein=[self.overview101 getNutrientWithInt:NUTRIENT_PROTEIN];
    self.proteinValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [protein rdaRatio]*100*3];
    Nutrient *carbs=[self.overview101 getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
    self.carbsValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [carbs rdaRatio]*100*3];
    Nutrient *calories = [self.overview101 getNutrientWithInt:NUTRIENT_ENERGYKCAL];
    self.caloriesValueLabel.text = [NSString stringWithFormat:@"%.0f Kcal", [calories nutrientValue]];
    self.TotalCarloriesLabel.text = [NSString stringWithFormat:@"%.0f", [calories nutrientValue]];
    
    [self updateBoxLayOut:[fat rdaRatio]*3 AndInforGraphicView:self.fatInforGraphicView AndValueLabel:self.fatValueLabel AndNutritionLabel:self.fatLabel AndZeroView:self.fatZero];
    [self updateBoxLayOut:[salt rdaRatio]*3 AndInforGraphicView:self.saltInforGraphicView AndValueLabel:self.saltValueLabel AndNutritionLabel:self.saltLabel AndZeroView:self.saltZero];
    [self updateBoxLayOut:[protein rdaRatio]*3 AndInforGraphicView:self.proteinInforGraphicView AndValueLabel:self.proteinValueLabel AndNutritionLabel:self.proteinLabel AndZeroView:self.proteinZero];
    [self updateBoxLayOut:[carbs rdaRatio]*3 AndInforGraphicView:self.carbsInforGraphicView AndValueLabel:self.carbsValueLabel AndNutritionLabel:self.carbsLabel AndZeroView:self.carbsZero];
    [self updateCarloriesBoxLayOut:[calories rdaRatio]*3 AndInforGraphicView:self.caloriesInforGraphicView AndValueLabel:self.caloriesValueLabel AndNutritionLabel:self.caloriesLabel AndTriableImage:self.caloriesTriableImage andZeroView:self.caloriesZero];
}

- (void) chickenVegtablesSalad {
    self.navigationItem.title = @"Chicken Vegetable Salad";
    self.foodImageView.image = [UIImage imageNamed:@"data_foodChickenVegetablesSalad.png"];
    //第3筆食物數值, CapreseSalad
    self.overview102 = [ChickenVegetablesSalad getNutrientOverviewForUserType:1];
    Nutrient *fat=[self.overview102 getNutrientWithInt:NUTRIENT_TOTALLIPID];
    self.fatValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [fat rdaRatio]*100*3];
    Nutrient *salt=[self.overview102 getNutrientWithInt:NUTRIENT_SODIUM];
    self.saltValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [salt rdaRatio]*100*3];
    Nutrient *protein=[self.overview102 getNutrientWithInt:NUTRIENT_PROTEIN];
    self.proteinValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [protein rdaRatio]*100*3];
    Nutrient *carbs=[self.overview102 getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
    self.carbsValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [carbs rdaRatio]*100*3];
    Nutrient *calories = [self.overview102 getNutrientWithInt:NUTRIENT_ENERGYKCAL];
    self.caloriesValueLabel.text = [NSString stringWithFormat:@"%.0f Kcal", [calories nutrientValue]];
    self.TotalCarloriesLabel.text = [NSString stringWithFormat:@"%.0f", [calories nutrientValue]];
    
    [self updateBoxLayOut:[fat rdaRatio]*3 AndInforGraphicView:self.fatInforGraphicView AndValueLabel:self.fatValueLabel AndNutritionLabel:self.fatLabel AndZeroView:self.fatZero];
    [self updateBoxLayOut:[salt rdaRatio]*3 AndInforGraphicView:self.saltInforGraphicView AndValueLabel:self.saltValueLabel AndNutritionLabel:self.saltLabel AndZeroView:self.saltZero];
    [self updateBoxLayOut:[protein rdaRatio]*3 AndInforGraphicView:self.proteinInforGraphicView AndValueLabel:self.proteinValueLabel AndNutritionLabel:self.proteinLabel AndZeroView:self.proteinZero];
    [self updateBoxLayOut:[carbs rdaRatio]*3 AndInforGraphicView:self.carbsInforGraphicView AndValueLabel:self.carbsValueLabel AndNutritionLabel:self.carbsLabel AndZeroView:self.carbsZero];
    [self updateCarloriesBoxLayOut:[calories rdaRatio]*3 AndInforGraphicView:self.caloriesInforGraphicView AndValueLabel:self.caloriesValueLabel AndNutritionLabel:self.caloriesLabel AndTriableImage:self.caloriesTriableImage andZeroView:self.caloriesZero];
}

- (void) freshBerriesIceCream {
    self.navigationItem.title = @"Fresh Berries Ice Cream";
    self.foodImageView.image = [UIImage imageNamed:@"data_foodFreshberriesicecream.png"];
    //第4筆食物數值, Fresh Berries Icecrea
    self.overview103 = [FreshBerriesIceCream getNutrientOverviewForUserType:1];
    Nutrient *fat=[self.overview103 getNutrientWithInt:NUTRIENT_TOTALLIPID];
    self.fatValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [fat rdaRatio]*100*3];
    Nutrient *salt=[self.overview103 getNutrientWithInt:NUTRIENT_SODIUM];
    self.saltValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [salt rdaRatio]*100*3];
    Nutrient *protein=[self.overview103 getNutrientWithInt:NUTRIENT_PROTEIN];
    self.proteinValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [protein rdaRatio]*100*3];
    Nutrient *carbs=[self.overview103 getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
    self.carbsValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [carbs rdaRatio]*100*3];
    Nutrient *calories = [self.overview103 getNutrientWithInt:NUTRIENT_ENERGYKCAL];
    self.caloriesValueLabel.text = [NSString stringWithFormat:@"%.0f Kcal", [calories nutrientValue]];
    self.TotalCarloriesLabel.text = [NSString stringWithFormat:@"%.0f", [calories nutrientValue]];
    
    [self updateBoxLayOut:[fat rdaRatio]*3 AndInforGraphicView:self.fatInforGraphicView AndValueLabel:self.fatValueLabel AndNutritionLabel:self.fatLabel AndZeroView:self.fatZero];
    [self updateBoxLayOut:[salt rdaRatio]*3 AndInforGraphicView:self.saltInforGraphicView AndValueLabel:self.saltValueLabel AndNutritionLabel:self.saltLabel AndZeroView:self.saltZero];
    [self updateBoxLayOut:[protein rdaRatio]*3 AndInforGraphicView:self.proteinInforGraphicView AndValueLabel:self.proteinValueLabel AndNutritionLabel:self.proteinLabel AndZeroView:self.proteinZero];
    [self updateBoxLayOut:[carbs rdaRatio]*3 AndInforGraphicView:self.carbsInforGraphicView AndValueLabel:self.carbsValueLabel AndNutritionLabel:self.carbsLabel AndZeroView:self.carbsZero];
    [self updateCarloriesBoxLayOut:[calories rdaRatio]*3 AndInforGraphicView:self.caloriesInforGraphicView AndValueLabel:self.caloriesValueLabel AndNutritionLabel:self.caloriesLabel AndTriableImage:self.caloriesTriableImage andZeroView:self.caloriesZero];
}



//橫向的生長 inforgraphic
- (void) updateBoxLayOut:(double)Ratio AndInforGraphicView:(UIView *)inforgraphicView AndValueLabel:(UILabel *)ValueLabel AndNutritionLabel:(UILabel *)NutritionLabel AndZeroView:(UIView *)zeroView{
    if (Ratio < 0.5) {
        inforgraphicView.frame = CGRectMake(0, 0, 180*Ratio, inforgraphicView.frame.size.height);
        ValueLabel.textColor = [UIColor blackColor];
        NutritionLabel.textColor = [UIColor blackColor];
    }else if (Ratio < 0.7 && Ratio > 0.5) {
        inforgraphicView.frame = CGRectMake(0, 0, 180*Ratio, inforgraphicView.frame.size.height);
        ValueLabel.textColor = [UIColor whiteColor];
        NutritionLabel.textColor = [UIColor whiteColor];
    }else if (Ratio > 0.7 && Ratio < 1.3){
        if (Ratio < 1.0) {
            inforgraphicView.frame = CGRectMake(0, 0, 180*Ratio, inforgraphicView.frame.size.height);
        }else{
            inforgraphicView.frame = CGRectMake(0, 0, 180, inforgraphicView.frame.size.height);
        }
        ValueLabel.textColor = [UIColor whiteColor];
        NutritionLabel.textColor = [UIColor whiteColor];
    }else{
        inforgraphicView.frame = CGRectMake(0, 0, 180, inforgraphicView.frame.size.height);
        ValueLabel.textColor = [UIColor whiteColor];
        NutritionLabel.textColor = [UIColor whiteColor];
    }
    
    if (Ratio == 0){
        inforgraphicView.backgroundColor = [UIColor clearColor]; //無顏色
        zeroView.backgroundColor = [UIColor clearColor];
    }else if (Ratio < 0.5){ //橘色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
        zeroView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
    }else if (Ratio < 1.5 ) { //綠色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:134.0f/255.0f green:170.0f/255.0f blue:102.0f/255.0f alpha:1.0]; //綠色
        zeroView.backgroundColor = [UIColor colorWithRed:134.0f/255.0f green:170.0f/255.0f blue:102.0f/255.0f alpha:1.0]; //綠色
    }else if (Ratio < 2.0 ){ //橘色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
        zeroView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
    }else{ //紅色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0];   //紅色
        zeroView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0];   //紅色
    }
}

//直向生長
- (void) updateCarloriesBoxLayOut:(double)Ratio AndInforGraphicView:(UIView *)inforgraphicView AndValueLabel:(UILabel *)ValueLabel AndNutritionLabel:(UILabel *)NutritionLabel AndTriableImage:(UIImageView *)triableImage andZeroView:(UIView *)zeroView{
    if (Ratio < 0.5) {
        inforgraphicView.frame = CGRectMake(0, 175-175*Ratio, 122, 175*Ratio);
        triableImage.frame = CGRectMake(192, 3+175-175*Ratio, triableImage.frame.size.width, triableImage.frame.size.height);
        ValueLabel.textColor = [UIColor blackColor];
        NutritionLabel.textColor = [UIColor blackColor];
    }else if (Ratio < 0.7 && Ratio > 0.5) {
        inforgraphicView.frame = CGRectMake(0, 175-175*Ratio, 122, 175*Ratio);
        triableImage.frame = CGRectMake(192, 3+175-175*Ratio, triableImage.frame.size.width, triableImage.frame.size.height);
        ValueLabel.textColor = [UIColor whiteColor];
        NutritionLabel.textColor = [UIColor whiteColor];
    }else if (Ratio > 0.7 && Ratio < 1.3){
        if (Ratio < 1.0) {
            inforgraphicView.frame = CGRectMake(0, 175-175*Ratio, 122, 175*Ratio);
            triableImage.frame = CGRectMake(192, 3+175-175*Ratio, triableImage.frame.size.width, triableImage.frame.size.height);
        }else{
            inforgraphicView.frame = CGRectMake(0, 207-207, 122, 175);
            triableImage.frame = CGRectMake(192, 3, triableImage.frame.size.width, triableImage.frame.size.height);
        }
        ValueLabel.textColor = [UIColor whiteColor];
        NutritionLabel.textColor = [UIColor whiteColor];
    }else{
        inforgraphicView.frame = CGRectMake(0, 207-207, 122, 175);
        triableImage.frame = CGRectMake(192, 3, 122, triableImage.frame.size.height);
        ValueLabel.textColor = [UIColor whiteColor];
        NutritionLabel.textColor = [UIColor whiteColor];
    }
    
    if (Ratio == 0){
        inforgraphicView.backgroundColor = [UIColor clearColor]; //無顏色
        zeroView.backgroundColor = [UIColor clearColor]; //無顏色
    }else if (Ratio < 0.5){ //橘色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
        zeroView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
        triableImage.image = [UIImage imageNamed:@"TriableYellow.png"];
    }else if (Ratio < 1.5 ) { //綠色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:134.0f/255.0f green:170.0f/255.0f blue:102.0f/255.0f alpha:1.0]; //綠色
        zeroView.backgroundColor = [UIColor colorWithRed:134.0f/255.0f green:170.0f/255.0f blue:102.0f/255.0f alpha:1.0]; //綠色
        triableImage.image = [UIImage imageNamed:@"TriableGreen.png"];
    }else if (Ratio < 2.0 ){ //橘色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
        zeroView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
        triableImage.image = [UIImage imageNamed:@"TriableYellow.png"];
    }else{ //紅色
        inforgraphicView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0];   //紅色
        zeroView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0];   //紅色
        triableImage.image = [UIImage imageNamed:@"TriableRed.png"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
// detailTable.tag = 100
// ingredientsTable.tag = 101

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //detail 有33個， ingredients 則根據meal數量
    if (tableView.tag == 100) {
        return 33;
    }else if (tableView.tag == 101){
        switch ([_detailItem tag]) {
            case 100:
                //第1筆食物數值, CapreseSalad
                return [CapreseSalad countOfIngredients];
                break;
            case 101:
                //第2筆食物數值, TomatoSpaghetti
                return [TomatoSpaghetti countOfIngredients];
                break;
            case 102:
                //第3筆食物數值, ChickenVegetablesSalad
                return [ChickenVegetablesSalad countOfIngredients];
                break;
            case 103:
                //第4筆食物數值, FreshBerriesIceCream
                return [FreshBerriesIceCream countOfIngredients];
                break;
                
            default:
                break;
        }
    }
    return 0;
}

// set height for the header
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 21;
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return 57.0f;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 100) {
        // initial UIView for header
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 37)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        //    headerView.backgroundColor =[UIColor clearColor];
        // initial title label for header view
        UILabel *titleGroup = [[UILabel alloc] init];
        [titleGroup setBackgroundColor:[UIColor clearColor]];
        [titleGroup setFrame:CGRectMake(13.0f, 0.0f, 200 , 21.0f)];
        titleGroup.textColor =[UIColor blackColor];
        titleGroup.font = [UIFont fontWithName:@"Helvetica Light" size:12.0];
        [titleGroup setTextAlignment:NSTextAlignmentLeft];
        
        
        CGPoint _subTitlePoint = CGPointMake(207, 0);
        // initial sub title label for header view
        UILabel *subTitleGroup = [[UILabel alloc] init];
        [subTitleGroup setBackgroundColor:[UIColor clearColor]];
        [subTitleGroup setFrame:CGRectMake(_subTitlePoint.x, _subTitlePoint.y, 100 , 21.0f)];
        
        subTitleGroup.textColor = [UIColor blackColor];
        subTitleGroup.font = [UIFont fontWithName:@"Helvetica Light" size:12.0f];
        [subTitleGroup setTextAlignment:NSTextAlignmentRight];
        subTitleGroup.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        // there are 3 sections with different title and sub title
        if (section == 0) {
            [titleGroup setText:@"Category"];
            [subTitleGroup setText:@" Servings    DV%  "];
        }else if (section ==1){
            [titleGroup setText:@"MAIN"];
            [subTitleGroup setText:@""];
        }else if (section ==2){
            [titleGroup setText:@"OTHERS"];
            [subTitleGroup setText:@""];
        }
        
        [headerView addSubview:titleGroup];
        [headerView addSubview:subTitleGroup];
        return headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 100) {
        static NSString *CellIdentifier = @"foodViewCell";
        CustomDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        //直立的坐標
        CGSize _VauleViewSize = CGSizeMake(200, 14);
        if(UIInterfaceOrientationIsLandscape(orientation)){
            //橫擺的坐標
            _VauleViewSize = CGSizeMake(200, 14);
        }
        
        switch ([_detailItem tag]) {
            case 100:
                //第1筆食物數值, CapreseSalad
                [self updateBoxForCell:cell AndIndexPath:indexPath AndSize:_VauleViewSize AndOverView:self.overview100];
                break;
            case 101:
                //第2筆食物數值, TomatoSpaghetti
                [self updateBoxForCell:cell AndIndexPath:indexPath AndSize:_VauleViewSize AndOverView:self.overview101];
                break;
            case 102:
                //第3筆食物數值, Chicken Vegetable Salad
                [self updateBoxForCell:cell AndIndexPath:indexPath AndSize:_VauleViewSize AndOverView:self.overview102];
                break;
            case 103:
                //第4筆食物數值, Freshberriesicecream
                [self updateBoxForCell:cell AndIndexPath:indexPath AndSize:_VauleViewSize AndOverView:self.overview103];
                break;
                
            default:
                break;
        }
        return cell;
    }else if (tableView.tag == 101){
        
        static NSString *CellIdentifier = @"IngredientItemCell";
        IngredientItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        // Configure the cell...
        if (cell == nil) {
            cell = [[IngredientItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.descriptionLabel.adjustsFontSizeToFitWidth = NO;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.alpha=1.0;
        
        Ingredient *ingredient;
        
        if ([_detailItem tag] == 100) {
            ingredient = [CapreseSalad getIngredientAtIndex:(unsigned int)indexPath.row];
        }else if ([_detailItem tag] == 101){
            ingredient = [TomatoSpaghetti getIngredientAtIndex:(unsigned int)indexPath.row];
        }else if ([_detailItem tag] == 102){
            ingredient = [ChickenVegetablesSalad getIngredientAtIndex:(unsigned int)indexPath.row];
        }else if ([_detailItem tag] == 103){
            ingredient = [FreshBerriesIceCream getIngredientAtIndex:(unsigned int)indexPath.row];
        }
        
        cell.weightLabel.text = [NSString stringWithFormat:@"%.0f",[ingredient weight]];
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@", [[ingredient food] longDescription]];
        
        return cell;
    }
    return nil;
}

- (void) updateBoxForCell:(CustomDetailCell *)cell AndIndexPath:(NSIndexPath *)indexPath AndSize:(CGSize)size AndOverView:(NutrientOverview *)overview{
    // 10% 以內用綠色
    // 40% 以內用橘色
    // 其它用紅色
    // 0 用無色
    if (indexPath.row == 0) { //NUTRIENT_CAFFEINE
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_CAFFEINE];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 1) { //NUTRIENT_CALCIUM
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_CALCIUM];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 2) { //NUTRIENT_CARBOHYDRATE
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 3) { //NUTRIENT_CHOLESTEROL
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_CHOLESTEROL];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 4) { //NUTRIENT_CHOLINE
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_CHOLINE];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 5) { //NUTRIENT_COPPER
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_COPPER];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 6) { //NUTRIENT_ENERGYKCAL
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_ENERGYKCAL];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 7) { //NUTRIENT_FIBER
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_FIBER];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 8) { //NUTRIENT_FLUORIDE
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_FLUORIDE];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 9) { //NUTRIENT_FOLATE
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_FOLATE];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 10) { //NUTRIENT_IRON
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_IRON];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 11) { //NUTRIENT_MAGNESIUM
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_MAGNESIUM];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 12) { //NUTRIENT_MANGANESE
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_MANGANESE];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 13) { //NUTRIENT_NIACIN
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_NIACIN];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 14) { //NUTRIENT_PANTOTHENICACID
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_PANTOTHENICACID];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 15) { //NUTRIENT_PHOSPHORUS
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_PHOSPHORUS];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 16) { //NUTRIENT_POTASSIUM
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_POTASSIUM];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 17) { //NUTRIENT_PROTEIN
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_PROTEIN];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 18) { //NUTRIENT_RIBOFLAVIN
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_RIBOFLAVIN];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 19) { //NUTRIENT_SELENIUM
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_SELENIUM];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 20) { //NUTRIENT_SODIUM
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_SODIUM];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 21) { //NUTRIENT_SUGARS
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_SUGARS];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 22) { //NUTRIENT_THIAMIN
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_THIAMIN];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 23) { //NUTRIENT_TOTALLIPID
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_TOTALLIPID];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 24) { //NUTRIENT_VITAMINA
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_VITAMINA];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 25) { //NUTRIENT_VITAMINB12
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_VITAMINB12];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 26) { //NUTRIENT_VITAMINB6
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_VITAMINB6];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 27) { //NUTRIENT_VITAMINC
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_VITAMINC];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 28) { //NUTRIENT_VITAMIND
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_VITAMIND];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 29) { //NUTRIENT_VITAMINE
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_VITAMINE];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 30) { //NUTRIENT_VITAMINK
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_VITAMINK];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 31) { //NUTRIENT_WATER
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_WATER];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }else if (indexPath.row == 32) { //NUTRIENT_ZINC
        Nutrient *nutrient = [overview getNutrientWithInt:NUTRIENT_ZINC];
        [self NutrientBoxUpdate:cell AndRdatio:[nutrient rdaRatio]*3 AndSize:size AndNutrition:nutrient];
    }
}

- (void) NutrientBoxUpdate:(CustomDetailCell *)cell AndRdatio:(double)rdaRatio AndSize:(CGSize)size AndNutrition:(Nutrient *)nutrition{
    if (rdaRatio == 0){
        cell.cellNutrientVauleView.backgroundColor = [UIColor clearColor]; //無顏色
    }else if (rdaRatio<0.5){
        if (rdaRatio<1.0) {
            cell.cellNutrientVauleView.frame = CGRectMake(0, 0, size.width*rdaRatio, 14);
        }else{
            cell.cellNutrientVauleView.frame = CGRectMake(0, 0, size.width, 14);
        }
        cell.cellNutrientVauleView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
        
    }else if (rdaRatio<1.5) {
        // adjust width according to ratio
        if (rdaRatio<1.0) {
            cell.cellNutrientVauleView.frame = CGRectMake(0, 0, size.width*rdaRatio, 14);
        }else{
            cell.cellNutrientVauleView.frame = CGRectMake(0, 0, size.width, 14);
        }
        
        // adjust color according to ratio
        cell.cellNutrientVauleView.backgroundColor = [UIColor colorWithRed:134.0f/255.0f green:170.0f/255.0f blue:102.0f/255.0f alpha:1.0]; //綠色
    }else if (rdaRatio < 2.0){
        if (rdaRatio<1.0) {
            cell.cellNutrientVauleView.frame = CGRectMake(0, 0, size.width*rdaRatio, 14);
        }else{
            cell.cellNutrientVauleView.frame = CGRectMake(0, 0, size.width, 14);
        }
        cell.cellNutrientVauleView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0]; //橘色
    }else{
        cell.cellNutrientVauleView.frame = CGRectMake(0, 0, size.width, 14);
        cell.cellNutrientVauleView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0];   //紅色
    }
    
    // set title, value, and ratio text
    cell.cellNutrientTitleLabel.text = [nutrition nutrientShortName];
    cell.cellNutrientVauleLabel.text = [NSString stringWithFormat:@"%.0f %@", [nutrition nutrientValue],[nutrition unit]];
    cell.cellNutrientVauleRadioLabel.text = [NSString stringWithFormat:@"%.0f%%", rdaRatio*100];
}

#pragma mark - Table view delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)changeTabelViewPressed:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.detailTable.hidden = NO;
            self.detailView.hidden = NO;
            self.ingredientsTable.hidden = YES;
            self.ingredientsView.hidden = YES;
            break;
        case 1:
            self.detailTable.hidden = YES;
            self.detailView.hidden = YES;
            self.ingredientsTable.hidden = NO;
            self.ingredientsView.hidden = NO;
            break;
            
        default:
            break;
    }
    
}
@end