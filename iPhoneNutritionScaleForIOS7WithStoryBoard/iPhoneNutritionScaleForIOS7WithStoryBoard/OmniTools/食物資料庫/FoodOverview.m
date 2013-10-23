//
//  FoodOverview.m
//  KitchenScale
//
//  Created by Orange on 13/5/27.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import "FoodOverview.h"

@implementation FoodOverview
@synthesize energyRatio;
@synthesize fatRatio;
@synthesize sugarRatio;
@synthesize sodiumRatio;
@synthesize otherRatio;

@synthesize nutrientCaffeine;
@synthesize nutrientCalcium;
@synthesize nutrientCarbohydrate;
@synthesize nutrientCholesterol;
@synthesize nutrientCholine;
@synthesize nutrientCopper;
@synthesize nutrientEnergyKcal;
@synthesize nutrientFiber;
@synthesize nutrientFluoride;
@synthesize nutrientFolate;
@synthesize nutrientIron;
@synthesize nutrientMagnesium;
@synthesize nutrientManganese;
@synthesize nutrientNiacin;
@synthesize nutrientPantothenicacid;
@synthesize nutrientPhosphorus;
@synthesize nutrientPotassium;
@synthesize nutrientProtein;
@synthesize nutrientRiboflavin;
@synthesize nutrientSelenium;
@synthesize nutrientSodium;
@synthesize nutrientSugars;
@synthesize nutrientThiamin;
@synthesize nutrientTotallipid;
@synthesize nutrientVitaminA;
@synthesize nutrientVitaminB12;
@synthesize nutrientVitaminB6;
@synthesize nutrientVitaminC;
@synthesize nutrientVitaminD;
@synthesize nutrientVitaminE;
@synthesize nutrientVitaminK;
@synthesize nutrientWater;
@synthesize nutrientZinc;
@synthesize rdaFoodNutrientArray;
-(void) printInfo
{
	NSLog(@"======== FoodOverview ========");
	NSLog(@"**** energyRatio    =%.4f",energyRatio      );
	[nutrientEnergyKcal printInfo];
	NSLog(@"**** fatRatio      	=%.4f",fatRatio);
	[nutrientTotallipid printInfo];
	NSLog(@"**** sugarRatio		=%.4f",sugarRatio);
	[nutrientSugars printInfo];
	NSLog(@"**** sodiumRatio      =%.4f",sodiumRatio         );
	[nutrientSodium printInfo];
	NSLog(@"**** otherRatio     =%.4f",otherRatio      );

	[nutrientCaffeine printInfo];
	[nutrientCalcium printInfo];
	[nutrientCarbohydrate printInfo];
	[nutrientCholesterol printInfo];
	[nutrientCholine printInfo];
	[nutrientCopper printInfo];
	[nutrientFiber printInfo];
	[nutrientFluoride printInfo];
	[nutrientFolate printInfo];
	[nutrientIron printInfo];
	[nutrientMagnesium printInfo];
	[nutrientManganese printInfo];
	[nutrientNiacin printInfo];
	[nutrientPantothenicacid printInfo];
	[nutrientPhosphorus printInfo];
	[nutrientPotassium printInfo];
	[nutrientProtein printInfo];
	[nutrientRiboflavin printInfo];
	[nutrientSelenium printInfo];
	[nutrientThiamin printInfo];
	[nutrientVitaminA printInfo];
	[nutrientVitaminB12 printInfo];
	[nutrientVitaminB6 printInfo];
	[nutrientVitaminC printInfo];
	[nutrientVitaminD printInfo];
	[nutrientVitaminE printInfo];
	[nutrientVitaminK printInfo];
	[nutrientWater printInfo];
	[nutrientZinc printInfo];
}

-(void) printRatioInfo
{
	NSLog(@"======== FoodOverview ========");
	NSLog(@"**** energyRatio    =%.4f",energyRatio      );
	NSLog(@"**** fatRatio      	=%.4f",fatRatio);
	NSLog(@"**** sugarRatio		=%.4f",sugarRatio);
	NSLog(@"**** sodiumRatio      =%.4f",sodiumRatio         );
	NSLog(@"**** otherRatio     =%.4f",otherRatio      );
}
@end
