//
//  ManualWeightInputView.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTiltSlider.h"

@interface ManualWeightInputView : UIView

@property (nonatomic, strong) IBOutlet TLTiltSlider *iWeightSlider;
@property (nonatomic, strong) IBOutlet UILabel *iWeightLabel;
@property (nonatomic, strong) IBOutlet UIButton *iUnitButton;
@property (nonatomic, strong) IBOutlet UIButton *changeWeightInputBtn;
@end
