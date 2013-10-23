//
//  SettingsViewController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingItem.h"
#import "BLEUIProtocol.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BLEUIProtocol, PFLogInViewControllerDelegate>{
    int selectedCell;
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (nonatomic, readwrite) int selectedCell;
@property (nonatomic, strong) NSMutableArray *settingItemArray;
@property (nonatomic, strong) NSArray *aboutItem;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) UIImageView *FBiconview;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;

- (IBAction)closeButtonPressed:(id)sender;
- (void) facebookButtonLoginPressed:(id)sender;

@end
