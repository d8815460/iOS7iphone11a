//
//  FoodTaken.m
//  iPadNutritionScaleWithStoryBoard
//
//  Created by Orange Chang on 13/7/15.
//  Copyright (c) 2013年 Snowrex. All rights reserved.
//

#import "FoodTaken.h"

@implementation FoodTaken
@synthesize food;
@synthesize foodWeightGram;
@synthesize foodCalaries;
@synthesize takeTime;


-(void) printInfo
{
	NSLog(@"======== FoodTaken ========");
	[food printFoodInfo];
	NSLog(@"**** foodWeightGram =%.4f",foodWeightGram      );
	NSLog(@"**** foodCalaries  	=%.4f",foodCalaries);
	NSLog(@"**** takeTime		=%@",[OmniTool timerToString:takeTime]);

}
@end
