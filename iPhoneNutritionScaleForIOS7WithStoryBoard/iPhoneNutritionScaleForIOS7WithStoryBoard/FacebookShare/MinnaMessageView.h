//
//  MinnaMessageView.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by Orange Chang on 13/10/13.
//  Copyright (c) 2013年 Proch Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinnaMessageView : UIView
{
    UILabel *messageLabel;
    UIButton *dismissButton;
    int messageNumber;    // used to prevent multiple call of setMessage to close the window too fast
    NSTimer *blinkTimer;
}
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *dismissButton;

// set message, and will automatically dismiss after 3 seconds
-(void) setMessage:(NSString *)message;

@end
