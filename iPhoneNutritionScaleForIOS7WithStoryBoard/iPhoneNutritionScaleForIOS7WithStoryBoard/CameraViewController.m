//
//  CameraViewController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "CameraViewController.h"
#import <ImageIO/ImageIO.h>
#import "GPUImage.h"
#import "CircleDrawer.h"
#import "SharingViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "Meal.h"
#import "ReportViewController.h"
#import "GKImagePicker.h"
#import "GKImageCropView.h"
//#import "GKResizeableCropOverlayView.h"
#import "IngredientController.h"

//#import "ImageCropperView.h"

@interface CameraViewController (){
    AVCaptureSession            *_session;
    AVCaptureDeviceInput        *_captureInput;
    AVCaptureStillImageOutput   *_captureOutput;
    AVCaptureVideoPreviewLayer  *_preview;
    AVCaptureDevice             *_device;
    
    UIImage                     *_finishImage;
    
    UIImage                     *_croppedImage;
}
@property (strong, nonatomic) GKImagePicker *imagePicker;
@property (strong, nonatomic) GKImageCropView *imageCropView;
//@property (strong, nonatomic) Meal *currentMeal;
@end

// Some constants for the iris view and selector
NSString* kIrisViewClassName = @"PLCameraIrisAnimationView";

@implementation CameraViewController {
    UIView* iris_;
}
@synthesize cameraView          = _cameraView;
@synthesize takePhotoButton     = _takePhotoButton;
@synthesize flashButton         = _flashButton;
@synthesize positionButton      = _positionButton;
@synthesize albumButton         = _albumButton;
@synthesize reportButton        = _reportButton;
@synthesize ingredientsButton   = _ingredientsButton;
@synthesize watermarkScroll     = _watermarkScroll;
@synthesize watermarkScroll2    = _watermarkScroll2;
@synthesize waterView           = _waterView;
@synthesize getImageView        = _getImageView;
@synthesize circleDrawer0       = _circleDrawer0;
@synthesize circleDrawer1       = _circleDrawer1;
@synthesize circleDrawer2       = _circleDrawer2;
@synthesize carbsLabel          = _carbsLabel;
@synthesize carbsUnitLabel      = _carbsUnitLabel;
@synthesize saltLabel           = _saltLabel;
@synthesize saltUnitLabel       = _saltUnitLabel;
@synthesize fatLabel            = _fatLabel;
@synthesize fatUnitLabel        = _fatUnitLabel;
@synthesize circleDrawer02      = _circleDrawer02;
@synthesize circleDrawer12      = _circleDrawer12;
@synthesize circleDrawer22      = _circleDrawer22;
@synthesize carbsLabel2         = _carbsLabel2;
@synthesize carbsUnitLabel2     = _carbsUnitLabel2;
@synthesize saltLabel2          = _saltLabel2;
@synthesize saltUnitLabel2      = _saltUnitLabel2;
@synthesize fatLabel2           = _fatLabel2;
@synthesize fatUnitLabel2       = _fatUnitLabel2;
@synthesize teachImage          = _teachImage;
@synthesize keyboardCoView      = _keyboardCoView;
@synthesize foodNameTextField   = _foodNameTextField;
@synthesize meal                = _meal;
@synthesize imagePicker         = _imagePicker;
@synthesize isAlbum             = _isAlbum;
@synthesize skinShadowImage     = _skinShadowImage;
@synthesize skinShadowImage2    = _skinShadowImage2;
//@synthesize currentMeal         = _currentMeal;

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
    NSLog(@"view will appear");
    
    
    Meal *currentMeal = [OmniTool getCurrentMeal];
//    NSLog(@"meal carbs = %@, %@, %f, %@, %f, %@, %@", [[[currentMeal mealOverview] getNutrientWithInt:205] nutrientShortName], [[[currentMeal mealOverview] getNutrientWithInt:205] nutrientType], [[[currentMeal mealOverview] getNutrientWithInt:205] nutrientValue], [[[currentMeal mealOverview] getNutrientWithInt:205] unit], [[[currentMeal mealOverview] getNutrientWithInt:205] rdaRatio], [currentMeal mealOverview], currentMeal);
    
    
    NSLog(@"foodNameTextField = %lu", (unsigned long)self.foodNameTextField.text.length);
    if (self.foodNameTextField.text.length > 0) {
        self.FoodNameLabel.text = self.foodNameTextField.text;
        self.FoodNameLabel2.text = self.foodNameTextField.text;
    }else{
        self.FoodNameLabel.text = @"Healthy Food";
        self.FoodNameLabel2.text = @"Healthy Food";
    }
    
    
    if (![currentMeal mealOverview] && self.FoodNameLabel.text.length == 0) {
        self.reportButton.hidden = YES;
    }else if (![currentMeal mealOverview] && self.FoodNameLabel.text.length > 0){
        self.reportButton.hidden = YES;
    }else{
        //過濾空白文字
        NSString *foodComment = [self.FoodNameLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([foodComment isEqualToString:@"Healthy Food"] && ![[[currentMeal mealOverview] getNutrientWithInt:208] nutrientValue]) {
            self.reportButton.hidden = YES;
        }else if(![[[currentMeal mealOverview] getNutrientWithInt:208] nutrientValue]){
            self.reportButton.hidden = YES;
        }
        else{
            self.reportButton.hidden = NO;
        }
    }
    
    self.FoodKcalLabel.text = [NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:208] nutrientValue]];
    self.UnitLabel.text = @"Kcal";
    
    self.carbsUnitLabel.text = [NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:205] nutrientValue]];
    
    if ([[[currentMeal mealOverview] getNutrientWithInt:307] nutrientValue]<100.0) {
        self.saltUnitLabel.text = @"0";
    }else{
        self.saltUnitLabel.text = [NSString stringWithFormat:@"%.1f", [[[currentMeal mealOverview] getNutrientWithInt:307] nutrientValue]/1000];
    }
    
    
    self.fatUnitLabel.text = [NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:204] nutrientValue]];

    self.FoodKcalLabel2.text = [NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:208] nutrientValue]];
    self.UnitLabel2.text = @"Kcal";
    
    self.carbsUnitLabel2.text = [NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:205] nutrientValue]];
    
    if ([[[currentMeal mealOverview] getNutrientWithInt:307] nutrientValue]<100.0) {
        self.saltUnitLabel2.text = @"0";
    }else{
        self.saltUnitLabel2.text = [NSString stringWithFormat:@"%.1f", [[[currentMeal mealOverview] getNutrientWithInt:307] nutrientValue]/1000];
    }
    
    self.fatUnitLabel2.text = [NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:204] nutrientValue]];
    
    
    if (![[currentMeal mealOverview] getNutrientWithInt:205] && ![[currentMeal mealOverview] getNutrientWithInt:307] && ![[currentMeal mealOverview] getNutrientWithInt:204]) {
        
        [self initWaterScrollAndCarbsRda:0 AndSaltRda:0 AndFatRda:0];
        [self WaterScrollForViewWillAppeal:0 AndSaltRda:0 AndFatRda:0];
    }else{
        float carbsRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:205] rdaRatio]*100*3] floatValue];
        float saltRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:307] rdaRatio]*100*3] floatValue];
        float fatRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:204] rdaRatio]*100*3] floatValue];
        
        [self WaterScrollForViewWillAppeal:carbsRda AndSaltRda:saltRda AndFatRda:fatRda];
    }
    
//    if ([[[currentMeal mealOverview] getNutrientWithInt:205] rdaRatio] && [[[currentMeal mealOverview] getNutrientWithInt:307] rdaRatio] && [[[currentMeal mealOverview] getNutrientWithInt:204] rdaRatio]) {
//        float carbsRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:205] rdaRatio]*100*3] floatValue];
//        float saltRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:307] rdaRatio]*100*3] floatValue];
//        float fatRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:204] rdaRatio]*100*3] floatValue];
//    }
   #ifdef ORANGE_TEST
   	 _saveButton.hidden = NO;
   #endif
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
	// Do any additional setup after loading the view.
    
    [OmniTool initialCurrentMeal];
    
    _isAlbum = NO;
    
    self.foodNameTextField.text = @"Healthy Food";
    
    self.FoodNameLabel.text = self.foodNameTextField.text;
    self.FoodNameLabel2.text = self.foodNameTextField.text;

    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(640, 640);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
//    [self.cameraView setup];
    
    self.teachImage.hidden = YES;
    self.clearButton.hidden = YES;
    self.keyboardCoView.hidden = YES;
    self.foodNameTextField.delegate = self;
    self.disappearKeyboardButton.hidden = YES;
    
    [self initialize];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, 320, 320);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.cameraView.layer addSublayer:_preview];
    [_session startRunning];
    
    Meal *currentMeal = [OmniTool getCurrentMeal];
    
//    NSLog(@"%@, %@, %@", [[currentMeal mealOverview] getNutrientWithInt:205], [[currentMeal mealOverview] getNutrientWithInt:307], [[currentMeal mealOverview] getNutrientWithInt:204]);
    
    if (![[currentMeal mealOverview] getNutrientWithInt:205] && ![[currentMeal mealOverview] getNutrientWithInt:307] && ![[currentMeal mealOverview] getNutrientWithInt:204]) {

        [self initWaterScrollAndCarbsRda:0 AndSaltRda:0 AndFatRda:0];
        [self WaterScrollForViewWillAppeal:0 AndSaltRda:0 AndFatRda:0];
    }else{
        float carbsRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:205] rdaRatio]*100*3] floatValue];
        float saltRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:307] rdaRatio]*100*3] floatValue];
        float fatRda = [[NSString stringWithFormat:@"%.0f", [[[currentMeal mealOverview] getNutrientWithInt:204] rdaRatio]*100*3] floatValue];
        
        [self initWaterScrollAndCarbsRda:carbsRda AndSaltRda:saltRda AndFatRda:fatRda];
    }
    
    
    
    _takePhotoButton.userInteractionEnabled = YES;
    _albumButton.userInteractionEnabled = YES;
    _ingredientsButton.userInteractionEnabled = YES;
    _reportButton.userInteractionEnabled = YES;
}

- (void)hideTeachImage:(NSTimer *)timer {
    self.teachImage.hidden = YES;
    self.clearButton.hidden = YES;
    //按鈕可以按
    _takePhotoButton.userInteractionEnabled = YES;
    _albumButton.userInteractionEnabled = YES;
    _ingredientsButton.userInteractionEnabled = YES;
    _reportButton.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - private

- (void) initialize
{
    //1.創建會話層
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset640x480];
    
    //2.創建、配置輸入設備
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [_device lockForConfiguration:nil];
    if([_device flashMode] == AVCaptureFlashModeOff){//關閉
        [_flashButton setImage:[UIImage imageNamed:@"shoot_off"] forState:UIControlStateNormal];
    }
    else if([_device flashMode] == AVCaptureFlashModeAuto){//自動
        [_flashButton setImage:[UIImage imageNamed:@"shoot"] forState:UIControlStateNormal];
    }
    else{                                                  //閃光
        [_flashButton setImage:[UIImage imageNamed:@"shoot_on"] forState:UIControlStateNormal];
    }
    [_device unlockForConfiguration];
    
	NSError *error;
	_captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
	if (!_captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    [_session addInput:_captureInput];
    
    
    //3.創建、派制輸出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
	[_session addOutput:_captureOutput];
}

- (void) WaterScrollForViewWillAppeal:(float)carbsRda AndSaltRda:(float)saltRda AndFatRda:(float)fatRda{
    
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
    
    if (carbsRda < 50) {
        [self.circleDrawer02 setYellowColor:YES];
    }else if (carbsRda < 150){
        [self.circleDrawer02 setGreenColor:YES];
    }else if (carbsRda < 200){
        [self.circleDrawer02 setYellowColor:YES];
    }else if (carbsRda >= 200){
        [self.circleDrawer02 setRedColor:YES];
    }
    if (carbsRda > 100) {
        [self.circleDrawer02 drawPercentage:99.99 Rda:carbsRda];
    }else{
        [self.circleDrawer02 drawPercentage:carbsRda Rda:carbsRda];
    }
    
    if (saltRda < 50) {
        [self.circleDrawer12 setYellowColor:YES];
    }else if (saltRda < 150){
        [self.circleDrawer12 setGreenColor:YES];
    }else if (saltRda < 200){
        [self.circleDrawer12 setYellowColor:YES];
    }else if (saltRda >= 200){
        [self.circleDrawer12 setRedColor:YES];
    }
    if (saltRda > 100) {
        [self.circleDrawer12 drawPercentage:99.99 Rda:saltRda];
    }else{
        [self.circleDrawer12 drawPercentage:saltRda Rda:saltRda];
    }
    
    if (fatRda < 50) {
        [self.circleDrawer22 setYellowColor:YES];
    }else if (fatRda < 150){
        [self.circleDrawer22 setGreenColor:YES];
    }else if (fatRda < 200){
        [self.circleDrawer22 setYellowColor:YES];
    }else if (fatRda >= 200){
        [self.circleDrawer22 setRedColor:YES];
    }
    if (fatRda > 100) {
        [self.circleDrawer22 drawPercentage:99.99 Rda:fatRda];
    }else{
        [self.circleDrawer22 drawPercentage:fatRda Rda:fatRda];
    }
}

- (void)initWaterScrollAndCarbsRda:(float)carbsRda AndSaltRda:(float)saltRda AndFatRda:(float)fatRda
{
    _watermarkScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, self.cameraView.frame.size.height)];
    _watermarkScroll.contentSize = CGSizeMake(320.0f, 320.0f);
    _watermarkScroll.pagingEnabled = YES;
    _watermarkScroll.backgroundColor = [UIColor clearColor];
    
    self.skinShadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 320.0f)];
    self.skinShadowImage.image = [UIImage imageNamed:@"SkinShadow.png"];
    
    
    self.FoodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 110, 165, 90)];
    [self.FoodNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25]];
	self.FoodNameLabel.textAlignment = NSTextAlignmentRight;
    self.FoodNameLabel.numberOfLines = 0;
	self.FoodNameLabel.backgroundColor = [UIColor clearColor];
	self.FoodNameLabel.textColor = [UIColor whiteColor];
    self.FoodNameLabel.shadowColor = [UIColor blackColor];
    self.FoodNameLabel.shadowOffset = CGSizeMake(1,1);
    self.FoodNameLabel.text = @"Healthy Food";
    
    
    self.FoodKcalLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 255, 180, 60)];
    [self.FoodKcalLabel setFont:[UIFont fontWithName:@"Helvetica" size:75]];
    self.FoodKcalLabel.textAlignment = NSTextAlignmentRight;
    self.FoodKcalLabel.numberOfLines = 0;
    self.FoodKcalLabel.backgroundColor = [UIColor clearColor];
    self.FoodKcalLabel.textColor = [UIColor whiteColor];
    self.FoodKcalLabel.shadowColor = [UIColor blackColor];
    self.FoodKcalLabel.shadowOffset = CGSizeMake(1,1);
    self.FoodKcalLabel.text = @"0";
    
    self.UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(285, 295, 58, 15)];
    [self.UnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
	self.UnitLabel.textAlignment = NSTextAlignmentLeft;
    self.UnitLabel.numberOfLines = 0;
	self.UnitLabel.backgroundColor = [UIColor clearColor];
	self.UnitLabel.textColor = [UIColor whiteColor];
    self.UnitLabel.shadowColor = [UIColor blackColor];
    self.UnitLabel.shadowOffset = CGSizeMake(1,1);
    self.UnitLabel.text = @"Kcal";
    
//    NSLog(@"carbsRda = %f", carbsRda);
    
    if (carbsRda < 50) {//橘色
        self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else if (carbsRda < 150){//綠色
        self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else if (carbsRda < 200){
        self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else{// 紅色
        self.circleDrawer0 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                              ];
    }
    
    if (carbsRda > 100) {
        [self.circleDrawer0 drawPercentage:99.99 Rda:carbsRda];
    }else{
        [self.circleDrawer0 drawPercentage:carbsRda Rda:carbsRda];
    }

    self.carbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 80, 58, 15)];
    [self.carbsLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	self.carbsLabel.textAlignment = NSTextAlignmentLeft;
    self.carbsLabel.numberOfLines = 0;
	self.carbsLabel.backgroundColor = [UIColor clearColor];
	self.carbsLabel.textColor = [UIColor whiteColor];
    self.carbsLabel.shadowColor = [UIColor blackColor];
    self.carbsLabel.shadowOffset = CGSizeMake(1,1);
    self.carbsLabel.text = @"Carbs";
    
    self.carbsUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 53, 22)];
    [self.carbsUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:22]];
	self.carbsUnitLabel.textAlignment = NSTextAlignmentRight;
    self.carbsUnitLabel.numberOfLines = 0;
	self.carbsUnitLabel.backgroundColor = [UIColor clearColor];
	self.carbsUnitLabel.textColor = [UIColor whiteColor];
    self.carbsUnitLabel.shadowColor = [UIColor blackColor];
    self.carbsUnitLabel.shadowOffset = CGSizeMake(1,1);
    self.carbsUnitLabel.text = @"0";
    
    self.carbsUnit = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 15, 20)];
    [self.carbsUnit setFont:[UIFont fontWithName:@"Helvetica" size:12]];
	self.carbsUnit.textAlignment = NSTextAlignmentRight;
    self.carbsUnit.numberOfLines = 0;
	self.carbsUnit.backgroundColor = [UIColor clearColor];
	self.carbsUnit.textColor = [UIColor whiteColor];
    self.carbsUnit.shadowColor = [UIColor blackColor];
    self.carbsUnit.shadowOffset = CGSizeMake(1,1);
    self.carbsUnit.text = @"g";
    
    if (saltRda < 50) {//橘色
        self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else if (saltRda < 150){//綠色
        self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else if (saltRda < 200){
        self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else{// 紅色
        self.circleDrawer1 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                              ];
    }
    
    if (saltRda > 100) {
        [self.circleDrawer1 drawPercentage:99.99 Rda:saltRda];
    }else{
        [self.circleDrawer1 drawPercentage:saltRda Rda:saltRda];
    }
    
    
    self.saltLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 186, 58, 15)];
    [self.saltLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	self.saltLabel.textAlignment = NSTextAlignmentLeft;
    self.saltLabel.numberOfLines = 0;
	self.saltLabel.backgroundColor = [UIColor clearColor];
	self.saltLabel.textColor = [UIColor whiteColor];
    self.saltLabel.shadowColor = [UIColor blackColor];
    self.saltLabel.shadowOffset = CGSizeMake(1,1);
    self.saltLabel.text = @"Salt";
    
    self.saltUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, 53, 22)];
    [self.saltUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:22]];
	self.saltUnitLabel.textAlignment = NSTextAlignmentRight;
    self.saltUnitLabel.numberOfLines = 0;
	self.saltUnitLabel.backgroundColor = [UIColor clearColor];
	self.saltUnitLabel.textColor = [UIColor whiteColor];
    self.saltUnitLabel.shadowColor = [UIColor blackColor];
    self.saltUnitLabel.shadowOffset = CGSizeMake(1,1);
    self.saltUnitLabel.text = @"0";
    
    self.saltUnit = [[UILabel alloc] initWithFrame:CGRectMake(60, 145, 15, 20)];
    [self.saltUnit setFont:[UIFont fontWithName:@"Helvetica" size:12]];
	self.saltUnit.textAlignment = NSTextAlignmentRight;
    self.saltUnit.numberOfLines = 0;
	self.saltUnit.backgroundColor = [UIColor clearColor];
	self.saltUnit.textColor = [UIColor whiteColor];
    self.saltUnit.shadowColor = [UIColor blackColor];
    self.saltUnit.shadowOffset = CGSizeMake(1,1);
    self.saltUnit.text = @"g";
    
    if (fatRda < 50) {//橘色
        self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 215.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else if (fatRda < 150){//綠色
        self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 215.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else if (fatRda < 200){
        self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 215.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                              ];
    }else{// 紅色
        self.circleDrawer2 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 215.0f)
                                                             radius:47.5f
                                                     internalRadius:26.0f
                                                  circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f]
                                            activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                              ];
    }
    
    if (fatRda > 100) {
        [self.circleDrawer2 drawPercentage:99.99 Rda:fatRda];
    }else{
        [self.circleDrawer2 drawPercentage:fatRda Rda:fatRda];
    }
    
    self.fatLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 290, 58, 15)];
    [self.fatLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	self.fatLabel.textAlignment = NSTextAlignmentLeft;
    self.fatLabel.numberOfLines = 0;
	self.fatLabel.backgroundColor = [UIColor clearColor];
	self.fatLabel.textColor = [UIColor whiteColor];
    self.fatLabel.shadowColor = [UIColor blackColor];
    self.fatLabel.shadowOffset = CGSizeMake(1,1);
    self.fatLabel.text = @"Fat";
    
    self.fatUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 255, 53, 22)];
    [self.fatUnitLabel setFont:[UIFont fontWithName:@"Helvetica" size:22]];
	self.fatUnitLabel.textAlignment = NSTextAlignmentRight;
    self.fatUnitLabel.numberOfLines = 0;
	self.fatUnitLabel.backgroundColor = [UIColor clearColor];
	self.fatUnitLabel.textColor = [UIColor whiteColor];
    self.fatUnitLabel.shadowColor = [UIColor blackColor];
    self.fatUnitLabel.shadowOffset = CGSizeMake(1,1);
    self.fatUnitLabel.text = @"0";
    
    self.fatUnit = [[UILabel alloc] initWithFrame:CGRectMake(60, 250, 15, 20)];
    [self.fatUnit setFont:[UIFont fontWithName:@"Helvetica" size:12]];
	self.fatUnit.textAlignment = NSTextAlignmentRight;
    self.fatUnit.numberOfLines = 0;
	self.fatUnit.backgroundColor = [UIColor clearColor];
	self.fatUnit.textColor = [UIColor whiteColor];
    self.fatUnit.shadowColor = [UIColor blackColor];
    self.fatUnit.shadowOffset = CGSizeMake(1,1);
    self.fatUnit.text = @"g";
    
    [_watermarkScroll addSubview:self.skinShadowImage];
    [_watermarkScroll addSubview:self.FoodNameLabel];
    [_watermarkScroll addSubview:self.FoodKcalLabel];
    [_watermarkScroll addSubview:self.UnitLabel];
    [_watermarkScroll addSubview:self.circleDrawer0];
    [_watermarkScroll addSubview:self.circleDrawer1];
    [_watermarkScroll addSubview:self.circleDrawer2];
    [_watermarkScroll addSubview:self.carbsUnitLabel];
    [_watermarkScroll addSubview:self.saltUnitLabel];
    [_watermarkScroll addSubview:self.fatUnitLabel];
    [_watermarkScroll addSubview:self.carbsUnit];
    [_watermarkScroll addSubview:self.saltUnit];
    [_watermarkScroll addSubview:self.fatUnit];
    [_watermarkScroll addSubview:self.carbsLabel];
    [_watermarkScroll addSubview:self.saltLabel];
    [_watermarkScroll addSubview:self.fatLabel];
    
    
    [self.cameraView.layer addSublayer:_watermarkScroll.layer];
    
    
    _watermarkScroll2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, self.cameraView.frame.size.height)];
    _watermarkScroll2.contentSize = CGSizeMake(320.0f, 320.0f);
    _watermarkScroll2.pagingEnabled = YES;
    _watermarkScroll2.backgroundColor = [UIColor clearColor];
    
    self.skinShadowImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 320.0f)];
    self.skinShadowImage2.image = [UIImage imageNamed:@"SkinShadow.png"];
    
    self.FoodNameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 110, 165, 90)];
    [self.FoodNameLabel2 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25]];
	self.FoodNameLabel2.textAlignment = NSTextAlignmentRight;
    self.FoodNameLabel2.numberOfLines = 0;
	self.FoodNameLabel2.backgroundColor = [UIColor clearColor];
	self.FoodNameLabel2.textColor = [UIColor whiteColor];
    self.FoodNameLabel2.shadowColor = [UIColor blackColor];
    self.FoodNameLabel2.shadowOffset = CGSizeMake(1,1);
    self.FoodNameLabel2.text = @"Healthy Food";
    
    self.FoodKcalLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(105, 255, 180, 60)];
    [self.FoodKcalLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:75]];
    self.FoodKcalLabel2.textAlignment = NSTextAlignmentRight;
    self.FoodKcalLabel2.numberOfLines = 0;
    self.FoodKcalLabel2.backgroundColor = [UIColor clearColor];
    self.FoodKcalLabel2.textColor = [UIColor whiteColor];
    self.FoodKcalLabel2.shadowColor = [UIColor blackColor];
    self.FoodKcalLabel2.shadowOffset = CGSizeMake(1,1);
    self.FoodKcalLabel2.text = @"0";
    
    self.UnitLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(285, 295, 58, 15)];
    [self.UnitLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:15]];
	self.UnitLabel2.textAlignment = NSTextAlignmentLeft;
    self.UnitLabel2.numberOfLines = 0;
	self.UnitLabel2.backgroundColor = [UIColor clearColor];
	self.UnitLabel2.textColor = [UIColor whiteColor];
    self.UnitLabel2.shadowColor = [UIColor blackColor];
    self.UnitLabel2.shadowOffset = CGSizeMake(1,1);
    self.UnitLabel2.text = @"Kcal";
    
    if (carbsRda < 50) {//橘色
        self.circleDrawer02 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else if (carbsRda < 150){//綠色
        self.circleDrawer02 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else if (carbsRda < 200){
        self.circleDrawer02 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else{// 紅色
        self.circleDrawer02 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 5.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                               ];
    }
    
    if (carbsRda > 100) {
        [self.circleDrawer02 drawPercentage:99.99 Rda:carbsRda];
    }else{
        [self.circleDrawer02 drawPercentage:carbsRda Rda:carbsRda];
    }
    
    self.carbsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(35, 80, 58, 15)];
    [self.carbsLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	self.carbsLabel2.textAlignment = NSTextAlignmentLeft;
    self.carbsLabel2.numberOfLines = 0;
	self.carbsLabel2.backgroundColor = [UIColor clearColor];
	self.carbsLabel2.textColor = [UIColor whiteColor];
    self.carbsLabel2.shadowColor = [UIColor blackColor];
    self.carbsLabel2.shadowOffset = CGSizeMake(1,1);
    self.carbsLabel2.text = @"Carbs";
    
    self.carbsUnitLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 53, 22)];
    [self.carbsUnitLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:22]];
	self.carbsUnitLabel2.textAlignment = NSTextAlignmentRight;
    self.carbsUnitLabel2.numberOfLines = 0;
	self.carbsUnitLabel2.backgroundColor = [UIColor clearColor];
	self.carbsUnitLabel2.textColor = [UIColor whiteColor];
    self.carbsUnitLabel2.shadowColor = [UIColor blackColor];
    self.carbsUnitLabel2.shadowOffset = CGSizeMake(1,1);
    self.carbsUnitLabel2.text = @"0";
    
    self.carbsUnit2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 15, 20)];
    [self.carbsUnit2 setFont:[UIFont fontWithName:@"Helvetica" size:12]];
	self.carbsUnit2.textAlignment = NSTextAlignmentRight;
    self.carbsUnit2.numberOfLines = 0;
	self.carbsUnit2.backgroundColor = [UIColor clearColor];
	self.carbsUnit2.textColor = [UIColor whiteColor];
    self.carbsUnit2.shadowColor = [UIColor blackColor];
    self.carbsUnit2.shadowOffset = CGSizeMake(1,1);
    self.carbsUnit2.text = @"g";
    
    
    if (saltRda < 50) {//橘色
        self.circleDrawer12 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else if (saltRda < 150){//綠色
        self.circleDrawer12 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else if (saltRda < 200){
        self.circleDrawer12 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else{// 紅色
        self.circleDrawer12 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                               ];
    }
    
    if (saltRda > 100) {
        [self.circleDrawer12 drawPercentage:99.99 Rda:carbsRda];
    }else{
        [self.circleDrawer12 drawPercentage:saltRda Rda:carbsRda];
    }
    
    self.saltLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 186, 58, 15)];
    [self.saltLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	self.saltLabel2.textAlignment = NSTextAlignmentLeft;
    self.saltLabel2.numberOfLines = 0;
	self.saltLabel2.backgroundColor = [UIColor clearColor];
	self.saltLabel2.textColor = [UIColor whiteColor];
    self.saltLabel2.shadowColor = [UIColor blackColor];
    self.saltLabel2.shadowOffset = CGSizeMake(1,1);
    self.saltLabel2.text = @"Salt";
    
    self.saltUnitLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, 53, 22)];
    [self.saltUnitLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:22]];
	self.saltUnitLabel2.textAlignment = NSTextAlignmentRight;
    self.saltUnitLabel2.numberOfLines = 0;
	self.saltUnitLabel2.backgroundColor = [UIColor clearColor];
	self.saltUnitLabel2.textColor = [UIColor whiteColor];
    self.saltUnitLabel2.shadowColor = [UIColor blackColor];
    self.saltUnitLabel2.shadowOffset = CGSizeMake(1,1);
    self.saltUnitLabel2.text = @"0";
    
    self.saltUnit2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 145, 15, 20)];
    [self.saltUnit2 setFont:[UIFont fontWithName:@"Helvetica" size:12]];
	self.saltUnit2.textAlignment = NSTextAlignmentRight;
    self.saltUnit2.numberOfLines = 0;
	self.saltUnit2.backgroundColor = [UIColor clearColor];
	self.saltUnit2.textColor = [UIColor whiteColor];
    self.saltUnit2.shadowColor = [UIColor blackColor];
    self.saltUnit2.shadowOffset = CGSizeMake(1,1);
    self.saltUnit2.text = @"g";
    
    if (fatRda < 50) {//橘色
        self.circleDrawer22 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 215.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else if (fatRda < 150){//綠色
        self.circleDrawer22 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 215.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:134.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else if (fatRda < 200){
        self.circleDrawer22 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 110.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:0.8f]
                               ];
    }else{// 紅色
        self.circleDrawer22 = [[CircleDrawer alloc] initWithPosition:CGPointMake(5.0f, 215.0f)
                                                              radius:47.5f
                                                      internalRadius:26.0f
                                                   circleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.6f]
                                             activeCircleStrokeColor:[UIColor colorWithRed:218.0f/255.0f green:78.0f/255.0f blue:53.0f/255.0f alpha:0.8f]
                               ];
    }
    
    if (fatRda > 100) {
        [self.circleDrawer22 drawPercentage:99.99 Rda:fatRda];
    }else{
        [self.circleDrawer22 drawPercentage:fatRda Rda:fatRda];
    }
    
    self.fatLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(42, 290, 58, 15)];
    [self.fatLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	self.fatLabel2.textAlignment = NSTextAlignmentLeft;
    self.fatLabel2.numberOfLines = 0;
	self.fatLabel2.backgroundColor = [UIColor clearColor];
	self.fatLabel2.textColor = [UIColor whiteColor];
    self.fatLabel2.shadowColor = [UIColor blackColor];
    self.fatLabel2.shadowOffset = CGSizeMake(1,1);
    self.fatLabel2.text = @"Fat";
    
    self.fatUnitLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 255, 53, 22)];
    [self.fatUnitLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:22]];
	self.fatUnitLabel2.textAlignment = NSTextAlignmentRight;
    self.fatUnitLabel2.numberOfLines = 0;
	self.fatUnitLabel2.backgroundColor = [UIColor clearColor];
	self.fatUnitLabel2.textColor = [UIColor whiteColor];
    self.fatUnitLabel2.shadowColor = [UIColor blackColor];
    self.fatUnitLabel2.shadowOffset = CGSizeMake(1,1);
    self.fatUnitLabel2.text = @"0";
    
    self.fatUnit2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 250, 15, 20)];
    [self.fatUnit2 setFont:[UIFont fontWithName:@"Helvetica" size:12]];
	self.fatUnit2.textAlignment = NSTextAlignmentRight;
    self.fatUnit2.numberOfLines = 0;
	self.fatUnit2.backgroundColor = [UIColor clearColor];
	self.fatUnit2.textColor = [UIColor whiteColor];
    self.fatUnit2.shadowColor = [UIColor blackColor];
    self.fatUnit2.shadowOffset = CGSizeMake(1,1);
    self.fatUnit2.text = @"g";
    
    [_watermarkScroll2 addSubview:self.skinShadowImage2];
    [_watermarkScroll2 addSubview:self.FoodNameLabel2];
    [_watermarkScroll2 addSubview:self.FoodKcalLabel2];
    [_watermarkScroll2 addSubview:self.UnitLabel2];
    [_watermarkScroll2 addSubview:self.circleDrawer02];
    [_watermarkScroll2 addSubview:self.circleDrawer12];
    [_watermarkScroll2 addSubview:self.circleDrawer22];
    [_watermarkScroll2 addSubview:self.carbsLabel2];
    [_watermarkScroll2 addSubview:self.saltLabel2];
    [_watermarkScroll2 addSubview:self.fatLabel2];
    [_watermarkScroll2 addSubview:self.carbsUnitLabel2];
    [_watermarkScroll2 addSubview:self.saltUnitLabel2];
    [_watermarkScroll2 addSubview:self.fatUnitLabel2];
    [_watermarkScroll2 addSubview:self.carbsUnit2];
    [_watermarkScroll2 addSubview:self.saltUnit2];
    [_watermarkScroll2 addSubview:self.fatUnit2];
    
    [self.getImageView.layer addSublayer:_watermarkScroll2.layer];
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

-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        NSLog(@"save error");
        
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"Saved Successfully!");
    }
}

- (void)addHollowOpenToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.delegate = self;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"cameraIrisHollowOpen";
    [view.layer addAnimation:animation forKey:@"animation"];
}

- (void)addHollowCloseToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];//初始化動畫
    animation.duration = 0.5f;//間隔的時間
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cameraIrisHollowClose";
    
    [view.layer addAnimation:animation forKey:@"HollowClose"];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

#pragma mark - IBAction
- (IBAction)disappearKeyboard:(id)sender {
    if ([self isKeyboardOnScreen]) {
        self.disappearKeyboardButton.hidden = NO;
        [self.foodNameTextField resignFirstResponder];
    }else{
        //Do nothing.
        self.disappearKeyboardButton.hidden = YES;
    }
}

- (IBAction)changeFlash:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && [_device hasFlash])
    {
        [_flashButton setEnabled:NO];
        [_device lockForConfiguration:nil];
        if([_device flashMode] == AVCaptureFlashModeOff)
        {
            [_device setFlashMode:AVCaptureFlashModeAuto];
            [_flashButton setImage:[UIImage imageNamed:@"shoot"] forState:UIControlStateNormal];//自動
        }
        else if([_device flashMode] == AVCaptureFlashModeAuto)
        {
            [_device setFlashMode:AVCaptureFlashModeOn];
            [_flashButton setImage:[UIImage imageNamed:@"shoot_on"] forState:UIControlStateNormal];//閃光
        }
        else{
            [_device setFlashMode:AVCaptureFlashModeOff];
            [_flashButton setImage:[UIImage imageNamed:@"shoot_off"] forState:UIControlStateNormal];//關閉
        }
        [_device unlockForConfiguration];
        [_flashButton setEnabled:YES];
    }
}

- (IBAction)positionChange:(id)sender {
    //添加動畫
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .8f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    if (_device.position == AVCaptureDevicePositionFront) {
        animation.subtype = kCATransitionFromRight;
    }
    else if(_device.position == AVCaptureDevicePositionBack){
        animation.subtype = kCATransitionFromLeft;
    }
    [_preview addAnimation:animation forKey:@"animation"];
    
    NSArray *inputs = _session.inputs;
    for ( AVCaptureDeviceInput *input in inputs )
    {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
                self.flashButton.hidden = NO;
            }
            else
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
                self.flashButton.hidden = YES;
            }
            _device = newCamera;
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [_session beginConfiguration];
            
            [_session removeInput:input];
            [_session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [_session commitConfiguration];
            break;
        }
    }
}

- (IBAction)takePhoto:(id)sender {
    _isAlbum = NO;
    
    self.takePhotoButton.userInteractionEnabled = NO;
    
//    [self addHollowCloseToView:self.cameraView];
    
    //get connection
    AVCaptureConnection *videoConnection;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         _saveButton.hidden = NO;
         _cancelButton.hidden = NO;
         _albumButton.hidden = YES;
         _positionButton.hidden = YES;
         _flashButton.hidden = YES;
         [self addHollowCloseToView:self.cameraView];
         [_session stopRunning];
         [self addHollowOpenToView:self.cameraView];
         
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         UIImage *image = [[UIImage alloc ] initWithData:imageData];

         self.cameraView.hidden = YES;
         self.getImageView.image = image;
         self.getImageView.hidden = NO;
     }];
}

//- (UIImage *)imageScaledToSize:(UIImage *)originalImage:(CGSize)size
//{
//    //avoid redundant drawing
//    if (CGSizeEqualToSize(originalImage.size, size))
//    {
//        return originalImage;
//    }
//    
//    //create drawing context
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
//    
//    //draw
//    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
//    
//    //capture resultant image
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    //return image
//    return image;
//}

- (IBAction)albumButtonPressed:(id)sender {
    [self shouldPresentPhotoCaptureController];
}

- (IBAction)cancelAction:(id)sender {
    _isAlbum = NO;
    self.takePhotoButton.userInteractionEnabled = YES;
    _saveButton.hidden = YES;
    _cancelButton.hidden = YES;
    _albumButton.hidden = NO;
    _positionButton.hidden = NO;
    _flashButton.hidden = NO;
    self.getImageView.image = nil;
    self.cameraView.hidden = NO;
    [_session startRunning];
}

- (IBAction)saveAction:(id)sender {
    NSLog(@"save action");
    //如果照片來自於本機得相簿，就不用在儲存了。
    if (_isAlbum) {
        // Do nothing.
    }else{
        UIImageWriteToSavedPhotosAlbum(_getImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
//    _saveButton.hidden = YES;
//    _cancelButton.hidden = YES;
//    _albumButton.hidden = NO;
//    [_session startRunning];
    
    //轉場至share.
    [self performSegueWithIdentifier:@"saveDown" sender:nil];
}

- (IBAction)closeBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)teachBtnAction:(id)sender {
    if ([self isKeyboardOnScreen]) {
        self.disappearKeyboardButton.hidden = NO;
        [self.foodNameTextField resignFirstResponder];
    }
    self.teachImage.hidden = NO;
    self.clearButton.hidden = NO;
    //按鈕不能按。
    _takePhotoButton.userInteractionEnabled = NO;
    _albumButton.userInteractionEnabled = NO;
    _ingredientsButton.userInteractionEnabled = NO;
    _reportButton.userInteractionEnabled = NO;
}

- (IBAction)editFoodNameAction:(id)sender {
    NSLog(@"編輯食物名稱");
    if (self.foodNameTextField.text.length == 0) {
        self.foodNameTextField.text = @"Healthy Food";
    }
    self.keyboardCoView.hidden = NO;
    [self.foodNameTextField becomeFirstResponder];
}

- (IBAction)clearFoodNameAction:(id)sender {
    self.foodNameTextField.text = nil;
}

- (IBAction)clearButtonPressed:(id)sender {
    self.teachImage.hidden = YES;
    self.clearButton.hidden = YES;
    //按鈕不能按。
    _takePhotoButton.userInteractionEnabled = YES;
    _albumButton.userInteractionEnabled = YES;
    _ingredientsButton.userInteractionEnabled = YES;
    _reportButton.userInteractionEnabled = YES;
}

- (IBAction)reportButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"report" sender:nil];
}

- (IBAction)keyboardDoneButtonPressed:(id)sender {
    [self.foodNameTextField resignFirstResponder];
    self.FoodNameLabel.text = self.foodNameTextField.text;
    self.FoodNameLabel2.text = self.foodNameTextField.text;
}

- (IBAction)addIngredents:(id)sender {
    [self performSegueWithIdentifier:@"ingredientsSegue" sender:nil];
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2{
	UIGraphicsBeginImageContext(image1.size);
	[image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
	[image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resultingImage;
}

//目標ViewController要添加一個setDetailItem的方法，用來接收這裡的參數
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // ensure this is the Seque which is leading to the detail view
    if ([[segue identifier] isEqualToString:@"saveDown"])
    {
        SharingViewController *detail = [segue destinationViewController];
        //傳送資料含蓋合成後的照片、食物的最後紀錄、食物名稱、

//        [self.imagePicker setResizeableCropArea:YES];
        
        if (self.albumButton.isHidden) {
            
            if (_isAlbum) {
                NSLog(@" stat here 1");
                
                CGRect croppedRect = CGRectMake(0, 0, 640, 640);
                CGImageRef croppedImage = CGImageCreateWithImageInRect(self.getImageView.image.CGImage, croppedRect);
                _croppedImage = [[UIImage alloc] initWithCGImage:croppedImage];
                CFRelease(croppedImage);
            }else{
                NSLog(@" stat here 2");
                
                CGRect croppedRect = CGRectMake(0, 0, 640, 640);
                CGImageRef croppedImage = CGImageCreateWithImageInRect(self.getImageView.image.CGImage, croppedRect);
                _croppedImage = [[UIImage alloc] initWithCGImage:croppedImage];
                
                CGImageRelease(croppedImage);
                
            }
            
        }else{
            NSLog(@" stat here 3");
            self.imageCropView = [[GKImageCropView alloc] initWithFrame:self.view.bounds];
            [self.imageCropView setImageToCrop:self.getImageView.image];
            [self.imageCropView setResizableCropArea:YES];
            [self.imageCropView setCropSize:CGSizeMake(320, 320)];
        }
        
        NSString *isAlbumBool = [NSString stringWithFormat:@"%i", _isAlbum];
        
        Meal *currentMeal = [OmniTool getCurrentMeal];
        NSMutableArray *detailArray = [[NSMutableArray alloc] initWithObjects:self.getImageView, currentMeal,self.FoodNameLabel, isAlbumBool, nil];
        [detail setDetailItem:detailArray];
    } else if ([[segue identifier] isEqualToString:@"report"]){
        //傳送資料為照片
        ReportViewController *detail = [segue destinationViewController];
        //傳送資料含蓋合成後的照片、食物的最後紀錄、食物名稱、
        
        //        [self.imagePicker setResizeableCropArea:YES];
        if (self.albumButton.isHidden) {
            
            if (_isAlbum) {
                NSLog(@" stat here 1");
                
//                CGRect croppedRect = CGRectMake(0, 0, 640, 640);
//                CGImageRef croppedImage = CGImageCreateWithImageInRect(self.getImageView.image.CGImage, croppedRect);
//                _croppedImage = [[UIImage alloc] initWithCGImage:croppedImage];
            }else{
                NSLog(@" stat here 2");
                
//                CGRect croppedRect = CGRectMake(0, 0, 640, 640);
//                CGImageRef croppedImage = CGImageCreateWithImageInRect(self.getImageView.image.CGImage, croppedRect);
//                _croppedImage = [[UIImage alloc] initWithCGImage:croppedImage];
//                
//                CGImageRelease(croppedImage);
                
            }
            
        }else{
            NSLog(@" stat here 3");
//            self.imageCropView = [[GKImageCropView alloc] initWithFrame:self.view.bounds];
//            [self.imageCropView setImageToCrop:self.getImageView.image];
//            [self.imageCropView setResizableCropArea:YES];
//            [self.imageCropView setCropSize:CGSizeMake(320, 320)];
        }
        
        NSString *isAlbumBool = [NSString stringWithFormat:@"%i", _isAlbum];
        
        Meal *currentMeal = [OmniTool getCurrentMeal];
        NSMutableArray *detailArray = [[NSMutableArray alloc] initWithObjects:self.getImageView, currentMeal,self.FoodNameLabel, isAlbumBool, nil];
        [detail setDetailItem:detailArray];
    }else if ([[segue identifier] isEqualToString:@"ingredientsSegue"]){
        
    }
}


//啓動相簿
- (BOOL)shouldPresentPhotoCaptureController {
    
    BOOL presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
//    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
//    
//    if (!presentedPhotoCaptureController) {
//        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
//    }
    return presentedPhotoCaptureController;
}

- (BOOL)shouldStartCameraController {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    } else {
        return NO;
    }
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = NO;
    cameraUI.delegate = self;
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
//    [cameraUI takePicture];
    
    [self presentViewController:cameraUI animated:YES completion:NULL];
//    [self presentModalViewController:cameraUI animated:YES];
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
    } else {
        return NO;
    }
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:NULL];
//    [self presentModalViewController:cameraUI animated:YES];
    return YES;
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSLog(@"從相簿");
    self.getImageView.hidden = NO;
//    [self dismissModalViewControllerAnimated:NO];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //透明度
//    if (self.albumButton.isHidden) {
//        [self.cameraView.layer addSublayer:_watermarkScroll.layer];
//        self.cameraView.hidden = NO;
//    }else{
//        [self.cameraView.layer addSublayer:_watermarkScroll.layer];
//        self.cameraView.hidden = YES;
//    }
    self.cameraView.hidden = YES;
    self.getImageView.image = image;
    
    _isAlbum = YES;
    
    _saveButton.hidden = NO;
    _cancelButton.hidden = NO;
    _albumButton.hidden = YES;
    _positionButton.hidden = YES;
    _flashButton.hidden = YES;
    //    [self.placeholderLabel setAlpha:0.0f];
    [self shouldUploadImage:image];
}

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    return YES;
}

#pragma mark - Keyboard events
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.keyboardCoView.frame;
        frame.origin.y -= kbSize.height;
        self.keyboardCoView.frame = frame;
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.keyboardCoView.frame;
        frame.origin.y += kbSize.height;
        self.keyboardCoView .frame = frame;
        
    }];
}

#pragma mark - TextField Delegate
//回車鍵、退出鍵盤
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self.foodNameTextField.text isEqualToString:@"\n"]) {
        [self.foodNameTextField resignFirstResponder];
    }
    return YES;
}

//開始編輯食物名稱
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"開始編輯食物名稱");
    
    if (self.foodNameTextField.text.length == 0) {
        self.foodNameTextField.text = @"Healthy Food";
    }
    
    self.disappearKeyboardButton.hidden = NO;
}
//結束編輯食物名稱
- (void) textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"結束編輯食物名稱");
    self.disappearKeyboardButton.hidden = YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"將要結束編輯食物名稱");
    self.disappearKeyboardButton.hidden = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"按下Down 要結束編輯食物名稱");
    if (self.foodNameTextField.text.length == 0) {
        self.FoodNameLabel.text = @"Healthy Food";
        self.FoodNameLabel2.text = @"Healthy Food";
        self.foodNameTextField.text = @"Healthy Food";
    }else{
        self.FoodNameLabel.text = self.foodNameTextField.text;
        self.FoodNameLabel2.text = self.foodNameTextField.text;
    }
    self.disappearKeyboardButton.hidden = YES;
    [self.foodNameTextField resignFirstResponder];
    return YES;
}

@end
