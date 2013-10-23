//
//  CameraViewController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CircleDrawer.h"
#import "GKImagePicker.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, GKImagePickerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *getImageView;
@property (strong, nonatomic) IBOutlet UIView  *cameraView;
@property (strong, nonatomic) IBOutlet UIButton *positionButton;
@property (strong, nonatomic) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) IBOutlet UIButton *albumButton;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *reportButton;
@property (strong, nonatomic) IBOutlet UIButton *ingredientsButton;
@property (strong, nonatomic) IBOutlet UIView *keyboardCoView;
@property (strong, nonatomic) UIImageView       *skinShadowImage;
@property (strong, nonatomic) UILabel           *FoodNameLabel;
@property (strong, nonatomic) UILabel           *FoodKcalLabel;
@property (strong, nonatomic) UILabel           *UnitLabel;
@property (strong, nonatomic) UILabel           *carbsLabel;
@property (strong, nonatomic) UILabel           *carbsUnitLabel;
@property (strong, nonatomic) UILabel           *carbsUnit;
@property (strong, nonatomic) UILabel           *saltLabel;
@property (strong, nonatomic) UILabel           *saltUnitLabel;
@property (strong, nonatomic) UILabel           *saltUnit;
@property (strong, nonatomic) UILabel           *fatLabel;
@property (strong, nonatomic) UILabel           *fatUnitLabel;
@property (strong, nonatomic) UILabel           *fatUnit;
@property (strong, nonatomic) UIImageView       *skinShadowImage2;
@property (strong, nonatomic) UILabel           *FoodNameLabel2;
@property (strong, nonatomic) UILabel           *FoodKcalLabel2;
@property (strong, nonatomic) UILabel           *UnitLabel2;
@property (strong, nonatomic) UILabel           *carbsLabel2;
@property (strong, nonatomic) UILabel           *carbsUnitLabel2;
@property (strong, nonatomic) UILabel           *carbsUnit2;
@property (strong, nonatomic) UILabel           *saltLabel2;
@property (strong, nonatomic) UILabel           *saltUnitLabel2;
@property (strong, nonatomic) UILabel           *saltUnit2;
@property (strong, nonatomic) UILabel           *fatLabel2;
@property (strong, nonatomic) UILabel           *fatUnitLabel2;
@property (strong, nonatomic) UILabel           *fatUnit2;
@property (strong, nonatomic) CircleDrawer      *circleDrawer0;
@property (strong, nonatomic) CircleDrawer      *circleDrawer1;
@property (strong, nonatomic) CircleDrawer      *circleDrawer2;
@property (strong, nonatomic) CircleDrawer      *circleDrawer02;
@property (strong, nonatomic) CircleDrawer      *circleDrawer12;
@property (strong, nonatomic) CircleDrawer      *circleDrawer22;
@property (nonatomic, strong) UIScrollView *watermarkScroll;
@property (nonatomic, strong) UIScrollView *watermarkScroll2;
@property (nonatomic, strong) UIView       *waterView;
@property (strong, nonatomic) IBOutlet UIImageView *teachImage;
@property (strong, nonatomic) IBOutlet UITextField *foodNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) Meal *meal;
@property (nonatomic, assign) BOOL resizableCropArea;
@property (nonatomic, assign) BOOL isAlbum;
@property (strong, nonatomic) IBOutlet UIButton *disappearKeyboardButton;
- (IBAction)disappearKeyboard:(id)sender;

- (IBAction)changeFlash:(id)sender;
- (IBAction)positionChange:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)albumButtonPressed:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)closeBtnAction:(id)sender;
- (IBAction)teachBtnAction:(id)sender;
- (IBAction)editFoodNameAction:(id)sender;
- (IBAction)clearFoodNameAction:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)reportButtonPressed:(id)sender;
- (IBAction)keyboardDoneButtonPressed:(id)sender;
- (IBAction)addIngredents:(id)sender;

@end
