//
//  ViewController.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodViewController.h"
#import "SharingViewController.h"

@interface ViewController : UIViewController<MinnaNotificationProtocol, SharingViewControllerDelegate>
{
    
}
@property (nonatomic, strong) FoodViewController    *foodView;
@property (nonatomic, strong) NSMutableArray        *sendArray;
@property (nonatomic, strong) MinnaMessageView      *messageView;


- (IBAction)firstBigImageButtonPressed:(id)sender;
- (IBAction)secondImageButtonPressed:(id)sender;
- (IBAction)thirdImageButtonPressed:(id)sender;
- (IBAction)fourthImageButtonPressed:(id)sender;
@end
