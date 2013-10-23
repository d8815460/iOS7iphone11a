//
//  IngredientController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "NutritionAnalyzer.h"
// Consts for AutoCompleteOptions:
//
// if YES - suggestions will be picked for display case-sensitive
// if NO - case will be ignored
#define ACOCaseSensitive @"ACOCaseSensitive"

// if "nil" each cell will copy the font of the source UITextField
// if not "nil" given UIFont will be used
#define ACOUseSourceFont @"ACOUseSourceFont"

// if YES substrings in cells will be highlighted with bold as user types in
// *** FOR FUTURE USE ***
#define ACOHighlightSubstrWithBold @"ACOHighlightSubstrWithBold"

// if YES - suggestions view will be on top of the source UITextField
// if NO - it will be on the bottom
// *** FOR FUTURE USE ***
#define ACOShowSuggestionsOnTop @"ACOShowSuggestionsOnTop"



@interface IngredientController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

// Dictionary of auto-completion options (check constants above)
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic) bool cellSelected;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *itemTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong, nonatomic) IBOutlet UIView *ingredientView;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong,nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong ,nonatomic) IBOutlet UILabel *kcalLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodAddedLabel;

- (IBAction)segmentedControlIndexChanged:(id)sender;
- (IBAction)addFoodAsIngredient:(id)sender;
@end
