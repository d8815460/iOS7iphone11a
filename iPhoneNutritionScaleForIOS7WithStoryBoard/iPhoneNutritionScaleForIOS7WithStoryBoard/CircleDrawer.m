//
//  CircleDrawer.m
//  KitchenScale
//
//  Created by Orange on 13/5/2.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import "CircleDrawer.h"


@interface CircleDrawer ()

@property float radius;
@property float interalRadius;
@property (nonatomic, strong) UIColor *circleStrokeColor;
@property (nonatomic, strong) UIColor *activeCircleStrokeColor;
@property float percentageCompleted;
@end

@implementation CircleDrawer
- (id)initWithPosition:(CGPoint)position
                radius:(float)radius
        internalRadius:(float)internalRadius
     circleStrokeColor:(UIColor *)circleStrokeColor
activeCircleStrokeColor:(UIColor *)activeCircleStrokeColor
{
    self = [super initWithFrame:CGRectMake(position.x, position.y, radius * 2, radius * 2)];
    if (self) {
        self.radius = radius;
        self.interalRadius = internalRadius;
        self.circleStrokeColor = circleStrokeColor;
        self.activeCircleStrokeColor = activeCircleStrokeColor;
        
	    self.backgroundColor = [UIColor clearColor];
	    self.percentageCompleted = 0.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //General circle info
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    float strokeWidth = self.radius - self.interalRadius;
    float radius = self.interalRadius + strokeWidth / 2;

    //Background circle
    UIBezierPath *circle1 = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:radius
                                                       startAngle:DEGREES_TO_RADIANS(0.0f)
                                                         endAngle:DEGREES_TO_RADIANS(360.0f)
                                                        clockwise:YES];
    if (isRed == YES) {
        self.circleStrokeColor =  [UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.25f];
        [self.circleStrokeColor setStroke];
    }else if (isYellow == YES){
        self.circleStrokeColor = [UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.25f];
        [self.circleStrokeColor setStroke];
    }else if (isGreen == YES){
        self.circleStrokeColor = [UIColor colorWithRed:134.0f/255.0f green:165.0f/255.0f blue:56.0f/255.0f alpha:0.25f];
        [self.circleStrokeColor setStroke];
    }
    
    circle1.lineWidth = strokeWidth;
    [circle1 stroke];
    
    //Active circle
    float startAngle = 0.0f;
    float degrees = 360.0f;
    
    if (isRed == YES ) {
        [[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.75f] setStroke];
    }else if (isYellow == YES){
        [[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.75f] setStroke];
    }else if (isGreen == YES){
        [[UIColor colorWithRed:134.0f/255.0f green:165.0f/255.0f blue:56.0f/255.0f alpha:0.75f] setStroke];
    }
    
    startAngle = 270.0f;
    float tempDegrees = self.percentageCompleted * 360.0 / 100.f;
    degrees = (tempDegrees < 90) ? (270 + tempDegrees) : (tempDegrees - 90);
    
    UIBezierPath *circle2 = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:radius
                                                       startAngle:DEGREES_TO_RADIANS(startAngle)
                                                         endAngle:DEGREES_TO_RADIANS(degrees)
                                                        clockwise:YES];

    circle2.lineWidth = strokeWidth;
    [circle2 stroke];

}

- (void) drawPercentage:(float)percentage Rda:(float)Rda
{
	if(percentage<0)
	    self.percentageCompleted = 0.0f;
	else if(percentage>100)
	    self.percentageCompleted = 100.0f;
	else
	    self.percentageCompleted = percentage;

	// to reduce the time to draw, set a barrier here
//	if(fabsf(self.percentageCompleted -lastDrawPercentage)<0.1)
//		return;
	lastDrawPercentage=self.percentageCompleted;
    [self setNeedsDisplay];
}
- (void) setRedColor:(BOOL) bRed
{
    if (bRed) {
        isYellow = NO;
        isGreen = NO;
        isRed = bRed;
    }
}
- (BOOL) getRedColor
{
	return isRed;
}

- (void) setYellowColor:(BOOL) bYellow
{
    if (bYellow) {
        isYellow = bYellow;
        isGreen = NO;
        isRed = NO;
    }
}
- (BOOL) getYellowColor
{
	return isYellow;
}

- (void) setGreenColor:(BOOL) bGreen
{
    if (bGreen) {
        isYellow = NO;
        isGreen = bGreen;
        isRed = NO;
    }
}
- (BOOL) getGreenColor
{
	return isGreen;
}

@end
