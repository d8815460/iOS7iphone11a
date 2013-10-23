//
//  OmniVar.m
//  KitchenScale
//
//  Created by Orange on 13/4/3.
//  Copyright (c) 2013年 Orange. All rights reserved.
//

#import "OmniVar.h"

// *************** simulation variables  ******************
// 	input weight from scale
double inputWeight;
int inputWeightUnit;
// 	simulated weight for smooth display
double simulatedWeight;
double targetSimulationWeight;
double simulationVelocity;
// 	translated weight for user selected unit
double translatedWeight;
int translatedWeightUnit;
// *************** simulation variables  ******************

int n_battery;
int n_connectRetry;
bool scaleNetStatus;	// NET sign on the scale
bool scaleStableStatus; // scale stable status
// for performance tuning issues
CFAbsoluteTime check_time1;
CFAbsoluteTime check_time2;
CFAbsoluteTime check_time3;
CFAbsoluteTime check_time4;
CFAbsoluteTime check_time5;
CFAbsoluteTime check_time6;
CFAbsoluteTime check_time7;
CFAbsoluteTime check_time8;
CFAbsoluteTime check_time9;
CFAbsoluteTime check_time10;
CFAbsoluteTime check_time11;
CFAbsoluteTime check_time12;
CFAbsoluteTime check_time13;
CFAbsoluteTime check_time14;
CFAbsoluteTime check_time15;

BOOL connectingPeripheral;	// avoid try to connect Peripheral again and again during connecting.

// Timer No.1 setting
CFAbsoluteTime	timer0TotalTime;	// in seconds
CFAbsoluteTime	timer1TotalTime;	// in seconds
CFAbsoluteTime	timer2TotalTime;	// in seconds
CFAbsoluteTime	timer3TotalTime;	// in seconds
CFAbsoluteTime	timer4TotalTime;	// in seconds
CFAbsoluteTime	timer5TotalTime;	// in seconds
CFAbsoluteTime	timer0EndTime;		// in seconds
CFAbsoluteTime	timer1EndTime;		// in seconds
CFAbsoluteTime	timer2EndTime;		// in seconds
CFAbsoluteTime	timer3EndTime;		// in seconds
CFAbsoluteTime	timer4EndTime;		// in seconds
CFAbsoluteTime	timer5EndTime;		// in seconds
CFAbsoluteTime	timer0RemindTime;	// in seconds
CFAbsoluteTime	timer1RemindTime;	// in seconds
CFAbsoluteTime	timer2RemindTime;	// in seconds
CFAbsoluteTime	timer3RemindTime;	// in seconds
CFAbsoluteTime	timer4RemindTime;	// in seconds
CFAbsoluteTime	timer5RemindTime;	// in seconds
int timer0State;
int timer1State;
int timer2State;
int timer3State;
int timer4State;
int timer5State;


//今日食物的累積
NSMutableArray *todayAccumulativeArray;

// a cache for getFoodRDA
// NSMutableDictionary(foodNumber->NSMutableDictionary(NSNumber:userType->NSMutableArray))
// saved percentage and value are only for 100g food
NSMutableDictionary *foodRDAdictionary;

// timer viewController
//FirstTimerViewController *secViewController;

bool m_isLandscape;
UIInterfaceOrientation orientation;

UIColor *whiteColorKey;
UIColor *orangeColorKey;
UIColor *lightOrangeColorKey;
UIColor *purpleColorKey;
UIColor *lightPurpleColorKey;
UIColor *blueColorKey;
UIColor *lightBlueColorKey;
UIColor *brownColorKey;
UIColor *lightBrownColorKey;
UIColor *redColorKey;
UIColor *lightRedColorKey;

NSMutableDictionary *certifiedDeviceUUIDDictionary;

NSMutableDictionary *certifiedDeviceNameDictionary;

BOOL isInputWeightView;

// ************* NutritionViewController usage global variables ***************
Food *nutritionViewSelectedFood;
Meal *__currentMeal;

Meal *CapreseSalad;
Meal *TomatoSpaghetti;
Meal *FreshBerriesIceCream;
Meal *ChickenVegetablesSalad;
Ingredient *selectedIngredient;



// ************* Share Facebook Switch *****************
BOOL isFacebookSwitchOn;
