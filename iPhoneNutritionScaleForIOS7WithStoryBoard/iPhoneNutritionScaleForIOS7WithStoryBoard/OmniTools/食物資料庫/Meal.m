//
//  Meal.m
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import "Meal.h"

@implementation Meal
@synthesize ingredientDictionary;
@synthesize mealOverview;

-(Meal *) initialize
{
    ingredientDictionary=[[NSMutableDictionary alloc] init];
    return self;
}
-(void) addIngredient:(Ingredient *) ingredient
{
    if(!ingredientDictionary)
        ingredientDictionary=[[NSMutableDictionary alloc] init];
    [ingredientDictionary setObject:ingredient forKey:[ingredient foodNumber]];
}
-(void) removeIngredient:(Ingredient *) ingredient
{
    
    if([ingredientDictionary count] > 0){
        [ingredientDictionary removeObjectForKey:[ingredient foodNumber]];
    }else if ([ingredientDictionary count]==1){
        [ingredientDictionary removeAllObjects];
    }
    
    // NSLog(@"%lu , %@", (unsigned long)[ingredientDictionary count], ingredientDictionary);
}

-(NutrientOverview *)getNutrientOverviewForUserType:(int) userType
{
    // TODO: Since the calculateOverviewWithUserType might takes sometime, it might worth to do a cache here.
//	if(mealOverview)
//		return mealOverview;
//	else
		return [self calculateOverviewWithUserType:(int) userType];
}

-(NutrientOverview *)calculateOverviewWithUserType:(int) userType
{
	mealOverview=[NutrientOverview alloc];
    if(!ingredientDictionary)
        ingredientDictionary=[[NSMutableDictionary alloc] init];
	
    // accumulate nutrition value
	for (NSNumber * key in ingredientDictionary) {
	    Ingredient *ingredient = [ingredientDictionary objectForKey:key];
	    if(!ingredient){
	    	NSLog(@"Error: calculateMealOverviewWithUserType found null Ingredient");
	    	continue;
	    }
	    FoodOverview *overviewForTheIngredient=[OmniTool getFoodOverview:[ingredient foodNumber] forUserType:userType weight:[ingredient weight]];
	    [OmniTool addNutrientOverview:mealOverview FromFoodOverview:overviewForTheIngredient];
	}
	return mealOverview;
}
-(BOOL) containsFood:(Food *)food
{
    if(!ingredientDictionary)   return NO;
    NSNumber *foodNumber = [food foodNumber];
    Ingredient *ingredient =[ingredientDictionary objectForKey:foodNumber];
    if(ingredient)
        return YES;
    else
        return NO;
}
-(unsigned int) countOfIngredients
{
    return (unsigned int) [ingredientDictionary count];
}
-(void) printInfo
{
    NSLog(@"**** Meal Info ****");
    if(!ingredientDictionary)
    {
        NSLog(@"Meal is not initialized yet");
        return;
    }
	for (NSNumber * key in ingredientDictionary) {
	    Ingredient *ingredient = [ingredientDictionary objectForKey:key];
	    if(!ingredient){
	    	NSLog(@"Error: calculateMealOverviewWithUserType found null Ingredient");
	    	continue;
	    }
        [ingredient printInfo];
    }
}
-(Ingredient *) getIngredientAtIndex:(unsigned int) ingredientIndex
{
	NSArray *allIngredient=[ingredientDictionary allValues];
	return (Ingredient *) [allIngredient objectAtIndex:ingredientIndex];
}



-(float) getKcal
{
	float kcal=0;
	Nutrient *nutrient = [self getNutrientWithNumber:NUTRIENT_ENERGYKCAL];
	if(nutrient){
		kcal=nutrient.nutrientValue;
    }else{
        // NSLog(@"Nutrient KCAL not found");
    }
	return kcal;
}

-(Nutrient *) getNutrientWithNumber:(int) nutrientNumber
{
	NutrientOverview *overview=[self getNutrientOverviewForUserType:1];
	if(!overview){
        NSLog(@"ERROR , getNutrientWithNumber:  overview is null.");
        return nil;
    }

	NSNumber *energyNumber=[[NSNumber alloc] initWithInt:nutrientNumber];

	return [overview getNutrient:energyNumber];
}
@end
