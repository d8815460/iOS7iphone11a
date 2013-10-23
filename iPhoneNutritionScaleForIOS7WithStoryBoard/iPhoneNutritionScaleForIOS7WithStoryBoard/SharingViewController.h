//
//  SharingViewController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleDrawer.h"
#import "ImageCropperView.h"

@class TPKeyboardAvoidingScrollView;

@class SharingViewController;

@protocol SharingViewControllerDelegate <NSObject>

- (void) SharingViewControllerDidShare:(SharingViewController*)controller Aboutmessange:(NSString *)string;

@end

@interface SharingViewController : UIViewController <UITextViewDelegate, PFLogInViewControllerDelegate,MinnaNotificationProtocol>{
}
@property (strong, nonatomic) id detailItem;
@property (nonatomic, weak)   id <SharingViewControllerDelegate>delegate;
@property (nonatomic, strong) UIScrollView      *watermarkScroll;
@property (strong, nonatomic) UIImageView       *skinShadowImage;
@property (strong, nonatomic) UILabel           *FoodNameLabel;
@property (strong, nonatomic) UILabel           *FoodKcalLabel;
@property (strong, nonatomic) UILabel           *UnitLabel;
@property (strong, nonatomic) CircleDrawer      *circleDrawer0;
@property (strong, nonatomic) CircleDrawer      *circleDrawer1;
@property (strong, nonatomic) CircleDrawer      *circleDrawer2;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyboardScroll;
@property (strong, nonatomic) IBOutlet UIView *TextViewBackground;
@property (strong, nonatomic) IBOutlet UIImageView *cameraView;
@property (strong, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet ImageCropperView *cropper;
@property (strong, nonatomic) IBOutlet UIButton *FBButton;
@property (strong, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, strong) MinnaMessageView *messageView;    // minna in-APP notification
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *textCountLabel;

@property (strong, nonatomic) UIImage *finalImage;

- (IBAction)facebookSwitchPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
@end
