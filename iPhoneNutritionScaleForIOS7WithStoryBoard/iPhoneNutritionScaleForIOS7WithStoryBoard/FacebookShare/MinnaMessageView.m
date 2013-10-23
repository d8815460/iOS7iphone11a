//
//  MinnaMessageView.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by Orange Chang on 13/10/13.
//  Copyright (c) 2013年 Proch Technology. All rights reserved.
//

#import "MinnaMessageView.h"

@implementation MinnaMessageView
@synthesize  dismissButton;
@synthesize messageLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // [self.layer setBorderWidth:1.0];
        // [self.layer setBorderColor:[[UIColor yellowColor] CGColor]];
        [self setOpaque:NO];
        [self setBackgroundColor:IPHONE11_DARK_GREEN_COLOR];
        
        //create the button
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //set the position of the button
        self.dismissButton.frame = CGRectMake(283, 10, 24,24);
        dismissButton.backgroundColor=[UIColor clearColor];
		
//        [dismissButton setTitle:@"X" forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
         UIImage *btnImage = [UIImage imageNamed:@"x_cancel.png"];
		 [dismissButton setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        //listen for clicks
        [self.dismissButton addTarget:self action:@selector(buttonPressed)
         forControlEvents:UIControlEventTouchUpInside];
        
        //add the button to the view
        [self addSubview:self.dismissButton];
        NSLog(@"button color: %@",dismissButton.backgroundColor);

		messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 275, 44)];
	    messageLabel.backgroundColor = [UIColor clearColor];
	    messageLabel.textAlignment = NSTextAlignmentCenter;
	    messageLabel.text = @"Minna message";
        messageLabel.font=MINNA_FONT_16;
        messageLabel.textColor=[UIColor whiteColor];
	    [self addSubview:messageLabel];
        
        messageNumber=0;
        self.hidden=YES;
    }
    return self;
}
-(void)buttonPressed {
//    NSLog(@"Button Pressed!");
    [self deActivate];
}
// set message, and will automatically dismiss after 3 seconds
-(void) setMessage:(NSString *)message
{
#ifdef ENABLE_BLINK_TIMER
    if(!blinkTimer)
        blinkTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:YES];
#endif
    messageNumber++;
    if(self.hidden==YES)
        [self activate];
    messageLabel.text=message;
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        messageNumber--;
        if(messageNumber==0){
            [self deActivate];
//            NSLog(@"hide Minna message");
        }else{
//            NSLog(@"Minna message number : %d",messageNumber);
        }
    });
}
-(void) activate
{
    self.hidden=NO;
    [UIView animateWithDuration:.5 animations:^(void){
        self.frame = CGRectMake(0, 0, 320, 44);
    }completion:^(BOOL finished){
    }];
}

-(void) deActivate
{
    [UIView animateWithDuration:.5 animations:^(void){
        self.frame = CGRectMake(0, -45, 320, 44);
    }completion:^(BOOL finished){
        self.hidden=YES;
    }];
    
#ifdef ENABLE_BLINK_TIMER
    [blinkTimer invalidate];
    blinkTimer=nil;
#endif
}
-(void)onTick:(NSTimer *)timer {
    if(messageLabel.textColor==[UIColor whiteColor])
        messageLabel.textColor=[UIColor yellowColor];
    else
        messageLabel.textColor=[UIColor whiteColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
