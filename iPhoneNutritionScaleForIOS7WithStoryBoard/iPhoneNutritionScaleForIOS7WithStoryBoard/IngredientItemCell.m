//
//  IngredientItemCell.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by Orange Chang on 13/9/29.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "IngredientItemCell.h"

@implementation IngredientItemCell
@synthesize weightLabel;
@synthesize descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
