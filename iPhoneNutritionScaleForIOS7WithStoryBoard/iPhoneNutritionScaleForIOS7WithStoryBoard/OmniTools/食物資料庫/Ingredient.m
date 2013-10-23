//
//  Ingredient.m
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient
@synthesize foodNumber;
@synthesize weight;
@synthesize food;
@synthesize isWeightSaved;
@synthesize isAddIngredient;

-(Ingredient *) initializeWithFood:(Food *)foodObject withWeight:(float) weightInGram
{
    self.isWeightSaved = NO;
    if(foodObject){
        food=foodObject;
        foodNumber=[food foodNumber];
    }else{
        NSLog(@"ERROR: initialize Ingredient with empty Food");
    }
    weight=weightInGram;
    return self;
}

-(void) setSaved:(BOOL)isSaved{
    self.isWeightSaved = isSaved;
}

-(void) setAddIngredient:(BOOL)isAdded{
    self.isAddIngredient = isAdded;
}

-(void) printInfo
{
    NSLog(@".Ingredient number=%d, weight=%.0f, description=%@",[foodNumber intValue],weight,[food longDescription]);
}
@end
