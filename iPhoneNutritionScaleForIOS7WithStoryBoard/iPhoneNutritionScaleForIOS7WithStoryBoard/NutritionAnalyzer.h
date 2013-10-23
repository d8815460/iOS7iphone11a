//
//  NutritionAnalyzer.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "CustomDetailCell.h"
#import "TLTiltSlider.h"
#import "ManualWeightInputView.h"
#import "ConnectScaleWeightView.h"
#import "BLEUIProtocol.h"

@interface NutritionAnalyzer : UIViewController<UITableViewDelegate, UITableViewDataSource, BLEUIProtocol>
{
}
@property (nonatomic) double                            currentWeight;
@property (nonatomic, strong) FoodOverview              *overViewFood;
@property (strong, nonatomic) NSNumber                  *foodNumber;

@property (strong, nonatomic) IBOutlet UILabel *foodTitle;
@property (strong, nonatomic) IBOutlet UILabel *foodDescription;
@property (strong, nonatomic) IBOutlet UITableView *nutrientTable;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftCancelButton;
@property (nonatomic) double didntSaveIngredientWeight;
@property (nonatomic) double didConnectScaleWeight;
@property (nonatomic) BOOL   isSave;

// Manual input weight
@property (strong, nonatomic) IBOutlet ManualWeightInputView *manualInputView;

// Weight input by scale connection
@property (strong, nonatomic) IBOutlet ConnectScaleWeightView *scaleInputView;

// iPhoneScaleContentView is used to contain manualInputView and scaleInputView for animation
@property (strong, nonatomic) IBOutlet UIView *iPhoneScaleContentView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *EditAndSaveButton;

- (IBAction)iPhoneSliderValueChanged:(id)sender;
- (IBAction)changeToBuletoothScale:(id)sender;
- (IBAction)changeToInputWeightScale:(id)sender;

- (IBAction)clickUnitButton:(id)sender;
- (IBAction)EditAndSaveModeAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@end
