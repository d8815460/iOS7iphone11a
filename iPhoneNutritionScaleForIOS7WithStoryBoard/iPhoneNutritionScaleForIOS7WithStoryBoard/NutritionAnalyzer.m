//
//  NutritionAnalyzer.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "NutritionAnalyzer.h"

@interface NutritionAnalyzer ()
{
    Boolean scaleIsOpen;
}
@end

@implementation NutritionAnalyzer
@synthesize currentWeight;
@synthesize overViewFood;
@synthesize iPhoneScaleContentView;
@synthesize detailItem = _detailItem;
@synthesize didntSaveIngredientWeight = _didntSaveIngredientWeight;
@synthesize didConnectScaleWeight = _didConnectScaleWeight;

- (void)setDetailItem:(id)detailItem{
    if (_detailItem != detailItem) {
        _detailItem = detailItem;
        
        selectedIngredient = _detailItem;
        _didntSaveIngredientWeight = selectedIngredient.weight;
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _isSave = NO;
    
    if (selectedIngredient.weight > 500.0f) {
        self.manualInputView.iWeightSlider.maximumValue = selectedIngredient.weight;
    }else{
        self.manualInputView.iWeightSlider.maximumValue = 500.0f;
    }
    
    //尚未編輯模式
    self.manualInputView.iWeightSlider.hidden = YES;
    self.manualInputView.changeWeightInputBtn.hidden = YES;
    self.scaleInputView.iPhoneChangeButton.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    // default is input mode
    isInputWeightView = YES;
    self.manualInputView.alpha = 1.0f;
    self.scaleInputView.alpha = 0.0f;
    
    self.foodTitle.text=[nutritionViewSelectedFood title];
    self.foodDescription.text=[nutritionViewSelectedFood subTitle];
    self.foodNumber=[nutritionViewSelectedFood foodNumber];
    
    // Adjust default input weight
    // selectedIngredient.weight
    self.manualInputView.iWeightSlider.value = _didntSaveIngredientWeight;
    self.manualInputView.iWeightLabel.text = [NSString stringWithFormat:@"%.0f", _didntSaveIngredientWeight];
    
    self.EditAndSaveButton.title = @"Save";
    [self EditMode];
    
    [OmniTool updateSearchCount:self.foodNumber];
    [OmniTool logSearch:self.foodNumber];
    
    [self.iPhoneScaleContentView addSubview:self.scaleInputView];
    [self.iPhoneScaleContentView addSubview:self.manualInputView];
    
    //******* UI ********** 第一次進場 scale 預設是關閉，不用設定UI
    scaleIsOpen = NO;
    
	// add into Bluetooth Listener list
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] addBLEListener:self];
    
	[self initialScaleView];
    [self stateNotConnected];
    
    //取消右划返回。
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void) initialScaleView
{
    //manage orientation
    orientation = [OmniTool getCurrentOrientation];
    
	// connect button
    self.scaleInputView.connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scaleInputView.connectButton setBackgroundImage:[UIImage imageNamed:@"connectscale.png"] forState:UIControlStateNormal];
	[self.scaleInputView.connectButton addTarget:self action:@selector(clickConnect:) forControlEvents:UIControlEventTouchUpInside];
	[self.scaleInputView addSubview:self.scaleInputView.connectButton];
    
	// cancel button while connecting
    self.scaleInputView.cancelConnectingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scaleInputView.cancelConnectingButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
	[self.scaleInputView.cancelConnectingButton addTarget:self action:@selector(clickCancelConnectingButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.scaleInputView addSubview:self.scaleInputView.cancelConnectingButton];

	// message label
	self.scaleInputView.messageLabel = [[UILabel alloc] init];
	[self.scaleInputView.messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	self.scaleInputView.messageLabel.textAlignment = NSTextAlignmentCenter;
	self.scaleInputView.messageLabel.backgroundColor = [UIColor clearColor];
	self.scaleInputView.messageLabel.text = @"Connecting";
	self.scaleInputView.messageLabel.textColor = [UIColor blackColor];
	[self.scaleInputView addSubview:self.scaleInputView.messageLabel];
    self.scaleInputView.messageLabel.frame = CGRectMake(73, 12,200, 48);
    self.scaleInputView.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.scaleInputView.messageLabel.numberOfLines = 0;

    
	// connecting label
	/*
	self.scaleInputView.connectingLabel = [[UILabel alloc] init];
	[self.scaleInputView.connectingLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	self.scaleInputView.connectingLabel.textAlignment = NSTextAlignmentCenter;
	self.scaleInputView.connectingLabel.backgroundColor = [UIColor clearColor];
	self.scaleInputView.connectingLabel.text = @"Connecting";
	self.scaleInputView.connectingLabel.textColor = [UIColor blackColor];
	[self.scaleInputView addSubview:self.scaleInputView.connectingLabel];
    */
    
	// spinner
	self.scaleInputView.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.scaleInputView.spinner.hidesWhenStopped = YES;
    [self.scaleInputView addSubview:self.scaleInputView.spinner];
    [self.scaleInputView.spinner startAnimating];
    
    
	// OK button while connection failed
    self.scaleInputView.okReconnectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scaleInputView.okReconnectButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
	self.scaleInputView.okReconnectButton.tag = 0;
	[self.scaleInputView.okReconnectButton addTarget:self action:@selector(clickOkReconnectButton:) forControlEvents:UIControlEventTouchUpInside];
	
    
	// CANCEL button while connection failed
    self.scaleInputView.cancelConnectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scaleInputView.cancelConnectButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
	self.scaleInputView.cancelConnectButton.tag = 0;
	[self.scaleInputView.cancelConnectButton addTarget:self action:@selector(clickCancelConnectButton:) forControlEvents:UIControlEventTouchUpInside];
	
    /*
	self.scaleInputView.connectionFailedLabel = [[UILabel alloc] init];
	[self.scaleInputView.connectionFailedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	self.scaleInputView.connectionFailedLabel.textAlignment = NSTextAlignmentCenter;
	self.scaleInputView.connectionFailedLabel.backgroundColor = [UIColor clearColor];
	self.scaleInputView.connectionFailedLabel.text = @"Connection failed,";
	self.scaleInputView.connectionFailedLabel.textColor = [UIColor blackColor];
*/
/*	
    self.scaleInputView.tryAgainLabel = [[UILabel alloc] init];
	[self.scaleInputView.tryAgainLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	self.scaleInputView.tryAgainLabel.textAlignment = NSTextAlignmentCenter;
	self.scaleInputView.tryAgainLabel.backgroundColor = [UIColor clearColor];
	self.scaleInputView.tryAgainLabel.text = @"Would you like to try again?";
	self.scaleInputView.tryAgainLabel.textColor = [UIColor colorWithRed:62.0/255.0 green:115.0/255.0 blue:0.0/255.0 alpha:1.0];
*/	
    
    //******* UI ********** 第一次進場
    //Tare 按鈕
    self.scaleInputView.tareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scaleInputView.tareButton setBackgroundImage:[UIImage imageNamed:@"tare5.png"] forState:UIControlStateNormal];
    [self.scaleInputView.tareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.scaleInputView.tareButton addTarget:self action:@selector(clickTare:) forControlEvents:UIControlEventTouchUpInside];
    
    //電池電量顯示
    self.scaleInputView.batteryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_battery.png"]];
    self.scaleInputView.batteryImageView.frame = CGRectMake(265, 10, 20, 10);

    self.scaleInputView.bateryLabel = [[UILabel alloc] init];
    self.scaleInputView.bateryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
    self.scaleInputView.bateryLabel.textAlignment = NSTextAlignmentCenter;
    self.scaleInputView.bateryLabel.backgroundColor = [UIColor clearColor];
    self.scaleInputView.bateryLabel.textColor = [UIColor colorWithRed:216.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0];
    self.scaleInputView.bateryLabel.text = @"19%";  //這裡要串接電池含量的float
    self.scaleInputView.bateryLabel.frame = CGRectMake(284, 7, 33,14);
    
	// retrieve default unit, which is saved last time
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	translatedWeightUnit  = (int) [userPrefs integerForKey:@"defaultUnit"];
	translatedWeightUnit=[OmniTool adjustUnit:translatedWeightUnit];
	NSString *unitString=[OmniTool unitIntToString:translatedWeightUnit];
    
    // 單位按鈕
	[self.scaleInputView.iUnitButton setTitle:unitString forState:UIControlStateNormal];
    
    
    //NET Label
    self.scaleInputView.netLabel = [[UILabel alloc] init];
    self.scaleInputView.netLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    self.scaleInputView.netLabel.textAlignment = NSTextAlignmentRight;
    self.scaleInputView.netLabel.backgroundColor = [UIColor clearColor];
    self.scaleInputView.netLabel.textColor = [UIColor blackColor];
    self.scaleInputView.netLabel.text = @"NET";
    self.scaleInputView.netLabel.alpha=0;
    
    CGPoint _connectButtonPoint = CGPointMake(92, 29);

    CGPoint _spinnerPoint       = CGPointMake(64, 42);
    
    self.scaleInputView.tareButton.frame = CGRectMake(110, 70, 101.0f, 35.0f);
    self.scaleInputView.netLabel.frame = CGRectMake(81, 8, 36, 18);
    self.scaleInputView.connectButton.frame = CGRectMake(_connectButtonPoint.x, _connectButtonPoint.y, 136, 47);
    self.scaleInputView.cancelConnectingButton.frame = CGRectMake(110, 72, 101, 35);

    self.scaleInputView.okReconnectButton.frame = CGRectMake(66, 72, 97, 34);
    self.scaleInputView.cancelConnectButton.frame = CGRectMake(182,72, 97, 34);
    // self.scaleInputView.connectionFailedLabel.frame = CGRectMake(_connectionFailedLabelPoint.x, _connectionFailedLabelPoint.y, 320, 30);
    // self.scaleInputView.tryAgainLabel.frame = CGRectMake(_tryAgainLabelPoint.x, _tryAgainLabelPoint.y, 320, 30);
    self.scaleInputView.spinner.frame = CGRectMake(_spinnerPoint.x, _spinnerPoint.y, 22, 22);
    // self.scaleInputView.connectingLabel.frame = CGRectMake(71, 54,201, 48);
    
    
    //設定對其項目後，不用另外設定動畫。以battery為例，就是距離右邊位置維持一致。
    self.scaleInputView.batteryImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.scaleInputView.bateryLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [self.scaleInputView addSubview:self.scaleInputView.tareButton];
    [self.scaleInputView addSubview:self.scaleInputView.netLabel];
    [self.scaleInputView addSubview:self.scaleInputView.batteryImageView];
    [self.scaleInputView addSubview:self.scaleInputView.bateryLabel];
    [self.scaleInputView addSubview:self.scaleInputView.okReconnectButton];
    [self.scaleInputView addSubview:self.scaleInputView.cancelConnectButton];
    // [self.scaleInputView addSubview:self.scaleInputView.connectionFailedLabel];
    // [self.scaleInputView addSubview:self.scaleInputView.tryAgainLabel];
    // [self.scaleInputView addSubview:self.scaleInputView.connectingLabel];
    [self.scaleInputView addSubview:self.scaleInputView.messageLabel];
    [self.scaleInputView addSubview:self.scaleInputView.cancelConnectingButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nutrient Table data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 33;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 29;
    }
    return 0;
}

// set height for the header
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // initial UIView for header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 37)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
//    headerView.backgroundColor =[UIColor clearColor];
    // initial title label for header view
    UILabel *titleGroup = [[UILabel alloc] init];
    [titleGroup setBackgroundColor:[UIColor clearColor]];
    [titleGroup setFrame:CGRectMake(13.0f, 0.0f, 200 , 21.0f)];
    titleGroup.textColor =[UIColor blackColor];
    titleGroup.font = [UIFont fontWithName:@"Helvetica Light" size:12.0];
    [titleGroup setTextAlignment:NSTextAlignmentLeft];
    
    
    CGPoint _subTitlePoint = CGPointMake(207, 0);
    // initial sub title label for header view
    UILabel *subTitleGroup = [[UILabel alloc] init];
    [subTitleGroup setBackgroundColor:[UIColor clearColor]];
    [subTitleGroup setFrame:CGRectMake(_subTitlePoint.x, _subTitlePoint.y, 100 , 21.0f)];
    subTitleGroup.textColor = [UIColor blackColor];
    subTitleGroup.font = [UIFont fontWithName:@"Helvetica Light" size:12.0f];
    [subTitleGroup setTextAlignment:NSTextAlignmentRight];
    subTitleGroup.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    // there are 3 sections with different title and sub title
    if (section == 0) {
        [titleGroup setText:@"Category"];
        [subTitleGroup setText:@" Servings    DV%  "];
    }else if (section ==1){
        [titleGroup setText:@"MAIN"];
        [subTitleGroup setText:@""];
    }else if (section ==2){
        [titleGroup setText:@"OTHERS"];
        [subTitleGroup setText:@""];
    }
    
    [headerView addSubview:titleGroup];
    [headerView addSubview:subTitleGroup];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    float foodWeight;
    // selectedIngredient.weight
    
    if (_isSave) {
        if(selectedIngredient)
        {
            foodWeight = selectedIngredient.weight;
        }else{
            // get the Overview Object
            foodWeight=self.currentWeight;
        }
    }else{
        if(selectedIngredient)
        {
            //判斷有沒有藍牙連秤，沒有連接磅秤狀況下，數值為0
            if (isInputWeightView) {
                foodWeight =_didntSaveIngredientWeight;
            }else{
                if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] isPeripheralConnected]) {
                    foodWeight = _didConnectScaleWeight;
                }else{
                    foodWeight = 0;
                }
            }
        }else{
            // get the Overview Object
            foodWeight=self.currentWeight;
        }
    }
    if(self.foodNumber){
    	if(foodWeight <0)
    		foodWeight=0;
        FoodOverview *overview = [OmniTool getFoodOverview:self.foodNumber forUserType:1 weight:foodWeight];
        self.overViewFood = overview;
    }else{
    	// no food selected, abort generating cells
    	NSLog(@"ERROR cellForRowAtIndexPath: no food selected");
    }
    
    static NSString *CellIdentifier = @"CustomDetailCell";
    CustomDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CGSize _VauleViewSize = CGSizeMake(200, 14);
    UIColor *greenColor=[UIColor colorWithRed:134.0f/255.0f green:170.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    UIColor *redColor=[UIColor colorWithRed:216.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0];
    UIColor *orangeColor=[UIColor colorWithRed:234.0f/255.0f green:164.0f/255.0f blue:56.0f/255.0f alpha:1.0];
	NSArray *rdaNutrientArray = [self.overViewFood rdaFoodNutrientArray];
    if (indexPath.section == 0 && indexPath.row <[rdaNutrientArray count]) {
		// acquire the corresponding nutrient
		FoodNutrient *foodNutrient= [rdaNutrientArray objectAtIndex:indexPath.row];
		/*
		new rule 20131003
		0% ~ 50 % 橘色
		50% ~ 150% 綠色
		150% ~ 200％ 橘色
		200%+ ~ 紅色
		*/
		float rdaRatio=[foodNutrient rdaRatio];
        if (rdaRatio<1.0) {
            cell.cellNutrientVauleView.frame = CGRectMake(13, 21, _VauleViewSize.width*rdaRatio, _VauleViewSize.height);
        }else{
            cell.cellNutrientVauleView.frame = CGRectMake(13, 21, _VauleViewSize.width, _VauleViewSize.height);
        }
        
        if (rdaRatio == 0){
            cell.cellNutrientVauleView.backgroundColor = [UIColor clearColor]; //無顏色
        }else if (rdaRatio< 0.5 ){
            cell.cellNutrientVauleView.backgroundColor = orangeColor;
        }else if (rdaRatio<1.5) {
            cell.cellNutrientVauleView.backgroundColor = greenColor;
        }else if (rdaRatio< 2 ){
            cell.cellNutrientVauleView.backgroundColor = orangeColor;
        }else{
            cell.cellNutrientVauleView.backgroundColor = redColor;
        }
        // set title, value, and ratio text
        cell.cellNutrientTitleLabel.text = [foodNutrient nutrientShortName];
        cell.cellNutrientVauleLabel.text = [NSString stringWithFormat:@"%.0f %@", [foodNutrient nutrientValue],[foodNutrient unit]];
        cell.cellNutrientVauleRadioLabel.text = [NSString stringWithFormat:@"%.0f%%", rdaRatio*100*3];
	}
    
    return cell;
}

-(IBAction)iPhoneSliderValueChanged:(id)sender{
    [self updateSliderPopoverText];
    [self weightUpdate];
    if(selectedIngredient)
    {
        _didntSaveIngredientWeight = self.manualInputView.iWeightSlider.value;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // NSLog(@"prepareForSegue Analyzer");
}

- (void)updateSliderPopoverText
{
    self.manualInputView.iWeightLabel.text = [NSString stringWithFormat:@"%.0f", self.manualInputView.iWeightSlider.value];
}

-(void) weightUpdate  // called when the bluetooth is asking a new weight, to simulate the weigh change
{
#ifdef DEBUG_SCALE_COMMAND
    NSLog(@"weightUpdate %.0f",inputWeight);
#endif

	NSString *weightFormat=@"%.0f";
	translatedWeight = [OmniTool unitConvert:inputWeight SourceUnit:inputWeightUnit TargetUnit:translatedWeightUnit];
	// different unit got different format
	switch(translatedWeightUnit)
	{
	    case UNIT_G:
            weightFormat=@"%.1f";
	        break;
	    case UNIT_LB:
	        weightFormat=@"%.2f";
	        break;
	    case UNIT_OZ:
	        weightFormat=@"%.2f";
	        break;
	    case UNIT_CATTY:
	        weightFormat=@"%.3f";
	        break;
	    case UNIT_TAEL:
	        weightFormat=@"%.2f";
	        break;
	    case UNIT_CHIAN:
	        weightFormat=@"%.1f";
	        break;
	}
    
	self.scaleInputView.iWeightLabel.text=[NSString stringWithFormat:weightFormat, translatedWeight];
    
    if (isInputWeightView) {
        if ([self.manualInputView.iWeightLabel.text doubleValue]< 0.0f) {
            self.EditAndSaveButton.enabled = NO;
        }else{
            self.EditAndSaveButton.enabled = YES;
        }
    }else{
        if ([self.scaleInputView.iWeightLabel.text doubleValue]< 0.0f) {
            self.EditAndSaveButton.enabled = NO;
        }else{
            self.EditAndSaveButton.enabled = YES;
        }
    }
    //藍芽連線狀態
    if (isInputWeightView) {
        double weight = [self.manualInputView.iWeightLabel.text doubleValue];
        self.currentWeight = weight;
    }else{
        if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] isPeripheralConnected]) {
            self.currentWeight = [OmniTool getCurrentGram];
            // modify the selectedIngredient.weight by [OmniTool getCurrentGram]
            if(selectedIngredient)
                _didConnectScaleWeight = (float) self.currentWeight;
        }else{
            self.currentWeight = 0;
        }
    }
    
    //視覺化圖表依重量取得該食物的營養量。
    if (!self.foodNumber || !self.currentWeight) {
        if(self.foodNumber){
		    FoodOverview *overview = [OmniTool getFoodOverview:self.foodNumber forUserType:1 weight:0];
		    self.overViewFood = overview;
        }
    }else{
    	float foodWeight=self.currentWeight;
    	if(foodWeight<0)
    		foodWeight=0;
	    FoodOverview *overview = [OmniTool getFoodOverview:self.foodNumber forUserType:1 weight:foodWeight];
	    self.overViewFood = overview;
    }
    
    [self.nutrientTable reloadData];
}
/******************************** BLEUIProtocol ***********************************************/
-(void) BLEinitializing{	// called when the bluetooth manager is just initializing
#ifdef DEBUG_STATE_TRANSITION
	NSLog(@"BLEinitializing");
#endif
    
	self.scaleInputView.connectButton.hidden=YES;
    
	self.scaleInputView.tareButton.hidden=YES;
	self.scaleInputView.iWeightLabel.hidden=YES;
	self.scaleInputView.iUnitButton.hidden=YES;
	[self.scaleInputView setNetLabelHidden:YES];
    
	// state: connecting
	//		cancel button
	self.scaleInputView.cancelConnectingButton.hidden=NO;
	//		Connecting label
	self.scaleInputView.messageLabel.hidden=NO;
	self.scaleInputView.messageLabel.text = @"Starting bluetooth";
	self.scaleInputView.spinner.hidden=NO;
	[self.scaleInputView.spinner startAnimating];
	// state: connection failed
	//		Connection failed Label
    self.scaleInputView.iPhoneChangeButton.hidden = NO;
	// self.scaleInputView.connectionFailedLabel.hidden=YES;
	//		try again Label
	// self.scaleInputView.tryAgainLabel.hidden=YES;
	//		OK button
	self.scaleInputView.okReconnectButton.hidden=YES;
	//		cancel button
	self.scaleInputView.cancelConnectButton.hidden=YES;
	//   hide  battery info
	self.scaleInputView.batteryImageView.hidden=YES;
	self.scaleInputView.bateryLabel.hidden=YES;
}
-(void) BLEinitializeDone{	// called when the bluetooth manager has been initialized
    //    	[(AppDelegate *)[[UIApplication sharedApplication] delegate] connectBluetooth];
}
-(void) BLEinitializeFailed	// called when the bluetooth manager initialization failed.
{
#ifdef DEBUG_STATE_TRANSITION
	NSLog(@"BLEinitializeFailed");
#endif
    
	self.scaleInputView.connectButton.hidden=YES;
    
	self.scaleInputView.tareButton.hidden=YES;
	self.scaleInputView.iWeightLabel.hidden=YES;
	self.scaleInputView.iUnitButton.hidden=YES;
	[self.scaleInputView setNetLabelHidden:YES];
    
	// state: connecting
	//		cancel button
	self.scaleInputView.cancelConnectingButton.hidden=NO;
	//		Connecting label
	self.scaleInputView.messageLabel.hidden=NO;
	self.scaleInputView.messageLabel.text = @"Bluetooth 4.0 not enabled.";
	self.scaleInputView.spinner.hidden=YES;
	[self.scaleInputView.spinner stopAnimating];
	// state: connection failed
	//		Connection failed Label
    self.scaleInputView.iPhoneChangeButton.hidden = NO;
	// self.scaleInputView.connectionFailedLabel.hidden=YES;
	//		try again Label
	// self.scaleInputView.tryAgainLabel.hidden=YES;
	//		OK button
	self.scaleInputView.okReconnectButton.hidden=YES;
	//		cancel button
	self.scaleInputView.cancelConnectButton.hidden=YES;
	//   hide  battery info
	self.scaleInputView.batteryImageView.hidden=YES;
	self.scaleInputView.bateryLabel.hidden=YES;

    [self stateNotConnected];
    [self changeToManualInput];
}
-(void) changeToManualInput
{
    self.manualInputView.alpha = 1.0f;
    self.scaleInputView.alpha = 0.0f;
    isInputWeightView = YES;
    [self weightUpdate];
    [self exchangeViewWithAnimation:self.iPhoneScaleContentView changeView:self.manualInputView withView:self.scaleInputView animationType:0];
    
}
-(void) BLEScaning	// called when the bluetooth manager is scanning for peripherals
{
#ifdef DEBUG_STATE_TRANSITION
	NSLog(@"BLEScaning");
#endif
	self.scaleInputView.connectButton.hidden=YES;
    
	self.scaleInputView.tareButton.hidden=YES;
	self.scaleInputView.iWeightLabel.hidden=YES;
	self.scaleInputView.iUnitButton.hidden=YES;
	[self.scaleInputView setNetLabelHidden:YES];
    
	// state: connecting
	//		cancel button
	self.scaleInputView.cancelConnectingButton.hidden=NO;
	//		Connecting label
	self.scaleInputView.messageLabel.hidden=NO;
	self.scaleInputView.messageLabel.text = @"Scanning devices";
	self.scaleInputView.spinner.hidden=NO;
	[self.scaleInputView.spinner startAnimating];
	// state: connection failed
	//		Connection failed Label
    self.scaleInputView.iPhoneChangeButton.hidden = NO;
	// self.scaleInputView.connectionFailedLabel.hidden=YES;
	//		try again Label
	// self.scaleInputView.tryAgainLabel.hidden=YES;
	//		OK button
	self.scaleInputView.okReconnectButton.hidden=YES;
	//		cancel button
	self.scaleInputView.cancelConnectButton.hidden=YES;
	//   hide  battery info
	self.scaleInputView.batteryImageView.hidden=YES;
	self.scaleInputView.bateryLabel.hidden=YES;
}
-(void) BLEScanDone	// called when the bluetooth manager has done scanning peripherals
{
#ifdef DEBUG_STATE_TRANSITION
	NSLog(@"BLEScanDone");
#endif
	if([(AppDelegate *)[[UIApplication sharedApplication] delegate] isPeripheralConnected]){
		self.scaleInputView.connectButton.hidden=YES;
        
		self.scaleInputView.tareButton.hidden=NO;
		self.scaleInputView.iWeightLabel.hidden=NO;
		self.scaleInputView.iUnitButton.hidden=NO;
		[self.scaleInputView setNetLabelHidden:NO];
        
		// state: connecting
		//		cancel button
		self.scaleInputView.cancelConnectingButton.hidden=YES;
		//		Connecting label
		self.scaleInputView.messageLabel.hidden=YES;
		self.scaleInputView.spinner.hidden=YES;
		[self.scaleInputView.spinner stopAnimating];
		// state: connection failed
		//		Connection failed Label
        self.scaleInputView.iPhoneChangeButton.hidden = NO;
		// self.scaleInputView.connectionFailedLabel.hidden=YES;
		//		try again Label
		// self.scaleInputView.tryAgainLabel.hidden=YES;
		//		OK button
		self.scaleInputView.okReconnectButton.hidden=YES;
		//		cancel button
		self.scaleInputView.cancelConnectButton.hidden=YES;
	}else{
		// return to weighing state
		// return to initial state with connect button
		self.scaleInputView.connectButton.hidden=NO;
        
		self.scaleInputView.tareButton.hidden=YES;
		self.scaleInputView.iWeightLabel.hidden=YES;
		self.scaleInputView.iUnitButton.hidden=YES;
		[self.scaleInputView setNetLabelHidden:YES];
        
		// state: connecting
		//		cancel button
		self.scaleInputView.cancelConnectingButton.hidden=YES;
		//		Connecting label
		self.scaleInputView.messageLabel.hidden=YES;
		self.scaleInputView.spinner.hidden=YES;
		[self.scaleInputView.spinner stopAnimating];
		// state: connection failed
		//		Connection failed Label
        self.scaleInputView.iPhoneChangeButton.hidden = NO;
		// self.scaleInputView.connectionFailedLabel.hidden=YES;
		//		try again Label
		// self.scaleInputView.tryAgainLabel.hidden=YES;
		//		OK button
		self.scaleInputView.okReconnectButton.hidden=YES;
		//		cancel button
		self.scaleInputView.cancelConnectButton.hidden=YES;
		//   hide  battery info
		self.scaleInputView.batteryImageView.hidden=YES;
		self.scaleInputView.bateryLabel.hidden=YES;
	}
	
}
-(void) BLEStartConnect  // called when the bluetooth is connecting
{
#ifdef DEBUG_STATE_TRANSITION
	NSLog(@"BLEStartConnect");
#endif
	self.scaleInputView.connectButton.hidden=YES;
    
	self.scaleInputView.tareButton.hidden=YES;
	self.scaleInputView.iWeightLabel.hidden=YES;
	self.scaleInputView.iUnitButton.hidden=YES;
	[self.scaleInputView setNetLabelHidden:YES];
    
	// state: connecting
	//		cancel button
	self.scaleInputView.cancelConnectingButton.hidden=NO;
	//		Connecting label
	self.scaleInputView.messageLabel.hidden=NO;
	self.scaleInputView.messageLabel.text = @"Connecting";
	self.scaleInputView.spinner.hidden=NO;
	[self.scaleInputView.spinner startAnimating];
	// state: connection failed
	//		Connection failed Label
    self.scaleInputView.iPhoneChangeButton.hidden = NO;
	// self.scaleInputView.connectionFailedLabel.hidden=YES;
	//		try again Label
	// self.scaleInputView.tryAgainLabel.hidden=YES;
	//		OK button
	self.scaleInputView.okReconnectButton.hidden=YES;
	//		cancel button
	self.scaleInputView.cancelConnectButton.hidden=YES;
	//   hide  battery info
	self.scaleInputView.batteryImageView.hidden=YES;
	self.scaleInputView.bateryLabel.hidden=YES;
}

-(void) BLEReady  // called when the bluetooth peripheral is connected and ready for service
{
	// initial the scale
	self.scaleInputView.netLabel.alpha=0;
	
    
}
-(void) BLECancelConnection  // called when the bluetooth is canceled(disconnect)
{
	[self stateNotConnected];
}
-(void) BLELostConnect  // called when the bluetooth failed to connect after 5 times try
{
    [self weightUpdate];
	[self stateConnectionFailed];
}
-(void) updateBattery:(int)batteryValue 	// update battery status
{
	if(batteryValue > LOW_BATTERY){
		// hide low battery icon
		self.scaleInputView.batteryImageView.hidden=YES;
		self.scaleInputView.bateryLabel.hidden=YES;
	}else{
		// show low battery icon
		self.scaleInputView.batteryImageView.hidden=NO;
		self.scaleInputView.bateryLabel.hidden=NO;
		self.scaleInputView.bateryLabel.text=[NSString stringWithFormat:@"%d%%",batteryValue];
	}
    
}
-(void) updateNetSign:(bool)showNetSign 	// update net sign
{
	if(showNetSign)
		self.scaleInputView.netLabel.alpha=1.0;
	else
		self.scaleInputView.netLabel.alpha=0;
}
-(void) updateStable:(bool)weightStable  // update stable
{
	// change the color of weighing
	if(weightStable)
		self.scaleInputView.iWeightLabel.textColor = [UIColor blackColor];
	else
		self.scaleInputView.iWeightLabel.textColor = [UIColor grayColor];
	
}
-(void) updateConnectionStatus:(bool)bIsConnected 	// update connection status
{
	if(bIsConnected){
		self.scaleInputView.connectButton.hidden=YES;
        
		self.scaleInputView.tareButton.hidden=NO;
		self.scaleInputView.iWeightLabel.hidden=NO;
		self.scaleInputView.iUnitButton.hidden=NO;
		[self.scaleInputView setNetLabelHidden:NO];
        
		// state: connecting
		//		cancel button
		self.scaleInputView.cancelConnectingButton.hidden=YES;
		//		Connecting label
		self.scaleInputView.messageLabel.hidden=YES;
		self.scaleInputView.spinner.hidden=YES;
		[self.scaleInputView.spinner stopAnimating];
		// state: connection failed
		//		Connection failed Label
        self.scaleInputView.iPhoneChangeButton.hidden = NO;
		// self.scaleInputView.connectionFailedLabel.hidden=YES;
		//		try again Label
		// self.scaleInputView.tryAgainLabel.hidden=YES;
		//		OK button
		self.scaleInputView.okReconnectButton.hidden=YES;
		//		cancel button
		self.scaleInputView.cancelConnectButton.hidden=YES;
	}
}
-(NSString *) BLEListenerUniqueID 	// returns a uniqueID. different listener with same ID will be replaced. Used to avoid un-necessary listeners
{
	return @"1";
}
/******************************** BLEUIProtocol END ***********************************************/


-(void) stateNotConnected
{
	self.scaleInputView.connectButton.hidden=NO;
    
	self.scaleInputView.tareButton.hidden=YES;
	self.scaleInputView.iWeightLabel.hidden=YES;
	self.scaleInputView.iUnitButton.hidden=YES;
	[self.scaleInputView setNetLabelHidden:YES];
    
	// state: connecting
	//		cancel button
	self.scaleInputView.cancelConnectingButton.hidden=YES;
	//		Connecting label
	self.scaleInputView.messageLabel.hidden=YES;
	self.scaleInputView.spinner.hidden=YES;
	[self.scaleInputView.spinner stopAnimating];
	// state: connection failed
	//		Connection failed Label
    self.scaleInputView.iPhoneChangeButton.hidden = NO;
	// self.scaleInputView.connectionFailedLabel.hidden=YES;
	//		try again Label
	// self.scaleInputView.tryAgainLabel.hidden=YES;
	//		OK button
	self.scaleInputView.okReconnectButton.hidden=YES;
	//		cancel button
	self.scaleInputView.cancelConnectButton.hidden=YES;
	//   hide  battery info
	self.scaleInputView.batteryImageView.hidden=YES;
	self.scaleInputView.bateryLabel.hidden=YES;
}



// state: connection failed
//		Connection failed Label
//		try again Label
//		OK button
//		cancel button
-(void) stateConnectionFailed
{
	self.scaleInputView.connectButton.hidden=YES;
    
	self.scaleInputView.tareButton.hidden=YES;
	self.scaleInputView.iWeightLabel.hidden=YES;
	self.scaleInputView.iUnitButton.hidden=YES;
	[self.scaleInputView setNetLabelHidden:YES];
    
	// state: connecting
	//		cancel button
	self.scaleInputView.cancelConnectingButton.hidden=YES;
	//		Connecting label
	self.scaleInputView.messageLabel.hidden=NO;
	self.scaleInputView.messageLabel.text=@"Connection failed.\nTry again?";
	
	self.scaleInputView.spinner.hidden=YES;
	[self.scaleInputView.spinner stopAnimating];
	// state: connection failed
	//		Connection failed Label
    self.scaleInputView.iPhoneChangeButton.hidden = NO;
	// self.scaleInputView.connectionFailedLabel.hidden=NO;
	//		try again Label
	// self.scaleInputView.tryAgainLabel.hidden=NO;
	//		OK button
	self.scaleInputView.okReconnectButton.hidden=NO;
	//		cancel button
	self.scaleInputView.cancelConnectButton.hidden=NO;
	//   hide  battery info
	self.scaleInputView.batteryImageView.hidden=YES;
	self.scaleInputView.bateryLabel.hidden=YES;
}

-(void) clickConnect:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] connectBluetooth];
}
-(void) clickCancelConnectingButton:(id)sender
{
	// cancel the connecting process
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] cancelBluetooth];
	n_connectRetry=0;
	[self stateConnectionFailed];
}
-(void) clickOkReconnectButton:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] connectBluetooth];
}
-(void) clickCancelConnectButton:(id)sender
{
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] cancelBluetooth];
	n_connectRetry=0;
	[self stateNotConnected];
}
-(IBAction)clickUnitButton:(id)sender
{
	translatedWeightUnit=[OmniTool adjustUnit:(translatedWeightUnit+1)];
	[self.scaleInputView.iUnitButton setTitle:[OmniTool unitIntToString:translatedWeightUnit] forState:UIControlStateNormal];
	// save it into user preference
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    [userPrefs setInteger:translatedWeightUnit forKey:@"defaultUnit"];
    [userPrefs synchronize];
}

- (void) EditMode{
    if (!selectedIngredient.isWeightSaved) {
        //從來沒改過數值
        self.EditAndSaveButton.title = @"Save";
        self.manualInputView.iWeightSlider.hidden = NO;
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = self.leftCancelButton;
        self.manualInputView.changeWeightInputBtn.hidden = NO;
        self.scaleInputView.iPhoneChangeButton.hidden = NO;
        if (isInputWeightView) {
            [self updateSliderPopoverText];
        }
        if (![OmniTool getCurrentConnectionStatus]) {
            //沒有連接磅秤
            [self changeToManualInput];
        }else{
            //如果有連接秤，直接顯示藍牙磅秤
            [self changeToBuletoothScale:nil];
        }
        
    }else{
        if (isInputWeightView) {
            self.EditAndSaveButton.title = @"Edit";
            self.manualInputView.iWeightSlider.hidden = YES;
            self.navigationItem.hidesBackButton = NO;
            self.navigationItem.leftBarButtonItem = nil;
            selectedIngredient.weight = self.manualInputView.iWeightSlider.value;
            self.manualInputView.changeWeightInputBtn.hidden = YES;
            self.scaleInputView.iPhoneChangeButton.hidden = YES;
            
        }else{
            self.EditAndSaveButton.title = @"Edit";
            self.manualInputView.iWeightSlider.hidden = YES;
            self.navigationItem.hidesBackButton = NO;
            self.navigationItem.leftBarButtonItem = nil;
            selectedIngredient.weight = (float) self.currentWeight;
            self.manualInputView.iWeightLabel.text = [NSString stringWithFormat:@"%.0f", selectedIngredient.weight];
            self.manualInputView.changeWeightInputBtn.hidden = YES;
            self.scaleInputView.iPhoneChangeButton.hidden = YES;
            [self changeToManualInput];
            
        }
    }
}

- (IBAction)EditAndSaveModeAction:(id)sender {
    //已經改過數值
    //先判斷button現在是什麼Title，Edit的話顯示Slider，Title換成Save
    if ([self.EditAndSaveButton.title isEqualToString:@"Edit"]) {
        self.EditAndSaveButton.title = @"Save";
        self.manualInputView.iWeightSlider.hidden = NO;
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = self.leftCancelButton;
        self.manualInputView.changeWeightInputBtn.hidden = NO;
        self.scaleInputView.iPhoneChangeButton.hidden = NO;
        if (isInputWeightView) {
            [self updateSliderPopoverText];
        }
        if (![OmniTool getCurrentConnectionStatus]) {
            //沒有連接磅秤
            [self changeToManualInput];
        }else{
            //如果有連接秤，直接顯示藍牙磅秤
            [self changeToBuletoothScale:nil];
        }
        
    }else{
        //Save的話，儲存數據到Cell Array，切換成Edit，隱藏Slider，並儲存當前數據至selectedIngredient.weight
        //終止藍牙連線的更新。
        if (isInputWeightView) {
            self.EditAndSaveButton.title = @"Edit";
            self.manualInputView.iWeightSlider.hidden = YES;
            self.navigationItem.hidesBackButton = NO;
            self.navigationItem.leftBarButtonItem = nil;
            selectedIngredient.weight = self.manualInputView.iWeightSlider.value;
            self.manualInputView.changeWeightInputBtn.hidden = YES;
            self.scaleInputView.iPhoneChangeButton.hidden = YES;
            _isSave = YES;
            [selectedIngredient setSaved:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.EditAndSaveButton.title = @"Edit";
            self.manualInputView.iWeightSlider.hidden = YES;
            self.navigationItem.hidesBackButton = NO;
            self.navigationItem.leftBarButtonItem = nil;
            selectedIngredient.weight = (float) self.currentWeight;
            self.manualInputView.iWeightLabel.text = [NSString stringWithFormat:@"%.0f", selectedIngredient.weight];
            self.manualInputView.changeWeightInputBtn.hidden = YES;
            self.scaleInputView.iPhoneChangeButton.hidden = YES;
            [self changeToManualInput];
            _isSave = YES;
            [selectedIngredient setSaved:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    NSLog(@" cancel edit %.0f" , selectedIngredient.weight);
    self.EditAndSaveButton.title = @"Edit";
    self.manualInputView.iWeightSlider.hidden = YES;
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.leftBarButtonItem = nil;
    self.manualInputView.changeWeightInputBtn.hidden = YES;
    self.scaleInputView.iPhoneChangeButton.hidden = YES;
    
    self.manualInputView.iWeightLabel.text = [NSString stringWithFormat:@"%.0f", selectedIngredient.weight];
    self.scaleInputView.iWeightLabel.text = [NSString stringWithFormat:@"%.0f", selectedIngredient.weight];
    
    _didntSaveIngredientWeight = selectedIngredient.weight;
    [self.nutrientTable reloadData];
    [self.navigationController popViewControllerAnimated:YES];
//    if (!selectedIngredient.isWeightSaved) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

-(void)clickTare:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] requestNetData];
}



- (IBAction)changeToBuletoothScale:(id)sender {
    self.manualInputView.alpha = 0.0f;
    self.scaleInputView.alpha = 1.0f;
    isInputWeightView = NO;
    
    [self weightUpdate];
    [self exchangeViewWithAnimation:self.iPhoneScaleContentView changeView:self.scaleInputView withView:self.manualInputView animationType:0];
}

- (IBAction)changeToInputWeightScale:(id)sender {
    self.manualInputView.alpha = 1.0f;
    self.scaleInputView.alpha = 0.0f;
    isInputWeightView = YES;
    [self weightUpdate];
    [self exchangeViewWithAnimation:self.iPhoneScaleContentView changeView:self.manualInputView withView:self.scaleInputView animationType:0];
}


- (void)exchangeViewWithAnimation:(UIView *)view changeView:(UIView *)sView withView:(UIView *)eView animationType:(NSInteger)type
{
    
    NSUInteger sv = [[view subviews] indexOfObject:sView];
    NSUInteger ev = [[view subviews] indexOfObject:eView];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    switch (type) {
        case 0:
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:view cache:YES];
            [view exchangeSubviewAtIndex:sv withSubviewAtIndex:ev];
            break;
        case 1:
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:view cache:YES];
            [view exchangeSubviewAtIndex:sv withSubviewAtIndex:ev];
            break;
        default:
            break;
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [UIView commitAnimations];
}
@end
