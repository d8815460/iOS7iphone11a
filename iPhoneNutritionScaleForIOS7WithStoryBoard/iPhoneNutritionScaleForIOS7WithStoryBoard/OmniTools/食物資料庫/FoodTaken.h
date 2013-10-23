//
//  FoodTaken.h
//  iPadNutritionScaleWithStoryBoard
//
//  Created by Orange Chang on 13/7/15.
//  Copyright (c) 2013年 Snowrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
@interface FoodTaken : NSObject
{
	Food *food;
	double foodWeightGram;
	double foodCalaries;
	CFAbsoluteTime takeTime;
}
@property(nonatomic,retain) Food *food;
@property double foodWeightGram;
@property double foodCalaries;
@property CFAbsoluteTime takeTime;


-(void) printInfo;	// debug usage function

@end
