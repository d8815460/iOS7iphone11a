//
//  FoodNutrient.m
//  KitchenScale
//
//  Created by Orange on 13/5/22.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//


#import "FoodNutrient.h"

@implementation FoodNutrient

@synthesize	foodNumber;
@synthesize	nutrientNumber;
@synthesize	nutrientName;
@synthesize	nutrientShortName;

// @synthesize	tagName;	// 目前無用的值
@synthesize nutrientValue;	
@synthesize nutrient100gValue;	// 是每 100g 裡所含的量
@synthesize	unit;
// @synthesize dataPoint;
// @synthesize stdError;
@synthesize searchOrder;//官網上的顯示順序
@synthesize	nutrientType; // 類別, ex: 'Proximate', 'Mineral', 'Vitamin' ,'Lipid', 'Amino Acid', 'Other'
@synthesize	rdaRatio;
@synthesize	rda100gRatio;

-(void) printInfo
{
	NSLog(@"==== FoodNutrient ====");
	NSLog(@"	foodNumber   =%@",foodNumber);
	NSLog(@"	nutrientNumbe=%@",nutrientNumber   );
	NSLog(@"	nutrientName =%@",nutrientName);
	NSLog(@"	nutrientShortName =%@",nutrientShortName);
//	NSLog(@"	tagName      =%@",tagName);
	NSLog(@"	nutrientValue=%f",nutrientValue  );
	NSLog(@"	nutrientVal1'=%f",nutrient100gValue  );
	NSLog(@"	unit         =%@",unit);
	NSLog(@"	searchOrder  =%d",searchOrder  );
	NSLog(@"	nutrientType =%@",nutrientType);
	NSLog(@"	rdaRatio     =%f",rdaRatio  );
	NSLog(@"	rdaPercent100=%f",rda100gRatio  );
}
-(void) printWeightVariables
{
	NSLog(@"	WeightVariables=%f , %f , %f , %f",nutrientValue ,nutrient100gValue,rdaRatio,rda100gRatio );
}
-(void) setNutrientNumberWithInt:(int) number
{
	nutrientNumber = [[NSNumber alloc] initWithInt:number];
}
-(void) setFoodNumberWithInt:(int) number
{
	foodNumber = [[NSNumber alloc] initWithInt:number];
}
-(FoodNutrient *) cloneFoodNutrient
{
	FoodNutrient *f=[FoodNutrient alloc];

	[f setFoodNumber:[self foodNumber]];
	[f setNutrientNumber:[self nutrientNumber]];
	[f setNutrientName:[self nutrientName]];
//	[f setTagName:[self tagName]];
	[f setNutrientValue:[self nutrientValue]];
	[f setNutrient100gValue:[self nutrient100gValue]];
	[f setUnit:[self unit]];
//	[f setDataPoint:[self dataPoint]];
//	[f setStdError:[self stdError]];
	[f setSearchOrder:[self searchOrder]];
	[f setNutrientType:[self nutrientType]];
	[f setNutrientShortName:[self nutrientShortName]];
	[f setRdaRatio:[self rdaRatio]];
	[f setRda100gRatio:[self rda100gRatio]];
	return f;
}
-(Nutrient *)toNutrient
{
	Nutrient *nutrient=[Nutrient alloc];
	nutrient.nutrientNumber=self.nutrientNumber;
	nutrient.nutrientName=self.nutrientName;
	nutrient.nutrientShortName=self.nutrientShortName;
    
	nutrient.nutrientValue=self.nutrientValue;
	nutrient.unit=self.unit;
	nutrient.searchOrder=self.searchOrder;//官網上的顯示順序
	nutrient.nutrientType=self.nutrientType; // 類別, ex: 'Proximate', 'Mineral', 'Vitamin' ,'Lipid', 'Amino Acid', 'Other'
	nutrient.rdaRatio=self.rdaRatio;	// 每日建議攝取營養百分比列表 ratio, 需乘100才是百分比
	return nutrient;
}
@end
