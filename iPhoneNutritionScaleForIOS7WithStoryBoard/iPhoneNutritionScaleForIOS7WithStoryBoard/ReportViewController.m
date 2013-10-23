//
//  ReportViewController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/10/4.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "ReportViewController.h"
#import "CustomDetailCell.h"
#import "IngredientItemCell.h"

@interface ReportViewController ()

@end

@implementation ReportViewController
//@synthesize meal = _meal;
@synthesize detailItem = _detailItem;
@synthesize watermarkScroll = _watermarkScroll;
@synthesize skinShadowImage = _skinShadowImage;

- (void)setDetailItem:(id)detailItem{
    if (_detailItem != detailItem) {
        _detailItem = detailItem;
        
        NSLog(@"detail = %@", _detailItem);
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Meal *currentMeal=    [OmniTool getCurrentMeal];
//    _meal = [OmniTool getCurrentMeal];
    UILabel *foodName2 = [_detailItem objectAtIndex:2];
    
    self.foodNameLabel.text = foodName2.text;

    UIImageView *imageView = [_detailItem objectAtIndex:0];
    
    if (!imageView.image) {
        self.foodImageView.image = [UIImage imageNamed:@"NoPicture.png"];
    }else{
        self.foodImageView.image = imageView.image;
    }
    
    self.overViewFood = [currentMeal getNutrientOverviewForUserType:1];
    Nutrient *fat=[self.overViewFood getNutrientWithInt:NUTRIENT_TOTALLIPID];
    self.fatValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [fat rdaRatio]*100*3];
    Nutrient *salt=[self.overViewFood getNutrientWithInt:NUTRIENT_SODIUM];
    self.saltValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [salt rdaRatio]*100*3];
    Nutrient *protein=[self.overViewFood getNutrientWithInt:NUTRIENT_PROTEIN];
    self.proteinValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [protein rdaRatio]*100*3];
    Nutrient *carbs=[self.overViewFood getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
    self.carbsValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [carbs rdaRatio]*100*3];
    Nutrient *calories = [self.overViewFood getNutrientWithInt:NUTRIENT_ENERGYKCAL];
    self.caloriesValueLabel.text = [NSString stringWithFormat:@"%.0f Kcal", [calories nutrientValue]];
    self.TotalCarloriesLabel.text = [NSString stringWithFormat:@"%.0f", [calories nutrientValue]];
    
    [self updateBoxLayOut:[fat rdaRatio]*3 AndInforGraphicView:self.fatInforGraphicView AndValueLabel:self.fatValueLabel AndNutritionLabel:self.fatLabel AndZeroView:self.fatZero];
    [self updateBoxLayOut:[salt rdaRatio]*3 AndInforGraphicView:self.saltInforGraphicView AndValueLabel:self.saltValueLabel AndNutritionLabel:self.saltLabel AndZeroView:self.saltZero];
    [self updateBoxLayOut:[protein rdaRatio]*3 AndInforGraphicView:self.proteinInforGraphicView AndValueLabel:self.proteinValueLabel AndNutritionLabel:self.proteinLabel AndZeroView:self.proteinZero];
    [self updateBoxLayOut:[carbs rdaRatio]*3 AndInforGraphicView:self.carbsInforGraphicView AndValueLabel:self.carbsValueLabel AndNutritionLabel:self.carbsLabel AndZeroView:self.carbsZero];
    [self updateCarloriesBoxLayOut:[calories rdaRatio]*3 AndInforGraphicView:self.caloriesInforGraphicView AndValueLabel:self.caloriesValueLabel AndNutritionLabel:self.caloriesLabel AndTriableImage:self.caloriesTriableImage andZeroView:self.caloriesZero];
    
    NSLog(@"fat = %@", self.overViewFood);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did Load. 1");
	// Do any additional setup after loading the view.
    
    _watermarkScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 290, 290)];
    _watermarkScroll.contentSize = CGSizeMake(290, 290);
    _watermarkScroll.pagingEnabled = YES;
    _watermarkScroll.backgroundColor = [UIColor clearColor];
    
    self.skinShadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 290, 290)];
    self.skinShadowImage.image = [UIImage imageNamed:@"SkinShadow.png"];
    
    if (![[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:205] && ![[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:307] && ![[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:204]) {
        
        float carbsRda = 0;
        float saltRda = 0;
        float fatRda = 0;
        
        if (carbsRda < 50) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 150) {//綠色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 200) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (carbsRda < 50) {
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda < 150){
            [self.circleDrawer0 setGreenColor:YES];
        }else if (carbsRda < 200){
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda >= 200){
            [self.circleDrawer0 setRedColor:YES];
        }
        if (carbsRda > 100) {
            [self.circleDrawer0 drawPercentage:99.99 Rda:carbsRda];
        }else{
            [self.circleDrawer0 drawPercentage:carbsRda Rda:carbsRda];
        }
        
        if (saltRda < 50) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 150) {//綠色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 200) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (saltRda < 50) {
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda < 150){
            [self.circleDrawer1 setGreenColor:YES];
        }else if (saltRda < 200){
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda >= 200){
            [self.circleDrawer1 setRedColor:YES];
        }
        if (saltRda > 100) {
            [self.circleDrawer1 drawPercentage:99.99 Rda:saltRda];
        }else{
            [self.circleDrawer1 drawPercentage:saltRda Rda:saltRda];
        }
        
        
        if (fatRda < 50) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 150) {//綠色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 200) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (fatRda < 50) {
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda < 150){
            [self.circleDrawer2 setGreenColor:YES];
        }else if (fatRda < 200){
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda >= 200){
            [self.circleDrawer2 setRedColor:YES];
        }
        if (fatRda > 100) {
            [self.circleDrawer2 drawPercentage:99.99 Rda:fatRda];
        }else{
            [self.circleDrawer2 drawPercentage:fatRda Rda:fatRda];
        }
    }else{
        float carbsRda = [[NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:205] rdaRatio]*100*3] floatValue];
        float saltRda = [[NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:307] rdaRatio]*100*3] floatValue];
        float fatRda = [[NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:204] rdaRatio]*100*3] floatValue];
        
        if (carbsRda < 50) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 150) {//綠色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 200) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (carbsRda < 50) {
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda < 150){
            [self.circleDrawer0 setGreenColor:YES];
        }else if (carbsRda < 200){
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda >= 200){
            [self.circleDrawer0 setRedColor:YES];
        }
        if (carbsRda > 100) {
            [self.circleDrawer0 drawPercentage:99.99 Rda:carbsRda];
        }else{
            [self.circleDrawer0 drawPercentage:carbsRda Rda:carbsRda];
        }
        
        if (saltRda < 50) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 150) {//綠色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 200) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 100.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (saltRda < 50) {
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda < 150){
            [self.circleDrawer1 setGreenColor:YES];
        }else if (saltRda < 200){
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda >= 200){
            [self.circleDrawer1 setRedColor:YES];
        }
        if (saltRda > 100) {
            [self.circleDrawer1 drawPercentage:99.99 Rda:saltRda];
        }else{
            [self.circleDrawer1 drawPercentage:saltRda Rda:saltRda];
        }
        
        
        if (fatRda < 50) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 150) {//綠色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 200) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 195.0f) radius:45.3f internalRadius:25.0f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (fatRda < 50) {
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda < 150){
            [self.circleDrawer2 setGreenColor:YES];
        }else if (fatRda < 200){
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda >= 200){
            [self.circleDrawer2 setRedColor:YES];
        }
        if (fatRda > 100) {
            [self.circleDrawer2 drawPercentage:99.99 Rda:fatRda];
        }else{
            [self.circleDrawer2 drawPercentage:fatRda Rda:fatRda];
        }
    }
    
    self.FoodNameLabelSkin = [[UILabel alloc] initWithFrame:CGRectMake(143.9f, 105.0f, 141.79f, 88.0f)];
    [self.FoodNameLabelSkin setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21.48]];
    self.FoodNameLabelSkin.textAlignment = NSTextAlignmentRight;
    self.FoodNameLabelSkin.numberOfLines = 0;
    self.FoodNameLabelSkin.backgroundColor = [UIColor clearColor];
    self.FoodNameLabelSkin.textColor = [UIColor whiteColor];
    self.FoodNameLabelSkin.shadowColor = [UIColor blackColor];
    self.FoodNameLabelSkin.shadowOffset = CGSizeMake(1,1);
    UILabel *foodName = [_detailItem objectAtIndex:2];
    self.FoodNameLabelSkin.text = foodName.text; //上一頁Camera參數
    
    self.FoodKcalLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 235, 180, 60)];
    [self.FoodKcalLabel setFont:[UIFont fontWithName:@"Helvetica" size:60]];
    self.FoodKcalLabel.textAlignment = NSTextAlignmentRight;
    self.FoodKcalLabel.numberOfLines = 0;
    self.FoodKcalLabel.backgroundColor = [UIColor clearColor];
    self.FoodKcalLabel.textColor = [UIColor whiteColor];
    self.FoodKcalLabel.shadowColor = [UIColor blackColor];
    self.FoodKcalLabel.shadowOffset = CGSizeMake(1,1);
    self.FoodKcalLabel.text = [NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:208] nutrientValue]];
    
    self.UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 270, 58, 15)];
    [self.UnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    self.UnitLabel.textAlignment = NSTextAlignmentLeft;
    self.UnitLabel.numberOfLines = 0;
    self.UnitLabel.backgroundColor = [UIColor clearColor];
    self.UnitLabel.textColor = [UIColor whiteColor];
    self.UnitLabel.shadowColor = [UIColor blackColor];
    self.UnitLabel.shadowOffset = CGSizeMake(1,1);
    self.UnitLabel.text = @"Kcal";
    
    
    
    UILabel *carbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 77, 58, 15)];
    [carbsLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    carbsLabel.textAlignment = NSTextAlignmentLeft;
    carbsLabel.numberOfLines = 0;
    carbsLabel.backgroundColor = [UIColor clearColor];
    carbsLabel.textColor = [UIColor whiteColor];
    carbsLabel.shadowColor = [UIColor blackColor];
    carbsLabel.shadowOffset = CGSizeMake(1,1);
    carbsLabel.text = @"Carbs";
    
    UILabel *carbsUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 40, 48, 20)];
    [carbsUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    carbsUnitLabel.textAlignment = NSTextAlignmentRight;
    carbsUnitLabel.numberOfLines = 0;
    carbsUnitLabel.backgroundColor = [UIColor clearColor];
    carbsUnitLabel.textColor = [UIColor whiteColor];
    carbsUnitLabel.shadowColor = [UIColor blackColor];
    carbsUnitLabel.shadowOffset = CGSizeMake(1,1);
    carbsUnitLabel.text = [NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:205] nutrientValue]];//上一頁Camera參數
    
    UILabel *carbsUnit = [[UILabel alloc] initWithFrame:CGRectMake(62, 37, 15, 20)];
    [carbsUnit setFont:[UIFont fontWithName:@"Helvetica" size:10.5]];
    carbsUnit.textAlignment = NSTextAlignmentLeft;
    carbsUnit.numberOfLines = 0;
    carbsUnit.backgroundColor = [UIColor clearColor];
    carbsUnit.textColor = [UIColor whiteColor];
    carbsUnit.shadowColor = [UIColor blackColor];
    carbsUnit.shadowOffset = CGSizeMake(1,1);
    carbsUnit.text = @"g";
    
    
    
    UILabel *saltLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 172, 58, 15)];
    [saltLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    saltLabel.textAlignment = NSTextAlignmentLeft;
    saltLabel.numberOfLines = 0;
    saltLabel.backgroundColor = [UIColor clearColor];
    saltLabel.textColor = [UIColor whiteColor];
    saltLabel.shadowColor = [UIColor blackColor];
    saltLabel.shadowOffset = CGSizeMake(1,1);
    saltLabel.text = @"Salt";
    
    UILabel *saltUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 135, 48, 20)];
    [saltUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    saltUnitLabel.textAlignment = NSTextAlignmentRight;
    saltUnitLabel.numberOfLines = 0;
    saltUnitLabel.backgroundColor = [UIColor clearColor];
    saltUnitLabel.textColor = [UIColor whiteColor];
    saltUnitLabel.shadowColor = [UIColor blackColor];
    saltUnitLabel.shadowOffset = CGSizeMake(1,1);
    Meal *currentMeal=    [OmniTool getCurrentMeal];
    if ([[[currentMeal mealOverview] getNutrientWithInt:307] nutrientValue]<100.0) {
        saltUnitLabel.text = @"0";
    }else{
        saltUnitLabel.text = [NSString stringWithFormat:@"%.1f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:307] nutrientValue]/1000];//上一頁Camera參數
    }
    
    
    
    UILabel *saltUnit = [[UILabel alloc] initWithFrame:CGRectMake(62, 132, 15, 20)];
    [saltUnit setFont:[UIFont fontWithName:@"Helvetica" size:10.5]];
    saltUnit.textAlignment = NSTextAlignmentLeft;
    saltUnit.numberOfLines = 0;
    saltUnit.backgroundColor = [UIColor clearColor];
    saltUnit.textColor = [UIColor whiteColor];
    saltUnit.shadowColor = [UIColor blackColor];
    saltUnit.shadowOffset = CGSizeMake(1,1);
    saltUnit.text = @"g";
    
    
    
    UILabel *fatLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 268, 58, 15)];
    [fatLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    fatLabel.textAlignment = NSTextAlignmentLeft;
    fatLabel.numberOfLines = 0;
    fatLabel.backgroundColor = [UIColor clearColor];
    fatLabel.textColor = [UIColor whiteColor];
    fatLabel.shadowColor = [UIColor blackColor];
    fatLabel.shadowOffset = CGSizeMake(1,1);
    fatLabel.text = @"Fat";
    
    UILabel *fatUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 230, 48, 20)];
    [fatUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    fatUnitLabel.textAlignment = NSTextAlignmentRight;
    fatUnitLabel.numberOfLines = 0;
    fatUnitLabel.backgroundColor = [UIColor clearColor];
    fatUnitLabel.textColor = [UIColor whiteColor];
    fatUnitLabel.shadowColor = [UIColor blackColor];
    fatUnitLabel.shadowOffset = CGSizeMake(1,1);
    fatUnitLabel.text = [NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:204] nutrientValue]];//上一頁Camera參數
    
    UILabel *fatUnit = [[UILabel alloc] initWithFrame:CGRectMake(62, 227, 15, 20)];
    [fatUnit setFont:[UIFont fontWithName:@"Helvetica" size:10.5]];
    fatUnit.textAlignment = NSTextAlignmentLeft;
    fatUnit.numberOfLines = 0;
    fatUnit.backgroundColor = [UIColor clearColor];
    fatUnit.textColor = [UIColor whiteColor];
    fatUnit.shadowColor = [UIColor blackColor];
    fatUnit.shadowOffset = CGSizeMake(1,1);
    fatUnit.text = @"g";
    
    [_watermarkScroll addSubview:self.skinShadowImage];
    [_watermarkScroll addSubview:self.FoodNameLabelSkin];
    [_watermarkScroll addSubview:self.FoodKcalLabel];
    [_watermarkScroll addSubview:self.UnitLabel];
    [_watermarkScroll addSubview:self.circleDrawer0];
    [_watermarkScroll addSubview:self.circleDrawer1];
    [_watermarkScroll addSubview:self.circleDrawer2];
    [_watermarkScroll addSubview:carbsLabel];
    [_watermarkScroll addSubview:saltLabel];
    [_watermarkScroll addSubview:fatLabel];
    [_watermarkScroll addSubview:carbsUnitLabel];
    [_watermarkScroll addSubview:saltUnitLabel];
    [_watermarkScroll addSubview:fatUnitLabel];
    [_watermarkScroll addSubview:carbsUnit];
    [_watermarkScroll addSubview:saltUnit];
    [_watermarkScroll addSubview:fatUnit];
    
    UIImageView *imageView = [_detailItem objectAtIndex:0];
    
    if (!imageView.image) {
        // do nothing.
    }else{
        [self.foodImageView.layer addSublayer:_watermarkScroll.layer];
    }
    
    
    self.ingredientsTable.hidden = YES;
    self.ingredientsView.hidden = YES;
    self.ingredientsTable.delegate = self;
    self.detailTable.hidden = NO;
    self.detailView.hidden = NO;
    self.detailTable.delegate = self;
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
// detailTable.tag = 102
// ingredientsTable.tag = 103
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //detail 有33個， ingredients 則根據meal數量
    if (tableView.tag == 102) {
//        NSLog(@" 1x");
        return 33;
    }else{
//        NSLog(@" 2x");
        Meal *currentMeal=    [OmniTool getCurrentMeal];
        return [currentMeal countOfIngredients];
    }
}

// set height for the header
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 102) {
        return 35;
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 102) {
        return 57.0f;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 102) {
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
    
    if (tableView.tag == 102) {
        static NSString *CellIdentifier = @"foodViewCell";
        CustomDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        //直立的坐標
        CGSize _VauleViewSize = CGSizeMake(200, 14);
        if(UIInterfaceOrientationIsLandscape(orientation)){
            //橫擺的坐標
            _VauleViewSize = CGSizeMake(200, 14);
        }
        
        [self updateBoxForCell:cell AndIndexPath:indexPath AndSize:_VauleViewSize AndOverView:self.overViewFood];
        return cell;
    }else if (tableView.tag == 103){
        
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
        
        Meal *currentMeal=    [OmniTool getCurrentMeal];
        Ingredient *ingredient;
        ingredient = [currentMeal getIngredientAtIndex:(unsigned int)indexPath.row];
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
