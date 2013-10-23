//
//  FoodNutrientDayLog.h
//  iPadNutritionScaleWithStoryBoard
//
//  Created by Orange Chang on 13/7/5.
//  Copyright (c) 2013年 Snowrex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodOverview.h"
#import "OmniVar.h"
@interface FoodNutrientDayLog : NSObject
{
    NSMutableArray * sumFoodNutrientArray;
    WEEK_DAY weekDay;
    NSString *dateString;	// like @"7/4"
    FoodOverview *foodOverview;
    int year;
    int month;
    int day;
}
@property(nonatomic,copy)	NSMutableArray *sumFoodNutrientArray;
@property(nonatomic,copy)	NSString *dateString;
@property(nonatomic,retain)	FoodOverview *foodOverview;
@property	WEEK_DAY weekDay;
@property	int year;
@property	int month;
@property	int day;


-(NSString *)getWeekDayString;	// returns like "Monday", etc

-(void) printInfo;
-(void) printShortInfo;
-(void) printDateInfo;

@end
