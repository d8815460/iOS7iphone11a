//
//  ReportViewController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/10/4.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleDrawer.h"

@interface ReportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
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
@property (strong, nonatomic) IBOutlet UITableView *detailTable;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *ingredientsView;
@property (strong, nonatomic) IBOutlet UITableView *ingredientsTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tableSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (nonatomic, strong) UIScrollView      *watermarkScroll;
@property (strong, nonatomic) UIImageView       *skinShadowImage;
@property (strong, nonatomic) UILabel           *FoodNameLabelSkin;
@property (strong, nonatomic) UILabel           *FoodKcalLabel;
@property (strong, nonatomic) UILabel           *UnitLabel;
@property (strong, nonatomic) CircleDrawer      *circleDrawer0;
@property (strong, nonatomic) CircleDrawer      *circleDrawer1;
@property (strong, nonatomic) CircleDrawer      *circleDrawer2;

@property (strong, nonatomic) IBOutlet UILabel *TotalCarloriesLabel;

@property (nonatomic, strong) NutrientOverview *overViewFood;
//@property (strong, nonatomic) Meal *meal;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;

- (IBAction)changeTabelViewPressed:(id)sender;

@end
