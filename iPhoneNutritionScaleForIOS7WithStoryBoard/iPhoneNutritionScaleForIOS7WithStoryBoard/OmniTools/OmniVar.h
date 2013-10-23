//
//  OmniVar.h
//  KitchenScale
//
//  Created by Orange on 13/4/3.
//  Copyright (c) 2013年 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import "Meal.h"
#import "Ingredient.h"

// #define DEBUG_LOG_TIMER		// check all the timers for performance tuning

// #define DEBUG_STATE_TRANSITION	// check for the state transition

// #define DEBUG_SCALE_COMMAND
// #define DEBUG_SQL

// #define DEBUG_LINE_CHART

// #define ORANGE_TEST

extern double inputWeight;
// 	input weight from scale
extern double inputWeight;
extern int inputWeightUnit;
// 	simulated weight for smooth display
extern double simulatedWeight;
extern double targetSimulationWeight;
extern double simulationVelocity;
// 	translated weight for user selected unit
extern double translatedWeight;
extern int translatedWeightUnit;

extern    int n_battery;
extern    int n_connectRetry;

extern bool scaleNetStatus; // YES: net on,  NO: net off
extern bool scaleStableStatus; // scale stable status

extern BOOL connectingPeripheral;	// avoid try to connect Peripheral again and again during connecting.

#define STATE_NONE			0
#define STATE_TUTORIAL		1
#define STATE_NO_SCALE		2
#define STATE_BT_TUTORIAL	3
#define STATE_MAIN			4
#define STATE_MENU			5
#define STATE_ABOUT			6

// for performance tuning issues
extern CFAbsoluteTime check_time1;
extern CFAbsoluteTime check_time2;
extern CFAbsoluteTime check_time3;
extern CFAbsoluteTime check_time4;
extern CFAbsoluteTime check_time5;
extern CFAbsoluteTime check_time6;
extern CFAbsoluteTime check_time7;
extern CFAbsoluteTime check_time8;
extern CFAbsoluteTime check_time9;
extern CFAbsoluteTime check_time10;
extern CFAbsoluteTime check_time11;
extern CFAbsoluteTime check_time12;
extern CFAbsoluteTime check_time13;
extern CFAbsoluteTime check_time14;
extern CFAbsoluteTime check_time15;

extern CFAbsoluteTime	timer0TotalTime;	// in seconds
extern CFAbsoluteTime	timer0EndTime;		// in seconds
/*
	timerState
		0: initial
		1: running
		2: pause
		3: end
*/
extern int timer0State;
extern CFAbsoluteTime	timer0RemindTime;	// in seconds

extern CFAbsoluteTime	timer1TotalTime;	// in seconds
extern CFAbsoluteTime	timer1EndTime;		// in seconds
/*
	timerState
		0: initial
		1: running
		2: pause
		3: end
*/
extern int timer1State;
extern CFAbsoluteTime	timer1RemindTime;	// in seconds

extern CFAbsoluteTime	timer2TotalTime;	// in seconds
extern CFAbsoluteTime	timer2EndTime;		// in seconds
/*
	timerState
		0: initial
		1: running
		2: pause
		3: end
*/
extern int timer2State;
extern CFAbsoluteTime	timer2RemindTime;	// in seconds

extern CFAbsoluteTime	timer3TotalTime;	// in seconds
extern CFAbsoluteTime	timer3EndTime;		// in seconds
/*
	timerState
		0: initial
		1: running
		2: pause
		3: end
*/
extern int timer3State;
extern CFAbsoluteTime	timer3RemindTime;	// in seconds

extern CFAbsoluteTime	timer4TotalTime;	// in seconds
extern CFAbsoluteTime	timer4EndTime;		// in seconds
/*
	timerState
		0: initial
		1: running
		2: pause
		3: end
*/
extern int timer4State;
extern CFAbsoluteTime	timer4RemindTime;	// in seconds
extern CFAbsoluteTime	timer5TotalTime;	// in seconds
extern CFAbsoluteTime	timer5EndTime;		// in seconds
/*
	timerState
		0: initial
		1: running
		2: pause
		3: end
*/
extern int timer5State;
extern CFAbsoluteTime	timer5RemindTime;	// in seconds


//今日食物的累積
extern NSMutableArray *todayAccumulativeArray;


// a cache for getFoodRDA
// NSMutableDictionary(foodNumber->NSMutableDictionary(NSNumber:userType->NSMutableArray))
// saved percentage and value are only for 100g food
extern NSMutableDictionary *foodRDAdictionary;

//extern FirstTimerViewController *secViewController;

extern bool m_isLandscape;
extern UIInterfaceOrientation orientation;

typedef enum {
	CONNECTION_STATE_BT_NOT_READY,	// Initial, BT not start
	CONNECTION_STATE_BT_READY,	// BT ready, waiting for order ,activePeripheral =nil
	CONNECTION_STATE_SEARCHING,	// searching for peripherals, either activeperipheral connected or not
	CONNECTION_STATE_CONNECTED,	// Connected, not scanning
	CONNECTION_STATE_NOT_CONNECTED,	// activePeripheral not nil, not connected
	CONNECTION_STATE_CONNECTING,
	CONNECTION_STATE_CONNECTION_FAILD
} ConnectionState;

typedef enum {
	WEEK_DAY_MONDAY=1,	// Initial, BT not start
	WEEK_DAY_TUESDAY,	// BT ready, waiting for order ,activePeripheral =nil
	WEEK_DAY_WEDNESDAY,	// searching for peripherals, either activeperipheral connected or not
	WEEK_DAY_THURSDAY,	// Connected, not scanning
	WEEK_DAY_FRIDAY,	// activePeripheral not nil, not connected
	WEEK_DAY_SATURDAY,
	WEEK_DAY_SUNDAY
} WEEK_DAY;

#define SECONDS_IN_ONE_DAY 86400

#define NUTRIENT_ENERGYKCAL          208
#define NUTRIENT_CAFFEINE            262
#define NUTRIENT_CALCIUM             301
#define NUTRIENT_CARBOHYDRATE        205
#define NUTRIENT_CHOLESTEROL         601
#define NUTRIENT_CHOLINE             421
#define NUTRIENT_COPPER              312
#define NUTRIENT_FIBER               291
#define NUTRIENT_FLUORIDE            313
#define NUTRIENT_FOLATE              417
#define NUTRIENT_IRON                303
#define NUTRIENT_MAGNESIUM           304
#define NUTRIENT_MANGANESE           315
#define NUTRIENT_NIACIN              406
#define NUTRIENT_PANTOTHENICACID     410
#define NUTRIENT_PHOSPHORUS          305
#define NUTRIENT_POTASSIUM           306
#define NUTRIENT_PROTEIN             203
#define NUTRIENT_RIBOFLAVIN          405
#define NUTRIENT_SELENIUM            317
#define NUTRIENT_SODIUM              307
#define NUTRIENT_SUGARS              269
#define NUTRIENT_THIAMIN             404
#define NUTRIENT_TOTALLIPID          204
#define NUTRIENT_VITAMINA            320
#define NUTRIENT_VITAMINB12          418
#define NUTRIENT_VITAMINB6           415
#define NUTRIENT_VITAMINC            401
#define NUTRIENT_VITAMIND            328
#define NUTRIENT_VITAMINE            323
#define NUTRIENT_VITAMINK            430
#define NUTRIENT_WATER               255
#define NUTRIENT_ZINC	        	309

extern UIColor *orangeColorKey;
extern UIColor *lightOrangeColorKey;
extern UIColor *purpleColorKey;
extern UIColor *lightPurpleColorKey;
extern UIColor *blueColorKey;
extern UIColor *lightBlueColorKey;
extern UIColor *brownColorKey;
extern UIColor *lightBrownColorKey;
extern UIColor *redColorKey;
extern UIColor *lightRedColorKey;

#define GREEN_TEXT_COLOR [UIColor colorWithRed:62.0f/255.0f green:115.0f/255.0f blue:0.0f/255.0f alpha:1.0]

#define ZERO_BOTTOMLINE_HEIGHT 5

extern NSMutableDictionary *certifiedDeviceUUIDDictionary;
extern NSMutableDictionary *certifiedDeviceNameDictionary;

extern BOOL isInputWeightView;

// ************* NutritionViewController usage global variables ***************
extern Food *nutritionViewSelectedFood;


#define IPHONE11_DARK_GREEN_COLOR [UIColor colorWithRed:45/255.0f green:180.0f/255.0f blue:115.0f/255.0f alpha:1.0]
#define IPHONE11_LIGHT_GREEN_COLOR [UIColor colorWithRed:116.0f/255.0f green:196.0f/255.0f blue:151.0f/255.0f alpha:1.0]

extern Meal *__currentMeal;

extern Meal *CapreseSalad;
extern Meal *TomatoSpaghetti;
extern Meal *FreshBerriesIceCream;
extern Meal *ChickenVegetablesSalad;

extern Ingredient *selectedIngredient;

#define MINNA_FONT_8 [UIFont fontWithName:@"HelveticaNeue-Light" size: 8.0f]
#define MINNA_FONT_9 [UIFont fontWithName:@"HelveticaNeue-Light" size: 9.0f]
#define MINNA_FONT_10 [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f]
#define MINNA_FONT_11 [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f]
#define MINNA_FONT_12 [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]
#define MINNA_FONT_13 [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]
#define MINNA_FONT_14 [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
#define MINNA_FONT_15 [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]
#define MINNA_FONT_16 [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
#define MINNA_FONT_17 [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]
#define MINNA_FONT_18 [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]
#define MINNA_FONT_19 [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f]
#define MINNA_FONT_20 [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f]
#define MINNA_FONT_21 [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f]
#define MINNA_FONT_22 [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f]
#define MINNA_FONT_23 [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0f]
#define MINNA_FONT_24 [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0f]
#define MINNA_FONT_25 [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0f]
#define MINNA_FONT_26 [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0f]
#define MINNA_FONT_27 [UIFont fontWithName:@"HelveticaNeue-Light" size:27.0f]
#define MINNA_FONT_28 [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0f]


// ***************** Share To Facebook Switch *****************

extern BOOL isFacebookSwitchOn;
