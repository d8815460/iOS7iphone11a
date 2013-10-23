//
//  CircleDrawer.h
//  KitchenScale
//
//  Created by Orange on 13/5/2.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleDrawer : UIView
{
	BOOL isRed;
    BOOL isYellow;
    BOOL isGreen;
	float lastDrawPercentage;
}

- (id)initWithPosition:(CGPoint)position
                radius:(float)radius
        internalRadius:(float)internalRadius
     circleStrokeColor:(UIColor *)circleStrokeColor
activeCircleStrokeColor:(UIColor *)activeCircleStrokeColor;

- (void) drawPercentage:(float)percentage Rda:(float)Rda;
- (void) setRedColor:(BOOL) bRed;
- (BOOL) getRedColor;
- (void) setYellowColor:(BOOL) bYellow;
- (BOOL) getYellowColor;
- (void) setGreenColor:(BOOL) bGreen;
- (BOOL) getGreenColor;
@end
