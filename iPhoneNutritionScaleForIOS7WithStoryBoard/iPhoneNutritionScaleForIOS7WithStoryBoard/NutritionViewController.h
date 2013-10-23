//
//  NutritionViewController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
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

@class NutritionViewController;
@protocol NutritionViewControllerDelegate <NSObject>

//當按下Enter Search後執行。
- (void)NutritionViewController:(NutritionViewController *)searchView didSelectFood:(Food *)food;
@end

@interface NutritionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,MinnaNotificationProtocol>{
    
}
@property (nonatomic, weak) id <NutritionViewControllerDelegate> delegate;
// Dictionary of auto-completion options (check constants above)
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic) bool cellSelected;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;

- (IBAction)closeFoodSearch:(id)sender;


@end
