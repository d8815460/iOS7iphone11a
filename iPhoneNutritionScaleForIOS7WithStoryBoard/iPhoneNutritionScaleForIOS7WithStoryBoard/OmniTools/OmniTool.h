//
//  OmniTool.h
//  KitchenScale
//
//  Created by Orange on 13/4/3.
//  Copyright (c) 2013年 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIBLECBKeyfob.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import "FoodOverview.h"
#import "Food.h"
#import "FoodNutrientDayLog.h"
#import "FoodTaken.h"
#import "encription.h"

@interface OmniTool : NSObject
{
}
+(int) adjustUnit:(int) unit;	// if the unit is not found, return UNIT_G
+(int) unitStringToInt:(NSString*) unitString;
+(NSString*) unitIntToString:(int) unitInt;

//判斷iphone機器
+ (NSString*)deviceString;

//取得s_cmd的值
// + (void)s_cmdObjects:(char *)sender;

// time to HH:MM:SS
+(NSString*) timerToString:(CFAbsoluteTime) t;

+(void) testCodes;

/*
//用戶照片資料
+ (void)processFacebookProfilePictureData:(NSData *)data;
//用戶有一個有效的Facebook數據
+ (BOOL)userHasValidFacebookData:(PFUser *)user;
//用戶有個人照片
+ (BOOL)userHasProfilePictures:(PFUser *)user;
//截取用戶的名字顯示在DisplayName上
+ (NSString *)firstNameForDisplayName:(NSString *)displayName;

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)unfollowUsersEventually:(NSArray *)users;

+ (void)sendFollowingPushNotification:(PFUser *)user;
*/



/* search food in USDA database with keyword
	return array of Food，會先列以keyword為首的food，再列有含keyword的food
	各回傳最多50筆，所以上限是100筆

// search food example
	NSMutableArray *array = [OmniTool searchFood:@"butter"];
	id food;
    for(int i = 0; i < array.count; i++){
    	food = [array objectAtIndex:i];
        NSLog(@"Food(%@) = %@, group=%@",[food foodNumber],[food longDescription],[food foodGroup]);
    }
Execution Result:
2013-05-30 14:06:36.192 KitchenScale[3038:907] Food(1001) = Butter, salted, group=Dairy and Egg Products
2013-05-30 14:06:36.194 KitchenScale[3038:907] Food(1002) = Butter, whipped, with salt, group=Dairy and Egg Products
2013-05-30 14:06:36.195 KitchenScale[3038:907] Food(1003) = Butter oil, anhydrous, group=Dairy and Egg Products
2013-05-30 14:06:36.196 KitchenScale[3038:907] Food(1145) = Butter, without salt, group=Dairy and Egg Products
2013-05-30 14:06:36.197 KitchenScale[3038:907] Food(4601) = Butter, light, stick, with salt, group=Fats and Oils
2013-05-30 14:06:36.198 KitchenScale[3038:907] Food(4602) = Butter, light, stick, without salt, group=Fats and Oils
2013-05-30 14:06:36.198 KitchenScale[3038:907] Food(11106) = Butterbur, (fuki), raw, group=Vegetables and Vegetable Products
... etc
Execution time=0.120 second(s).

// search food with 5+5 records example. Be noted the duplicated items won't be added, so there might be less than 10 records.
	NSMutableArray *array = [OmniTool searchFood:@"butter" RecordCount:5];
	id food;
    for(int i = 0; i < array.count; i++){
    	food = [array objectAtIndex:i];
        NSLog(@"Food(%@) = %@, group=%@",[food foodNumber],[food longDescription],[food foodGroup]);
    }
Execution Result:
2013-05-30 15:51:20.307 KitchenScale[3289:907] Food(1001) = Butter, salted, group=Dairy and Egg Products
2013-05-30 15:51:20.308 KitchenScale[3289:907] Food(1002) = Butter, whipped, with salt, group=Dairy and Egg Products
2013-05-30 15:51:20.309 KitchenScale[3289:907] Food(1003) = Butter oil, anhydrous, group=Dairy and Egg Products
2013-05-30 15:51:20.310 KitchenScale[3289:907] Food(1145) = Butter, without salt, group=Dairy and Egg Products
2013-05-30 15:51:20.311 KitchenScale[3289:907] Food(4601) = Butter, light, stick, with salt, group=Fats and Oils
2013-05-30 15:51:20.311 KitchenScale[3289:907] Food(1058) = Sour dressing, non-butterfat, cultured, filled cream-type, group=Dairy and Egg Products
2013-05-30 15:51:20.313 KitchenScale[3289:907] Food(1088) = Milk, buttermilk, fluid, cultured, lowfat, group=Dairy and Egg Products
Execution time=0.018 second(s).

*/
+(NSMutableArray *)searchFood:(NSString *) keyword;	
// with limit count version
+(NSMutableArray *)searchFood:(NSString *) keyword RecordCount:(int)recordCount;	

/* search nutrient in food in USDA database with foodNumber
	return array of FoodNutrient

Example codes:
	NSMutableArray *array = [OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:90560]];
	id food;
    for(int i = 0; i < array.count; i++){
    	food = [array objectAtIndex:i];
        NSLog(@"%@ %f%@ (%@ , %@). DP=%i, STD=%f, order=%i, type=%@, shortname=%@ "
        	,[food nutrientName]
        	,[food nutrientValue]
        	,[food unit]
        	,[food tagName]
        	,[food nutrientNumber]
        	,[food dataPoint]
        	,[food stdError]
        	,[food searchOrder]
        	,[food nutrientType]
        	,[food nutrientShortName]);
    }
Execution result:
2013-05-28 17:12:32.353 KitchenScale[543:907] Water 79.200000g (WATER , 255). DP=0, STD=0.000000, order=100, type=Proximate, shortname=Water 
2013-05-28 17:12:32.354 KitchenScale[543:907] Energy 90.000000kcal (ENERC_KCAL , 208). DP=0, STD=0.000000, order=300, type=Proximate, shortname=Energy 
2013-05-28 17:12:32.355 KitchenScale[543:907] Energy 377.000000kJ (ENERC_KJ , 268). DP=0, STD=0.000000, order=400, type=Proximate, shortname=Energy 
2013-05-28 17:12:32.356 KitchenScale[543:907] Protein 16.100000g (PROCNT , 203). DP=0, STD=0.000000, order=600, type=Proximate, shortname=Protein 
2013-05-28 17:12:32.357 KitchenScale[543:907] Total lipid (fat) 1.400000g (FAT , 204). DP=0, STD=0.000000, order=800, type=Proximate, shortname=FAT 

*/
+(NSMutableArray *)getFoodNutrient:(NSNumber *)foodNumber;
+(NSMutableArray *)getFoodNutrientOnlyInRDA:(NSNumber *)foodNumber;

+(void)testTable:(NSString *)tableName;	// debug function
+(void)logSearch:(NSNumber *)foodNumber;// log search behavior
+(void)initialDatabase:(NSString *)dbFilename;	// initialize database
+(NSString *)getDatabasePath:(NSString *)dbFileName;	// DB utility tool
+(void)updateSearchCount:(NSNumber *)foodNumber;// add search count, search behavior log tool function
+(int)getSearchCount:(NSNumber *)foodNumber;	// get search count, search behavior log tool function
/*
	// return recently searched Food
	// example for recentSearch
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1001]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1002]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1003]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:90480]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:90480]];
	NSMutableArray *array = [OmniTool recentSearch];
	id food;
    for(int i = 0; i < array.count; i++){
    	food = [array objectAtIndex:i];
        NSLog(@"Food(%@) = %@, group=%@",[food number],[food longDescription],[food foodGroup]);
    }
Execution result:
2013-05-28 15:57:36.325 KitchenScale[403:907] Food(90480) = Syrup, cane, group=Sweets
2013-05-28 15:57:36.326 KitchenScale[403:907] Food(01003) = Butter oil, anhydrous, group=Dairy and Egg Products
2013-05-28 15:57:36.327 KitchenScale[403:907] Food(01002) = Butter, whipped, with salt, group=Dairy and Egg Products
2013-05-28 15:57:36.328 KitchenScale[403:907] Food(01001) = Butter, salted, group=Dairy and Egg Products
2013-05-28 15:57:36.329 KitchenScale[403:907] Food(03206) = Babyfood, cookie, baby, fruit, group=Baby Foods
2013-05-28 15:57:36.330 KitchenScale[403:907] Food(43432) = Babyfood, dinner, macaroni, beef and tomato sauce, toddler, group=Baby Foods
2013-05-28 15:57:36.331 KitchenScale[403:907] Food(43529) = Babyfood, rice and apples, dry, group=Baby Foods
2013-05-28 15:57:36.332 KitchenScale[403:907] Food(11308) = Peas, green (includes baby and lesuer types), canned, drained solids, unprepared, group=Vegetables and Vegetable Products
2013-05-28 15:57:36.333 KitchenScale[403:907] Food(43373) = Babyfood, dinner, chicken and noodle with vegetables, toddler, group=Baby Foods
2013-05-28 15:57:36.334 KitchenScale[403:907] Food(90560) = Mollusks, snail, raw, group=Finfish and Shellfish Products

*/
+(NSMutableArray *)recentSearch;
/*
	// return mostly searched Food
	// example for mostSearch
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1001]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1002]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1003]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:90480]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:90480]];
	NSMutableArray *array = [OmniTool mostSearch];
	id food;
    for(int i = 0; i < array.count; i++){
    	food = [array objectAtIndex:i];
        NSLog(@"Food(%@) = %@, group=%@",[food number],[food longDescription],[food foodGroup]);
    }
Execution result:
2013-05-28 15:59:53.523 KitchenScale[422:907] Food(01001) = Butter, salted, group=Dairy and Egg Products
2013-05-28 15:59:53.524 KitchenScale[422:907] Food(03206) = Babyfood, cookie, baby, fruit, group=Baby Foods
2013-05-28 15:59:53.525 KitchenScale[422:907] Food(90480) = Syrup, cane, group=Sweets
2013-05-28 15:59:53.526 KitchenScale[422:907] Food(01002) = Butter, whipped, with salt, group=Dairy and Egg Products
2013-05-28 15:59:53.527 KitchenScale[422:907] Food(01003) = Butter oil, anhydrous, group=Dairy and Egg Products
2013-05-28 15:59:53.528 KitchenScale[422:907] Food(11308) = Peas, green (includes baby and lesuer types), canned, drained solids, unprepared, group=Vegetables and Vegetable Products
2013-05-28 15:59:53.529 KitchenScale[422:907] Food(43373) = Babyfood, dinner, chicken and noodle with vegetables, toddler, group=Baby Foods
2013-05-28 15:59:53.530 KitchenScale[422:907] Food(43432) = Babyfood, dinner, macaroni, beef and tomato sauce, toddler, group=Baby Foods
2013-05-28 15:59:53.530 KitchenScale[422:907] Food(43529) = Babyfood, rice and apples, dry, group=Baby Foods
2013-05-28 15:59:53.531 KitchenScale[422:907] Food(90560) = Mollusks, snail, raw, group=Finfish and Shellfish Products

*/
+(NSMutableArray *)mostSearch;
/*
	getRDAList: return RDA nutrient list, order by sr_order, 
	userType: 	0 = woman
				1 = man
	// example of getRDAList of man
	NSMutableArray *array = [OmniTool getRDAList:1];
	id food;
    for(int i = 0; i < array.count; i++){
    	food = [array objectAtIndex:i];
        NSLog(@"%@ %f%@ (%@ , %@).  order=%i, type=%@ , shortname=%@ ",[food nutrientName],[food nutrientValue],[food unit],[food tagName],[food nutrientNumber],[food searchOrder],[food nutrientType],[food nutrientShortName]);
    }
Execution Result:
2013-05-28 17:24:04.216 KitchenScale[613:907] Water 3700.000000g (WATER , 255).  order=100, type=Proximate , shortname=Water 
2013-05-28 17:24:04.217 KitchenScale[613:907] Energy 2600.000000kcal (ENERC_KCAL , 208).  order=300, type=Proximate , shortname=Energy 
2013-05-28 17:24:04.218 KitchenScale[613:907] Energy 10885.680000kJ (ENERC_KJ , 268).  order=400, type=Proximate , shortname=Energy 
2013-05-28 17:24:04.219 KitchenScale[613:907] Protein 56.000000g (PROCNT , 203).  order=600, type=Proximate , shortname=Protein 
2013-05-28 17:24:04.220 KitchenScale[613:907] Total lipid (fat) 715.000000g (FAT , 204).  order=800, type=Proximate , shortname=FAT 
... etc
*/
+(NSMutableArray *)getRDAList:(int) userType;
/*
	getRDAList 的擴充，限制類別 withNutrientType

	// example of getRDAList withNutrientType of man
	NSMutableArray *array = [OmniTool getRDAList:1 withNutrientType:@"Vitamin"];
	id food;
    for(int i = 0; i < array.count; i++){
    	food = [array objectAtIndex:i];
        NSLog(@"%@ %f%@ (%@ , %@).  order=%i, type=%@ , shortname=%@ ",[food nutrientName],[food nutrientValue],[food unit],[food tagName],[food nutrientNumber],[food searchOrder],[food nutrientType],[food nutrientShortName]);
    }

Execution Result:
2013-05-28 17:26:03.502 KitchenScale[630:907] Vitamin C, total ascorbic acid 90.000000mg (VITC , 401).  order=6300, type=Vitamin , shortname=Vitamin C 
2013-05-28 17:26:03.503 KitchenScale[630:907] Thiamin 1.200000mg (THIA , 404).  order=6400, type=Vitamin , shortname=Thiamin 
2013-05-28 17:26:03.504 KitchenScale[630:907] Riboflavin 1.300000mg (RIBF , 405).  order=6500, type=Vitamin , shortname=Riboflavin 
2013-05-28 17:26:03.505 KitchenScale[630:907] Niacin 16.000000mg (NIA , 406).  order=6600, type=Vitamin , shortname=Niacin 
2013-05-28 17:26:03.506 KitchenScale[630:907] Pantothenic acid 5.000000mg (PANTAC , 410).  order=6700, type=Vitamin , shortname=PANTAC 
2013-05-28 17:26:03.507 KitchenScale[630:907] Vitamin B-6 1.300000mg (VITB6A , 415).  order=6800, type=Vitamin , shortname=Vitamin B-6 
... etc
*/
+(NSMutableArray *)getRDAList:(int) userType withNutrientType:(NSString *)nutrientType;

// 取得 Food 的 RDA 百分比， gram 為輸入的重量，單位為g，userType 1為男人，2為女人
// 回傳 FoodNutrient 列表，按官網順序排列
// 只回傳 RDA表裡有值的數值
/*
	// example of getFoodRDA of man
	NSMutableArray *array = [OmniTool getFoodRDA:[[NSNumber alloc] initWithInt:1001] forUserType:1 weight:225];
	id foodNutrient;
    for(int i = 0; i < array.count; i++){
    	foodNutrient = [array objectAtIndex:i];
    	// water(420) = 30.1%
        NSLog(@"%@(%@)=%f%@   rda=%f%% ,shortname=%@"
	        ,[foodNutrient nutrientName]
	        ,[foodNutrient nutrientNumber]
	        ,[foodNutrient nutrientValue]
	        ,[foodNutrient unit]
	        ,[foodNutrient rdaRatio]
	        ,[foodNutrient nutrientShortName]
	        );
    }
Execution Result:
2013-05-28 17:29:02.909 KitchenScale[651:907] Water(255)=15.870000g   rda=0.009651% ,shortname=Water
2013-05-28 17:29:02.910 KitchenScale[651:907] Energy(208)=717.000000kcal   rda=0.620481% ,shortname=Energy
2013-05-28 17:29:02.911 KitchenScale[651:907] Energy(268)=2999.000000kJ   rda=0.619874% ,shortname=Energy
2013-05-28 17:29:02.912 KitchenScale[651:907] Protein(203)=0.850000g   rda=0.034152% ,shortname=Protein
2013-05-28 17:29:02.913 KitchenScale[651:907] Total lipid (fat)(204)=81.110000g   rda=0.255241% ,shortname=FAT
2013-05-28 17:29:02.914 KitchenScale[651:907] Carbohydrate, by difference(205)=0.060000g   rda=0.001038% ,shortname=Carbohydrate
... etc

2013-05-31 13:18:08.112 KitchenScale[3732:907] Execution time=0.109 second(s).
*/
+(NSMutableArray *)getFoodRDA:(NSNumber *)foodNumber forUserType:(int)userType weight:(double)gram;
+(NSMutableArray *)getFoodRDAWithInt:(int)foodNumber forUserType:(int) userType weight:(double)gram;

// add type filter, and sort order
// order: 0 = official site order ascending
//			1 = rdaRatio order descending
//			2 = nutrientValue order descending
/*

	// example of getFoodRDA of man, with order and filter
	NSArray *array = [OmniTool getFoodRDA:[[NSNumber alloc] initWithInt:1001] forUserType:1 weight:225 nutrientType:@"Vitamin" sortOrder:1];
	id foodNutrient;
    for(int i = 0; i < array.count; i++){
    	foodNutrient = [array objectAtIndex:i];
        NSLog(@"%@(%@)=%f%@   rda=%f%% type=%@ shortName=%@"
	        ,[foodNutrient nutrientName]
	        ,[foodNutrient nutrientNumber]
	        ,[foodNutrient nutrientValue]
	        ,[foodNutrient unit]
	        ,[foodNutrient rdaRatio]
	        ,[foodNutrient nutrientType]
	        ,[foodNutrient nutrientShortName]
	        );
    }
Execution Result:
2013-05-30 15:25:29.527 KitchenScale[3209:907] Vitamin A, RAE(320)=684.000000µg   rda=1.710000% type=Vitamin shortName=Vitamin A
2013-05-30 15:25:29.528 KitchenScale[3209:907] Vitamin D (D2 + D3)(328)=1.500000µg   rda=0.675000% type=Vitamin shortName=Vitamin D
2013-05-30 15:25:29.529 KitchenScale[3209:907] Vitamin E (alpha-tocopherol)(323)=2.320000mg   rda=0.348000% type=Vitamin shortName=Vitamin E 
2013-05-30 15:25:29.530 KitchenScale[3209:907] Vitamin B-12(418)=0.170000µg   rda=0.159375% type=Vitamin shortName=Vitamin B-12
2013-05-30 15:25:29.531 KitchenScale[3209:907] Vitamin K (phylloquinone)(430)=7.000000µg   rda=0.131250% type=Vitamin shortName=Vitamin K
2013-05-30 15:25:29.532 KitchenScale[3209:907] Choline, total(421)=18.800000mg   rda=0.076909% type=Vitamin shortName=Choline, total
2013-05-30 15:25:29.533 KitchenScale[3209:907] Riboflavin(405)=0.034000mg   rda=0.058846% type=Vitamin shortName=Riboflavin
2013-05-30 15:25:29.534 KitchenScale[3209:907] Pantothenic acid(410)=0.110000mg   rda=0.049500% type=Vitamin shortName=PANTAC
2013-05-30 15:25:29.536 KitchenScale[3209:907] Folate, total(417)=3.000000µg   rda=0.016875% type=Vitamin shortName=Folate, total
2013-05-30 15:25:29.537 KitchenScale[3209:907] Thiamin(404)=0.005000mg   rda=0.009375% type=Vitamin shortName=Thiamin
2013-05-30 15:25:29.538 KitchenScale[3209:907] Niacin(406)=0.042000mg   rda=0.005906% type=Vitamin shortName=Niacin
2013-05-30 15:25:29.539 KitchenScale[3209:907] Vitamin B-6(415)=0.003000mg   rda=0.005192% type=Vitamin shortName=Vitamin B-6
2013-05-30 15:25:29.540 KitchenScale[3209:907] Vitamin C, total ascorbic acid(401)=0.000000mg   rda=0.000000% type=Vitamin shortName=Vitamin C

2013-05-30 15:25:29.543 KitchenScale[3209:907] Execution time=0.104 second(s).

*/
+(NSArray *)getFoodRDA:(NSNumber *)foodNumber forUserType:(int)userType weight:(double)gram nutrientType:(NSString *)nutrientType sortOrder:(int) sortOrder;
+(FoodNutrient *)getFoodRDA:(NSNumber *)foodNumber forUserType:(int)userType weight:(double)gram nutrientType:(NSString *)nutrientType AndNutrientNumber:(NSNumber *)nutrientNumber sortOrder:(int) sortOrder;



+(void) clearSearch; // 清除 search logs

/*
	取得食物的簡化指標百分比，以及指標的營養成分百分比
Example code of getThreeRecommend of man, with weight=gram
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");
	timeCheck = CFAbsoluteTimeGetCurrent();

	FoodOverview *overview = [OmniTool getFoodOverview:[[NSNumber alloc] initWithInt:1001] forUserType:1 weight:200];
	// 注意，caloriesRatio等等都是比率, 要乘 100 才是百分比
	[overview printInfo];

	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
	NSLog(@"====== Orange Test Area END ======");

	NSLog(@"====== Orange Test Area again ======");
	timeCheck = CFAbsoluteTimeGetCurrent();

	overview = [OmniTool getFoodOverview:[[NSNumber alloc] initWithInt:1001] forUserType:1 weight:100];
	// 注意，caloriesRatio等等都是比率, 要乘 100 才是百分比
//	[overview printInfo];

	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
	NSLog(@"====== Orange Test Area END ======");

Execution Result:
2013-06-26 17:41:33.707 iPadNutritionScaleWithStoryBoard[16181:907] ====== Orange Test Area ======
2013-06-26 17:41:33.804 iPadNutritionScaleWithStoryBoard[16181:907] ======== FoodOverview ========
2013-06-26 17:41:33.805 iPadNutritionScaleWithStoryBoard[16181:907] **** energyRatio    =0.5515
2013-06-26 17:41:33.807 iPadNutritionScaleWithStoryBoard[16181:907] ==== FoodNutrient ====
2013-06-26 17:41:33.808 iPadNutritionScaleWithStoryBoard[16181:907] 	foodNumber   =1001
2013-06-26 17:41:33.810 iPadNutritionScaleWithStoryBoard[16181:907] 	nutrientNumbe=208
2013-06-26 17:41:33.811 iPadNutritionScaleWithStoryBoard[16181:907] 	nutrientName =Energy
... etc

2013-06-26 17:41:34.449 iPadNutritionScaleWithStoryBoard[16181:907] Execution time=0.738 second(s).
2013-06-26 17:41:34.451 iPadNutritionScaleWithStoryBoard[16181:907] ====== Orange Test Area END ======
2013-06-26 17:44:01.678 iPadNutritionScaleWithStoryBoard[16200:907] ====== Orange Test Area again ======
2013-06-26 17:44:01.680 iPadNutritionScaleWithStoryBoard[16200:907] Execution time=0.001 second(s).
2013-06-26 17:44:01.682 iPadNutritionScaleWithStoryBoard[16200:907] ====== Orange Test Area END ======

Note: FoodOverview printInfo takes pretty much time, around 0.6 second.
*/

+(FoodOverview *)getFoodOverview:(NSNumber *)foodNumber forUserType:(int) userType weight:(float)gram;

/*
getCurrentConnectionStatus
	if disconnected, return nil
	else, return 
	
Example Code:
	CBPeripheral *ap=[OmniTool getCurrentConnectionStatus];
	if(ap==nil){
		NSLog(@"Scale disconnected");
	}else{
	    CFStringRef s = CFUUIDCreateString(NULL, ap.UUID);
	    printf("------------------------------------\r\n");
	    printf("Peripheral Info :\r\n");
	    printf("UUID : %s\r\n",CFStringGetCStringPtr(s, 0));
	    printf("RSSI : %d\r\n",[ap.RSSI intValue]);
	    printf("Name : %s\r\n",[ap.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
	    printf("isConnected : %d\r\n",ap.isConnected);
	    printf("-------------------------------------\r\n");
	}

Execution Result:(未連線)
2013-05-24 15:48:17.211 KitchenScale[12905:907] Scale disconnected

Execution Result:(連線)
------------------------------------

Peripheral Info :

UUID : 7D89DE51-3650-7E0B-DE1B-094A6774F259

RSSI : 0

Name : INFOS 9A3Bv35.05

isConnected : 1

-------------------------------------
*/
+(CBPeripheral *)getCurrentConnectionStatus;

/* scan devices for t seconds

	// scan devices example
	[OmniTool scanBT4device:(float)1.0];
	sleep(2.0);
	NSMutableArray* array=[OmniTool getDeviceList];
    for(int i = 0; i < array.count; i++) {
        CBPeripheral *ap = [array objectAtIndex:i];
	    CFStringRef s = CFUUIDCreateString(NULL, ap.UUID);
	    NSLog(@"------------------------------------");
	    NSLog(@"Peripheral Info :");
	    NSLog(@"UUID : %s",CFStringGetCStringPtr(s, 0));
	    NSLog(@"RSSI : %d",[ap.RSSI intValue]);
	    NSLog(@"Name : %s",[ap.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
	    NSLog(@"isConnected : %d",ap.isConnected);
	    NSLog(@"-------------------------------------");
	}
Execution Result:
2013-05-27 13:32:26.407 KitchenScale[13698:907] start scan device...
2013-05-27 13:32:28.410 KitchenScale[13698:907] ------------------------------------
2013-05-27 13:32:28.412 KitchenScale[13698:907] Peripheral Info :
2013-05-27 13:32:28.414 KitchenScale[13698:907] UUID : 7D89DE51-3650-7E0B-DE1B-094A6774F259
2013-05-27 13:32:28.415 KitchenScale[13698:907] RSSI : 0
2013-05-27 13:32:28.416 KitchenScale[13698:907] Name : INFOS 9A3Bv35.05
2013-05-27 13:32:28.416 KitchenScale[13698:907] isConnected : 1
2013-05-27 13:32:28.417 KitchenScale[13698:907] -------------------------------------
2013-05-27 13:32:28.430 KitchenScale[13698:907] stop scan
*/
+(void)scanBT4device:(float) t;
// return a list of CBPeripheral
+(NSMutableArray*)getDeviceList;




/* disconnect from current connected peripharel, if connected.
範例程式(Excample Code):
	CBPeripheral *ap=[OmniTool getCurrentConnectionStatus];
	if(ap.isConnected==YES){
		[OmniTool disconnectFromCurrentPeripheral];
	}else{
		NSString *apUUID=[OmniTool UUIDtoString:[ap UUID]];
		[OmniTool connectPeripheral:ap WithUUID:apUUID];
	}
*/
+(void) disconnectFromCurrentPeripheral;

	
// convert CBPeripheral.UUID into NSString
+(NSString *)UUIDtoString:(CFUUIDRef) UUID;

/* get current weight in gram
Example of execution
	NSLog(@"current weight= %f",[OmniTool getCurrentGram]);
*/
+(double) getCurrentGram;

// RDA list cache functions
+(NSMutableArray *)getFoodRDAcache:(NSNumber *)foodNumber forUserType:(int) userType;
+(void)setFoodRDAcache:(NSNumber *)foodNumber forUserType:(int)userType WithRDAarray:(NSMutableArray *)arrayRDA;
+(NSMutableArray *)multiplyFoodRDAWithGram:(NSMutableArray *)cacheArray weight:(double)gram;

+(double)unitConvert:(double) weightValue SourceUnit:(int)sourceUnit TargetUnit:(int)targetUnit;
+(double) weightSimulation:(double)targetWeight;

+(void) seperateTitleSubtitle:(Food *)food; // for seperate title and subtitle from long description

/*
API (1)：點擊輸入框時用：
     回傳一個 NSMutableDictionary ，裡面含2組 NSMutableArray ，包括
     (a) Most Searched 
     (b) Recent Searched

Example of execution:
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1001]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1002]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:1003]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:90480]];
	[OmniTool getFoodNutrient:[[NSNumber alloc] initWithInt:90480]];
	
	NSMutableDictionary *dic=[OmniTool getMostRecentSearched];
	NSEnumerator *enumerator = [dic keyEnumerator];
	NSString *groupTitle;
	while ((groupTitle = [enumerator nextObject])) {
		NSLog(@"====== %@ ======",groupTitle);
		NSMutableArray *foodArray = [dic valueForKey:groupTitle];
		id food;
	    for(int i = 0; i < foodArray.count; i++){
	    	food = [foodArray objectAtIndex:i];
			[food printFoodInfo];
	    }
	}
	
Execution Result:
2013-06-21 16:01:00.033 iPadNutritionScaleWithStoryBoard[13381:907] ====== Orange Test Area ======
2013-06-21 16:01:00.323 iPadNutritionScaleWithStoryBoard[13381:907] ====== Recent Searched ======
2013-06-21 16:01:00.324 iPadNutritionScaleWithStoryBoard[13381:907] Food(90480)=[Syrup, cane] group=[Sweets] title=[Syrup, cane] sub title=[]
2013-06-21 16:01:00.326 iPadNutritionScaleWithStoryBoard[13381:907] Food(1003)=[Butter oil, anhydrous] group=[Dairy and Egg Products] title=[Butter oil, anhydrous] sub title=[]
2013-06-21 16:01:00.328 iPadNutritionScaleWithStoryBoard[13381:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter, whipped,] sub title=[ with salt]
2013-06-21 16:01:00.329 iPadNutritionScaleWithStoryBoard[13381:907] Food(1001)=[Butter, salted] group=[Dairy and Egg Products] title=[Butter, salted] sub title=[]
2013-06-21 16:01:00.331 iPadNutritionScaleWithStoryBoard[13381:907] ====== Most Searched ======
2013-06-21 16:01:00.332 iPadNutritionScaleWithStoryBoard[13381:907] Food(90480)=[Syrup, cane] group=[Sweets] title=[Syrup, cane] sub title=[]
2013-06-21 16:01:00.333 iPadNutritionScaleWithStoryBoard[13381:907] Food(1001)=[Butter, salted] group=[Dairy and Egg Products] title=[Butter, salted] sub title=[]
2013-06-21 16:01:00.335 iPadNutritionScaleWithStoryBoard[13381:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter, whipped,] sub title=[ with salt]
2013-06-21 16:01:00.337 iPadNutritionScaleWithStoryBoard[13381:907] Food(1003)=[Butter oil, anhydrous] group=[Dairy and Egg Products] title=[Butter oil, anhydrous] sub title=[]
2013-06-21 16:01:00.338 iPadNutritionScaleWithStoryBoard[13381:907] Execution time=0.301 second(s).
2013-06-21 16:01:00.339 iPadNutritionScaleWithStoryBoard[13381:907] ====== Orange Test Area END ======

*/
+(NSMutableDictionary *)getMostRecentSearched;

/*
API (2)：輸入中用：
     回傳一個 NSMutableDictionary ，含1組NSArray，(c) Recommend Search
Example of execution:
	
	NSMutableDictionary *dic=[OmniTool searchFoodWithTitle:@"bu"];
	NSEnumerator *enumerator = [dic keyEnumerator];
	NSString *groupTitle;
	while ((groupTitle = [enumerator nextObject])) {
		NSLog(@"====== %@ ======",groupTitle);
		NSMutableArray *foodArray = [dic valueForKey:groupTitle];
		id food;
	    for(int i = 0; i < foodArray.count; i++){
	    	food = [foodArray objectAtIndex:i];
			[food printFoodInfo];
	    }
	}
	
Execution Result:
2013-06-21 16:33:57.456 iPadNutritionScaleWithStoryBoard[13445:907] ====== Orange Test Area ======
2013-06-21 16:33:57.537 iPadNutritionScaleWithStoryBoard[13445:907] ====== Search Result ======
2013-06-21 16:33:57.538 iPadNutritionScaleWithStoryBoard[13445:907] Food(1001)=[Butter, salted] group=[Dairy and Egg Products] title=[Butter, salted] sub title=[]
2013-06-21 16:33:57.540 iPadNutritionScaleWithStoryBoard[13445:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter, whipped,] sub title=[ with salt]
2013-06-21 16:33:57.541 iPadNutritionScaleWithStoryBoard[13445:907] Food(1003)=[Butter oil, anhydrous] group=[Dairy and Egg Products] title=[Butter oil, anhydrous] sub title=[]
2013-06-21 16:33:57.543 iPadNutritionScaleWithStoryBoard[13445:907] Food(1145)=[Butter, without salt] group=[Dairy and Egg Products] title=[Butter, without salt] sub title=[]
...
2013-06-21 16:33:57.667 iPadNutritionScaleWithStoryBoard[13445:907] Food(8476)=[Cereals ready-to-eat, MALT-O-MEAL, Honey BUZZERS] group=[Breakfast Cereals] title=[Cereals ready-to-eat, MALT-O-MEAL,] sub title=[ Honey BUZZERS]
2013-06-21 16:33:57.669 iPadNutritionScaleWithStoryBoard[13445:907] Food(8553)=[Cereals ready-to-eat, GENERAL MILLS, CHEERIOS, Yogurt Burst, strawberry] group=[Breakfast Cereals] title=[Cereals ready-to-eat, GENERAL MILLS,] sub title=[ CHEERIOS, Yogurt Burst, strawberry]
2013-06-21 16:33:57.671 iPadNutritionScaleWithStoryBoard[13445:907] Food(8633)=[Cereals ready-to-eat, Post Honey Bunches of Oats with vanilla bunches] group=[Breakfast Cereals] title=[Cereals ready-to-eat, Post Honey Bunches of Oats with vanilla bunches] sub title=[]
2013-06-21 16:33:57.672 iPadNutritionScaleWithStoryBoard[13445:907] Execution time=0.211 second(s).
2013-06-21 16:33:57.673 iPadNutritionScaleWithStoryBoard[13445:907] ====== Orange Test Area END ======

*/
+(NSMutableDictionary *)searchFoodWithTitle:(NSString *) keyword;
/*
API (3)：按下Enter Search用：
     回傳一個 NSMutableDictionary ，含1組NSArray，(d) Search Result
Example of execution:
	
	NSMutableDictionary *dic=[OmniTool recommendFoodSearch:@"bu"];
	NSEnumerator *enumerator = [dic keyEnumerator];
	NSString *groupTitle;
	while ((groupTitle = [enumerator nextObject])) {
		NSLog(@"====== %@ ======",groupTitle);
		NSMutableArray *foodArray = [dic valueForKey:groupTitle];
		id food;
	    for(int i = 0; i < foodArray.count; i++){
	    	food = [foodArray objectAtIndex:i];
			[food printFoodInfo];
	    }
	}
	
Execution Result:
2013-06-21 16:38:35.282 iPadNutritionScaleWithStoryBoard[13474:907] ====== Orange Test Area ======
2013-06-21 16:38:35.331 iPadNutritionScaleWithStoryBoard[13474:907] ====== Recommend Search ======
2013-06-21 16:38:35.333 iPadNutritionScaleWithStoryBoard[13474:907] Food(1001)=[Butter, salted] group=[Dairy and Egg Products] title=[Butter, salted] sub title=[]
2013-06-21 16:38:35.335 iPadNutritionScaleWithStoryBoard[13474:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter, whipped,] sub title=[ with salt]
2013-06-21 16:38:35.336 iPadNutritionScaleWithStoryBoard[13474:907] Food(1003)=[Butter oil, anhydrous] group=[Dairy and Egg Products] title=[Butter oil, anhydrous] sub title=[]
...
2013-06-21 16:38:35.362 iPadNutritionScaleWithStoryBoard[13474:907] Food(20012)=[Bulgur, dry] group=[Cereal Grains and Pasta] title=[Bulgur, dry] sub title=[]
2013-06-21 16:38:35.363 iPadNutritionScaleWithStoryBoard[13474:907] Food(20013)=[Bulgur, cooked] group=[Cereal Grains and Pasta] title=[Bulgur, cooked] sub title=[]
2013-06-21 16:38:35.365 iPadNutritionScaleWithStoryBoard[13474:907] Execution time=0.079 second(s).
2013-06-21 16:38:35.367 iPadNutritionScaleWithStoryBoard[13474:907] ====== Orange Test Area END ======

*/
+(NSMutableDictionary *)recommendFoodSearch:(NSString *) keyword;

+(NSString *)connectionStateToString:(ConnectionState) connState;



//Weekly Average 繪製柱狀圖表動畫。
+(void)weeklyAverageViewController:(float )virtualKey AndBarView:(UIView *)barView AndImageView:(UIImageView *)ImageView;
//+(void)weeklyAverageViewController:(float )virtualKey AndBarViewColor:(UIView *)barView;

/*
	Ratio: 0----badLowerBound----goodLowerBound----goodUpperBound----badUpperBound
	P2~P3 is good
	P1~P4 is soso
	other is bad
*/
+(void)weeklyAverageViewController:(float )virtualKey 
						AndBarViewColor:(UIView *)barView 
						BadLowerBound:(float)badLowerBound 
						BadUpperBound:(float)badUpperBound 
						GoodLowerBound:(float)goodLowerBound 
						GoodUpperBound:(float)goodUpperBound;
+(void)weeklyAverageViewController:(float )virtualKey
                      AndImageView:(UIImageView *)ImageView
                     BadLowerBound:(float)badLowerBound
                     BadUpperBound:(float)badUpperBound
                    GoodLowerBound:(float)goodLowerBound
                    GoodUpperBound:(float)goodUpperBound;
// profile: pre-defined setting profile
+(void)weeklyAverageViewController:(float )virtualKey AndBarViewColor:(UIView *)barView Profile:(int)profile;

+(void)weeklyAverageViewController:(float )virtualKey AndAnimateBarView:(UIView *)barView;
+(void)weeklyAverageViewController:(float )virtualKey AndImageView:(UIImageView *)ImageView Profile:(int)profile;
//今日累積
+(float)todayFatRatio;
+(float)todaySugarRatio;
+(float)todaySaltRatio;
+(float)todayOtherRatio;
+(float)todayKcalRatio;
+(float)todayKcalVaule;
+(BOOL)todayAlreadyTaken;	// 今日若有記錄
//繪製首頁的色塊
+(void)colorBoxWithRatio:(float)Ratio AndTodayRatio:(float)TodatyRatio AndInforgraphicView:(UIView *)inforgraphicView AndAddInforGraphicView:(UIView *)addInforgraphicView AndVauleLabel:(UILabel *)VauleLabel AndColorButton:(UIButton *)colorButton AndPoint:(CGPoint)Point AndSize:(CGSize)Size DoDebug:(BOOL)doDebug;
//Calories色塊方塊繪圖
+(void)energyColorBoxWithValue:(float)value
                  CurrentRatio:(float)Ratio
                 AndTodayRatio:(float)TodayRatio
           AndInforgraphicView:(UIView *)inforgraphicView
        AndAddInforGraphicView:(UIView *)addInforgraphicView
                 AndVauleLabel:(UILabel *)VauleLabel
                AndColorButton:(UIButton *)colorButton
                      AndPoint:(CGPoint)Point
                       AndSize:(CGSize)Size
                       DoDebug:(BOOL)doDebug;
/*
+(void)energyRatioColorBoxWithRatio:(float)Ratio AndTodayRatio:(float)TodatyRatio AndEnergyKcal:(float)EnergyValue AndInforgraphicView:(UIView *)inforgraphicView AndAddInforGraphicView:(UIView *)addInforgraphicView AndTriangleImage:(UIImageView *)triangleImage AndVauleLabel:(UILabel *)VauleLabel AndColorButton:(UIButton *)colorButton AndPoint:(CGPoint)Point AndSize:(CGSize)Size AndTrianglePoint:(CGPoint)triPoint AndTriangleSize:(CGSize)triSize;
*/
 //高度規則，未連接磅秤情況下：
+(void)theRuleForColorBoxWithRatio:(float)TodayRatio AndVirtualGraphic:(UIView *)VirtualGraphic andPointX:(float)PointX AndPointY:(float)PointY AndSizeWidth:(float)width AndSizeHeight:(float)height;
+(void)theRuleForKcalColorBoxWithRatio:(float)TodayRatio AndVirtualGraphic:(UIView *)VirtualGraphic andPointX:(float)PointX AndPointY:(float)PointY AndSizeWidth:(float)width AndSizeHeight:(float)height AndTriangleImage:(UIImageView *)triangleImage AndTrianglePointX:(float)triangleImagePointX AndTrianglePointY:(float)triangleImagePointY AndTriangleSizeWidth:(float)triangleImageWidth AndTriangleSizeHeight:(float)triangleImageHeight;
//繪製update()有今日累積食物
// +(void)DrawWithTodayRatio:(float)todayRatio AndVirtualGraphic:(UIView *)VirtualGraphic AndPointX:(float)PointX AndPointY:(float)PointY AndWidth:(float)width AndHeight:(float)height AndAddVirtualGraphic:(UIView *)addVirtualGraphic;
//初始化色塊
+(void)initColorBoxName:(NSString *)titleName AndInforgraphicView:(UIView *)inforgraphicView AndeBGView:(UIView *)BackGroundView AndBGPoint:(CGPoint)BGPoint AndBGSize:(CGSize)BGSize AndVirtualGraphic:(UIView *)virtualGraphic AndPoint:(CGPoint)Point AndSize:(CGSize)Size BackGroundImageView:(UIImageView *)BGImageView AndAddVirtualGraphic:(UIView *)addVirtualGraphic AndBGColor:(UIColor *)BGColor AndLightColor:(UIColor *)lightColor AndVauleLabel:(UILabel *)VauleLabel AndVLPoint:(CGPoint)VLPoint AndVLSize:(CGSize)VLSize AndButton:(UIButton *)Button;
//初始化卡路里色塊
+(void)initCalorieBoxName:(NSString *)titleName
      AndInforgraphicView:(UIView *)inforgraphicView
               AndeBGView:(UIView *)BackGroundView
               AndBGPoint:(CGPoint)BGPoint
                AndBGSize:(CGSize)BGSize
        AndVirtualGraphic:(UIView *)virtualGraphic
                 AndPoint:(CGPoint)Point
                  AndSize:(CGSize)Size
       AdnTrigleImageView:(UIImageView *)triangleImageView
         AndTrianglePoint:(CGPoint)TPoint
          AndTriangleSize:(CGSize)TSize
      BackGroundImageView:(UIImageView *)BGImageView
     AndAddVirtualGraphic:(UIView *)addVirtualGraphic
       AndAddTriangleView:(UIImageView *)addTriangleImageView
      AndAddTrianglePoint:(CGPoint)ATPoint
       AndAddTriangleSize:(CGSize)ATSize
               AndBGColor:(UIColor *)BGColor
            AndLightColor:(UIColor *)lightColor
            AndVauleLabel:(UILabel *)VauleLabel
               AndVLPoint:(CGPoint)VLPoint
                AndVLSize:(CGSize)VLSize
                AndButton:(UIButton *)Button;

// 修正 Box 高度
+(void) landscapeBoxFixTitleColor:(double)totalRatio VirtualGraphic:(UIView *)virtualGraphic Button:(UIButton*)boxButton Label:(UILabel *)boxLabel DebugLog:(BOOL)doLog;
+(void) portraitBoxFixTitleColor:(double)totalRatio VirtualGraphic:(UIView *)virtualGraphic Button:(UIButton*)boxButton Label:(UILabel *)boxLabel DebugLog:(BOOL)doLog;
+(void) orientationBoxFixTitleColor:(double)totalRatio VirtualGraphic:(UIView *)virtualGraphic Button:(UIButton*)boxButton Label:(UILabel *)boxLabel DebugLog:(BOOL)doLog CritilHeight:(float)criticalHeight;


// return monday morning 00:00:00 absolute time
+(CFAbsoluteTime) getMondayMorningTime:(CFAbsoluteTime) absoluteTime;


/* log foods taken
Sample Codes:
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");
	
	[OmniTool clearFoodTakenLog];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1001] WeightGram:100.0];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200.0];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1004] WeightGram:130.0];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1008] WeightGram:104.0];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:50.0];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1001] WeightGram:60.0];

	timeCheck = CFAbsoluteTimeGetCurrent();
	FoodNutrientDayLog *dayLog=[OmniTool getNutrientsTakenToday:1];
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));

	[dayLog printInfo];
	NSLog(@"====== Orange Test Area END ======");

Execution Result:
2013-07-07 10:46:12.808 iPadNutritionScaleWithStoryBoard[23130:907] ====== Orange Test Area ======
2013-07-07 10:46:13.152 iPadNutritionScaleWithStoryBoard[23130:907] Execution time=0.339 second(s).
2013-07-07 10:46:13.154 iPadNutritionScaleWithStoryBoard[23130:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:46:13.156 iPadNutritionScaleWithStoryBoard[23130:907] 	week day=Sunday(7).
2013-07-07 10:46:13.157 iPadNutritionScaleWithStoryBoard[23130:907] 	Date    =7/7.
2013-07-07 10:46:13.158 iPadNutritionScaleWithStoryBoard[23130:907]     Nutrient list :
2013-07-07 10:46:13.160 iPadNutritionScaleWithStoryBoard[23130:907] ==== FoodNutrient ====
2013-07-07 10:46:13.161 iPadNutritionScaleWithStoryBoard[23130:907] 	foodNumber   =1004
2013-07-07 10:46:13.163 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientNumbe=255
2013-07-07 10:46:13.164 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientName =Water
2013-07-07 10:46:13.165 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientShortName =Water
2013-07-07 10:46:13.167 iPadNutritionScaleWithStoryBoard[23130:907] 	tagName      =WATER
2013-07-07 10:46:13.168 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientValue=55.133000
2013-07-07 10:46:13.170 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientVal1'=42.410000
2013-07-07 10:46:13.171 iPadNutritionScaleWithStoryBoard[23130:907] 	unit         =g
2013-07-07 10:46:13.172 iPadNutritionScaleWithStoryBoard[23130:907] 	searchOrder  =100
2013-07-07 10:46:13.173 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientType =Proximate
2013-07-07 10:46:13.175 iPadNutritionScaleWithStoryBoard[23130:907] 	rdaRatio     =0.014901
2013-07-07 10:46:13.177 iPadNutritionScaleWithStoryBoard[23130:907] 	rdaPercent100=0.011462
...

2013-07-07 10:46:13.779 iPadNutritionScaleWithStoryBoard[23130:907] ==== FoodNutrient ====
2013-07-07 10:46:13.781 iPadNutritionScaleWithStoryBoard[23130:907] 	foodNumber   =1004
2013-07-07 10:46:13.782 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientNumbe=262
2013-07-07 10:46:13.784 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientName =Caffeine
2013-07-07 10:46:13.786 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientShortName =Caffeine
2013-07-07 10:46:13.787 iPadNutritionScaleWithStoryBoard[23130:907] 	tagName      =CAFFN
2013-07-07 10:46:13.789 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientValue=0.000000
2013-07-07 10:46:13.790 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientVal1'=0.000000
2013-07-07 10:46:13.792 iPadNutritionScaleWithStoryBoard[23130:907] 	unit         =mg
2013-07-07 10:46:13.793 iPadNutritionScaleWithStoryBoard[23130:907] 	searchOrder  =18300
2013-07-07 10:46:13.795 iPadNutritionScaleWithStoryBoard[23130:907] 	nutrientType =Other
2013-07-07 10:46:13.796 iPadNutritionScaleWithStoryBoard[23130:907] 	rdaRatio     =0.000000
2013-07-07 10:46:13.798 iPadNutritionScaleWithStoryBoard[23130:907] 	rdaPercent100=0.000000
2013-07-07 10:46:13.799 iPadNutritionScaleWithStoryBoard[23130:907] ====== Orange Test Area END ======
*/
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double) gram ;
// log foods taken at given time
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram AtTime:(CFAbsoluteTime)takenTime;

// get the total nutrients taken today
// user Type: 0=woman, 1=man, default is 1
+(FoodNutrientDayLog *) getNutrientsTakenToday:(int)userType;

+(NSMutableArray *)addNutrientArray:(NSMutableArray *)targetArray sourceNutrientArray:(NSMutableArray *)sourceArray;
// add the nutrientValue and RDA percent
+(FoodNutrient *) addFoodNutrient:(FoodNutrient *)targetFoodNutrient sourceFoodNutrient:(FoodNutrient *)sourceFoodNutrient;

// retrieve FoodOverview from FoodNutrient Array
+(void)computeFoodOverview:(FoodNutrientDayLog *)foodNutrientDayLog;

// return dictionary of FoodNutrientDayLog
// key: NSNumber  1=Monday, 2=Tuesday, etc
// value: FoodNutrientDayLog object
/*
Example codes:
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");
	

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime morningTime=[OmniTool getMondayMorningTime: CFAbsoluteTimeGetCurrent()];
	
	// monday, takes 100g total
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	
	// tuesday, took 200g 
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:40 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:60 AtTime:morningTime+31500];
	
	// wednesday, record nothing
	morningTime+=SECONDS_IN_ONE_DAY;
	
	// thursday, took 400g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+11500];
	
	// friday, took 500g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+11500];
	
	// saturday, took 600g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+544];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11521];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12400];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31600];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+501];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+11502];

	// and nothing on Sunday
	
	timeCheck = CFAbsoluteTimeGetCurrent();
	NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenThisWeek:1];
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
	
	for(int i=1;i<8;i++){
		FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
		[dayLog printShortInfo];
	}
	NSLog(@"====== Orange Test Area END ======");
Execution Results:
2013-07-07 10:43:47.494 iPadNutritionScaleWithStoryBoard[23110:907] ====== Orange Test Area ======
2013-07-07 10:43:47.879 iPadNutritionScaleWithStoryBoard[23110:907] Execution time=0.127 second(s).
2013-07-07 10:43:47.881 iPadNutritionScaleWithStoryBoard[23110:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:43:47.882 iPadNutritionScaleWithStoryBoard[23110:907] 	week day=Monday(1).
2013-07-07 10:43:47.884 iPadNutritionScaleWithStoryBoard[23110:907] 	Date    =7/1.
2013-07-07 10:43:47.885 iPadNutritionScaleWithStoryBoard[23110:907]     First nutrient information:
2013-07-07 10:43:47.887 iPadNutritionScaleWithStoryBoard[23110:907] ==== FoodNutrient ====
2013-07-07 10:43:47.888 iPadNutritionScaleWithStoryBoard[23110:907] 	foodNumber   =1002
2013-07-07 10:43:47.890 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientNumbe=255
2013-07-07 10:43:47.891 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientName =Water
2013-07-07 10:43:47.892 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientShortName =Water
2013-07-07 10:43:47.894 iPadNutritionScaleWithStoryBoard[23110:907] 	tagName      =WATER
2013-07-07 10:43:47.895 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientValue=15.870000
2013-07-07 10:43:47.897 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientVal1'=15.870000
2013-07-07 10:43:47.898 iPadNutritionScaleWithStoryBoard[23110:907] 	unit         =g
2013-07-07 10:43:47.899 iPadNutritionScaleWithStoryBoard[23110:907] 	searchOrder  =100
2013-07-07 10:43:47.901 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientType =Proximate
2013-07-07 10:43:47.902 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaRatio     =0.004289
2013-07-07 10:43:47.903 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaPercent100=0.004289
2013-07-07 10:43:47.905 iPadNutritionScaleWithStoryBoard[23110:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:43:47.906 iPadNutritionScaleWithStoryBoard[23110:907] 	week day=Tuesday(2).
2013-07-07 10:43:47.908 iPadNutritionScaleWithStoryBoard[23110:907] 	Date    =7/2.
2013-07-07 10:43:47.909 iPadNutritionScaleWithStoryBoard[23110:907]     First nutrient information:
2013-07-07 10:43:47.911 iPadNutritionScaleWithStoryBoard[23110:907] ==== FoodNutrient ====
2013-07-07 10:43:47.912 iPadNutritionScaleWithStoryBoard[23110:907] 	foodNumber   =1002
2013-07-07 10:43:47.914 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientNumbe=255
2013-07-07 10:43:47.916 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientName =Water
2013-07-07 10:43:47.918 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientShortName =Water
2013-07-07 10:43:47.919 iPadNutritionScaleWithStoryBoard[23110:907] 	tagName      =WATER
2013-07-07 10:43:47.921 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientValue=31.740000
2013-07-07 10:43:47.922 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientVal1'=15.870000
2013-07-07 10:43:47.923 iPadNutritionScaleWithStoryBoard[23110:907] 	unit         =g
2013-07-07 10:43:47.925 iPadNutritionScaleWithStoryBoard[23110:907] 	searchOrder  =100
2013-07-07 10:43:47.926 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientType =Proximate
2013-07-07 10:43:47.927 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaRatio     =0.008578
2013-07-07 10:43:47.929 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaPercent100=0.004289
2013-07-07 10:43:47.930 iPadNutritionScaleWithStoryBoard[23110:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:43:47.932 iPadNutritionScaleWithStoryBoard[23110:907] 	week day=Wednesday(3).
2013-07-07 10:43:47.933 iPadNutritionScaleWithStoryBoard[23110:907] 	Date    =7/3.
2013-07-07 10:43:47.935 iPadNutritionScaleWithStoryBoard[23110:907] 	Nutrient array is EMPTY!
2013-07-07 10:43:47.936 iPadNutritionScaleWithStoryBoard[23110:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:43:47.937 iPadNutritionScaleWithStoryBoard[23110:907] 	week day=Thursday(4).
2013-07-07 10:43:47.939 iPadNutritionScaleWithStoryBoard[23110:907] 	Date    =7/4.
2013-07-07 10:43:47.940 iPadNutritionScaleWithStoryBoard[23110:907]     First nutrient information:
2013-07-07 10:43:47.942 iPadNutritionScaleWithStoryBoard[23110:907] ==== FoodNutrient ====
2013-07-07 10:43:47.943 iPadNutritionScaleWithStoryBoard[23110:907] 	foodNumber   =1002
2013-07-07 10:43:47.944 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientNumbe=255
2013-07-07 10:43:47.946 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientName =Water
2013-07-07 10:43:47.947 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientShortName =Water
2013-07-07 10:43:47.948 iPadNutritionScaleWithStoryBoard[23110:907] 	tagName      =WATER
2013-07-07 10:43:47.949 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientValue=63.480000
2013-07-07 10:43:47.951 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientVal1'=15.870000
2013-07-07 10:43:47.952 iPadNutritionScaleWithStoryBoard[23110:907] 	unit         =g
2013-07-07 10:43:47.953 iPadNutritionScaleWithStoryBoard[23110:907] 	searchOrder  =100
2013-07-07 10:43:47.954 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientType =Proximate
2013-07-07 10:43:47.956 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaRatio     =0.017157
2013-07-07 10:43:47.957 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaPercent100=0.004289
2013-07-07 10:43:47.959 iPadNutritionScaleWithStoryBoard[23110:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:43:47.960 iPadNutritionScaleWithStoryBoard[23110:907] 	week day=Friday(5).
2013-07-07 10:43:47.961 iPadNutritionScaleWithStoryBoard[23110:907] 	Date    =7/5.
2013-07-07 10:43:47.962 iPadNutritionScaleWithStoryBoard[23110:907]     First nutrient information:
2013-07-07 10:43:47.964 iPadNutritionScaleWithStoryBoard[23110:907] ==== FoodNutrient ====
2013-07-07 10:43:47.965 iPadNutritionScaleWithStoryBoard[23110:907] 	foodNumber   =1002
2013-07-07 10:43:47.966 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientNumbe=255
2013-07-07 10:43:47.968 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientName =Water
2013-07-07 10:43:47.969 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientShortName =Water
2013-07-07 10:43:47.971 iPadNutritionScaleWithStoryBoard[23110:907] 	tagName      =WATER
2013-07-07 10:43:47.972 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientValue=79.350000
2013-07-07 10:43:47.973 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientVal1'=15.870000
2013-07-07 10:43:47.974 iPadNutritionScaleWithStoryBoard[23110:907] 	unit         =g
2013-07-07 10:43:47.976 iPadNutritionScaleWithStoryBoard[23110:907] 	searchOrder  =100
2013-07-07 10:43:47.977 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientType =Proximate
2013-07-07 10:43:47.978 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaRatio     =0.021446
2013-07-07 10:43:47.980 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaPercent100=0.004289
2013-07-07 10:43:47.981 iPadNutritionScaleWithStoryBoard[23110:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:43:47.982 iPadNutritionScaleWithStoryBoard[23110:907] 	week day=Saturday(6).
2013-07-07 10:43:47.984 iPadNutritionScaleWithStoryBoard[23110:907] 	Date    =7/6.
2013-07-07 10:43:47.985 iPadNutritionScaleWithStoryBoard[23110:907]     First nutrient information:
2013-07-07 10:43:47.987 iPadNutritionScaleWithStoryBoard[23110:907] ==== FoodNutrient ====
2013-07-07 10:43:47.988 iPadNutritionScaleWithStoryBoard[23110:907] 	foodNumber   =1002
2013-07-07 10:43:47.989 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientNumbe=255
2013-07-07 10:43:47.991 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientName =Water
2013-07-07 10:43:47.992 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientShortName =Water
2013-07-07 10:43:47.993 iPadNutritionScaleWithStoryBoard[23110:907] 	tagName      =WATER
2013-07-07 10:43:47.994 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientValue=95.220000
2013-07-07 10:43:47.996 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientVal1'=15.870000
2013-07-07 10:43:47.997 iPadNutritionScaleWithStoryBoard[23110:907] 	unit         =g
2013-07-07 10:43:47.998 iPadNutritionScaleWithStoryBoard[23110:907] 	searchOrder  =100
2013-07-07 10:43:48.000 iPadNutritionScaleWithStoryBoard[23110:907] 	nutrientType =Proximate
2013-07-07 10:43:48.001 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaRatio     =0.025735
2013-07-07 10:43:48.003 iPadNutritionScaleWithStoryBoard[23110:907] 	rdaPercent100=0.004289
2013-07-07 10:43:48.004 iPadNutritionScaleWithStoryBoard[23110:907] ********** FoodNutrientDayLog ********************************
2013-07-07 10:43:48.005 iPadNutritionScaleWithStoryBoard[23110:907] 	week day=Sunday(7).
2013-07-07 10:43:48.006 iPadNutritionScaleWithStoryBoard[23110:907] 	Date    =7/7.
2013-07-07 10:43:48.008 iPadNutritionScaleWithStoryBoard[23110:907] 	Nutrient array is EMPTY!
2013-07-07 10:43:48.009 iPadNutritionScaleWithStoryBoard[23110:907] ====== Orange Test Area END ======

*/
+(NSMutableDictionary *) getNutrientsTakenThisWeek: (int)userType;

/*
	選擇某一週的營養記錄 getNutrientsTakenWithWeekBias
	weekBias: 0=本週, 1= 下一週, -1=上一週
Sample Codes:
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");
	

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime morningTime=[OmniTool getMondayMorningTime: CFAbsoluteTimeGetCurrent()];
	// 日期移到上一週
	morningTime=morningTime-SECONDS_IN_ONE_DAY*7;
	
	// monday, takes 100g total
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	
	// tuesday, took 200g 
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:40 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:60 AtTime:morningTime+31500];
	
	// wednesday, record nothing
	morningTime+=SECONDS_IN_ONE_DAY;
	
	// thursday, took 400g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+11500];
	
	// friday, took 500g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+11500];
	
	// saturday, took 600g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+544];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11521];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12400];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31600];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+501];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+11502];

	// and nothing on Sunday
	
	timeCheck = CFAbsoluteTimeGetCurrent();
	NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenWithWeekBias:-1 UserType:1];


	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
	
	for(int i=1;i<8;i++){
		FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
		[dayLog printDateInfo];
	}
	NSLog(@"====== Orange Test Area END ======");
Execution Result:
2013-07-31 08:14:43.445 iPadNutritionScaleWithStoryBoard[33003:c07] ====== Orange Test Area ======
2013-07-31 08:14:43.483 iPadNutritionScaleWithStoryBoard[33003:c07] Execution time=0.007 second(s).
2013-07-31 08:14:43.483 iPadNutritionScaleWithStoryBoard[33003:c07] ********** FoodNutrientDayLog ********************************
2013-07-31 08:14:43.483 iPadNutritionScaleWithStoryBoard[33003:c07] 	week day=Monday(1).
2013-07-31 08:14:43.484 iPadNutritionScaleWithStoryBoard[33003:c07] 	Date    =7/22.
2013-07-31 08:14:43.484 iPadNutritionScaleWithStoryBoard[33003:c07]     Nutrient array size=34
2013-07-31 08:14:43.484 iPadNutritionScaleWithStoryBoard[33003:c07] ********** FoodNutrientDayLog ********************************
2013-07-31 08:14:43.484 iPadNutritionScaleWithStoryBoard[33003:c07] 	week day=Tuesday(2).
2013-07-31 08:14:43.485 iPadNutritionScaleWithStoryBoard[33003:c07] 	Date    =7/23.
2013-07-31 08:14:43.485 iPadNutritionScaleWithStoryBoard[33003:c07]     Nutrient array size=34
2013-07-31 08:14:43.485 iPadNutritionScaleWithStoryBoard[33003:c07] ********** FoodNutrientDayLog ********************************
2013-07-31 08:14:43.485 iPadNutritionScaleWithStoryBoard[33003:c07] 	week day=Wednesday(3).
2013-07-31 08:14:43.486 iPadNutritionScaleWithStoryBoard[33003:c07] 	Date    =7/24.
2013-07-31 08:14:43.486 iPadNutritionScaleWithStoryBoard[33003:c07] 	Nutrient array is EMPTY!
2013-07-31 08:14:43.486 iPadNutritionScaleWithStoryBoard[33003:c07] ********** FoodNutrientDayLog ********************************
2013-07-31 08:14:43.486 iPadNutritionScaleWithStoryBoard[33003:c07] 	week day=Thursday(4).
2013-07-31 08:14:43.486 iPadNutritionScaleWithStoryBoard[33003:c07] 	Date    =7/25.
2013-07-31 08:14:43.487 iPadNutritionScaleWithStoryBoard[33003:c07]     Nutrient array size=34
2013-07-31 08:14:43.487 iPadNutritionScaleWithStoryBoard[33003:c07] ********** FoodNutrientDayLog ********************************
2013-07-31 08:14:43.487 iPadNutritionScaleWithStoryBoard[33003:c07] 	week day=Friday(5).
2013-07-31 08:14:43.487 iPadNutritionScaleWithStoryBoard[33003:c07] 	Date    =7/26.
2013-07-31 08:14:43.488 iPadNutritionScaleWithStoryBoard[33003:c07]     Nutrient array size=34
2013-07-31 08:14:43.488 iPadNutritionScaleWithStoryBoard[33003:c07] ********** FoodNutrientDayLog ********************************
2013-07-31 08:14:43.488 iPadNutritionScaleWithStoryBoard[33003:c07] 	week day=Saturday(6).
2013-07-31 08:14:43.488 iPadNutritionScaleWithStoryBoard[33003:c07] 	Date    =7/27.
2013-07-31 08:14:43.488 iPadNutritionScaleWithStoryBoard[33003:c07]     Nutrient array size=34
2013-07-31 08:14:43.489 iPadNutritionScaleWithStoryBoard[33003:c07] ********** FoodNutrientDayLog ********************************
2013-07-31 08:14:43.489 iPadNutritionScaleWithStoryBoard[33003:c07] 	week day=Sunday(7).
2013-07-31 08:14:43.489 iPadNutritionScaleWithStoryBoard[33003:c07] 	Date    =7/28.
2013-07-31 08:14:43.489 iPadNutritionScaleWithStoryBoard[33003:c07] 	Nutrient array is EMPTY!
2013-07-31 08:14:43.489 iPadNutritionScaleWithStoryBoard[33003:c07] ====== Orange Test Area END ======

*/
+(NSMutableDictionary *) getNutrientsTakenWithWeekBias:(int)weekBias UserType:(int)userType;

// get the total nutrients taken between 2 timings
// user Type: 0=woman, 1=man, default is 1
+(FoodNutrientDayLog *) getFoodNutrientDayLog:(int)userType Between:(CFAbsoluteTime)startTime And:(CFAbsoluteTime)endTime;

// log foods taken at given time
//本週星期幾
/* 	Example Codes:
		CFAbsoluteTime timeCheck;
		NSLog(@"====== Orange Test Area ======");
		
	
		[OmniTool clearFoodTakenLog];	// clear the log for testing
		
		
		NSNumber *foodNumber=[[NSNumber alloc] initWithInt:1003];
		// monday, takes 150g total
		[OmniTool logFoodTaken:foodNumber WeightGram:30 WeekDay:WEEK_DAY_TUESDAY Hour:13 Minute:24 Second:30];
		[OmniTool logFoodTaken:foodNumber WeightGram:120 WeekDay:WEEK_DAY_TUESDAY Hour:14 Minute:24 Second:30];
	
		timeCheck = CFAbsoluteTimeGetCurrent();
		NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenThisWeek:1];
		NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
		
		for(int i=1;i<8;i++){
			FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
			[dayLog printShortInfo];
		}
		NSLog(@"====== Orange Test Area END ======");

	Execution Result:
2013-07-08 14:11:05.637 iPadNutritionScaleWithStoryBoard[23681:907] ====== Orange Test Area ======
2013-07-08 14:11:05.768 iPadNutritionScaleWithStoryBoard[23681:907] Execution time=0.093 second(s).
2013-07-08 14:11:05.769 iPadNutritionScaleWithStoryBoard[23681:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:11:05.771 iPadNutritionScaleWithStoryBoard[23681:907] 	week day=Monday(1).
2013-07-08 14:11:05.772 iPadNutritionScaleWithStoryBoard[23681:907] 	Date    =7/8.
2013-07-08 14:11:05.774 iPadNutritionScaleWithStoryBoard[23681:907] 	Nutrient array is EMPTY!
2013-07-08 14:11:05.775 iPadNutritionScaleWithStoryBoard[23681:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:11:05.776 iPadNutritionScaleWithStoryBoard[23681:907] 	week day=Tuesday(2).
2013-07-08 14:11:05.778 iPadNutritionScaleWithStoryBoard[23681:907] 	Date    =7/9.
2013-07-08 14:11:05.780 iPadNutritionScaleWithStoryBoard[23681:907]     First nutrient information:
2013-07-08 14:11:05.781 iPadNutritionScaleWithStoryBoard[23681:907] ==== FoodNutrient ====
2013-07-08 14:11:05.783 iPadNutritionScaleWithStoryBoard[23681:907] 	foodNumber   =1003
2013-07-08 14:11:05.784 iPadNutritionScaleWithStoryBoard[23681:907] 	nutrientNumbe=255
2013-07-08 14:11:05.785 iPadNutritionScaleWithStoryBoard[23681:907] 	nutrientName =Water
2013-07-08 14:11:05.787 iPadNutritionScaleWithStoryBoard[23681:907] 	nutrientShortName =Water
2013-07-08 14:11:05.789 iPadNutritionScaleWithStoryBoard[23681:907] 	tagName      =WATER
2013-07-08 14:11:05.790 iPadNutritionScaleWithStoryBoard[23681:907] 	nutrientValue=0.360000
2013-07-08 14:11:05.791 iPadNutritionScaleWithStoryBoard[23681:907] 	nutrientVal1'=0.240000
2013-07-08 14:11:05.793 iPadNutritionScaleWithStoryBoard[23681:907] 	unit         =g
2013-07-08 14:11:05.794 iPadNutritionScaleWithStoryBoard[23681:907] 	searchOrder  =100
2013-07-08 14:11:05.796 iPadNutritionScaleWithStoryBoard[23681:907] 	nutrientType =Proximate
2013-07-08 14:11:05.797 iPadNutritionScaleWithStoryBoard[23681:907] 	rdaRatio     =0.000097
2013-07-08 14:11:05.799 iPadNutritionScaleWithStoryBoard[23681:907] 	rdaPercent100=0.000065
2013-07-08 14:11:05.800 iPadNutritionScaleWithStoryBoard[23681:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:11:05.802 iPadNutritionScaleWithStoryBoard[23681:907] 	week day=Wednesday(3).
2013-07-08 14:11:05.803 iPadNutritionScaleWithStoryBoard[23681:907] 	Date    =7/10.
2013-07-08 14:11:05.805 iPadNutritionScaleWithStoryBoard[23681:907] 	Nutrient array is EMPTY!
2013-07-08 14:11:05.806 iPadNutritionScaleWithStoryBoard[23681:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:11:05.808 iPadNutritionScaleWithStoryBoard[23681:907] 	week day=Thursday(4).
2013-07-08 14:11:05.809 iPadNutritionScaleWithStoryBoard[23681:907] 	Date    =7/11.
2013-07-08 14:11:05.810 iPadNutritionScaleWithStoryBoard[23681:907] 	Nutrient array is EMPTY!
2013-07-08 14:11:05.812 iPadNutritionScaleWithStoryBoard[23681:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:11:05.813 iPadNutritionScaleWithStoryBoard[23681:907] 	week day=Friday(5).
2013-07-08 14:11:05.814 iPadNutritionScaleWithStoryBoard[23681:907] 	Date    =7/12.
2013-07-08 14:11:05.816 iPadNutritionScaleWithStoryBoard[23681:907] 	Nutrient array is EMPTY!
2013-07-08 14:11:05.817 iPadNutritionScaleWithStoryBoard[23681:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:11:05.818 iPadNutritionScaleWithStoryBoard[23681:907] 	week day=Saturday(6).
2013-07-08 14:11:05.820 iPadNutritionScaleWithStoryBoard[23681:907] 	Date    =7/13.
2013-07-08 14:11:05.821 iPadNutritionScaleWithStoryBoard[23681:907] 	Nutrient array is EMPTY!
2013-07-08 14:11:05.823 iPadNutritionScaleWithStoryBoard[23681:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:11:05.824 iPadNutritionScaleWithStoryBoard[23681:907] 	week day=Sunday(7).
2013-07-08 14:11:05.826 iPadNutritionScaleWithStoryBoard[23681:907] 	Date    =7/14.
2013-07-08 14:11:05.827 iPadNutritionScaleWithStoryBoard[23681:907] 	Nutrient array is EMPTY!
2013-07-08 14:11:05.829 iPadNutritionScaleWithStoryBoard[23681:907] ====== Orange Test Area END ======
*/
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram WeekDay:(WEEK_DAY)weekDay Hour:(int)hour Minute:(int)minute Second:(int)second;

// 底層 API: 新增食物記錄於特定時間
// 幾年幾月幾日
/* Example Codes:
		CFAbsoluteTime timeCheck;
		NSLog(@"====== Orange Test Area ======");
		
	
		[OmniTool clearFoodTakenLog];	// clear the log for testing
		
		
		NSNumber *foodNumber=[[NSNumber alloc] initWithInt:1003];
		// Tuesday, takes 300g total
		[OmniTool logFoodTaken:foodNumber WeightGram:300 Year:2013 Month:7 Day:10 Hour:14 Minute:40 Second:10.0];
		// Error input
		[OmniTool logFoodTaken:foodNumber WeightGram:300 Year:2013 Month:13 Day:10 Hour:14 Minute:40 Second:10.0];
	
		timeCheck = CFAbsoluteTimeGetCurrent();
		NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenThisWeek:1];
		NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
		
		for(int i=1;i<8;i++){
			FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
			[dayLog printShortInfo];
		}
		NSLog(@"====== Orange Test Area END ======");
	Execution Result:
2013-07-08 14:50:24.721 iPadNutritionScaleWithStoryBoard[23777:907] ====== Orange Test Area ======
2013-07-08 14:50:24.784 iPadNutritionScaleWithStoryBoard[23777:907] Warning! Illegal date time when calling logFoodTaken: WeightGram:300.000000 Year:2013 Month:13 Day:10 Hour:14 Minute:40 Second:10.00
2013-07-08 14:50:24.903 iPadNutritionScaleWithStoryBoard[23777:907] Execution time=0.118 second(s).
2013-07-08 14:50:24.906 iPadNutritionScaleWithStoryBoard[23777:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:50:24.907 iPadNutritionScaleWithStoryBoard[23777:907] 	week day=Monday(1).
2013-07-08 14:50:24.909 iPadNutritionScaleWithStoryBoard[23777:907] 	Date    =7/8.
2013-07-08 14:50:24.910 iPadNutritionScaleWithStoryBoard[23777:907] 	Nutrient array is EMPTY!
2013-07-08 14:50:24.912 iPadNutritionScaleWithStoryBoard[23777:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:50:24.913 iPadNutritionScaleWithStoryBoard[23777:907] 	week day=Tuesday(2).
2013-07-08 14:50:24.914 iPadNutritionScaleWithStoryBoard[23777:907] 	Date    =7/9.
2013-07-08 14:50:24.916 iPadNutritionScaleWithStoryBoard[23777:907] 	Nutrient array is EMPTY!
2013-07-08 14:50:24.917 iPadNutritionScaleWithStoryBoard[23777:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:50:24.919 iPadNutritionScaleWithStoryBoard[23777:907] 	week day=Wednesday(3).
2013-07-08 14:50:24.920 iPadNutritionScaleWithStoryBoard[23777:907] 	Date    =7/10.
2013-07-08 14:50:24.921 iPadNutritionScaleWithStoryBoard[23777:907]     First nutrient information:
2013-07-08 14:50:24.923 iPadNutritionScaleWithStoryBoard[23777:907] ==== FoodNutrient ====
2013-07-08 14:50:24.924 iPadNutritionScaleWithStoryBoard[23777:907] 	foodNumber   =1003
2013-07-08 14:50:24.926 iPadNutritionScaleWithStoryBoard[23777:907] 	nutrientNumbe=255
2013-07-08 14:50:24.927 iPadNutritionScaleWithStoryBoard[23777:907] 	nutrientName =Water
2013-07-08 14:50:24.928 iPadNutritionScaleWithStoryBoard[23777:907] 	nutrientShortName =Water
2013-07-08 14:50:24.930 iPadNutritionScaleWithStoryBoard[23777:907] 	tagName      =WATER
2013-07-08 14:50:24.931 iPadNutritionScaleWithStoryBoard[23777:907] 	nutrientValue=0.720000
2013-07-08 14:50:24.933 iPadNutritionScaleWithStoryBoard[23777:907] 	nutrientVal1'=0.240000
2013-07-08 14:50:24.934 iPadNutritionScaleWithStoryBoard[23777:907] 	unit         =g
2013-07-08 14:50:24.935 iPadNutritionScaleWithStoryBoard[23777:907] 	searchOrder  =100
2013-07-08 14:50:24.937 iPadNutritionScaleWithStoryBoard[23777:907] 	nutrientType =Proximate
2013-07-08 14:50:24.938 iPadNutritionScaleWithStoryBoard[23777:907] 	rdaRatio     =0.000195
2013-07-08 14:50:24.940 iPadNutritionScaleWithStoryBoard[23777:907] 	rdaPercent100=0.000065
2013-07-08 14:50:24.941 iPadNutritionScaleWithStoryBoard[23777:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:50:24.943 iPadNutritionScaleWithStoryBoard[23777:907] 	week day=Thursday(4).
2013-07-08 14:50:24.944 iPadNutritionScaleWithStoryBoard[23777:907] 	Date    =7/11.
2013-07-08 14:50:24.945 iPadNutritionScaleWithStoryBoard[23777:907] 	Nutrient array is EMPTY!
2013-07-08 14:50:24.947 iPadNutritionScaleWithStoryBoard[23777:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:50:24.949 iPadNutritionScaleWithStoryBoard[23777:907] 	week day=Friday(5).
2013-07-08 14:50:24.950 iPadNutritionScaleWithStoryBoard[23777:907] 	Date    =7/12.
2013-07-08 14:50:24.951 iPadNutritionScaleWithStoryBoard[23777:907] 	Nutrient array is EMPTY!
2013-07-08 14:50:24.953 iPadNutritionScaleWithStoryBoard[23777:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:50:24.955 iPadNutritionScaleWithStoryBoard[23777:907] 	week day=Saturday(6).
2013-07-08 14:50:24.956 iPadNutritionScaleWithStoryBoard[23777:907] 	Date    =7/13.
2013-07-08 14:50:24.958 iPadNutritionScaleWithStoryBoard[23777:907] 	Nutrient array is EMPTY!
2013-07-08 14:50:24.959 iPadNutritionScaleWithStoryBoard[23777:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:50:24.960 iPadNutritionScaleWithStoryBoard[23777:907] 	week day=Sunday(7).
2013-07-08 14:50:24.962 iPadNutritionScaleWithStoryBoard[23777:907] 	Date    =7/14.
2013-07-08 14:50:24.963 iPadNutritionScaleWithStoryBoard[23777:907] 	Nutrient array is EMPTY!
2013-07-08 14:50:24.964 iPadNutritionScaleWithStoryBoard[23777:907] ====== Orange Test Area END ======

*/
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram Year:(int)year Month:(int)month Day:(int)day Hour:(int)hour Minute:(int)minute Second:(double)second;

// 底層 API: 新增食物記錄於特定時間
//今年幾月幾日
/* Example Codes:
		CFAbsoluteTime timeCheck;
		NSLog(@"====== Orange Test Area ======");
		
	
		[OmniTool clearFoodTakenLog];	// clear the log for testing
		
		
		NSNumber *foodNumber=[[NSNumber alloc] initWithInt:1003];
		// Tuesday, takes 300g total
		[OmniTool logFoodTaken:foodNumber WeightGram:300 Month:7 Day:11 Hour:15 Minute:50 Second:23.0];
		// Error input
		[OmniTool logFoodTaken:foodNumber WeightGram:300 Month:2 Day:30 Hour:14 Minute:40 Second:10.0];
	
		timeCheck = CFAbsoluteTimeGetCurrent();
		NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenThisWeek:1];
		NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
		
		for(int i=1;i<8;i++){
			FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
			[dayLog printShortInfo];
		}
		NSLog(@"====== Orange Test Area END ======");
	Execution Result:
2013-07-08 14:57:12.313 iPadNutritionScaleWithStoryBoard[23804:907] ====== Orange Test Area ======
2013-07-08 14:57:12.350 iPadNutritionScaleWithStoryBoard[23804:907] Warning! Illegal date time when calling logFoodTaken: WeightGram:300.000000 Year:2013 Month:2 Day:30 Hour:14 Minute:40 Second:10.00
2013-07-08 14:57:12.462 iPadNutritionScaleWithStoryBoard[23804:907] Execution time=0.111 second(s).
2013-07-08 14:57:12.464 iPadNutritionScaleWithStoryBoard[23804:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:57:12.466 iPadNutritionScaleWithStoryBoard[23804:907] 	week day=Monday(1).
2013-07-08 14:57:12.467 iPadNutritionScaleWithStoryBoard[23804:907] 	Date    =7/8.
2013-07-08 14:57:12.469 iPadNutritionScaleWithStoryBoard[23804:907] 	Nutrient array is EMPTY!
2013-07-08 14:57:12.470 iPadNutritionScaleWithStoryBoard[23804:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:57:12.472 iPadNutritionScaleWithStoryBoard[23804:907] 	week day=Tuesday(2).
2013-07-08 14:57:12.473 iPadNutritionScaleWithStoryBoard[23804:907] 	Date    =7/9.
2013-07-08 14:57:12.474 iPadNutritionScaleWithStoryBoard[23804:907] 	Nutrient array is EMPTY!
2013-07-08 14:57:12.476 iPadNutritionScaleWithStoryBoard[23804:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:57:12.477 iPadNutritionScaleWithStoryBoard[23804:907] 	week day=Wednesday(3).
2013-07-08 14:57:12.479 iPadNutritionScaleWithStoryBoard[23804:907] 	Date    =7/10.
2013-07-08 14:57:12.480 iPadNutritionScaleWithStoryBoard[23804:907] 	Nutrient array is EMPTY!
2013-07-08 14:57:12.482 iPadNutritionScaleWithStoryBoard[23804:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:57:12.483 iPadNutritionScaleWithStoryBoard[23804:907] 	week day=Thursday(4).
2013-07-08 14:57:12.484 iPadNutritionScaleWithStoryBoard[23804:907] 	Date    =7/11.
2013-07-08 14:57:12.486 iPadNutritionScaleWithStoryBoard[23804:907]     First nutrient information:
2013-07-08 14:57:12.487 iPadNutritionScaleWithStoryBoard[23804:907] ==== FoodNutrient ====
2013-07-08 14:57:12.489 iPadNutritionScaleWithStoryBoard[23804:907] 	foodNumber   =1003
2013-07-08 14:57:12.490 iPadNutritionScaleWithStoryBoard[23804:907] 	nutrientNumbe=255
2013-07-08 14:57:12.492 iPadNutritionScaleWithStoryBoard[23804:907] 	nutrientName =Water
2013-07-08 14:57:12.493 iPadNutritionScaleWithStoryBoard[23804:907] 	nutrientShortName =Water
2013-07-08 14:57:12.495 iPadNutritionScaleWithStoryBoard[23804:907] 	tagName      =WATER
2013-07-08 14:57:12.496 iPadNutritionScaleWithStoryBoard[23804:907] 	nutrientValue=0.720000
2013-07-08 14:57:12.498 iPadNutritionScaleWithStoryBoard[23804:907] 	nutrientVal1'=0.240000
2013-07-08 14:57:12.499 iPadNutritionScaleWithStoryBoard[23804:907] 	unit         =g
2013-07-08 14:57:12.501 iPadNutritionScaleWithStoryBoard[23804:907] 	searchOrder  =100
2013-07-08 14:57:12.502 iPadNutritionScaleWithStoryBoard[23804:907] 	nutrientType =Proximate
2013-07-08 14:57:12.504 iPadNutritionScaleWithStoryBoard[23804:907] 	rdaRatio     =0.000195
2013-07-08 14:57:12.505 iPadNutritionScaleWithStoryBoard[23804:907] 	rdaPercent100=0.000065
2013-07-08 14:57:12.506 iPadNutritionScaleWithStoryBoard[23804:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:57:12.509 iPadNutritionScaleWithStoryBoard[23804:907] 	week day=Friday(5).
2013-07-08 14:57:12.510 iPadNutritionScaleWithStoryBoard[23804:907] 	Date    =7/12.
2013-07-08 14:57:12.512 iPadNutritionScaleWithStoryBoard[23804:907] 	Nutrient array is EMPTY!
2013-07-08 14:57:12.514 iPadNutritionScaleWithStoryBoard[23804:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:57:12.516 iPadNutritionScaleWithStoryBoard[23804:907] 	week day=Saturday(6).
2013-07-08 14:57:12.518 iPadNutritionScaleWithStoryBoard[23804:907] 	Date    =7/13.
2013-07-08 14:57:12.520 iPadNutritionScaleWithStoryBoard[23804:907] 	Nutrient array is EMPTY!
2013-07-08 14:57:12.522 iPadNutritionScaleWithStoryBoard[23804:907] ********** FoodNutrientDayLog ********************************
2013-07-08 14:57:12.524 iPadNutritionScaleWithStoryBoard[23804:907] 	week day=Sunday(7).
2013-07-08 14:57:12.526 iPadNutritionScaleWithStoryBoard[23804:907] 	Date    =7/14.
2013-07-08 14:57:12.528 iPadNutritionScaleWithStoryBoard[23804:907] 	Nutrient array is EMPTY!
2013-07-08 14:57:12.530 iPadNutritionScaleWithStoryBoard[23804:907] ====== Orange Test Area END ======
*/
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram Month:(int)month Day:(int)day Hour:(int)hour Minute:(int)minute Second:(double)second;

/*
底層 API: 清除記錄 
	全部的記錄
*/
+(void) clearFoodTakenLog;

// return morning 00:00:00 absolute time
+(CFAbsoluteTime) getMorningTime:(CFAbsoluteTime) absoluteTime;

/*
底層 API: 清除記錄 
	今日的記錄
Sample Codes: clear all records today.
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");
	

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime morningTime=[OmniTool getMondayMorningTime: CFAbsoluteTimeGetCurrent()];
	
	// monday, takes 100g total
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	
	// tuesday, took 200g 
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+500];
	
	// wednesday, record 300g
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+500];
	
	// thursday, took 400g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+11500];
	
	// friday, took 500g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+11500];
	
	// saturday, took 600g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+544];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11521];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12400];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31600];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+501];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+11502];

	// and nothing on Sunday
	
	timeCheck = CFAbsoluteTimeGetCurrent();
	[OmniTool clearFoodTakenLogToday];
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
	
	NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenThisWeek:1];
	for(int i=1;i<8;i++){
		FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
		[dayLog printShortInfo];
	}
	NSLog(@"====== Orange Test Area END ======");

Execution Result:
2013-07-08 15:35:08.268 iPadNutritionScaleWithStoryBoard[23921:907] ====== Orange Test Area ======
2013-07-08 15:35:08.505 iPadNutritionScaleWithStoryBoard[23921:907] Execution time=0.009 second(s).
2013-07-08 15:35:08.618 iPadNutritionScaleWithStoryBoard[23921:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:35:08.619 iPadNutritionScaleWithStoryBoard[23921:907] 	week day=Monday(1).
2013-07-08 15:35:08.621 iPadNutritionScaleWithStoryBoard[23921:907] 	Date    =7/8.
2013-07-08 15:35:08.623 iPadNutritionScaleWithStoryBoard[23921:907] 	Nutrient array is EMPTY!
2013-07-08 15:35:08.624 iPadNutritionScaleWithStoryBoard[23921:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:35:08.625 iPadNutritionScaleWithStoryBoard[23921:907] 	week day=Tuesday(2).
2013-07-08 15:35:08.627 iPadNutritionScaleWithStoryBoard[23921:907] 	Date    =7/9.
2013-07-08 15:35:08.628 iPadNutritionScaleWithStoryBoard[23921:907]     First nutrient information:
2013-07-08 15:35:08.630 iPadNutritionScaleWithStoryBoard[23921:907] ==== FoodNutrient ====
2013-07-08 15:35:08.631 iPadNutritionScaleWithStoryBoard[23921:907] 	foodNumber   =1002
2013-07-08 15:35:08.633 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientNumbe=255
2013-07-08 15:35:08.634 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientName =Water
2013-07-08 15:35:08.635 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientShortName =Water
2013-07-08 15:35:08.637 iPadNutritionScaleWithStoryBoard[23921:907] 	tagName      =WATER
2013-07-08 15:35:08.638 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientValue=31.740000
2013-07-08 15:35:08.639 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientVal1'=15.870000
2013-07-08 15:35:08.641 iPadNutritionScaleWithStoryBoard[23921:907] 	unit         =g
2013-07-08 15:35:08.642 iPadNutritionScaleWithStoryBoard[23921:907] 	searchOrder  =100
2013-07-08 15:35:08.643 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientType =Proximate
2013-07-08 15:35:08.645 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaRatio     =0.008578
2013-07-08 15:35:08.647 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaPercent100=0.004289
2013-07-08 15:35:08.648 iPadNutritionScaleWithStoryBoard[23921:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:35:08.649 iPadNutritionScaleWithStoryBoard[23921:907] 	week day=Wednesday(3).
2013-07-08 15:35:08.651 iPadNutritionScaleWithStoryBoard[23921:907] 	Date    =7/10.
2013-07-08 15:35:08.652 iPadNutritionScaleWithStoryBoard[23921:907]     First nutrient information:
2013-07-08 15:35:08.654 iPadNutritionScaleWithStoryBoard[23921:907] ==== FoodNutrient ====
2013-07-08 15:35:08.655 iPadNutritionScaleWithStoryBoard[23921:907] 	foodNumber   =1002
2013-07-08 15:35:08.657 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientNumbe=255
2013-07-08 15:35:08.658 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientName =Water
2013-07-08 15:35:08.660 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientShortName =Water
2013-07-08 15:35:08.661 iPadNutritionScaleWithStoryBoard[23921:907] 	tagName      =WATER
2013-07-08 15:35:08.663 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientValue=47.610000
2013-07-08 15:35:08.664 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientVal1'=15.870000
2013-07-08 15:35:08.665 iPadNutritionScaleWithStoryBoard[23921:907] 	unit         =g
2013-07-08 15:35:08.667 iPadNutritionScaleWithStoryBoard[23921:907] 	searchOrder  =100
2013-07-08 15:35:08.668 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientType =Proximate
2013-07-08 15:35:08.669 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaRatio     =0.012868
2013-07-08 15:35:08.671 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaPercent100=0.004289
2013-07-08 15:35:08.673 iPadNutritionScaleWithStoryBoard[23921:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:35:08.674 iPadNutritionScaleWithStoryBoard[23921:907] 	week day=Thursday(4).
2013-07-08 15:35:08.676 iPadNutritionScaleWithStoryBoard[23921:907] 	Date    =7/11.
2013-07-08 15:35:08.677 iPadNutritionScaleWithStoryBoard[23921:907]     First nutrient information:
2013-07-08 15:35:08.679 iPadNutritionScaleWithStoryBoard[23921:907] ==== FoodNutrient ====
2013-07-08 15:35:08.680 iPadNutritionScaleWithStoryBoard[23921:907] 	foodNumber   =1002
2013-07-08 15:35:08.682 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientNumbe=255
2013-07-08 15:35:08.683 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientName =Water
2013-07-08 15:35:08.685 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientShortName =Water
2013-07-08 15:35:08.686 iPadNutritionScaleWithStoryBoard[23921:907] 	tagName      =WATER
2013-07-08 15:35:08.688 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientValue=63.480000
2013-07-08 15:35:08.689 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientVal1'=15.870000
2013-07-08 15:35:08.690 iPadNutritionScaleWithStoryBoard[23921:907] 	unit         =g
2013-07-08 15:35:08.692 iPadNutritionScaleWithStoryBoard[23921:907] 	searchOrder  =100
2013-07-08 15:35:08.693 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientType =Proximate
2013-07-08 15:35:08.695 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaRatio     =0.017157
2013-07-08 15:35:08.696 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaPercent100=0.004289
2013-07-08 15:35:08.698 iPadNutritionScaleWithStoryBoard[23921:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:35:08.699 iPadNutritionScaleWithStoryBoard[23921:907] 	week day=Friday(5).
2013-07-08 15:35:08.700 iPadNutritionScaleWithStoryBoard[23921:907] 	Date    =7/12.
2013-07-08 15:35:08.702 iPadNutritionScaleWithStoryBoard[23921:907]     First nutrient information:
2013-07-08 15:35:08.703 iPadNutritionScaleWithStoryBoard[23921:907] ==== FoodNutrient ====
2013-07-08 15:35:08.705 iPadNutritionScaleWithStoryBoard[23921:907] 	foodNumber   =1002
2013-07-08 15:35:08.706 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientNumbe=255
2013-07-08 15:35:08.708 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientName =Water
2013-07-08 15:35:08.709 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientShortName =Water
2013-07-08 15:35:08.711 iPadNutritionScaleWithStoryBoard[23921:907] 	tagName      =WATER
2013-07-08 15:35:08.712 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientValue=79.350000
2013-07-08 15:35:08.713 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientVal1'=15.870000
2013-07-08 15:35:08.715 iPadNutritionScaleWithStoryBoard[23921:907] 	unit         =g
2013-07-08 15:35:08.717 iPadNutritionScaleWithStoryBoard[23921:907] 	searchOrder  =100
2013-07-08 15:35:08.718 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientType =Proximate
2013-07-08 15:35:08.719 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaRatio     =0.021446
2013-07-08 15:35:08.721 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaPercent100=0.004289
2013-07-08 15:35:08.723 iPadNutritionScaleWithStoryBoard[23921:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:35:08.724 iPadNutritionScaleWithStoryBoard[23921:907] 	week day=Saturday(6).
2013-07-08 15:35:08.726 iPadNutritionScaleWithStoryBoard[23921:907] 	Date    =7/13.
2013-07-08 15:35:08.727 iPadNutritionScaleWithStoryBoard[23921:907]     First nutrient information:
2013-07-08 15:35:08.729 iPadNutritionScaleWithStoryBoard[23921:907] ==== FoodNutrient ====
2013-07-08 15:35:08.730 iPadNutritionScaleWithStoryBoard[23921:907] 	foodNumber   =1002
2013-07-08 15:35:08.732 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientNumbe=255
2013-07-08 15:35:08.733 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientName =Water
2013-07-08 15:35:08.735 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientShortName =Water
2013-07-08 15:35:08.736 iPadNutritionScaleWithStoryBoard[23921:907] 	tagName      =WATER
2013-07-08 15:35:08.738 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientValue=95.220000
2013-07-08 15:35:08.739 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientVal1'=15.870000
2013-07-08 15:35:08.741 iPadNutritionScaleWithStoryBoard[23921:907] 	unit         =g
2013-07-08 15:35:08.742 iPadNutritionScaleWithStoryBoard[23921:907] 	searchOrder  =100
2013-07-08 15:35:08.744 iPadNutritionScaleWithStoryBoard[23921:907] 	nutrientType =Proximate
2013-07-08 15:35:08.745 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaRatio     =0.025735
2013-07-08 15:35:08.746 iPadNutritionScaleWithStoryBoard[23921:907] 	rdaPercent100=0.004289
2013-07-08 15:35:08.748 iPadNutritionScaleWithStoryBoard[23921:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:35:08.749 iPadNutritionScaleWithStoryBoard[23921:907] 	week day=Sunday(7).
2013-07-08 15:35:08.751 iPadNutritionScaleWithStoryBoard[23921:907] 	Date    =7/14.
2013-07-08 15:35:08.752 iPadNutritionScaleWithStoryBoard[23921:907] 	Nutrient array is EMPTY!
2013-07-08 15:35:08.754 iPadNutritionScaleWithStoryBoard[23921:907] ====== Orange Test Area END ======
*/
+(void) clearFoodTakenLogToday;

// 底層 API: 清除一段時間內的記錄 
+(void) clearFoodTakenFrom:(CFAbsoluteTime)startTime UntilTime:(CFAbsoluteTime) endTime;

/*
底層 API: 清除記錄 
	本週全部的記錄
Sample Codes: clear all records for this week
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");
	

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime morningTime=[OmniTool getMondayMorningTime: CFAbsoluteTimeGetCurrent()];
	
	// monday, takes 100g total
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	
	// tuesday, took 200g 
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+500];
	
	// wednesday, record 300g
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+500];
	
	// thursday, took 400g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+11500];
	
	// friday, took 500g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+11500];
	
	// saturday, took 600g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+544];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11521];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12400];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31600];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+501];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+11502];

	// and nothing on Sunday
	
	timeCheck = CFAbsoluteTimeGetCurrent();
	[OmniTool clearFoodTakenThisWeek];
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
	
	NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenThisWeek:1];
	for(int i=1;i<8;i++){
		FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
		[dayLog printShortInfo];
	}
	NSLog(@"====== Orange Test Area END ======");

Execution Result:

2013-07-08 15:40:29.107 iPadNutritionScaleWithStoryBoard[23943:907] ====== Orange Test Area ======
2013-07-08 15:40:29.344 iPadNutritionScaleWithStoryBoard[23943:907] Execution time=0.009 second(s).
2013-07-08 15:40:29.387 iPadNutritionScaleWithStoryBoard[23943:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:40:29.388 iPadNutritionScaleWithStoryBoard[23943:907] 	week day=Monday(1).
2013-07-08 15:40:29.390 iPadNutritionScaleWithStoryBoard[23943:907] 	Date    =7/8.
2013-07-08 15:40:29.392 iPadNutritionScaleWithStoryBoard[23943:907] 	Nutrient array is EMPTY!
2013-07-08 15:40:29.393 iPadNutritionScaleWithStoryBoard[23943:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:40:29.394 iPadNutritionScaleWithStoryBoard[23943:907] 	week day=Tuesday(2).
2013-07-08 15:40:29.396 iPadNutritionScaleWithStoryBoard[23943:907] 	Date    =7/9.
2013-07-08 15:40:29.397 iPadNutritionScaleWithStoryBoard[23943:907] 	Nutrient array is EMPTY!
2013-07-08 15:40:29.399 iPadNutritionScaleWithStoryBoard[23943:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:40:29.400 iPadNutritionScaleWithStoryBoard[23943:907] 	week day=Wednesday(3).
2013-07-08 15:40:29.401 iPadNutritionScaleWithStoryBoard[23943:907] 	Date    =7/10.
2013-07-08 15:40:29.403 iPadNutritionScaleWithStoryBoard[23943:907] 	Nutrient array is EMPTY!
2013-07-08 15:40:29.404 iPadNutritionScaleWithStoryBoard[23943:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:40:29.406 iPadNutritionScaleWithStoryBoard[23943:907] 	week day=Thursday(4).
2013-07-08 15:40:29.408 iPadNutritionScaleWithStoryBoard[23943:907] 	Date    =7/11.
2013-07-08 15:40:29.409 iPadNutritionScaleWithStoryBoard[23943:907] 	Nutrient array is EMPTY!
2013-07-08 15:40:29.411 iPadNutritionScaleWithStoryBoard[23943:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:40:29.412 iPadNutritionScaleWithStoryBoard[23943:907] 	week day=Friday(5).
2013-07-08 15:40:29.414 iPadNutritionScaleWithStoryBoard[23943:907] 	Date    =7/12.
2013-07-08 15:40:29.415 iPadNutritionScaleWithStoryBoard[23943:907] 	Nutrient array is EMPTY!
2013-07-08 15:40:29.417 iPadNutritionScaleWithStoryBoard[23943:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:40:29.418 iPadNutritionScaleWithStoryBoard[23943:907] 	week day=Saturday(6).
2013-07-08 15:40:29.420 iPadNutritionScaleWithStoryBoard[23943:907] 	Date    =7/13.
2013-07-08 15:40:29.421 iPadNutritionScaleWithStoryBoard[23943:907] 	Nutrient array is EMPTY!
2013-07-08 15:40:29.423 iPadNutritionScaleWithStoryBoard[23943:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:40:29.424 iPadNutritionScaleWithStoryBoard[23943:907] 	week day=Sunday(7).
2013-07-08 15:40:29.425 iPadNutritionScaleWithStoryBoard[23943:907] 	Date    =7/14.
2013-07-08 15:40:29.427 iPadNutritionScaleWithStoryBoard[23943:907] 	Nutrient array is EMPTY!
2013-07-08 15:40:29.428 iPadNutritionScaleWithStoryBoard[23943:907] ====== Orange Test Area END ======
*/
+(void) clearFoodTakenThisWeek;

/*
底層 API: 清除記錄 
	本週星期幾的記錄
Sample Codes: clear Friday records only.
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");
	

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime morningTime=[OmniTool getMondayMorningTime: CFAbsoluteTimeGetCurrent()];
	
	// monday, takes 100g total
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	
	// tuesday, took 200g 
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+500];
	
	// wednesday, record 300g
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+500];
	
	// thursday, took 400g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+11500];
	
	// friday, took 500g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+11500];
	
	// saturday, took 600g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+544];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11521];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12400];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31600];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+501];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+11502];

	// and nothing on Sunday
	
	timeCheck = CFAbsoluteTimeGetCurrent();
	[OmniTool clearFoodTakenWeekDay:WEEK_DAY_FRIDAY];
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));
	
	NSMutableDictionary *weekLogDictionary=[OmniTool getNutrientsTakenThisWeek:1];
	for(int i=1;i<8;i++){
		FoodNutrientDayLog *dayLog=[weekLogDictionary objectForKey:[[NSNumber alloc] initWithInt:i]];
		[dayLog printShortInfo];
	}
	NSLog(@"====== Orange Test Area END ======");
Execution Result:
2013-07-08 15:47:41.712 iPadNutritionScaleWithStoryBoard[23966:907] ====== Orange Test Area ======
2013-07-08 15:47:41.951 iPadNutritionScaleWithStoryBoard[23966:907] Execution time=0.013 second(s).
2013-07-08 15:47:42.057 iPadNutritionScaleWithStoryBoard[23966:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:47:42.059 iPadNutritionScaleWithStoryBoard[23966:907] 	week day=Monday(1).
2013-07-08 15:47:42.061 iPadNutritionScaleWithStoryBoard[23966:907] 	Date    =7/8.
2013-07-08 15:47:42.062 iPadNutritionScaleWithStoryBoard[23966:907]     First nutrient information:
2013-07-08 15:47:42.064 iPadNutritionScaleWithStoryBoard[23966:907] ==== FoodNutrient ====
2013-07-08 15:47:42.066 iPadNutritionScaleWithStoryBoard[23966:907] 	foodNumber   =1002
2013-07-08 15:47:42.068 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientNumbe=255
2013-07-08 15:47:42.069 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientName =Water
2013-07-08 15:47:42.070 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientShortName =Water
2013-07-08 15:47:42.072 iPadNutritionScaleWithStoryBoard[23966:907] 	tagName      =WATER
2013-07-08 15:47:42.073 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientValue=15.870000
2013-07-08 15:47:42.075 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientVal1'=15.870000
2013-07-08 15:47:42.076 iPadNutritionScaleWithStoryBoard[23966:907] 	unit         =g
2013-07-08 15:47:42.077 iPadNutritionScaleWithStoryBoard[23966:907] 	searchOrder  =100
2013-07-08 15:47:42.079 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientType =Proximate
2013-07-08 15:47:42.080 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaRatio     =0.004289
2013-07-08 15:47:42.081 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaPercent100=0.004289
2013-07-08 15:47:42.083 iPadNutritionScaleWithStoryBoard[23966:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:47:42.084 iPadNutritionScaleWithStoryBoard[23966:907] 	week day=Tuesday(2).
2013-07-08 15:47:42.086 iPadNutritionScaleWithStoryBoard[23966:907] 	Date    =7/9.
2013-07-08 15:47:42.087 iPadNutritionScaleWithStoryBoard[23966:907]     First nutrient information:
2013-07-08 15:47:42.089 iPadNutritionScaleWithStoryBoard[23966:907] ==== FoodNutrient ====
2013-07-08 15:47:42.090 iPadNutritionScaleWithStoryBoard[23966:907] 	foodNumber   =1002
2013-07-08 15:47:42.091 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientNumbe=255
2013-07-08 15:47:42.093 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientName =Water
2013-07-08 15:47:42.094 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientShortName =Water
2013-07-08 15:47:42.096 iPadNutritionScaleWithStoryBoard[23966:907] 	tagName      =WATER
2013-07-08 15:47:42.097 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientValue=31.740000
2013-07-08 15:47:42.099 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientVal1'=15.870000
2013-07-08 15:47:42.100 iPadNutritionScaleWithStoryBoard[23966:907] 	unit         =g
2013-07-08 15:47:42.101 iPadNutritionScaleWithStoryBoard[23966:907] 	searchOrder  =100
2013-07-08 15:47:42.103 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientType =Proximate
2013-07-08 15:47:42.104 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaRatio     =0.008578
2013-07-08 15:47:42.105 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaPercent100=0.004289
2013-07-08 15:47:42.107 iPadNutritionScaleWithStoryBoard[23966:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:47:42.108 iPadNutritionScaleWithStoryBoard[23966:907] 	week day=Wednesday(3).
2013-07-08 15:47:42.110 iPadNutritionScaleWithStoryBoard[23966:907] 	Date    =7/10.
2013-07-08 15:47:42.111 iPadNutritionScaleWithStoryBoard[23966:907]     First nutrient information:
2013-07-08 15:47:42.113 iPadNutritionScaleWithStoryBoard[23966:907] ==== FoodNutrient ====
2013-07-08 15:47:42.115 iPadNutritionScaleWithStoryBoard[23966:907] 	foodNumber   =1002
2013-07-08 15:47:42.116 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientNumbe=255
2013-07-08 15:47:42.117 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientName =Water
2013-07-08 15:47:42.119 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientShortName =Water
2013-07-08 15:47:42.120 iPadNutritionScaleWithStoryBoard[23966:907] 	tagName      =WATER
2013-07-08 15:47:42.122 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientValue=47.610000
2013-07-08 15:47:42.123 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientVal1'=15.870000
2013-07-08 15:47:42.125 iPadNutritionScaleWithStoryBoard[23966:907] 	unit         =g
2013-07-08 15:47:42.126 iPadNutritionScaleWithStoryBoard[23966:907] 	searchOrder  =100
2013-07-08 15:47:42.127 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientType =Proximate
2013-07-08 15:47:42.129 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaRatio     =0.012868
2013-07-08 15:47:42.130 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaPercent100=0.004289
2013-07-08 15:47:42.131 iPadNutritionScaleWithStoryBoard[23966:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:47:42.133 iPadNutritionScaleWithStoryBoard[23966:907] 	week day=Thursday(4).
2013-07-08 15:47:42.134 iPadNutritionScaleWithStoryBoard[23966:907] 	Date    =7/11.
2013-07-08 15:47:42.136 iPadNutritionScaleWithStoryBoard[23966:907]     First nutrient information:
2013-07-08 15:47:42.137 iPadNutritionScaleWithStoryBoard[23966:907] ==== FoodNutrient ====
2013-07-08 15:47:42.139 iPadNutritionScaleWithStoryBoard[23966:907] 	foodNumber   =1002
2013-07-08 15:47:42.140 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientNumbe=255
2013-07-08 15:47:42.142 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientName =Water
2013-07-08 15:47:42.143 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientShortName =Water
2013-07-08 15:47:42.144 iPadNutritionScaleWithStoryBoard[23966:907] 	tagName      =WATER
2013-07-08 15:47:42.146 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientValue=63.480000
2013-07-08 15:47:42.147 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientVal1'=15.870000
2013-07-08 15:47:42.148 iPadNutritionScaleWithStoryBoard[23966:907] 	unit         =g
2013-07-08 15:47:42.150 iPadNutritionScaleWithStoryBoard[23966:907] 	searchOrder  =100
2013-07-08 15:47:42.151 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientType =Proximate
2013-07-08 15:47:42.153 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaRatio     =0.017157
2013-07-08 15:47:42.154 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaPercent100=0.004289
2013-07-08 15:47:42.156 iPadNutritionScaleWithStoryBoard[23966:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:47:42.157 iPadNutritionScaleWithStoryBoard[23966:907] 	week day=Friday(5).
2013-07-08 15:47:42.159 iPadNutritionScaleWithStoryBoard[23966:907] 	Date    =7/12.
2013-07-08 15:47:42.160 iPadNutritionScaleWithStoryBoard[23966:907] 	Nutrient array is EMPTY!
2013-07-08 15:47:42.161 iPadNutritionScaleWithStoryBoard[23966:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:47:42.163 iPadNutritionScaleWithStoryBoard[23966:907] 	week day=Saturday(6).
2013-07-08 15:47:42.164 iPadNutritionScaleWithStoryBoard[23966:907] 	Date    =7/13.
2013-07-08 15:47:42.166 iPadNutritionScaleWithStoryBoard[23966:907]     First nutrient information:
2013-07-08 15:47:42.167 iPadNutritionScaleWithStoryBoard[23966:907] ==== FoodNutrient ====
2013-07-08 15:47:42.169 iPadNutritionScaleWithStoryBoard[23966:907] 	foodNumber   =1002
2013-07-08 15:47:42.170 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientNumbe=255
2013-07-08 15:47:42.171 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientName =Water
2013-07-08 15:47:42.173 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientShortName =Water
2013-07-08 15:47:42.174 iPadNutritionScaleWithStoryBoard[23966:907] 	tagName      =WATER
2013-07-08 15:47:42.176 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientValue=95.220000
2013-07-08 15:47:42.177 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientVal1'=15.870000
2013-07-08 15:47:42.178 iPadNutritionScaleWithStoryBoard[23966:907] 	unit         =g
2013-07-08 15:47:42.180 iPadNutritionScaleWithStoryBoard[23966:907] 	searchOrder  =100
2013-07-08 15:47:42.181 iPadNutritionScaleWithStoryBoard[23966:907] 	nutrientType =Proximate
2013-07-08 15:47:42.182 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaRatio     =0.025735
2013-07-08 15:47:42.184 iPadNutritionScaleWithStoryBoard[23966:907] 	rdaPercent100=0.004289
2013-07-08 15:47:42.185 iPadNutritionScaleWithStoryBoard[23966:907] ********** FoodNutrientDayLog ********************************
2013-07-08 15:47:42.187 iPadNutritionScaleWithStoryBoard[23966:907] 	week day=Sunday(7).
2013-07-08 15:47:42.188 iPadNutritionScaleWithStoryBoard[23966:907] 	Date    =7/14.
2013-07-08 15:47:42.190 iPadNutritionScaleWithStoryBoard[23966:907] 	Nutrient array is EMPTY!
2013-07-08 15:47:42.191 iPadNutritionScaleWithStoryBoard[23966:907] ====== Orange Test Area END ======
20
*/
+(void) clearFoodTakenWeekDay:(WEEK_DAY) weekDay;


/*
	底層 API: 今日食物List (食物，重量，卡路里)
	return a list of FoodTaken object, sorted by time descedning
Sample Codes:

	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime todayMorningTime=[OmniTool getMorningTime:CFAbsoluteTimeGetCurrent()];
	
	// taken yesterday
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1001] WeightGram:300 AtTime:todayMorningTime-500];
	// taken today
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:todayMorningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:todayMorningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1003] WeightGram:80 AtTime:todayMorningTime+31500];
	

	timeCheck = CFAbsoluteTimeGetCurrent();
	NSMutableArray * foodsTakenList=[OmniTool getFoodsTakenToday];
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));

	for(FoodTaken *ft in foodsTakenList)
	{
		[ft printInfo];
	}
	
	NSLog(@"====== Orange Test Area END ======");

Execution Result:
2013-07-15 15:51:20.429 iPadNutritionScaleWithStoryBoard[29101:907] ====== Orange Test Area ======
2013-07-15 15:51:20.501 iPadNutritionScaleWithStoryBoard[29101:907] Execution time=0.017 second(s).
2013-07-15 15:51:20.502 iPadNutritionScaleWithStoryBoard[29101:907] ======== FoodTaken ========
2013-07-15 15:51:20.504 iPadNutritionScaleWithStoryBoard[29101:907] Food(1003)=[Butter oil, anhydrous] group=[Dairy and Egg Products] title=[Butter oil,Anhydrous] sub title=[]
2013-07-15 15:51:20.505 iPadNutritionScaleWithStoryBoard[29101:907] **** foodWeightGram =80.0000
2013-07-15 15:51:20.506 iPadNutritionScaleWithStoryBoard[29101:907] **** foodCalaries  	=700.8000
2013-07-15 15:51:20.506 iPadNutritionScaleWithStoryBoard[29101:907] **** takeTime		=22:45:00
2013-07-15 15:51:20.507 iPadNutritionScaleWithStoryBoard[29101:907] ======== FoodTaken ========
2013-07-15 15:51:20.508 iPadNutritionScaleWithStoryBoard[29101:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter,Whipped] sub title=[With salt]
2013-07-15 15:51:20.509 iPadNutritionScaleWithStoryBoard[29101:907] **** foodWeightGram =70.0000
2013-07-15 15:51:20.510 iPadNutritionScaleWithStoryBoard[29101:907] **** foodCalaries  	=501.9000
2013-07-15 15:51:20.511 iPadNutritionScaleWithStoryBoard[29101:907] **** takeTime		=17:11:40
2013-07-15 15:51:20.512 iPadNutritionScaleWithStoryBoard[29101:907] ======== FoodTaken ========
2013-07-15 15:51:20.513 iPadNutritionScaleWithStoryBoard[29101:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter,Whipped] sub title=[With salt]
2013-07-15 15:51:20.514 iPadNutritionScaleWithStoryBoard[29101:907] **** foodWeightGram =30.0000
2013-07-15 15:51:20.515 iPadNutritionScaleWithStoryBoard[29101:907] **** foodCalaries  	=215.1000
2013-07-15 15:51:20.515 iPadNutritionScaleWithStoryBoard[29101:907] **** takeTime		=14:08:20
2013-07-15 15:51:20.516 iPadNutritionScaleWithStoryBoard[29101:907] ====== Orange Test Area END ======

*/
+(NSMutableArray *) getFoodsTakenToday;
+(NSMutableArray *) getFoodsTakenAtDay:(CFAbsoluteTime) morningTimeInThatDay;


/*
	底層 API: 某一日食物List (食物，重量，卡路里)
	return a list of FoodTaken object, sorted by time descedning

Sample Codes:
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime todayMorningTime=[OmniTool getMorningTime:CFAbsoluteTimeGetCurrent()];
	
	// taken yesterday
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1001] WeightGram:300 AtTime:todayMorningTime-500];
	// taken today
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:todayMorningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:todayMorningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1003] WeightGram:80 AtTime:todayMorningTime+31500];
	

	timeCheck = CFAbsoluteTimeGetCurrent();
	NSMutableArray * foodsTakenList=[OmniTool getFoodsTakenAtDate:2013 Month:7 Day:15];
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));

	for(FoodTaken *ft in foodsTakenList)
	{
		[ft printInfo];
	}
	
	NSLog(@"====== Orange Test Area END ======");
Execution Result:
2013-07-15 16:13:24.436 iPadNutritionScaleWithStoryBoard[29172:907] ====== Orange Test Area ======
2013-07-15 16:13:24.505 iPadNutritionScaleWithStoryBoard[29172:907] Execution time=0.015 second(s).
2013-07-15 16:13:24.506 iPadNutritionScaleWithStoryBoard[29172:907] ======== FoodTaken ========
2013-07-15 16:13:24.507 iPadNutritionScaleWithStoryBoard[29172:907] Food(1003)=[Butter oil, anhydrous] group=[Dairy and Egg Products] title=[Butter oil,Anhydrous] sub title=[]
2013-07-15 16:13:24.508 iPadNutritionScaleWithStoryBoard[29172:907] **** foodWeightGram =80.0000
2013-07-15 16:13:24.509 iPadNutritionScaleWithStoryBoard[29172:907] **** foodCalaries  	=700.8000
2013-07-15 16:13:24.510 iPadNutritionScaleWithStoryBoard[29172:907] **** takeTime		=22:45:00
2013-07-15 16:13:24.514 iPadNutritionScaleWithStoryBoard[29172:907] ======== FoodTaken ========
2013-07-15 16:13:24.515 iPadNutritionScaleWithStoryBoard[29172:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter,Whipped] sub title=[With salt]
2013-07-15 16:13:24.516 iPadNutritionScaleWithStoryBoard[29172:907] **** foodWeightGram =70.0000
2013-07-15 16:13:24.517 iPadNutritionScaleWithStoryBoard[29172:907] **** foodCalaries  	=501.9000
2013-07-15 16:13:24.518 iPadNutritionScaleWithStoryBoard[29172:907] **** takeTime		=17:11:40
2013-07-15 16:13:24.518 iPadNutritionScaleWithStoryBoard[29172:907] ======== FoodTaken ========
2013-07-15 16:13:24.519 iPadNutritionScaleWithStoryBoard[29172:907] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter,Whipped] sub title=[With salt]
2013-07-15 16:13:24.520 iPadNutritionScaleWithStoryBoard[29172:907] **** foodWeightGram =30.0000
2013-07-15 16:13:24.521 iPadNutritionScaleWithStoryBoard[29172:907] **** foodCalaries  	=215.1000
2013-07-15 16:13:24.523 iPadNutritionScaleWithStoryBoard[29172:907] **** takeTime		=14:08:20
2013-07-15 16:13:24.524 iPadNutritionScaleWithStoryBoard[29172:907] ====== Orange Test Area END ======
*/
+(NSMutableArray *) getFoodsTakenAtDate:(int)year Month:(int)month Day:(int)day;

/*
	底層 API: 刪除某一筆攝取記錄

Sample Codes:
	CFAbsoluteTime timeCheck;
	NSLog(@"====== Orange Test Area ======");

	[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime todayMorningTime=[OmniTool getMorningTime:CFAbsoluteTimeGetCurrent()];
	
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:todayMorningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:todayMorningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1003] WeightGram:80 AtTime:todayMorningTime+31500];

	NSMutableArray * foodsTakenList=[OmniTool getFoodsTakenToday];
	
	FoodTaken *foodTakenRecord=[foodsTakenList objectAtIndex:0];
	
	timeCheck = CFAbsoluteTimeGetCurrent();
	[OmniTool deleteFoodTake:foodTakenRecord];	// delete one record
	NSLog(@"Execution time=%.3f second(s).",(CFAbsoluteTimeGetCurrent()-timeCheck));


	foodsTakenList=[OmniTool getFoodsTakenToday];	// get the list again.
	for(FoodTaken *ft in foodsTakenList)
	{
		[ft printInfo];
	}
	
	NSLog(@"====== Orange Test Area END ======");

Execution Result:
2013-07-16 23:46:51.973 iPadNutritionScaleWithStoryBoard[35976:c07] ====== Orange Test Area ======
2013-07-16 23:46:51.988 iPadNutritionScaleWithStoryBoard[35976:c07] Execution time=0.002 second(s).
2013-07-16 23:46:51.990 iPadNutritionScaleWithStoryBoard[35976:c07] ======== FoodTaken ========
2013-07-16 23:46:51.990 iPadNutritionScaleWithStoryBoard[35976:c07] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter,Whipped] sub title=[With salt]
2013-07-16 23:46:51.991 iPadNutritionScaleWithStoryBoard[35976:c07] **** foodWeightGram =70.0000
2013-07-16 23:46:51.991 iPadNutritionScaleWithStoryBoard[35976:c07] **** foodCalaries  	=501.9000
2013-07-16 23:46:51.991 iPadNutritionScaleWithStoryBoard[35976:c07] **** takeTime		=16:11:40
2013-07-16 23:46:51.991 iPadNutritionScaleWithStoryBoard[35976:c07] ======== FoodTaken ========
2013-07-16 23:46:51.991 iPadNutritionScaleWithStoryBoard[35976:c07] Food(1002)=[Butter, whipped, with salt] group=[Dairy and Egg Products] title=[Butter,Whipped] sub title=[With salt]
2013-07-16 23:46:51.992 iPadNutritionScaleWithStoryBoard[35976:c07] **** foodWeightGram =30.0000
2013-07-16 23:46:51.992 iPadNutritionScaleWithStoryBoard[35976:c07] **** foodCalaries  	=215.1000
2013-07-16 23:46:51.993 iPadNutritionScaleWithStoryBoard[35976:c07] **** takeTime		=13:08:20
2013-07-16 23:46:51.993 iPadNutritionScaleWithStoryBoard[35976:c07] ====== Orange Test Area END ======

*/
+(void)	deleteFoodTake:(FoodTaken *)foodTakeRecord;

+(void) insertWeekTestData;

+(void) setButtonColor:(UIButton*)boxButton Color:(UIColor *)color Debug:(BOOL)doDebug;	// set color of high color and normal color together

+(BOOL) isScaleConnected;
// either manual input, or connected to scale. There's a weight can use
+(BOOL) existWeightInput;
+(void) checkUIViewFrame:(UIView *)view Tag:(NSString *)tag;

+(CGRect) frameShift:(CGRect)rect Y:(int) shiftY;

//	triangleImage.frame 應該設為 kcalVirtualGraphic.x, kcalVirtualGraphic.y-triangleImage.height
+(void) adjustTriangleImage:(UIImageView*) triangleImage ReferenceFrame:(CGRect)refFrame;

+(void) loadCertifiedBLENames;
+(UIInterfaceOrientation) getCurrentOrientation;


// 將所有的View 截圖變成image。
+ (UIImage *) imageWithView:(UIView *)view;
+ (UIImage *) imageWithViewBackground:(UIView *)view;
+(void)addNutrientOverview:(NutrientOverview *)targetOverview FromFoodOverview:(FoodOverview *)sourceOverview;
+(void) printInfoNSData:(NSData*) data;

// 初始化 CurrentMeal 全域變數；重覆呼叫會再重新初始化一次
+(void) initialCurrentMeal;
// 取得 CurrentMeal 
+(Meal *) getCurrentMeal;

+(Food *)getFoodWithNumber:(unsigned int)foodNumber;

/*
    initialHardcodedMeals usage example:

 
 NSLog(@"********** CapreseSalad **********");
 //    [CapreseSalad printInfo];
 NutrientOverview *overview = [CapreseSalad getNutrientOverviewForUserType:1];
 NSLog(@"--SUGAR nutrient--");
 Nutrient *sugar=[overview getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
 [sugar printInfo];
 
 NSLog(@"--Sodium nutrient--");
 Nutrient *sodium=[overview getNutrientWithInt:NUTRIENT_SODIUM];
 [sodium printInfo];
 
 NSLog(@"--Fat nutrient--");
 Nutrient *fat=[overview getNutrientWithInt:NUTRIENT_TOTALLIPID];
 [fat printInfo];
 NSLog(@"--Kcal nutrient--");
 Nutrient *kcal=[overview getNutrientWithInt:NUTRIENT_ENERGYKCAL];
 [kcal printInfo];
 
 NSLog(@"********** Tomato Spaghetti **********");
 //    [TomatoSpaghetti printInfo];
 NutrientOverview *overview1 = [TomatoSpaghetti getNutrientOverviewForUserType:1];
 NSLog(@"--SUGAR nutrient--");
 Nutrient *sugar1=[overview1 getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
 [sugar1 printInfo];
 
 NSLog(@"--Sodium nutrient--");
 Nutrient *sodium1=[overview1 getNutrientWithInt:NUTRIENT_SODIUM];
 [sodium1 printInfo];
 
 NSLog(@"--Fat nutrient--");
 Nutrient *fat1=[overview1 getNutrientWithInt:NUTRIENT_TOTALLIPID];
 [fat1 printInfo];
 
 NSLog(@"--Kcal nutrient--");
 Nutrient *kcal1=[overview1 getNutrientWithInt:NUTRIENT_ENERGYKCAL];
 [kcal1 printInfo];
 
 NSLog(@"********** Fresh Berries Ice Cream **********");
 //    [TomatoSpaghetti printInfo];
 NutrientOverview *overview2 = [FreshBerriesIceCream getNutrientOverviewForUserType:1];
 NSLog(@"--SUGAR nutrient--");
 Nutrient *sugar2=[overview2 getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
 [sugar2 printInfo];
 
 NSLog(@"--Sodium nutrient--");
 Nutrient *sodium2=[overview2 getNutrientWithInt:NUTRIENT_SODIUM];
 [sodium2 printInfo];
 
 NSLog(@"--Fat nutrient--");
 Nutrient *fat2=[overview2 getNutrientWithInt:NUTRIENT_TOTALLIPID];
 [fat2 printInfo];
 
 NSLog(@"--Kcal nutrient--");
 Nutrient *kcal2=[overview2 getNutrientWithInt:NUTRIENT_ENERGYKCAL];
 [kcal2 printInfo];
 
 NSLog(@"********** Chicken Vegetable Salad **********");
 //    [TomatoSpaghetti printInfo];
 NutrientOverview *overview3 = [ChickenVegetablesSalad getNutrientOverviewForUserType:1];
 NSLog(@"--SUGAR nutrient--");
 Nutrient *sugar3=[overview3 getNutrientWithInt:NUTRIENT_CARBOHYDRATE];
 [sugar3 printInfo];
 
 NSLog(@"--Sodium nutrient--");
 Nutrient *sodium3=[overview3 getNutrientWithInt:NUTRIENT_SODIUM];
 [sodium3 printInfo];
 
 NSLog(@"--Fat nutrient--");
 Nutrient *fat3=[overview3 getNutrientWithInt:NUTRIENT_TOTALLIPID];
 [fat3 printInfo];
 
 NSLog(@"--Kcal nutrient--");
 Nutrient *kcal3=[overview3 getNutrientWithInt:NUTRIENT_ENERGYKCAL];
 [kcal3 printInfo];
 */
+(void) initialHardcodedMeals;

// APP 內部廣播系統，確保頁面切來切去訊息仍然會送到
+(void) addMinnaListener:(id<MinnaNotificationProtocol>) listener;
+(void) broadcastMinnaMessage:(NSString *)broadcastMessage;

// for debug C string message, need to print out CR LF
+(NSString *) CStringToNSString:(char *) cString ReplaceCRLF:(BOOL) replaceCRLF;

@end
