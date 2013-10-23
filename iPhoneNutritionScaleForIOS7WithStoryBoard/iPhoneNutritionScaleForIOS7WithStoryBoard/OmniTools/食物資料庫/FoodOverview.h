//
//  FoodOverview.h
//  KitchenScale
//
//  Created by Orange on 13/5/27.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodNutrient.h"
@interface FoodOverview : NSObject
{
	double energyRatio;
	double fatRatio;
	double sugarRatio;
	double sodiumRatio;
	double otherRatio;

	FoodNutrient *nutrientCaffeine;
	FoodNutrient *nutrientCalcium;
	FoodNutrient *nutrientCarbohydrate;
	FoodNutrient *nutrientCholesterol;
	FoodNutrient *nutrientCholine;
	FoodNutrient *nutrientCopper;
	FoodNutrient *nutrientEnergyKcal;
	FoodNutrient *nutrientFiber;
	FoodNutrient *nutrientFluoride;
	FoodNutrient *nutrientFolate;
	FoodNutrient *nutrientIron;
	FoodNutrient *nutrientMagnesium;
	FoodNutrient *nutrientManganese;
	FoodNutrient *nutrientNiacin;
	FoodNutrient *nutrientPantothenicacid;
	FoodNutrient *nutrientPhosphorus;
	FoodNutrient *nutrientPotassium;
	FoodNutrient *nutrientProtein;
	FoodNutrient *nutrientRiboflavin;
	FoodNutrient *nutrientSelenium;
	FoodNutrient *nutrientSodium;
	FoodNutrient *nutrientSugars;
	FoodNutrient *nutrientThiamin;
	FoodNutrient *nutrientTotallipid;
	FoodNutrient *nutrientVitaminA;
	FoodNutrient *nutrientVitaminB12;
	FoodNutrient *nutrientVitaminB6;
	FoodNutrient *nutrientVitaminC;
	FoodNutrient *nutrientVitaminD;
	FoodNutrient *nutrientVitaminE;
	FoodNutrient *nutrientVitaminK;
	FoodNutrient *nutrientWater;
	FoodNutrient *nutrientZinc;	
}
@property(nonatomic,retain) 	FoodNutrient *nutrientCaffeine;
@property(nonatomic,retain) 	FoodNutrient *nutrientCalcium;
@property(nonatomic,retain) 	FoodNutrient *nutrientCarbohydrate;
@property(nonatomic,retain) 	FoodNutrient *nutrientCholesterol;
@property(nonatomic,retain) 	FoodNutrient *nutrientCholine;
@property(nonatomic,retain) 	FoodNutrient *nutrientCopper;
@property(nonatomic,retain) 	FoodNutrient *nutrientEnergyKcal;
@property(nonatomic,retain) 	FoodNutrient *nutrientFiber;
@property(nonatomic,retain) 	FoodNutrient *nutrientFluoride;
@property(nonatomic,retain) 	FoodNutrient *nutrientFolate;
@property(nonatomic,retain) 	FoodNutrient *nutrientIron;
@property(nonatomic,retain) 	FoodNutrient *nutrientMagnesium;
@property(nonatomic,retain) 	FoodNutrient *nutrientManganese;
@property(nonatomic,retain) 	FoodNutrient *nutrientNiacin;
@property(nonatomic,retain) 	FoodNutrient *nutrientPantothenicacid;
@property(nonatomic,retain) 	FoodNutrient *nutrientPhosphorus;
@property(nonatomic,retain) 	FoodNutrient *nutrientPotassium;
@property(nonatomic,retain) 	FoodNutrient *nutrientProtein;
@property(nonatomic,retain) 	FoodNutrient *nutrientRiboflavin;
@property(nonatomic,retain) 	FoodNutrient *nutrientSelenium;
@property(nonatomic,retain) 	FoodNutrient *nutrientSodium;
@property(nonatomic,retain) 	FoodNutrient *nutrientSugars;
@property(nonatomic,retain) 	FoodNutrient *nutrientThiamin;
@property(nonatomic,retain) 	FoodNutrient *nutrientTotallipid;
@property(nonatomic,retain) 	FoodNutrient *nutrientVitaminA;
@property(nonatomic,retain) 	FoodNutrient *nutrientVitaminB12;
@property(nonatomic,retain) 	FoodNutrient *nutrientVitaminB6;
@property(nonatomic,retain) 	FoodNutrient *nutrientVitaminC;
@property(nonatomic,retain) 	FoodNutrient *nutrientVitaminD;
@property(nonatomic,retain) 	FoodNutrient *nutrientVitaminE;
@property(nonatomic,retain) 	FoodNutrient *nutrientVitaminK;
@property(nonatomic,retain) 	FoodNutrient *nutrientWater;
@property(nonatomic,retain) 	FoodNutrient *nutrientZinc;
@property(nonatomic,retain) 	NSArray *rdaFoodNutrientArray;

@property double energyRatio;
@property	double fatRatio;
@property	double sugarRatio;
@property	double sodiumRatio;
@property	double otherRatio;

-(void) printInfo;
-(void) printRatioInfo;

@end
