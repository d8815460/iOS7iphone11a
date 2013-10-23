//
//  Nutrient.h
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//
// Nutrient is used to accumulate RDA value for a Meal
#import <Foundation/Foundation.h>

@interface Nutrient : NSObject
{
	NSNumber *nutrientNumber;
	NSString *nutrientName;
	NSString *nutrientShortName;
    
	double nutrientValue;
	NSString *unit;
	int searchOrder;//官網上的顯示順序
	NSString *nutrientType; // 類別, ex: 'Proximate', 'Mineral', 'Vitamin' ,'Lipid', 'Amino Acid', 'Other'
	double rdaRatio;	// 每日建議攝取營養百分比列表 ratio, 需乘100才是百分比
}
@property(nonatomic,copy)   NSNumber *nutrientNumber;
@property(nonatomic,copy)	NSString *nutrientName;
@property(nonatomic,copy)	NSString *nutrientShortName;
@property	double nutrientValue;
@property(nonatomic,copy)	NSString *unit;
@property	int searchOrder;//官網上的顯示順序
@property(nonatomic,copy)	NSString *nutrientType; // 類別, ex: 'Proximate', 'Mineral', 'Vitamin' ,'Lipid', 'Amino Acid', 'Other'
@property	double rdaRatio;
-(void) printInfo;
+(Nutrient *)initEmptyObject;
@end
