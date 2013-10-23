//
//  FoodViewController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *fatLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatValueLabel;
@property (strong, nonatomic) IBOutlet UIView *fatInforGraphicView;
@property (strong, nonatomic) IBOutlet UIView *fatZero;
@property (strong, nonatomic) IBOutlet UILabel *saltLabel;
@property (strong, nonatomic) IBOutlet UILabel *saltValueLabel;
@property (strong, nonatomic) IBOutlet UIView *saltInforGraphicView;
@property (strong, nonatomic) IBOutlet UIView *saltZero;
@property (strong, nonatomic) IBOutlet UILabel *proteinLabel;
@property (strong, nonatomic) IBOutlet UILabel *proteinValueLabel;
@property (strong, nonatomic) IBOutlet UIView *proteinInforGraphicView;
@property (strong, nonatomic) IBOutlet UIView *proteinZero;
@property (strong, nonatomic) IBOutlet UILabel *carbsLabel;
@property (strong, nonatomic) IBOutlet UILabel *carbsValueLabel;
@property (strong, nonatomic) IBOutlet UIView *carbsInforGraphicView;
@property (strong, nonatomic) IBOutlet UIView *carbsZero;
@property (strong, nonatomic) IBOutlet UIImageView *caloriesTriableImage;
@property (strong, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (strong, nonatomic) IBOutlet UILabel *caloriesValueLabel;
@property (strong, nonatomic) IBOutlet UIView *caloriesInforGraphicView;
@property (strong, nonatomic) IBOutlet UIView *caloriesZero;
@property (strong, nonatomic) IBOutlet UITableView *ingredientsTable;
@property (strong, nonatomic) IBOutlet UIView *ingredientsView;
@property (strong, nonatomic) IBOutlet UITableView *detailTable;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tableSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (strong, nonatomic) NutrientOverview *overview100; //第1筆食物數值, CapreseSalad
@property (strong, nonatomic) NutrientOverview *overview101; //第2筆食物數值, TomatoSpaghetti
@property (strong, nonatomic) NutrientOverview *overview102; //第3筆食物數值, Chicken Vegetable Salad
@property (strong, nonatomic) NutrientOverview *overview103; //第4筆食物數值, Freshberriesicecream
@property (strong, nonatomic) IBOutlet UILabel *TotalCarloriesLabel;

@property (nonatomic) double                        sugarRatio;
@property (nonatomic) double                        otherRatio;
@property (nonatomic) double                        sodiumRatio;
@property (nonatomic) double                        fatRatio;
@property (nonatomic) double                        energyRatio;
@property (nonatomic, strong) FoodOverview          *overViewFood;
@property (nonatomic, strong) NSMutableArray        *getArray;


- (IBAction)changeTabelViewPressed:(id)sender;

@end
