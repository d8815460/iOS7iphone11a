//
//  Nutrient.m
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import "Nutrient.h"

@implementation Nutrient
@synthesize nutrientNumber;
@synthesize nutrientName;
@synthesize nutrientShortName;
@synthesize nutrientValue;
@synthesize unit;
@synthesize searchOrder;
@synthesize nutrientType;
@synthesize rdaRatio;
-(void) printInfo
{
    NSLog(@"Nutrient(%@): Number=%d, value=%f %@, RDA ratio=%.3f",nutrientName,[nutrientNumber intValue],nutrientValue,self.unit,rdaRatio);
}


+(Nutrient *)initEmptyObject
{
	Nutrient *nutrient=[Nutrient alloc];
	nutrient.nutrientNumber=[[NSNumber alloc] initWithInt:-1];
	nutrient.nutrientName=@"N/A";
	nutrient.nutrientShortName=@"N/A";
    
	nutrient.nutrientValue=-1;
	nutrient.unit=@"N/A";
	nutrient.searchOrder=-1;//官網上的顯示順序
	nutrient.nutrientType=@"N/A"; // 類別, ex: 'Proximate', 'Mineral', 'Vitamin' ,'Lipid', 'Amino Acid', 'Other'
	nutrient.rdaRatio=-1;	// 每日建議攝取營養百分比列表 ratio, 需乘100才是百分比
	return nutrient;
}

@end
