//
//  FoodNutrientDayLog.m
//  iPadNutritionScaleWithStoryBoard
//
//  Created by Orange Chang on 13/7/5.
//  Copyright (c) 2013年 Snowrex. All rights reserved.
//

#import "FoodNutrientDayLog.h"

@implementation FoodNutrientDayLog
@synthesize	sumFoodNutrientArray;
@synthesize	dateString;
@synthesize	weekDay;
@synthesize foodOverview;
@synthesize	year;
@synthesize	month;
@synthesize day;

-(NSString *)getWeekDayString
{
	switch(weekDay){
		case WEEK_DAY_MONDAY		:
			return @"Monday";
				break;
		case WEEK_DAY_TUESDAY		:
			return @"Tuesday";
				break;
		case WEEK_DAY_WEDNESDAY	:
			return @"Wednesday";
				break;
		case WEEK_DAY_THURSDAY	:
			return @"Thursday";
				break;
		case WEEK_DAY_FRIDAY		:
			return @"Friday";
				break;
		case WEEK_DAY_SATURDAY	:
			return @"Saturday";
				break;
		case WEEK_DAY_SUNDAY    :
			return @"Sunday";
				break;
	}
}
-(void) printInfo
{
	NSLog(@"********** FoodNutrientDayLog ********************************");
	NSLog(@"	week day=%@(%d).",[self getWeekDayString],weekDay);
	if(dateString)
		NSLog(@"	Date    =%@.",dateString);
	else
		NSLog(@"	Date string is NOT set!");
		
	NSLog(@"    Nutrient list :");
	if(sumFoodNutrientArray){
		if(sumFoodNutrientArray.count==0){
			NSLog(@"	Nutrient array is EMPTY!");
		}else{
			for(FoodNutrient *f in sumFoodNutrientArray){
				[f printInfo];
			}
		}
	}else{
			NSLog(@"	Nutrient array is NOT initialized!");
	}
}
-(void) printShortInfo
{
	NSLog(@"********** FoodNutrientDayLog ********************************");
	NSLog(@"	week day=%@(%d).",[self getWeekDayString],weekDay);
	if(dateString)
		NSLog(@"	Date    =%@.",dateString);
	else
		NSLog(@"	Date string is NOT set!");
		
	if(sumFoodNutrientArray){
		if(sumFoodNutrientArray.count==0)
			NSLog(@"	Nutrient array is EMPTY!");
		else{
			NSLog(@"    First nutrient information:");
			FoodNutrient *f=[sumFoodNutrientArray objectAtIndex:0];
			[f printInfo];
		}
	}else{
			NSLog(@"	Nutrient array is NOT initialized!");
	}
}
-(void) printDateInfo
{
	NSLog(@"********** FoodNutrientDayLog ********************************");
	NSLog(@"	week day=%@(%d).",[self getWeekDayString],weekDay);
	if(dateString)
		NSLog(@"	Date    =%@.",dateString);
	else
		NSLog(@"	Date string is NOT set!");
		
	if(sumFoodNutrientArray){
		if(sumFoodNutrientArray.count==0)
			NSLog(@"	Nutrient array is EMPTY!");
		else{
			NSLog(@"    Nutrient array size=%lu",(unsigned long)[sumFoodNutrientArray count]);
		}
	}else{
			NSLog(@"	Nutrient array is NOT initialized!");
	}
}
- (id) init
{
	if (self = [super init])
	{
		sumFoodNutrientArray=[[NSMutableArray alloc]init];
	}
	return self;
}
@end
