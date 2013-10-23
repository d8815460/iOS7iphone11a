//
//  Food.h
//  KitchenScale
//
//  Created by Orange on 13/5/20.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject
{
	NSNumber *foodNumber;
	NSString *shortDescription;
	NSString *longDescription;
	NSString *foodGroup;
	
	// 這四個值還沒用到，只是資料庫裡有
//	double factorCarbohydrate;
//	double factorFat;
//	double factorProtein;
//	double factorNitrogen;	// Nitrogen to Protein Conversion Factor
	
	int searchCount;	// only used in mostSearch function 

	NSString *title;
	NSString *subTitle;
	UIImage *foodImage;
}
@property(nonatomic,copy) NSNumber *foodNumber;
@property(nonatomic,copy) NSString *shortDescription;
@property(nonatomic,copy) NSString *longDescription;
@property(nonatomic,copy) NSString *foodGroup;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subTitle;
@property(nonatomic,copy) UIImage *foodImage;
// @property double factorCarbohydrate;
// @property double factorFat;
// @property double factorProtein;
// @property double factorNitrogen;
@property int searchCount;

-(void) setFoodNumberWithInt:(int) number;

-(void) printFoodInfo;

-(void) setFoodImageWithGroupID:(int)groupID;
	
@end
