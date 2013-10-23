//
//  FoodNutrient.h
//  KitchenScale
//
//  Created by Orange on 13/5/22.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nutrient.h"
@interface FoodNutrient : NSObject
{
	NSNumber *foodNumber;
	NSNumber *nutrientNumber;
	NSString *nutrientName;
	NSString *nutrientShortName;
	// NSString *tagName;	// 目前無用的值

	double nutrientValue;	
	double nutrient100gValue;	// 每 100g 裡所含的量
	NSString *unit;
	
	// 目前還用不到的二個值
	// int dataPoint;
	// double stdError;
	
	int searchOrder;//官網上的顯示順序
	NSString *nutrientType; // 類別, ex: 'Proximate', 'Mineral', 'Vitamin' ,'Lipid', 'Amino Acid', 'Other'
/*
	Can't found the classification of the nutrients in database. 
	Observe from the online system and got the following conclusion:
		Proximates(近似的)	~2200	
		Minerals	5300~6240
		Vitamins	6300~8950
		Lipids	9700	16200
		Amino Acids(氨基酸)	16300	18100
		Other	18200~
*/
	double rdaRatio;	// 每日建議攝取營養百分比列表 ratio, 需乘100才是百分比
	double rda100gRatio;	// 100g version
}
@property(nonatomic,copy)	NSNumber *foodNumber;
@property(nonatomic,copy)   NSNumber *nutrientNumber;
@property(nonatomic,copy)	NSString *nutrientName;
@property(nonatomic,copy)	NSString *nutrientShortName;

// @property(nonatomic,copy)	NSString *tagName;	// 目前無用的值

@property	double nutrientValue;
@property	double nutrient100gValue;	// 是每 100g 裡所含的量
@property(nonatomic,copy)	NSString *unit;

// @property	int dataPoint;
// @property	double stdError;
	
@property	int searchOrder;//官網上的顯示順序
@property(nonatomic,copy)	NSString *nutrientType; // 類別, ex: 'Proximate', 'Mineral', 'Vitamin' ,'Lipid', 'Amino Acid', 'Other'
@property	double rdaRatio;
@property	double rda100gRatio;

-(void) printInfo;
-(void) setNutrientNumberWithInt:(int) number;
-(void) setFoodNumberWithInt:(int) number;
-(FoodNutrient *) cloneFoodNutrient;
-(void) printWeightVariables;	// debug usage function
-(Nutrient *)toNutrient;
@end
