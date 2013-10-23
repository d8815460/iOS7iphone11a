//
//  Meal.h
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

// Meal is composed by a group of Ingredient
// Ingredient = Food + Weight

#import <Foundation/Foundation.h>
#import "Ingredient.h"
#import "NutrientOverview.h"
@interface Meal : NSObject
{
    NSMutableDictionary *ingredientDictionary;
    NutrientOverview *mealOverview;
}
// Mapping: foodNumber -> Ingredient
@property (strong, nonatomic) NSMutableDictionary *ingredientDictionary;
@property (strong, nonatomic) NutrientOverview *mealOverview;

-(NutrientOverview *)getNutrientOverviewForUserType:(int) userType;

-(NutrientOverview *)calculateOverviewWithUserType:(int) userType;
-(void) addIngredient:(Ingredient *) ingredient;
-(void) removeIngredient:(Ingredient *) ingredient;
-(Meal *) initialize;
-(void) printInfo;
-(BOOL) containsFood:(Food *)food;
-(unsigned int) countOfIngredients;
-(Ingredient *) getIngredientAtIndex:(unsigned int) ingredientIndex;
-(float) getKcal;

@end
