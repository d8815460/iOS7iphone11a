//
//  CustomDetailCell.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellNutrientTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *cellNutrientVauleView;
@property (strong, nonatomic) IBOutlet UILabel *cellNutrientVauleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellNutrientVauleRadioLabel;
@end
