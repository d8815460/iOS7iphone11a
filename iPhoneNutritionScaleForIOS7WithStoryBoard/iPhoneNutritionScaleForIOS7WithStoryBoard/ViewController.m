//
//  ViewController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "ViewController.h"
#import "FoodViewController.h"
#import "SharingViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize foodView;
@synthesize sendArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // add into minna message Listener list
    [OmniTool addMinnaListener:self];
    self.messageView=[[MinnaMessageView alloc] initWithFrame:CGRectMake(0,-45,320,44)];
    [self.view addSubview:self.messageView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstBigImageButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ToFoodView" sender:sender];
}

- (IBAction)secondImageButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ToFoodView" sender:sender];
}

- (IBAction)thirdImageButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ToFoodView" sender:sender];
}

- (IBAction)fourthImageButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ToFoodView" sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *btn = sender;
    
    self.foodView = (FoodViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"foodView"];
    self.foodView = [segue destinationViewController];
    
    
    // ensure this is the Seque which is leading to the detail view
    if ([[segue identifier] isEqualToString:@"ToFoodView"])
    {
        self.sendArray = nil;
        
        switch (btn.tag) {
            case 100:
                //第一筆食物數值, Chicken Vegetable Salad
                //傳送資料含蓋合成後的照片、食物的最後紀錄、食物名稱、等資料
//                [ChickenVegetablesSalad printInfo];
                [self.foodView setDetailItem:btn];
                break;
            case 101:
                //第二筆食物數值, CapreseSalad
//                [CapreseSalad printInfo];
                [self.foodView setDetailItem:btn];
                break;
            case 102:
                //第三筆食物數值, Freshberriesicecream
//                [FreshBerriesIceCream printInfo];
                [self.foodView setDetailItem:btn];
                break;
            case 103:
                //第四筆食物數值, TomatoSpaghetti
//                [TomatoSpaghetti printInfo];
                [self.foodView setDetailItem:btn];
                break;
            default:
                break;
        }
    }
}
#pragma mark - MinnaNotificationProtocol

-(void) MinnaMessage:(NSString *)message
{
//    NSLog(@"Got Minna Broadcast message: %@",message);
    [self.messageView setMessage:message];
}

-(NSNumber *) MinnaListenerID
{
    return [[NSNumber alloc] initWithInt:1];
}

- (void) SharingViewControllerDidShare:(SharingViewController *)controller Aboutmessange:(NSString *)string{
    NSLog(@"Got Minna Broadcast message: %@",string);
}

@end
