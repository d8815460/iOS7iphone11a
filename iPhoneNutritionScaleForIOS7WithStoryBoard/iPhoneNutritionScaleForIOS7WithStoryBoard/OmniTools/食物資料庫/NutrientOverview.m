//
//  NutrientOverview.m
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//
// NutrientOverview is used to manage a group of Nutrient
#import "NutrientOverview.h"

@implementation NutrientOverview
@synthesize nutrientDictionary;

-(Nutrient *) getNutrientWithInt:(int)nutrientNumber
{
    return [self getNutrient:[[NSNumber alloc] initWithInt:nutrientNumber]];
}
-(Nutrient *) getNutrient:(NSNumber *)nutrientNumber
{
	return [nutrientDictionary objectForKey:nutrientNumber];
}
-(void) printInfo
{
    NSLog(@"--------------- NutrientOverview Info --------------------");
    if(nutrientDictionary.count <1)
        NSLog(@"     NutrientOverview is Empty!    ");
    for( NSNumber *nutrientNumber in nutrientDictionary)
    {
        Nutrient *n =[self getNutrient:nutrientNumber];
        [n printInfo];
    }
    NSLog(@"Done --------------- NutrientOverview Info --------------------");
}

@end
