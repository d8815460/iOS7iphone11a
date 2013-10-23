//
//  SharingViewController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "SharingViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIImage+ResizeAdditions.h"
#import "MyLogInViewController.h"
#import "MBProgressHUD.h"

@interface SharingViewController (){
    NSMutableData *_data;   //FB之照片資料
    BOOL firstLaunch;
}
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@property (strong, nonatomic) NSMutableDictionary *storyObject;
@property (nonatomic, strong) PFObject *photoObject;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;         //定時器追蹤朋友Follow
@end

@implementation SharingViewController
@synthesize detailItem = _detailItem;
@synthesize cameraView = _cameraView;
@synthesize commentTextView = _commentTextView;
@synthesize TextViewBackground = _TextViewBackground;
@synthesize facebookSwitch = _facebookSwitch;
@synthesize placeholderLabel = _placeholderLabel;
@synthesize finalImage = _finalImage;
@synthesize cropper;
@synthesize photoFile;
@synthesize thumbnailFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;
@synthesize photoObject;
@synthesize hud;
@synthesize autoFollowTimer;
@synthesize activity;
@synthesize delegate;


- (void)setDetailItem:(id)detailItem{
    if (_detailItem != detailItem) {
        _detailItem = detailItem;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"view will appear , %i", isFacebookSwitchOn);
    if (isFacebookSwitchOn) {
        NSLog(@"view will appear 1");
        self.facebookSwitch.on = YES;
        BOOL preesed = [self.facebookSwitch isOn];
        [self setFBButtonState:preesed];
        self.saveButton.title = @"Share";
    }else{
        NSLog(@"view will appear 2");
        self.facebookSwitch.on = NO;
        BOOL preesed = [self.facebookSwitch isOn];
        [self setFBButtonState:preesed];
        self.saveButton.title = @"Save";
    }
    
    UIImageView *imageView = [_detailItem objectAtIndex:0];
    imageView.hidden = NO;
    //    self.cameraView.image = imageView.image;
    /* 先裁切成正方形 */
    self.cameraView.image = imageView.image;
    imageView.image = [self rotate:imageView.image andOrientation:imageView.image.imageOrientation];
    
    NSLog(@"Crop 1  Width:%ld  Height:%ld", CGImageGetWidth(imageView.image.CGImage), CGImageGetHeight(imageView.image.CGImage));
    
    // Create paths to output images
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    // Write image to PNG
    [UIImagePNGRepresentation(imageView.image) writeToFile:pngPath atomically:YES];
    // Let's check to see if files were successfully written...
    
    // Create file manager
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Crop orange Width:%ld  Height:%ld", CGImageGetWidth(self.cameraView.image.CGImage), CGImageGetHeight(self.cameraView.image.CGImage));
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    self.cameraView.image = [UIImage imageWithContentsOfFile:pngPath];
    
    
    //從相簿來的照片是(0, 0, 640, 640)
    //從相機來的照片是(0, 80, 480, 480)
    if ([[_detailItem objectAtIndex:3] isEqualToString:@"1"]) {// 判斷是否為來自於相簿
        if (CGImageGetWidth(self.cameraView.image.CGImage) > CGImageGetHeight(self.cameraView.image.CGImage)) {
//            NSLog(@"橫向照片");
            CGRect cropRect = CGRectMake(0, 0, CGImageGetHeight(self.cameraView.image.CGImage), CGImageGetHeight(self.cameraView.image.CGImage));
            CGImageRef imageRef = CGImageCreateWithImageInRect(self.cameraView.image.CGImage, cropRect);
            UIImage *result = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
//            NSLog(@"Crop camera  Width:%ld  Height:%ld", CGImageGetWidth(result.CGImage), CGImageGetHeight(result.CGImage));
//            NSLog(@"Crop camera  Bytes:%ld", CGImageGetBytesPerRow(result.CGImage));
            
            self.cameraView.image = result;
        }else{
//            NSLog(@"直向照片");
            CGRect cropRect = CGRectMake(0, 0, CGImageGetWidth(self.cameraView.image.CGImage), CGImageGetWidth(self.cameraView.image.CGImage));
            CGImageRef imageRef = CGImageCreateWithImageInRect(self.cameraView.image.CGImage, cropRect);
            UIImage *result = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
//            NSLog(@"Crop album  Width:%ld  Height:%ld", CGImageGetWidth(result.CGImage), CGImageGetHeight(result.CGImage));
//            NSLog(@"Crop album  Bytes:%ld", CGImageGetBytesPerRow(result.CGImage));
            
            self.cameraView.image = result;
        }
    }else{
        CGRect cropRect = CGRectMake(0, 80, 480, 480);
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.cameraView.image.CGImage, cropRect);
        UIImage *result = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        NSLog(@"Crop camera  Width:%ld  Height:%ld", CGImageGetWidth(result.CGImage), CGImageGetHeight(result.CGImage));
        NSLog(@"Crop camera  Bytes:%ld", CGImageGetBytesPerRow(result.CGImage));
        
        self.cameraView.image = result;
    }
}

-(UIImage*) rotate:(UIImage*) src andOrientation:(UIImageOrientation)orientation
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context=(UIGraphicsGetCurrentContext());
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90/180*M_PI) ;
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90/180*M_PI);
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 90/180*M_PI);
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.facebookSwitch.on = NO;
    BOOL preesed = [self.facebookSwitch isOn];
    [self setFBButtonState:preesed];
    self.saveButton.title = @"Save";
    
    NSDate *now = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd, yyyy HH:mm";
    NSLog(@"%@",[dateFormatter stringFromDate:now]);
    
    self.timeZoneLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:now]] ;
    [self.cropper setup];
    
    _TextViewBackground.layer.cornerRadius = 5;
    UIImage *buttonImage = [UIImage imageNamed:@"fb_share.png"];
    UIImage *buttonSelected = [UIImage imageNamed:@"fb_share_ok.png"];
    [self.FBButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.FBButton setBackgroundImage:buttonSelected forState:UIControlStateSelected];
    
    [_commentTextView setClipsToBounds:YES];
    _commentTextView.delegate = self;
    
    _watermarkScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 275, 275)];
    _watermarkScroll.contentSize = CGSizeMake(275, 275);
    _watermarkScroll.pagingEnabled = YES;
    _watermarkScroll.backgroundColor = [UIColor clearColor];
    
    self.skinShadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 320.0f)];
    self.skinShadowImage.image = [UIImage imageNamed:@"SkinShadow.png"];
    
    if (![[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:205] && ![[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:307] && ![[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:204]) {
        
        float carbsRda = 0;
        float saltRda = 0;
        float fatRda = 0;
        
        if (carbsRda < 50) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 150) {//綠色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 200) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (carbsRda < 50) {
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda < 150){
            [self.circleDrawer0 setGreenColor:YES];
        }else if (carbsRda < 200){
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda >= 200){
            [self.circleDrawer0 setRedColor:YES];
        }
        if (carbsRda > 100) {
            [self.circleDrawer0 drawPercentage:99.99 Rda:carbsRda];
        }else{
            [self.circleDrawer0 drawPercentage:carbsRda Rda:carbsRda];
        }
        
        if (saltRda < 50) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 150) {//綠色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 200) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (saltRda < 50) {
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda < 150){
            [self.circleDrawer1 setGreenColor:YES];
        }else if (saltRda < 200){
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda >= 200){
            [self.circleDrawer1 setRedColor:YES];
        }
        if (saltRda > 100) {
            [self.circleDrawer1 drawPercentage:99.99 Rda:saltRda];
        }else{
            [self.circleDrawer1 drawPercentage:saltRda Rda:saltRda];
        }
        
        
        if (fatRda < 50) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 150) {//綠色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 200) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (fatRda < 50) {
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda < 150){
            [self.circleDrawer2 setGreenColor:YES];
        }else if (fatRda < 200){
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda >= 200){
            [self.circleDrawer2 setRedColor:YES];
        }
        if (fatRda > 100) {
            [self.circleDrawer2 drawPercentage:99.99 Rda:fatRda];
        }else{
            [self.circleDrawer2 drawPercentage:fatRda Rda:fatRda];
        }
    }else{
        float carbsRda = [[NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:205] rdaRatio]*100*3] floatValue];
        float saltRda = [[NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:307] rdaRatio]*100*3] floatValue];
        float fatRda = [[NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:204] rdaRatio]*100*3] floatValue];
        
        if (carbsRda < 50) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 150) {//綠色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (carbsRda < 200) {//橘色
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (carbsRda < 50) {
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda < 150){
            [self.circleDrawer0 setGreenColor:YES];
        }else if (carbsRda < 200){
            [self.circleDrawer0 setYellowColor:YES];
        }else if (carbsRda >= 200){
            [self.circleDrawer0 setRedColor:YES];
        }
        if (carbsRda > 100) {
            [self.circleDrawer0 drawPercentage:99.99 Rda:carbsRda];
        }else{
            [self.circleDrawer0 drawPercentage:carbsRda Rda:carbsRda];
        }
        
        if (saltRda < 50) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 150) {//綠色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (saltRda < 200) {//橘色
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 95.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (saltRda < 50) {
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda < 150){
            [self.circleDrawer1 setGreenColor:YES];
        }else if (saltRda < 200){
            [self.circleDrawer1 setYellowColor:YES];
        }else if (saltRda >= 200){
            [self.circleDrawer1 setRedColor:YES];
        }
        if (saltRda > 100) {
            [self.circleDrawer1 drawPercentage:99.99 Rda:saltRda];
        }else{
            [self.circleDrawer1 drawPercentage:saltRda Rda:saltRda];
        }
        
        
        if (fatRda < 50) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 150) {//綠色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else if (fatRda < 200) {//橘色
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                                  ];
        }else{
            self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 185.0f) radius:40.0f internalRadius:21.5f circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f] activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                                  ];
        }
        if (fatRda < 50) {
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda < 150){
            [self.circleDrawer2 setGreenColor:YES];
        }else if (fatRda < 200){
            [self.circleDrawer2 setYellowColor:YES];
        }else if (fatRda >= 200){
            [self.circleDrawer2 setRedColor:YES];
        }
        if (fatRda > 100) {
            [self.circleDrawer2 drawPercentage:99.99 Rda:fatRda];
        }else{
            [self.circleDrawer2 drawPercentage:fatRda Rda:fatRda];
        }
    }
    
    self.FoodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(128.9f, 100.0f, 141.79f, 88.0f)];
    [self.FoodNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21.48]];
    self.FoodNameLabel.textAlignment = NSTextAlignmentRight;
    self.FoodNameLabel.numberOfLines = 0;
    self.FoodNameLabel.backgroundColor = [UIColor clearColor];
    self.FoodNameLabel.textColor = [UIColor whiteColor];
    self.FoodNameLabel.shadowColor = [UIColor blackColor];
    self.FoodNameLabel.shadowOffset = CGSizeMake(1,1);
    UILabel *foodName = [_detailItem objectAtIndex:2];
    self.FoodNameLabel.text = foodName.text; //上一頁Camera參數
    
    self.FoodKcalLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 215, 180, 60)];
    [self.FoodKcalLabel setFont:[UIFont fontWithName:@"Helvetica" size:60]];
    self.FoodKcalLabel.textAlignment = NSTextAlignmentRight;
    self.FoodKcalLabel.numberOfLines = 0;
    self.FoodKcalLabel.backgroundColor = [UIColor clearColor];
    self.FoodKcalLabel.textColor = [UIColor whiteColor];
    self.FoodKcalLabel.shadowColor = [UIColor blackColor];
    self.FoodKcalLabel.shadowOffset = CGSizeMake(1,1);
    self.FoodKcalLabel.text = [NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:208] nutrientValue]];
    
    self.UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 255, 58, 15)];
    [self.UnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    self.UnitLabel.textAlignment = NSTextAlignmentLeft;
    self.UnitLabel.numberOfLines = 0;
    self.UnitLabel.backgroundColor = [UIColor clearColor];
    self.UnitLabel.textColor = [UIColor whiteColor];
    self.UnitLabel.shadowColor = [UIColor blackColor];
    self.UnitLabel.shadowOffset = CGSizeMake(1,1);
    self.UnitLabel.text = @"Kcal";
    
    
    
    UILabel *carbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 67, 58, 15)];
    [carbsLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    carbsLabel.textAlignment = NSTextAlignmentLeft;
    carbsLabel.numberOfLines = 0;
    carbsLabel.backgroundColor = [UIColor clearColor];
    carbsLabel.textColor = [UIColor whiteColor];
    carbsLabel.shadowColor = [UIColor blackColor];
    carbsLabel.shadowOffset = CGSizeMake(1,1);
    carbsLabel.text = @"Carbs";
    
    UILabel *carbsUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 50, 20)];
    [carbsUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    carbsUnitLabel.textAlignment = NSTextAlignmentRight;
    carbsUnitLabel.numberOfLines = 0;
    carbsUnitLabel.backgroundColor = [UIColor clearColor];
    carbsUnitLabel.textColor = [UIColor whiteColor];
    carbsUnitLabel.shadowColor = [UIColor blackColor];
    carbsUnitLabel.shadowOffset = CGSizeMake(1,1);
    carbsUnitLabel.text = [NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:205] nutrientValue]];//上一頁Camera參數
    
    UILabel *carbsUnit = [[UILabel alloc] initWithFrame:CGRectMake(56, 32, 15, 20)];
    [carbsUnit setFont:[UIFont fontWithName:@"Helvetica" size:10.5]];
    carbsUnit.textAlignment = NSTextAlignmentLeft;
    carbsUnit.numberOfLines = 0;
    carbsUnit.backgroundColor = [UIColor clearColor];
    carbsUnit.textColor = [UIColor whiteColor];
    carbsUnit.shadowColor = [UIColor blackColor];
    carbsUnit.shadowOffset = CGSizeMake(1,1);
    carbsUnit.text = @"g";
    
    
    
    UILabel *saltLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 157, 58, 15)];
    [saltLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    saltLabel.textAlignment = NSTextAlignmentLeft;
    saltLabel.numberOfLines = 0;
    saltLabel.backgroundColor = [UIColor clearColor];
    saltLabel.textColor = [UIColor whiteColor];
    saltLabel.shadowColor = [UIColor blackColor];
    saltLabel.shadowOffset = CGSizeMake(1,1);
    saltLabel.text = @"Salt";
    
    UILabel *saltUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 125, 50, 20)];
    [saltUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    saltUnitLabel.textAlignment = NSTextAlignmentRight;
    saltUnitLabel.numberOfLines = 0;
    saltUnitLabel.backgroundColor = [UIColor clearColor];
    saltUnitLabel.textColor = [UIColor whiteColor];
    saltUnitLabel.shadowColor = [UIColor blackColor];
    saltUnitLabel.shadowOffset = CGSizeMake(1,1);
    Meal *currentMeal=    [OmniTool getCurrentMeal];
    if ([[[currentMeal mealOverview] getNutrientWithInt:307] nutrientValue]<100.0) {
        saltUnitLabel.text = @"0";
    }else{
        saltUnitLabel.text = [NSString stringWithFormat:@"%.1f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:307] nutrientValue]/1000];//上一頁Camera參數
    }
    
    
    
    UILabel *saltUnit = [[UILabel alloc] initWithFrame:CGRectMake(56, 122, 15, 20)];
    [saltUnit setFont:[UIFont fontWithName:@"Helvetica" size:10.5]];
    saltUnit.textAlignment = NSTextAlignmentLeft;
    saltUnit.numberOfLines = 0;
    saltUnit.backgroundColor = [UIColor clearColor];
    saltUnit.textColor = [UIColor whiteColor];
    saltUnit.shadowColor = [UIColor blackColor];
    saltUnit.shadowOffset = CGSizeMake(1,1);
    saltUnit.text = @"g";
    
    
    
    UILabel *fatLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 247, 58, 15)];
    [fatLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    fatLabel.textAlignment = NSTextAlignmentLeft;
    fatLabel.numberOfLines = 0;
    fatLabel.backgroundColor = [UIColor clearColor];
    fatLabel.textColor = [UIColor whiteColor];
    fatLabel.shadowColor = [UIColor blackColor];
    fatLabel.shadowOffset = CGSizeMake(1,1);
    fatLabel.text = @"Fat";
    
    UILabel *fatUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 215, 50, 20)];
    [fatUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    fatUnitLabel.textAlignment = NSTextAlignmentRight;
    fatUnitLabel.numberOfLines = 0;
    fatUnitLabel.backgroundColor = [UIColor clearColor];
    fatUnitLabel.textColor = [UIColor whiteColor];
    fatUnitLabel.shadowColor = [UIColor blackColor];
    fatUnitLabel.shadowOffset = CGSizeMake(1,1);
    fatUnitLabel.text = [NSString stringWithFormat:@"%.0f", [[[[_detailItem objectAtIndex:1] mealOverview] getNutrientWithInt:204] nutrientValue]];//上一頁Camera參數
    
    UILabel *fatUnit = [[UILabel alloc] initWithFrame:CGRectMake(56, 212, 15, 20)];
    [fatUnit setFont:[UIFont fontWithName:@"Helvetica" size:10.5]];
    fatUnit.textAlignment = NSTextAlignmentLeft;
    fatUnit.numberOfLines = 0;
    fatUnit.backgroundColor = [UIColor clearColor];
    fatUnit.textColor = [UIColor whiteColor];
    fatUnit.shadowColor = [UIColor blackColor];
    fatUnit.shadowOffset = CGSizeMake(1,1);
    fatUnit.text = @"g";
    
    [_watermarkScroll addSubview:self.skinShadowImage];
    [_watermarkScroll addSubview:self.FoodNameLabel];
    [_watermarkScroll addSubview:self.FoodKcalLabel];
    [_watermarkScroll addSubview:self.UnitLabel];
    [_watermarkScroll addSubview:self.circleDrawer0];
    [_watermarkScroll addSubview:self.circleDrawer1];
    [_watermarkScroll addSubview:self.circleDrawer2];
    [_watermarkScroll addSubview:carbsLabel];
    [_watermarkScroll addSubview:saltLabel];
    [_watermarkScroll addSubview:fatLabel];
    [_watermarkScroll addSubview:carbsUnitLabel];
    [_watermarkScroll addSubview:saltUnitLabel];
    [_watermarkScroll addSubview:fatUnitLabel];
    [_watermarkScroll addSubview:carbsUnit];
    [_watermarkScroll addSubview:saltUnit];
    [_watermarkScroll addSubview:fatUnit];
    
    [self.cameraView.layer addSublayer:_watermarkScroll.layer];
    
    // add into minna message Listener list
    [OmniTool addMinnaListener:self];
    self.messageView=[[MinnaMessageView alloc] initWithFrame:CGRectMake(0,-45,320,44)];
    [self.view addSubview:self.messageView];
    
    
}

-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        NSLog(@"save error: %@",error);
    }
    else  // No errors
    {
        // Show message image successfully saved
        if (!self.facebookSwitch.isOn) {
            [OmniTool broadcastMinnaMessage:@"Saved Successfully!"];
            NSLog(@"Saved Successfully!");
            /*
            UIAlertView *tmp = [[UIAlertView alloc]
                                initWithTitle:@"Saved"
                                message:@""
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:@"Ok", nil];
            
            [tmp show];
             */
        }else{
            
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textViewDidBeginEditing:(UITextView *)textView{
    [self.keyboardScroll adjustOffsetToIdealIfNeeded];
    
}

- (void) textViewDidChange:(UITextView *)textView{
    
    self.textCountLabel.textColor = [UIColor lightGrayColor];
    self.saveButton.tintColor = [UIColor whiteColor];
    self.saveButton.enabled = YES;
    
    if ([textView hasText]) {
        self.placeholderLabel.alpha = 0.0;
    }else{
        self.placeholderLabel.alpha = 1.0;
    }
}

- (void) textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"did change selection");
}



- (void)setFBButtonState:(BOOL)selected{
    [self.FBButton setSelected:selected];
//    [self.facebookSwitch setOn:selected];
}

- (IBAction)facebookSwitchPressed:(id)sender {
    if (![PFUser currentUser]) {
        NSLog(@"尚未登入");
        /*Step 0 : 彈跳登入畫面，讓用戶登入。 */
        // Customize the Log In View Controller
        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
        logInViewController.delegate = self;
        logInViewController.facebookPermissions = @[@"friends_about_me"];
        logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsDismissButton;
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
        BOOL preesed = [sender isOn];
        if (preesed) {
            self.saveButton.title = @"Share";
            isFacebookSwitchOn = YES;
        }else{
            self.saveButton.title = @"Save";
            isFacebookSwitchOn = NO;
        }
        [self setFBButtonState:preesed];
    }else{
        BOOL preesed = [sender isOn];
        if (preesed) {
            self.saveButton.title = @"Share";
            isFacebookSwitchOn = YES;
        }else{
            self.saveButton.title = @"Save";
            isFacebookSwitchOn = NO;
        }
        [self setFBButtonState:preesed];
    }
}

//上傳中其他按鈕就不能按，結束後其他按鈕才能按。
-(void)controlStatusUsable:(BOOL)usable {
    if (usable) {
        self.FBButton.userInteractionEnabled = YES;
        self.activity.hidden = YES;
        [self.activity stopAnimating];
    } else {
        self.FBButton.userInteractionEnabled = NO;
        self.activity.hidden = NO;
        [self.activity startAnimating];
    }
}

-(void)promptUserWithAccountNameForUploadPhoto {
    [self controlStatusUsable:NO];
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             
             NSString *trimmedComment = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             [self postOpenGraphWithImage:self.finalImage Message:trimmedComment];
             [OmniTool broadcastMinnaMessage:[NSString stringWithFormat:@"Uploading to Facebook"]];
             /*
             UIAlertView *tmp = [[UIAlertView alloc]
                                 initWithTitle:@"Upload to Facebook?"
                                 message:[NSString stringWithFormat:@"Upload to ""%@"" Account?", user.name]
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"No",@"Yes", nil];
             tmp.tag = 100; // to upload
             [tmp show];
              */
         }
         [self controlStatusUsable:YES];
     }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) { // yes answer
        if (alertView.tag==100) {
            // then upload
            NSString *trimmedComment = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self postOpenGraphWithImage:self.finalImage Message:trimmedComment];
            /*
            [self controlStatusUsable:NO];
            [FBRequestConnection startForUploadPhoto:self.cameraView.image
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                       if (!error) {
                                           UIAlertView *tmp = [[UIAlertView alloc]
                                                               initWithTitle:@"Sharing Complete"
                                                               message:@""
                                                               delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"Ok", nil];
                                           
                                           [tmp show];
                                       } else {
                                           UIAlertView *tmp = [[UIAlertView alloc]
                                                               initWithTitle:@"Error"
                                                               message:@"Some error happened"
                                                               delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"Ok", nil];
                                           
                                           [tmp show];
                                       }
                                       [self controlStatusUsable:YES];
                                   }];
        */

        }
    }
}

-(void) postOpenGraphWithImage:(UIImage *)_image Message:(NSString *)msg
{
    if(!_image)
    {
        NSLog(@"ERROR postOpenGraphWithImage: image is nil!");
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:msg forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(_image) forKey:@"picture"];


    [FBRequestConnection startWithGraphPath:@"me/photos"
                             parameters:params
                             HTTPMethod:@"POST"
                      completionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error)

     {
     
         if (error)

         {
         //showing an alert for failure
             NSLog(@"Unable to share the photo please try later. Error=%@",error);
             [OmniTool broadcastMinnaMessage:@"Photo sharing failed. Please try later."];
             [self.delegate SharingViewControllerDidShare:self Aboutmessange:@"Photo sharing failed. Please try later."];
             /*
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             [alert show];
              */
         }
         else
         {
             //showing an alert for success
             [OmniTool broadcastMinnaMessage:@"Shared Successfully!"];
             [self.delegate SharingViewControllerDidShare:self Aboutmessange:@"Shared Successfully!"];
             NSLog(@"Shared Successfully!");
             /*
             UIAlertView *tmp = [[UIAlertView alloc]
                                 initWithTitle:@"Sharing Complete"
                                 message:@""
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Ok", nil];
             
             [tmp show];
              */
         }
     }];
}

- (BOOL) isKeyboardOnScreen
{
    BOOL isKeyboardShown = NO;
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows.count > 1) {
        NSArray *wSubviews =  [windows[1]  subviews];
        if (wSubviews.count) {
            CGRect keyboardFrame = [wSubviews[0] frame];
            CGRect screenFrame = [windows[1] frame];
            if (keyboardFrame.origin.y+keyboardFrame.size.height == screenFrame.size.height) {
                isKeyboardShown = YES;
            }
        }
    }
    return isKeyboardShown;
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if ([self isKeyboardOnScreen]) {
        [self.commentTextView resignFirstResponder];
    }
    self.textCountLabel.hidden = YES;
    /* 合併照片與浮水印 */
    UIImageView *imageView = [_detailItem objectAtIndex:0];
    imageView.hidden = NO;
    // 整合浮水印輸出圖檔
    UIImage *waterImage = [OmniTool imageWithView:_watermarkScroll];
    // 合併照片及浮水印
    self.finalImage = [self composeImage:waterImage toImage:self.cameraView.image atFrame:CGRectMake(0, 0, 640, 640)];

    UIImage *backgroundImage;
    if (self.commentTextView.text.length == 0) {
        self.placeholderLabel.hidden = YES;
        // 再次合併含背景圖檔
        backgroundImage = [OmniTool imageWithViewBackground:self.TextViewBackground];
    }else{
        backgroundImage = [OmniTool imageWithViewBackground:self.TextViewBackground];
    }
    
    NSLog(@" backgroundImage = %f, %f", self.TextViewBackground.bounds.size.width, self.TextViewBackground.bounds.size.height);
    
    self.cropper.hidden = YES;
    // _watermarkScroll.hidden = YES;
    
    /*Step 1 : 儲存於本機的相簿*/
    UIImageWriteToSavedPhotosAlbum(backgroundImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    /* 上傳照片至用戶的Facebook相簿 */
    if (self.facebookSwitch.isOn) {
        if (FBSession.activeSession.isOpen) {
            // Yes, we are open, so lets make a request for user details so we can get the user name.
            [self promptUserWithAccountNameForUploadPhoto];
        } else {
            
            // We don't have an active session in this app, so lets open a new
            // facebook session with the appropriate permissions!
            
            // Firstly, construct a permission array.
            // you can find more "permissions strings" at http://developers.facebook.com/docs/authentication/permissions/
            // In this example, we will just request a publish_stream which is required to publish status or photos.
            
            NSArray *permissions = [[NSArray alloc] initWithObjects:
                                    @"publish_stream",
                                    nil];
            [self controlStatusUsable:NO];
            // OPEN Session!
            [FBSession openActiveSessionWithPublishPermissions:permissions
                                               defaultAudience:FBSessionDefaultAudienceFriends
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          // if login fails for any reason, we alert
                                          if (error) {
                                              NSLog(@"ERROR openActiveSessionWithPermissions: %@",error);
                                              // show error to user.
                                              
                                          } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                              
                                              // no error, so we proceed with requesting user details of current facebook session.
                                              
                                              [self promptUserWithAccountNameForUploadPhoto];
                                          }
                                          [self controlStatusUsable:YES];
                                      }];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
        
        return; // stop Parse cloud objects
        
        /* 開放關係圖 */
        NSDictionary *userInfo = [NSDictionary dictionary];
        /*接下來先偵測用戶是否已經登入過會員，如果還沒有，就先讓用戶登入
         如果已經登入過會員了，就直接執行照片存檔與分享。*/
        
        if (![PFUser currentUser]) {
            NSLog(@"尚未登入");
            /*Step 0 : 彈跳登入畫面，讓用戶登入。 */
            // Customize the Log In View Controller
            MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
            logInViewController.delegate = self;
            logInViewController.facebookPermissions = @[@"friends_about_me"];
            logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsDismissButton;
            
            // Present Log In View Controller
            [self presentViewController:logInViewController animated:YES completion:NULL];
        }else{
            NSLog(@"已經登入過");
            
            /*Step 2 : 開始上傳照片訊息於資料庫，接著判斷用戶是否要上傳到Facebook，如果有開啓，則進一步上傳至Facebook資訊牆。*/
            // Set story image
            if (self.storyObject[@"image"]) {
                self.finalImage = self.storyObject[@"image"];
            }
            [self shouldUploadImage:self.finalImage];
            
            //過濾空白文字
            NSString *trimmedComment = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            // Set story title
            if (self.storyObject[@"object"][@"title"]) {
                trimmedComment = self.storyObject[@"object"][@"title"];
            }
            // Set story description
            if (self.storyObject[@"object"][@"description"]) {
                trimmedComment = self.storyObject[@"object"][@"description"];
            }
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        trimmedComment,kPAPEditPhotoViewControllerUserInfoCommentKey,
                        nil];
            
            if (self.photoFile || self.thumbnailFile) {
                //有照片
                if (userInfo) {
                    NSString *postCommentText = [userInfo objectForKey:kPAPEditPhotoViewControllerUserInfoCommentKey];
                    PFObject *postObject = [PFObject objectWithClassName:kPAPPhotoClassKey];            //key = "Question"
                    [postObject setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];              //key = "user"
                    [postObject setObject:self.photoFile forKey:kPAPPhotoPictureKey];                   //key = "image"
                    [postObject setObject:self.thumbnailFile forKey:kPAPPhotoThumbnailKey];             //key = "thumbnail"
                    [postObject setObject:postCommentText forKey:@"text"];                     //key = "text"
                    
                    self.photoObject = postObject;
                }else{
                    [OmniTool broadcastMinnaMessage:@"Something Went Wrong."];
                    /*
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Something Went Wrong"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                     */
                }
            }
            PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [photoACL setPublicReadAccess:YES];
            [photoACL setPublicWriteAccess:YES];
            self.photoObject.ACL = photoACL;
            
            // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
            self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
            }];
            // save
            [self.photoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"照片內容已經上傳");
                    [[PAPCache sharedCache] setAttributesForPhoto:self.photoObject likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
                    
                    NSLog(@"Succeeded");
                    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo save succeeded!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    //                [alert show];
                    
                    if (userInfo) {
                        //                    if (self.FBButton.selected) {
                        //                        if ([PFFacebookUtils.session.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                        //                            [self requestPermissionAndPost]; //沒有權限
                        //                        } else {
                        //                            [self postOpenGraphAction];      //已經取得權限
                        //                        }
                        //                    }else{
                        //                        // do nothing.
                        //                    }
                    }
                }else{
                    NSLog(@"Photo save error: %@", error);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
            }];
        }
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)composeImage:(UIImage *)subImage toImage:(UIImage *)superImage atFrame:(CGRect)frame
{
    CGSize superSize = superImage.size;
    CGFloat widthScale = frame.size.width / self.cameraView.frame.size.width;
    CGFloat heightScale = frame.size.height / self.cameraView.frame.size.height;
    CGFloat xScale = frame.origin.x / self.cameraView.frame.size.width;
    CGFloat yScale = frame.origin.y / self.cameraView.frame.size.height;
    CGRect subFrame = CGRectMake(xScale * superSize.width, yScale * superSize.height, widthScale * superSize.width, heightScale * superSize.height);
    
    UIGraphicsBeginImageContext(superSize);
    [superImage drawInRect:CGRectMake(0, 0, superSize.width, superSize.height)];
    
    [subImage drawInRect:subFrame];
    __autoreleasing UIImage *finish = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finish;
}

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }else{
        self.photoFile = [PFFile fileWithData:imageData];
        self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
        // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
        self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }];
        NSLog(@"Requested background expiration task with id %lu for Nutrition Scale photo upload", (unsigned long)self.fileUploadBackgroundTaskId);
        
        
        [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"照片已經成功上傳");
                [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"小尺寸照片已經成功上傳");
                    }
                    [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
                }];
            } else {
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }
        }];
        return YES;
    }
}

- (void)viewDidUnload {
    [self setPlaceholderLabel:nil];
    [self setCropper:nil];
    [self setCameraView:nil];
    [self setCircleDrawer0:nil];
    [self setCircleDrawer1:nil];
    [self setCircleDrawer2:nil];
    [self setCommentTextView:nil];
    [self setDetailItem:nil];
    [self setFacebookSwitch:nil];
    [self setFBButton:nil];
    [self setFinalImage:nil];
    [self setFoodKcalLabel:nil];
    [self setFoodNameLabel:nil];
    [self setKeyboardScroll:nil];
    [super viewDidUnload];
}

- (void) gotoHome:(NSTimer *)timer {
    //    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
// Helper method to request publish permissions and post.
- (void)requestPermissionAndPost {
    //userInfo包含了物件以及key分別為 "發問內文", "comment"
    //    NSDictionary *userInfo = [NSDictionary dictionary];
    //過濾空白文字
    NSString *trimmedComment = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Iniitalize a connection for making a batch request
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    //取得剛剛發問的照片網址，當前用戶依時間排序的第一個問題。
    PFQuery *askQuestionQuery = [PFQuery queryWithClassName:@"Photo"];
    [askQuestionQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [askQuestionQuery orderByDescending:@"createdAt"];
    [askQuestionQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *image = [object objectForKey:@"image"];
        //        NSLog(@"2 image url = %@, %i",object, image.url.length);
        
        if ([image.url isEqualToString:@""]) {
            NSLog(@" no image");
            [image.url  isEqual: @"http://files.parse.com/c26cbef4-944d-4b8b-9942-74f95046e28b/b88efce8-9aea-43d7-a510-8bd94c95ccd8-bigstock-Chicken-salad-with-roasted-veg-14354648.jpg"];
        }
        // Request 1: Object creation
        NSMutableDictionary<FBOpenGraphObject> *FacebookObject =
        [FBGraphObject openGraphObjectForPostWithType:@"nutritionscale:post"
                                                title:trimmedComment
                                                image:image.url
                                                  url:@"https://itunes.apple.com/tw/app/omni-kitchen-scale/id618106385?l=zh&mt=8"
                                          description:@"Nutrition Scale"];
        
        FBRequest *objectRequest = [FBRequest requestForPostOpenGraphObject:FacebookObject];
        [connection addRequest:objectRequest
             completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (error) {
                     NSLog(@"Error: %@", error.description);
                 } else {
                     NSLog(@"Created object with id: %@", result[@"id"]);
                 }
             }
                batchEntryName:@"objectCreate"
         ];
        
        // Create an action
        NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
        action[@"question"] = @"{result=objectCreate:$.id}";
        action[@"fb:explicitly_shared"] = @"true";
        
        // Request 2: Publish action
        FBRequest *actionRequest = [FBRequest requestForPostWithGraphPath:@"me/nutritionscale:post"
                                                              graphObject:action];
        [connection addRequest:actionRequest
             completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (error) {
                     NSLog(@"Error: %@", error.description);
                 } else {
                     NSLog(@"1 Posted action with id: %@ , %@", result[@"id"], result);
                 }
             }];
        
        [connection start];
    }];
}

// Creates the Open Graph Action.
- (void)postOpenGraphAction {
    //userInfo包含了物件以及key分別為 "發問內文", "comment"
    //    NSDictionary *userInfo = [NSDictionary dictionary];
    //過濾空白文字
    NSString *trimmedComment = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // Iniitalize a connection for making a batch request
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    
    //取得剛剛發問的照片網址，當前用戶依時間排序的第一個問題。
    PFQuery *askQuestionQuery = [PFQuery queryWithClassName:@"Photo"];
    [askQuestionQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    //    [askQuestionQuery whereKey:@"text" equalTo:trimmedComment];
    //    [askQuestionQuery includeKey:@"image"];
    [askQuestionQuery orderByDescending:@"createdAt"];
    [askQuestionQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *image = [object objectForKey:@"image"];
        //        NSLog(@"image url = %@, %i",object, image.url.length);
        
        if (image.url.length == 0) {
            NSLog(@" no image");
            
            // Request 1: Object creation
            NSMutableDictionary<FBOpenGraphObject> *FacebookObject =
            [FBGraphObject openGraphObjectForPostWithType:@"nutritionscale:object"
                                                    title:trimmedComment
                                                    image:@"http://files.parse.com/fd061598-93ff-4bbe-96bb-d58907de35ae/19bfdc65-3404-4916-ac36-6254f0064bf3-PlaceholderPhoto.png"
                                                      url:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/wheels/id616638624?ls=1&mt=8&questionID=%@", object.objectId]
                                              description:@"Nutrition Scale"];
            
            
            FBRequest *objectRequest = [FBRequest requestForPostOpenGraphObject:FacebookObject];
            [connection addRequest:objectRequest
                 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     if (error) {
                         NSLog(@"Error: %@", error.description);
                     } else {
                         NSLog(@"Created object with id: %@", result[@"id"]);
                     }
                 }
                    batchEntryName:@"objectCreate"
             ];
            
            // Create an action
            NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
            action[@"object"] = @"{result=objectCreate:$.id}";
            action[@"fb:explicitly_shared"] = @"true";
            
            // Request 2: Publish action
            FBRequest *actionRequest = [FBRequest requestForPostWithGraphPath:@"me/nutritionscale:post"
                                                                  graphObject:action];
            [connection addRequest:actionRequest
                 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     if (error) {
                         NSLog(@"Error: %@", error.description);
                     } else {
                         NSLog(@"2 Posted action with id: %@ , %@", result[@"id"], result);
                     }
                 }];
            
            [connection start];
        }else{
            // Request 1: Object creation
            NSMutableDictionary<FBOpenGraphObject> *FacebookObject =
            [FBGraphObject openGraphObjectForPostWithType:@"wheelsio:object"
                                                    title:trimmedComment
                                                    image:image.url
                                                      url:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/wheels/id616638624?ls=1&mt=8&questionID=%@", object.objectId]
                                              description:@"Nutrition Scale"];
            
            //            NSLog(@" 2 image url = %@", image.url);
            
            FBRequest *objectRequest = [FBRequest requestForPostOpenGraphObject:FacebookObject];
            [connection addRequest:objectRequest
                 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     if (error) {
                         NSLog(@"Error: %@", error.description);
                     } else {
                         NSLog(@"Created object with id: %@", result[@"id"]);
                     }
                 }
                    batchEntryName:@"objectCreate"
             ];
            
            // Create an action
            NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
            action[@"object"] = @"{result=objectCreate:$.id}";
            action[@"fb:explicitly_shared"] = @"true";
            
            // Request 2: Publish action
            FBRequest *actionRequest = [FBRequest requestForPostWithGraphPath:@"me/wheelsio:ask"
                                                                  graphObject:action];
            [connection addRequest:actionRequest
                 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     if (error) {
                         NSLog(@"Error: %@", error.description);
                     } else {
                         NSLog(@"3 Posted action with id: %@ , %@", result[@"id"], result);
                     }
                 }];
            
            [connection start];
        }
    }];
    //    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - PFLogInViewControllerDelegate
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    BOOL preesed = [self.facebookSwitch isOn];
    [self setFBButtonState:preesed];
    
    if (user.isNew) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
        
        // Subscribe to private push channel
        if (user) {
            NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
            [user setObject:privateChannelName forKey:kPAPUserPrivateChannelKey];
        }
    }else if(user){
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
        
        // Subscribe to private push channel
        if (user) {
            NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
            [user setObject:privateChannelName forKey:kPAPUserPrivateChannelKey];
        }
    }
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Facebook Request Delegate
- (void)facebookRequestDidLoad:(id)result {
    PFUser *user = [PFUser currentUser];
    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
            }
        }
        
        // cache friend data
        [[PAPCache sharedCache] setFacebookFriends:facebookIds];
        
        if (user) {
            if (![user objectForKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey]) {
                self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                firstLaunch = YES;
                
                [user setObject:@YES forKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey];
                //                NSError *error = nil;
                
                // find common Facebook friends already using Anypic
                PFQuery *facebookFriendsQuery = [PFUser query];
                [facebookFriendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookIds];
                
                // auto-follow Parse employees
                //                PFQuery *autoFollowAccountsQuery = [PFUser query];
                //                [autoFollowAccountsQuery whereKey:kPAPUserFacebookIDKey containedIn:kPAPAutoFollowAccountFacebookIds];
                
                // combined query
                PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:facebookFriendsQuery, nil]];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    NSArray *anypicFriends = objects;
                    
                    if (!error) {
                        [anypicFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
                            PFObject *joinActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
                            [joinActivity setObject:user forKey:kPAPActivityFromUserKey];
                            [joinActivity setObject:newFriend forKey:kPAPActivityToUserKey];
                            [joinActivity setObject:kPAPActivityTypeJoined forKey:kPAPActivityTypeKey];
                            
                            PFACL *joinACL = [PFACL ACL];
                            [joinACL setPublicReadAccess:YES];
                            joinActivity.ACL = joinACL;
                            
                            // make sure our join activity is always earlier than a follow
                            [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [PAPUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                                    // This block will be executed once for each friend that is followed.
                                    // We need to refresh the timeline when we are following at least a few friends
                                    // Use a timer to avoid refreshing innecessarily
                                    if (self.autoFollowTimer) {
                                        [self.autoFollowTimer invalidate];
                                    }
                                    
                                    self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
                                }];
                            }];
                        }];
                    }
                    
                    //                    if (![self shouldProceedToMainInterface:user]) {
                    //                        [self logOut];
                    //                        return;
                    //                    }
                    
                    //                    if (!error) {
                    //                        [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
                    //                        if (anypicFriends.count > 0) {
                    //                            //                        self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
                    //                            //                        self.hud.dimBackground = YES;
                    //                            //                        self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                    //                        } else {
                    //                            //                        [self.homeViewController loadObjects];
                    //                        }
                    //                    }
                }];
            }
            
            [user saveEventually];
        } else {
            NSLog(@"No user session found. Forcing logOut.");
            //            [self logOut];
        }
    } else {
        self.hud.labelText = NSLocalizedString(@"Creating Profile", nil);
        NSString *facebookId = [result objectForKey:@"id"];
        NSString *facebookName = [result objectForKey:@"name"];
        //新增用戶資料 名字、姓氏、性別、地區(用Graph API的代號)
        NSString *facebookFirst_Name = [result objectForKey:@"first_name"];
        NSString *facebookLast_Name = [result objectForKey:@"last_name"];
        NSString *facebookBirthday = [result objectForKey:@"birthday"];
        NSString *facebookEmail = [result objectForKey:@"email"];
        NSString *facebookGender = [result objectForKey:@"gender"];
        NSString *facebookLocation = [result objectForKey:@"locale"];
        
        if (user) {
            if (facebookName && [facebookName length] != 0) {
                [user setObject:facebookName forKey:kPAPUserDisplayNameKey];
            } else {
                [user setObject:@"Someone" forKey:kPAPUserDisplayNameKey];
            }
            if (facebookId && [facebookId length] != 0) {
                [user setObject:facebookId forKey:kPAPUserFacebookIDKey];
            }
            //儲存姓氏
            if (facebookFirst_Name && facebookFirst_Name != 0) {
                [[PFUser currentUser] setObject:facebookFirst_Name forKey:kPAPUserFacebookFirstNameKey];
            }
            //儲存名字
            if (facebookLast_Name && facebookLast_Name != 0) {
                [[PFUser currentUser] setObject:facebookLast_Name forKey:kPAPUserFacebookLastNameKey];
            }
            //儲存生日
            if (facebookBirthday && facebookBirthday != 0) {
                [[PFUser currentUser] setObject:facebookBirthday forKey:kPAPUserFacebookBirthdayKey];
            }
            //儲存email
            if (facebookEmail && facebookEmail != 0) {
                [[PFUser currentUser] setObject:facebookEmail forKey:kPAPUserFacebookEmailKey];
            }
            //儲存性別
            if (facebookGender && facebookGender != 0) {
                [[PFUser currentUser] setObject:facebookGender forKey:kPAPUserFacebookGenderKey];
            }
            //儲存地理位置
            if (facebookLocation && facebookLocation != 0) {
                [[PFUser currentUser] setObject:facebookLocation forKey:kPAPUserFacebookLocalsKey];
            }
            
            NSLog(@"正在下載用戶檔案照片...");
            // Download user's profile picture
            NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:kPAPUserFacebookIDKey]]];
            // Facebook profile picture cache policy: Expires in 2 weeks
            NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0.0f];
            [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
            
            PFQuery *userQuery = [PFUser query];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count < 2000) {
                    [[PFUser currentUser] setObject:@YES forKey:@"EarlyBird"];
                    [user saveEventually];
                }else{
                    [[PFUser currentUser] setObject:@NO forKey:@"EarlyBird"];
                    [user saveEventually];
                }
            }];
        }
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}

- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    
    //    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    //    [MBProgressHUD hideHUDForView:self.paphomeViewController.view animated:YES];
    //    [self.paphomeViewController loadObjects];
}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [self logOut];
        }
    }
}

#pragma mark - NSURLConnectionDataDelegate 儲存照片資料
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [PAPUtility processFacebookProfilePictureData:_data];
}

#pragma mark - 登出
- (void)logOut {
    // clear cache
    [[OmniCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"install 4");
    // Unsubscribe from push notifications by clearing the channels key (leaving only broadcast enabled).
    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kPAPInstallationChannelsKey];
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc.
    // then go to LoginViewControllerƒ
    
}
#pragma mark - MinnaNotificationProtocol

-(void) MinnaMessage:(NSString *)message
{
    // NSLog(@"Got Minna Broadcast message: %@",message);
    [self.messageView setMessage:message];
}

-(NSNumber *) MinnaListenerID
{
    return [[NSNumber alloc] initWithInt:9];
}

#pragma mark - 判斷文字內容超過textView與否
//hide keyboard when press done
- (BOOL) textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aTange replacementText:(NSString *)aText{
    NSString* newText = [aTextView.text stringByReplacingCharactersInRange:aTange withString:aText];
    
    // TODO - find out why the size of the string is smaller than the actual width, so that you get extra,
    // wrapped characters unless you take something off
    CGSize tallerSize = CGSizeMake(aTextView.frame.size.width-15,aTextView.frame.size.height*2); // pretend there's more vertical space to get that extra line to check on
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:aTextView.font forKey: NSFontAttributeName];
    
    CGSize newSize = [newText boundingRectWithSize:tallerSize
                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                        attributes:stringAttributes context:nil].size;
    
    NSLog(@"newSize = %f , old = %f , newText = %lu", newSize.height, aTextView.frame.size.height, (unsigned long)newText.length);
    if (newSize.height > aTextView.frame.size.height)
    {
        return NO;
    }
    else{
        
        // ENTER problem:
        // if the tailing char is ENTER, it won't create larger CG size, that caused un-wanted situation
        if([newText hasSuffix:@"\n"]){
            if((newSize.height + aTextView.font.lineHeight) >aTextView.frame.size.height)
            {
                [aTextView resignFirstResponder];
                return NO;
            }
        }
        return YES;
    }
//    if([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    
//    return YES;
}



@end
