//
//  NutrientOverview.h
//  iPhoneNutritionScaleForIOS6WithStoryBoard
//
//  Created by Orange Chang on 13/9/25.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nutrient.h"
@interface NutrientOverview : NSObject
{
    // nutrientNumber -> Nutrient
    NSMutableDictionary *nutrientDictionary;
}
@property (strong,nonatomic) NSMutableDictionary *nutrientDictionary;

-(Nutrient *) getNutrient:(NSNumber *)nutrientNumber;
-(Nutrient *) getNutrientWithInt:(int)nutrientNumber;
-(void) printInfo;

@end
