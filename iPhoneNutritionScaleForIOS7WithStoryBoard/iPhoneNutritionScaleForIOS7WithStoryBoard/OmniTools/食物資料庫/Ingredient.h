//
//  Ingredient.h
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

// Meal is composed by a group of Ingredient
// Ingredient = Food + Weight

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject
{
    NSNumber *foodNumber;
    float weight;
    Food *food;
    BOOL isWeightSaved;
}
@property (strong, nonatomic) NSNumber *foodNumber;
@property (strong, nonatomic) Food *food;
@property float weight;
@property BOOL  isWeightSaved;
@property BOOL  isAddIngredient;

-(Ingredient *) initializeWithFood:(Food *)foodObject withWeight:(float) weightInGram;
-(void) setSaved:(BOOL)isSaved;
-(void) setAddIngredient:(BOOL)isAdded;
-(void) printInfo;
@end
