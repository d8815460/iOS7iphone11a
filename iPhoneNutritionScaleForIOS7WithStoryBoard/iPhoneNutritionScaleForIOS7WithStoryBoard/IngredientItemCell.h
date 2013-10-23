//
//  IngredientItemCell.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by Orange Chang on 13/9/29.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightUnitLabel;

@end
