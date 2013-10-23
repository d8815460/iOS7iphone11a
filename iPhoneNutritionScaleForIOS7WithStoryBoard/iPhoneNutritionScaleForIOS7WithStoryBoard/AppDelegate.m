//
//  AppDelegate.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "AppDelegate.h"
#import "BLEUIProtocol.h"
#import "OmniVar.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "unistd.h"
#import "ViewController.h"
#import "MyLogInViewController.h"
#import "MinnaNotificationProtocol.h"
#import "NotSupportViewController.h"

@interface AppDelegate(){
    NSMutableData *_data;
    BOOL firstLaunch;
}
@property (nonatomic, strong) MyLogInViewController *loginViewController;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer       *autoFollowTimer;

@property Reachability *hostReach;
@property Reachability *internetReach;
@property Reachability *wifiReach;

//如果當前用戶是Facebook用戶，繼續執行主界面，如果不是就不回傳NO。
- (BOOL)shouldProceedToMainInterface:(PFUser *)user;
- (void)setupAppearance;
- (BOOL)handleActionURL:(NSURL *)url;
@end


@implementation AppDelegate
@synthesize navController;
@synthesize networkStatus;
@synthesize hostReach, internetReach, wifiReach;
@synthesize hud;
@synthesize btModule;
@synthesize connectionState;
@synthesize mainStoryboard;
@synthesize HomeVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //如果自己指定 rootViewController才需要，預設使用Storyboard.
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ****************************************************************************
    // Fill in with your Parse and Twitter credentials. Don't forget to add your
    // Facebook id in Info.plist:
    // ****************************************************************************
    [Parse setApplicationId:@"NchmaRdn4CEPhawDvQQCWwNt4cxYxeYfYz0ODHhB" clientKey:@"JBgv1XqGtroiL3ApFpUyozWkrdCjl9TNMK2FKMpW"];
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"your_twitter_consumer_key" consumerSecret:@"your_twitter_consumer_secret"];
    
    //自動創建用戶
//    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Track app open.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (application.applicationIconBadgeNumber != 0) {
        NSLog(@"install 1");
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    //自定主題
//    [self setupAppearance];
    
    //初始化資料庫
    [OmniTool initialDatabase:@"usda.db"];
    [OmniTool loadCertifiedBLENames];
    
    /*
     藍芽模組
     */
	BLEdelegateDictionary = [[NSMutableDictionary alloc] init];
	[self initialInputBuffer];	// input buffer of bluetooth communication
    
    // orange's test area
    [OmniTool testCodes];
    
    // link to Orange's scale
    /*
     NSString *strName=@"";
     NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
     [userPrefs setObject:strName forKey:@"defaultPeripheralName"];
     [userPrefs synchronize];
     */
	// initialize connection state
	connectionState=CONNECTION_STATE_BT_NOT_READY;
#ifdef DEBUG_STATE_TRANSITION
    NSLog(@"connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
	startupAutoConnect=NO;	// after the bluetooth manager up, will it auto connect ?
	scanDoneAutoConnect=NO;
    
    sleep(1.2);
    
    /* iPhone 4s 以下機種，轉場至說明頁 */
    NSString *device = [OmniTool deviceString];
    NSLog(@"device = %@", device);
    if ([device isEqualToString:@"iPhone 1G"] || [device isEqualToString:@"iPhone 3G"] || [device isEqualToString:@"iPhone 3GS"] ||[device isEqualToString:@"iPhone 4"] || [device isEqualToString:@"iPhone 4S"]) {
        
        self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NotSupportViewController *rootViewController = (NotSupportViewController *)[self.mainStoryboard instantiateViewControllerWithIdentifier:@"notSupport"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
        return YES;
    }
    // Override point for customization after application launch.
    return YES;
}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [PFPush storeDeviceToken:deviceToken];
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    NSLog(@"install 2");
    [[PFInstallation currentInstallation] saveInBackground];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

#pragma mark - APP在開啓執行狀態中，也會執行。
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)localNotification {
    
}

#pragma mark - 一般開啓狀態的時候，收到的推播訊息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    if (application.applicationState != UIApplicationStateActive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Handle an interruption during the authorization flow, such as the user clicking the home button.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) timersInitial
{
    timer0State = 0;
    timer1State = 0;
    timer2State = 0;
    timer3State = 0;
    timer4State = 0;
    timer5State = 0;
    timer0RemindTime=0;
    timer1RemindTime=0;
    timer2RemindTime=0;
    timer3RemindTime=0;
    timer4RemindTime=0;
    timer5RemindTime=0;
}

#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"iphone NutritionScale iOS7 Project successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"iphone NutritionScale iOS7 failed to subscribe to push notifications on the broadcast channel.");
    }
}





#pragma mark - setupAppearance 自定樣式
- (void)setupAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
/*
 iOS 6 version
 [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
 [UIColor whiteColor],UITextAttributeTextColor,
 [UIColor colorWithWhite:0.0f alpha:0.750f],UITextAttributeTextShadowColor,
 [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)],UITextAttributeTextShadowOffset,
 [UIFont fontWithName:@"Calibri" size:0.0],
 UITextAttributeFont,
 nil]];
 NSShadow
 */
    // iOS 7 version
    NSShadow *navShadow=[[NSShadow alloc] init];
    [navShadow setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f]];
    [navShadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],NSForegroundColorAttributeName,
                                                          navShadow,NSShadowAttributeName,
                                                          [UIFont fontWithName:@"Calibri" size:0.0],
                                                          NSFontAttributeName,
                                                          nil]];
    
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@""]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@""]];
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"Me_Setting_button.png"] forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    
    // Change the appearance of other navigation button
    UIImage *barButtonImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    // Change the appearance of back button
    UIImage *backButtonImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];\
    
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"]];
}

#pragma mark - monitorReachability 偵測網路是否正常運作
- (void)monitorReachability{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:ReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName:@"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

#pragma mark - 網路訊號改變
- (void)reachabilityChanged:(NSNotification *)note{
    Reachability *curReach = (Reachability *)[note object];             //當前網路連線
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    networkStatus = [curReach currentReachabilityStatus];
}


#pragma mark - Parse連線狀況
- (BOOL)isParseReachable{
    return self.networkStatus != NotReachable;
}

#pragma mark - 當前用戶沒有註冊登入過，轉場至Login View Controller
- (void)presentLoginViewControllerAnimated:(BOOL)animated{
    NSLog(@"轉場至Login");
    self.loginViewController = [[MyLogInViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
    [self.loginViewController setDelegate:self];
    self.loginViewController.fields = PFLogInFieldsFacebook;
    self.loginViewController.facebookPermissions = @[ @"user_about_me" ];
    self.navController = (UINavigationController *)[self.mainStoryboard instantiateViewControllerWithIdentifier:@"settingsNavigation"];
    self.window.rootViewController = self.navController;
    [self.window.rootViewController presentViewController:self.loginViewController animated:YES completion:nil];
    [self.window makeKeyAndVisible];
}

- (void)presentLoginViewController {
    [self presentLoginViewControllerAnimated:YES];
}

#pragma mark - 已經登入，轉場至rootViewController
- (void)presentMainViewControllerAnimated:(BOOL)aninmated{
    //    //如果用戶已經登入，直接跳過WelcomeView，到達ViewController
    //    InitialSlidingViewController *initViewC = (InitialSlidingViewController *)[self.uistoryboard instantiateViewControllerWithIdentifier:@"Initial"];
    //    [initViewC resetTopView];
    //
    //    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:initViewC];
    //
    //    self.window.rootViewController = nil;
    //    self.window.rootViewController = navigation;
    //    [self.window makeKeyAndVisible];
    //    [navigation setNavigationBarHidden:YES animated:NO];
}

#pragma mark - 如果是Timer就使用MWFSlideNavigationViewController，其他的部分就用UINavigationController
- (void)presentTimerViewControllerAnimated:(BOOL)aninmated{
    //
    //    InitialSlidingViewController *initViewC = (InitialSlidingViewController *)[self.uistoryboard instantiateViewControllerWithIdentifier:@"Initial"];
    //    FirstTimerViewController *secViewController = [self.uistoryboard instantiateViewControllerWithIdentifier:@"TimerTop"];
    //    initViewC.topViewController = secViewController;
    //    [initViewC resetTopView];
    //    self.window.rootViewController = nil;
    //    self.window.rootViewController = initViewC;
}

#pragma mark - 登入界面PFLoginViewController
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    
    if (user.isNew) {
        NSLog(@"新用戶");
        if (![self shouldProceedToMainInterface:user]) {
            //            self.navController = (settingsNavigation *)[self.mainStoryboard instantiateViewControllerWithIdentifier:@"settingsNavigation"];
            //            self.window.rootViewController = self.navController;
            //            //            [self.window.rootViewController presentViewController:self.loginViewController animated:YES completion:nil];
            //            [self.window makeKeyAndVisible];
        }
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }else if (user){
        NSLog(@"舊有用戶");
        if (![self shouldProceedToMainInterface:user]) {
            //            self.navController = (settingsNavigation *)[self.mainStoryboard instantiateViewControllerWithIdentifier:@"settingsNavigation"];
            //            self.window.rootViewController = self.navController;
            //            //            [self.window.rootViewController presentViewController:self.loginViewController animated:YES completion:nil];
            //            [self.window makeKeyAndVisible];
        }
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}

- (void)presentHomeController{
    NSLog(@"轉場至Home首頁");
    //    self.navController = (homeNavigation *)[self.mainStoryboard instantiateViewControllerWithIdentifier:@"homeNavigation"];
    //    self.window.rootViewController = self.navController;
    //    [self.window makeKeyAndVisible];
}

#pragma mark - 回到Welcome
- (void)presentWelcomeViewController;
{
	// Go to the welcome screen and have them log in or create an account.
    //    ProchWelcomeViewController *welcomeVC = (ProchWelcomeViewController *)[self.uistoryboard instantiateViewControllerWithIdentifier:@"welcomVC"];
    //	self.window.rootViewController = welcomeVC;
}

#pragma mark - 藍牙監聽
// add BLE listener
-(void)addBLEListener:(id)ble
{
	if([ble conformsToProtocol:@protocol(BLEUIProtocol)]) {
        // NSLog(@"addBLEListener %@",[ble BLEListenerUniqueID]);
		[BLEdelegateDictionary setObject:ble forKey:[ble BLEListenerUniqueID]];
	}
}

-(void) removeBLEListenerWithID:(NSString *) listenerUniqueID
{
	[BLEdelegateDictionary removeObjectForKey:listenerUniqueID];
}

// remove BLE listener
-(void)removeBLEListener:(id)ble
{
	if([ble conformsToProtocol:@protocol(BLEUIProtocol)]) {
		[BLEdelegateDictionary removeObjectForKey:[ble BLEListenerUniqueID]];
	}
}

-(void)connectBluetooth
{
    // check if the bluetooth is already connected or not
    if (btModule.activePeripheral){
    	if(btModule.activePeripheral.state==CBPeripheralStateDisconnected){
	    	[self reconnectBluetooth];
    	}
	}else{
		if([self initBluetoothModule]==YES){
			n_connectRetry = 5;
#ifdef DEBUG_STATE_TRANSITION
            NSLog(@"scanAndConnectDefaultPeripheral 4");
#endif
			[self scanAndConnectDefaultPeripheral];
		}else{
			// auto connect while bt manager is up
			startupAutoConnect=YES;
		}
	}
}
-(BOOL) initBluetoothModule
{
	if(!btModule){
		connectionState=CONNECTION_STATE_BT_NOT_READY;
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"b. connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
		// first connect
		btModule = [[TIBLECBKeyfob alloc] init];
		[btModule controlSetup:1];	// enables CoreBluetooths Central Manager
		btModule.delegate = self;
		// Before the CoreBluetooths Central Manager is enabled, it is not possible to connect here.
		// After the bluetooth manager is initialized, auto-connection will be applied.
		// see -(void) updateCMState:(int) state
		
	    [self notifyBLEinitializing];
        
		// notify bluetooth not function
        [NSTimer scheduledTimerWithTimeInterval:5.0
                                         target:self
                                       selector:@selector(bluetoothCheckTimer:)
                                       userInfo:nil
                                        repeats:NO];
        
		return NO;
	}
	if(btModule.CM.state!=CBCentralManagerStatePoweredOn){
		[btModule controlSetup:1];	// enables CoreBluetooths Central Manager
	    [self notifyBLEinitializing];
        
		// notify bluetooth not function
        [NSTimer scheduledTimerWithTimeInterval:5.0
                                         target:self
                                       selector:@selector(bluetoothCheckTimer:)
                                       userInfo:nil
                                        repeats:NO];
        
		return NO;
	}
	return YES;
}
// bluetooth check timer
-(void) bluetoothCheckTimer:(NSTimer*)timer
{
	if(connectionState==CONNECTION_STATE_BT_NOT_READY){
		[self notifyBLEinitializeFailed];
	}
}
-(void) updateCMState:(int) state
{
    if(state==CBCentralManagerStatePoweredOn){
    	// device is ready for service
        
		connectionState=CONNECTION_STATE_BT_READY;
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"a. connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
        
	    [self notifyBLEinitializeDone];
		
		if(startupAutoConnect){
			// connect device
			if(retryConnectDeviceName)
				[self connectPeripheralWithName:retryConnectDeviceName ResetReconnectCounter:YES];
			else{
				n_connectRetry=5;
				[self scanAndConnectDefaultPeripheral];
			}
			startupAutoConnect=NO;
		}
    }
}
- (void) scanAndConnectDefaultPeripheral
{
	if(connectionState==CONNECTION_STATE_BT_NOT_READY)
		return; // avoid multiple connect
	if(connectionState==CONNECTION_STATE_SEARCHING)
		return; // avoid multiple connect
	if(connectionState==CONNECTION_STATE_CONNECTING)
		return; // avoid multiple connect

#ifdef DEBUG_SCALE_COMMAND
	NSLog(@"Scan & connecting to defaultPeripheral, Listener %d",(int) [BLEdelegateDictionary count]);
#endif
	if([self initBluetoothModule]==NO){
		// Before the CoreBluetooths Central Manager is enabled, it is not possible to connect here.
		// After the bluetooth manager is initialized, auto-connection will be applied.
		// see -(void) updateCMState:(int) state
		startupAutoConnect=YES;
		return;
	}
    [btModule clearNotActivePeripherals];
    
    [self notifyBLEScanning];
    [btModule findBLEPeripherals:2];	// find for 2 seconds, ?? the 2 second is never been used?
	connectionState=CONNECTION_STATE_SEARCHING;
#ifdef DEBUG_STATE_TRANSITION
	NSLog(@"2. connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}
// 連線的timer
-(void) connectionTimer:(NSTimer*)timer
{
#ifdef DEBUG_LOG_TIMER
    NSLog(@"Timer:connectionTimer triggered");
#endif
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	BOOL doConnect=NO;
    
	NSString* defaultPeripheralName  =  [userPrefs objectForKey:@"defaultPeripheralName"];
	// NSLog(@"retrieve defaultPeripheralName=(%@) ",defaultPeripheralName);
	[btModule.CM stopScan];
	[self searchEndConnectionState];
    
	if(n_connectRetry <=0){	// cancel connection clicked
		return;
	}
    
    if (btModule.peripherals.count > 0)
    {
	    for(int i = 0; i < btModule.peripherals.count; i++) {
            
	        CBPeripheral *p = [btModule.peripherals objectAtIndex:i];
        	if(!p)
                continue;
            NSString* deviceName=p.name;
            if(!deviceName)
                continue;
	        // [btModule printPeripheralInfo:p];
        	BOOL compare = [deviceName isEqualToString:defaultPeripheralName];
        	if (compare==YES) {
	        	doConnect=YES;
				NSLog(@"Default peripheral found, connect to bluetooth name:%s, UUID:%@.",[p.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy],[p.identifier UUIDString]);
			    [self notifyBLEStartConnect];
		        connectionState=CONNECTION_STATE_CONNECTING;
#ifdef DEBUG_STATE_TRANSITION
                NSLog(@"j.connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
		        [btModule connectPeripheral:p syncMode:YES];
	        }
		}
		if(doConnect==NO){
	    	//搜尋藍牙，現在是找第一個。
        	CBPeripheral *firstPeripheral=[btModule.peripherals objectAtIndex:0];
			NSLog(@"Default peripheral not found, connect to bluetooth 0 which name:%s, UUID:%@.",[firstPeripheral.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy],[firstPeripheral.identifier UUIDString]);
			[self notifyBLEStartConnect];
	        connectionState=CONNECTION_STATE_CONNECTING;
#ifdef DEBUG_STATE_TRANSITION
            NSLog(@"k.connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
	        [btModule connectPeripheral:firstPeripheral syncMode:YES];
	    }
    }
    else
    {
        //這裡放的是連線失敗的動作，電子秤的是把連線關掉
    	n_connectRetry --;
		NSLog(@"Connect Retry counter=%d", n_connectRetry);
    	if (n_connectRetry > 0)
    	{
#ifdef DEBUG_STATE_TRANSITION
            NSLog(@"scanAndConnectDefaultPeripheral 1");
#endif
	    	[self scanAndConnectDefaultPeripheral];
	    }
	    else
	    {
            [self notifyBLELostConnect];
			connectionState=CONNECTION_STATE_CONNECTION_FAILD;
#ifdef DEBUG_STATE_TRANSITION
            NSLog(@"connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
	    }
    }
}

// scan timer
-(void) scanTimer:(NSTimer*)timer
{
#ifdef DEBUG_LOG_TIMER
    NSLog(@"Timer:scanTimer triggered");
#endif
	if(btModule)
		[btModule.CM stopScan];
    
	[self searchEndConnectionState];
	
    [self notifyBLEScanDone];
    // auto connect after scan
	if(scanDoneAutoConnect){
		n_connectRetry--;
		if(n_connectRetry ==0){
			scanDoneAutoConnect=NO;
		}
		[self connectPeripheralWithName:retryConnectDeviceName ResetReconnectCounter:NO];
	}
}

//傳輸資料用
-(void) sendDataString:(NSString *)dataString
{
	bool bConnected=false;
    if (btModule.activePeripheral){
    	if(btModule.activePeripheral.state!=CBPeripheralStateConnected){
	    	// Do not send while the connection is broken.
    	}else{
	        [btModule txUART:dataString p:[btModule activePeripheral]];
//            NSLog(@"sendDataString %@, CONNECTED",dataString);
        	bConnected=true;
        	if([self isStableState:connectionState]){
        		if(connectionState!=CONNECTION_STATE_CONNECTED){
	        		connectionState=CONNECTION_STATE_CONNECTED;
#ifdef DEBUG_STATE_TRANSITION
                    NSLog(@"connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
				}
	        }
    	}
	}else{
		NSLog(@"WARNING! sendDataString to nowhere");
	}
    [self notifyUpdateConnectionStatus:bConnected];
    
	if(connectionState==CONNECTION_STATE_CONNECTED && bConnected==false){
        [self notifyBLELostConnect];
        connectionState=CONNECTION_STATE_CONNECTION_FAILD;
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
	}
}
- (void)requestBatteryData
{
#ifdef DEBUG_LOG_TIMER
    // NSLog(@"Timer:requestBatteryData triggered");
#endif
    [self sendDataString:@"[B]\r\n"];
}
- (void)requestWeightData
{
#ifdef DEBUG_LOG_TIMER
    // NSLog(@"Timer:requestWeightData triggered");
#endif
	[self sendDataString:@"[W]\r\n"];
}
- (void)requestNetData
{
    [self sendDataString:@"[T]\r\n"];
}

- (void)startUpdateTimers
{
#ifdef DEBUG_LOG_TIMER
    NSLog(@"Timer:startUpdateTimers triggered");
#endif
    [self stopUpdateTimers];
    timer_update_weight = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                           target:self
                                                         selector:@selector(requestWeightData)
                                                         userInfo:nil
                                                          repeats:YES];
    
    timer_update_battery = [NSTimer scheduledTimerWithTimeInterval:5
                                                            target:self
                                                          selector:@selector(requestBatteryData)
                                                          userInfo:nil
                                                           repeats:YES] ;
}
-(void) stopUpdateTimers
{
    [timer_update_weight invalidate];
    [timer_update_battery invalidate];
    
}
//連結藍牙成功後
//連線成功的callback
-(void) keyfobReady
{
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	[userPrefs setBool:YES forKey:@"beenConnected"];
    // [btModule enableTXPower:[btModule activePeripheral]];	// this module does not support POWER services
    [btModule enableUART_RX_Read:[btModule activePeripheral]];
    
    check_time5 = CFAbsoluteTimeGetCurrent();
    if(check_time1 >0){
		NSLog(@"Initialize BT manager and connection establish time=%.2f",check_time5-check_time1);
		check_time1=0;
	}else{
		NSLog(@"Connection establish time=%.2f",check_time5-check_time3);
	}
    [self notifyBLEReady];
    connectionState=CONNECTION_STATE_CONNECTED;
    [self startUpdateTimers];
}
-(void) reconnectBluetooth
{
	if (btModule.activePeripheral && btModule.activePeripheral.state==CBPeripheralStateConnected)
		[[btModule CM] cancelPeripheralConnection:[btModule activePeripheral]];
    if (btModule.activePeripheral){
    	if(btModule.activePeripheral.state==CBPeripheralStateDisconnected){
			n_connectRetry = 5;
            
#ifdef DEBUG_STATE_TRANSITION
            NSLog(@"scanAndConnectDefaultPeripheral 2");
#endif
			[self scanAndConnectDefaultPeripheral];
    	}
	}else{
		n_connectRetry = 5;
        
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"scanAndConnectDefaultPeripheral 3");
#endif
		[self scanAndConnectDefaultPeripheral];
	}
}
// 說明是TX powerlevel values are updated，不過我沒用過
-(void) TXPwrLevelUpdated:(char)TXPwr
{
    
}
-(void)initialInputBuffer
{
	bluetoothInputBufferIndex=0;
}
-(char *) stringValuesUpdated:(char *)newIncomingMessage
{
    char *positionCRLF = 0;
    int messageLength = 0;
	char tempBuffer[INPUT_QUEUE_SIZE];
	int remindBufferSize;
#ifdef DEBUG_SCALE_COMMAND
    NSLog(@"stringValuesUpdated [%@]",[OmniTool CStringToNSString:newIncomingMessage ReplaceCRLF:YES] );
#endif
    if(bluetoothInputBufferIndex < 0)
    	bluetoothInputBufferIndex=0;
    
	messageLength = (int) strlen(newIncomingMessage);
	if (messageLength + bluetoothInputBufferIndex > INPUT_QUEUE_SIZE)
    	messageLength = INPUT_QUEUE_SIZE - bluetoothInputBufferIndex-1;
    
    memcpy(&bluetoothMessageInputBuffer[bluetoothInputBufferIndex], newIncomingMessage, messageLength);
    bluetoothInputBufferIndex += messageLength;
    
    while(1)
    {
        bluetoothMessageInputBuffer[bluetoothInputBufferIndex]=0;
        if(bluetoothInputBufferIndex==0)
        	return bluetoothMessageInputBuffer;
		positionCRLF = (char*)strstr(bluetoothMessageInputBuffer, "\r\n");
	    if(positionCRLF==NULL) // not found
	    {
#ifdef DEBUG_SCALE_COMMAND
            NSLog(@"CRLF not found, buffer length=%lu",strlen(bluetoothMessageInputBuffer));
#endif
			bluetoothMessageInputBuffer[bluetoothInputBufferIndex]=0;
	    	return bluetoothMessageInputBuffer;
	    }
		if (positionCRLF == 0) // empty message
		{
			bluetoothMessageInputBuffer[0]=0;
			bluetoothMessageInputBuffer[1]=0;
			if(bluetoothInputBufferIndex >=2){
				memcpy(tempBuffer,positionCRLF+2,bluetoothInputBufferIndex-2);
				memcpy(bluetoothMessageInputBuffer,tempBuffer,bluetoothInputBufferIndex-2);
				bluetoothInputBufferIndex-=2;
			}else{
				memset(bluetoothMessageInputBuffer, 0, INPUT_QUEUE_SIZE);
				bluetoothInputBufferIndex = 0;
			}
			bluetoothMessageInputBuffer[bluetoothInputBufferIndex]=0;
			return bluetoothMessageInputBuffer;
		}
		*positionCRLF = 0;	// cut string with '\0'
		*(positionCRLF+1)=0; // clear LF avoid bug
		[self parserScaleCommand:bluetoothMessageInputBuffer];
		
		
		remindBufferSize=(int)(bluetoothInputBufferIndex - (positionCRLF+2-bluetoothMessageInputBuffer));
		memcpy(tempBuffer,positionCRLF+2,remindBufferSize);
		memcpy(bluetoothMessageInputBuffer,tempBuffer,remindBufferSize);
		bluetoothInputBufferIndex=remindBufferSize;
		if(bluetoothInputBufferIndex<0)
			bluetoothInputBufferIndex=0;
	}
}

/*
 [self testInput:"\r\n"];
 [self testInput:"   100g gw\r\n"		];
 [self testInput:"   100g gw\r\nabc"		];
 [self testInput:"\r\n"					];
 [self testInput:"   100g gw\r \n"		];
 [self testInput:"   100g gw\r\n"		];
 [self testInput:"  aa  bb  \r\n"		];
 [self testInput:"   120g gw"			];
 [self testInput:"\r\n"					];
 [self testInput:"   130g gw\r"			];
 [self testInput:"\n"					];
 [self testInput:"   101g gw\r\n   102g gw\r\n   103g gw\r\n  "		];
 [self testInput:"   201g gw\r\n   202g gw\r\n   203g gw\r\n    201g gw\r\n   202g gw\r\n   203g gw\r\n     201g gw\r\n   202g gw\r\n   203g gw\r\n     201g gw\r\n   202g gw\r\n   203g gw\r\n     201g gw\r\n   202g gw\r\n   203g gw\r\n   "		];
 
 */
-(void) testInput:(char *)msg
{
	int i;
	int len=(int) strlen(msg);
	printf("Input=[");
	for(i=0;i<len;i++){
		if(msg[i]=='\r'){
			printf("<CR>");
		}else if(msg[i]=='\n'){
			printf("<LF>");
		}else{
			printf("%c",msg[i]);
		}
	}
	printf("] length=%d\r\n",len);
	
	[self stringValuesUpdated:msg];
	NSLog(@"bluetoothInputBufferIndex=%d",bluetoothInputBufferIndex);
	printf("buffer=[");
	for(i=0;i<bluetoothInputBufferIndex;i++){
		if(bluetoothMessageInputBuffer[i]=='\r'){
			printf("<CR>");
		}else if(bluetoothMessageInputBuffer[i]=='\n'){
			printf("<LF>");
		}else{
			printf("%c",bluetoothMessageInputBuffer[i]);
		}
	}
	printf("]\r\n");
}

-(void)cancelBluetooth
{
	if(!btModule)	return;
	n_connectRetry=0;	// don't retry if cancel is pressed
	if (btModule.activePeripheral && btModule.activePeripheral.state==CBPeripheralStateConnected)
		[[btModule CM] cancelPeripheralConnection:[btModule activePeripheral]];
    
    [self notifyBLECancelConnection];
    if(connectionState != CONNECTION_STATE_BT_NOT_READY)
		connectionState=CONNECTION_STATE_NOT_CONNECTED;
#ifdef DEBUG_STATE_TRANSITION
    NSLog(@"connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
}
-(void) scanPeripheral:(float) forSeconds
{
	if([self initBluetoothModule]==NO)
		return;	// bluetooth manager not initialized yet
	
    [btModule clearNotActivePeripherals];
    
	[self notifyBLEScanning];
    [btModule findBLEPeripherals:forSeconds];
	connectionState=CONNECTION_STATE_SEARCHING;
#ifdef DEBUG_STATE_TRANSITION
    NSLog(@"1.connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
    [NSTimer scheduledTimerWithTimeInterval:(float)forSeconds target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
}
-(NSMutableArray *) getCurrentPeripherals
{
	if(!(btModule.peripherals))
		// initial the array
		btModule.peripherals = [[NSMutableArray alloc] init];
	return btModule.peripherals;
}
// find the correct connection state besides searching and connecting and connection failed
-(void) searchEndConnectionState
{
	/*
     typedef enum {
     CONNECTION_STATE_BT_NOT_READY,	// Initial, BT not start
     CONNECTION_STATE_BT_READY,	// BT ready, waiting for order ,activePeripheral =nil
     CONNECTION_STATE_SEARCHING,	// searching for peripherals
     CONNECTION_STATE_CONNECTED,	// Connected
     CONNECTION_STATE_NOT_CONNECTED,	// activePeripheral not nil, not connected
     CONNECTION_STATE_CONNECTING,
     CONNECTION_STATE_CONNECTION_FAILD	// user clicked cancel or lost connect
     } ConnectionState;
     */
	if(!btModule){
		connectionState=CONNECTION_STATE_BT_NOT_READY;
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"connectionState check=%@",[OmniTool connectionStateToString:connectionState]);
#endif
		return;
	}
	if(!(btModule.activePeripheral)){
		connectionState=CONNECTION_STATE_BT_READY;
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"connectionState check=%@",[OmniTool connectionStateToString:connectionState]);
#endif
		return;
	}
	if(btModule.activePeripheral.state==CBPeripheralStateConnected){
		connectionState=CONNECTION_STATE_CONNECTED;
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"connectionState check=%@",[OmniTool connectionStateToString:connectionState]);
#endif
		return;
	}else{
		connectionState=CONNECTION_STATE_NOT_CONNECTED;
#ifdef DEBUG_STATE_TRANSITION
        NSLog(@"connectionState check=%@",[OmniTool connectionStateToString:connectionState]);
#endif
		return;
	}
}
// connect to device with the device name
-(void) connectPeripheralWithName:(NSString *) strName ResetReconnectCounter:(BOOL) doResetReconnectCounter
{
	if(!strName){
		NSLog(@"ERROR: connectPeripheralWithName with null name.");
		return;
	}
	retryConnectDeviceName=strName;
	if([self initBluetoothModule]==NO){
		// Before the CoreBluetooths Central Manager is enabled, it is not possible to connect here.
		// After the bluetooth manager is initialized, auto-connection will be applied.
		// see -(void) updateCMState:(int) state
		startupAutoConnect=YES;
	}else{
		if(btModule.activePeripheral){
			// if it's still active, ignore the connect command.
			if([[btModule activePeripheral] state]==CBPeripheralStateConnected){
				// check again to see if they are same device
				
				if([btModule.activePeripheral.name isEqualToString:strName]){
                    return;
				}else{
					// disconnect from current peripheral
					[btModule disconnectFromCurrentPeripheral];
				}
			}
		}
		if(doResetReconnectCounter)
			n_connectRetry = 5;
        
	    if (btModule.peripherals.count > 0)
	    {
		    for(int i = 0; i < btModule.peripherals.count; i++) {
		        CBPeripheral *p = [btModule.peripherals objectAtIndex:i];
	        	if(!p) continue;
                if(!p.name) continue;
		        // [btModule printPeripheralInfo:p];
                BOOL compare = [p.name isEqualToString:strName];
	        	if (compare==YES) {
					NSLog(@"connectPeripheralWithName: Peripheral found. Connecting to bluetooth name:%s, UUID:%@.",[p.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy],[p.identifier UUIDString]);
                    
				    [self notifyBLEStartConnect];
			        connectionState=CONNECTION_STATE_CONNECTING;
#ifdef DEBUG_STATE_TRANSITION
                    NSLog(@"l.connectionState=%@",[OmniTool connectionStateToString:connectionState]);
#endif
			        [btModule connectPeripheral:p syncMode:YES];
			        return;
		        }
			}
	    }
		// scan and retry to find the device again
		scanDoneAutoConnect=YES;
		[self scanPeripheral:2.0];
		n_connectRetry--;
		NSLog(@"connectPeripheralWithName: Peripheral with name (%@) NOT found! Scanning the peripherals.",strName);
	}
}

-(BOOL) isStableState:(ConnectionState) connState
{
    /*
     typedef enum {
     CONNECTION_STATE_BT_NOT_READY,	// Initial, BT not start
     CONNECTION_STATE_BT_READY,	// BT ready, waiting for order ,activePeripheral =nil
     CONNECTION_STATE_SEARCHING,	// searching for peripherals, either activeperipheral connected or not
     CONNECTION_STATE_CONNECTED,	// Connected, not scanning
     CONNECTION_STATE_NOT_CONNECTED,	// activePeripheral not nil, not connected
     CONNECTION_STATE_CONNECTING,
     CONNECTION_STATE_CONNECTION_FAILD
     } ConnectionState;
     */
	switch(connState)
	{
		case  CONNECTION_STATE_BT_NOT_READY:
			// "CONNECTION_STATE_BT_NOT_READY";
			return NO;
		case  CONNECTION_STATE_BT_READY:
			// "CONNECTION_STATE_BT_READY";
			return YES;
		case  CONNECTION_STATE_SEARCHING:
			// "CONNECTION_STATE_SEARCHING";
			return NO;
		case  CONNECTION_STATE_CONNECTED:
			// "CONNECTION_STATE_CONNECTED";
			return YES;
		case  CONNECTION_STATE_NOT_CONNECTED:
			// "CONNECTION_STATE_NOT_CONNECTED";
			return YES;
		case  CONNECTION_STATE_CONNECTING:
			// "CONNECTION_STATE_CONNECTING";
			return NO;
		case  CONNECTION_STATE_CONNECTION_FAILD:
			// "CONNECTION_STATE_CONNECTION_FAILD";
			return YES;
		default:
			// "CONNECTION_STATE UNKNOWN";
			return NO;
	}
}

-(void) notifyBLEScanning
{
	NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLEScaning];
        }
    }
}

-(void) notifyBLEStartConnect
{
	// call BLEStartConnect for each delegate
	NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLEStartConnect];
        }
    }
}

-(void) notifyBLEinitializing
{
    // call BLEinitializing for each delegate
    NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLEinitializing];
        }
    }
}

-(void) notifyBLEinitializeDone
{
	// call BLEinitialized for each delegate
	NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLEinitializeDone];
        }
    }
}

-(void) notifyBLEinitializeFailed
{
	// call BLEinitialized for each delegate
	NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLEinitializeFailed];
        }
    }
}
-(void) notifyBLELostConnect
{
    // call BLELostConnect for each delegate
    NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLELostConnect];
        }
    }
    
}
-(void) notifyUpdateConnectionStatus:(bool) bConnected
{
    NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener updateConnectionStatus:bConnected];
        }
    }
}
-(void) notifyWeightUpdate
{
    // call weightUpdate for each delegate
    NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener weightUpdate];
        }
    }
}
-(void) notifyUpdateStable:(char *)weightTypeString
{
	if (strcmp(weightTypeString, "GW") == 0 || strcmp(weightTypeString, "NW") == 0)
	{
		if(scaleStableStatus==false){	// unstable -> stable
			// call updateStable for each delegate
			NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
			id bleListener;
			while ((bleListener = [enumerator nextObject])) {
			    if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
			        [bleListener updateStable:true];
			    }
			}
		}
		scaleStableStatus=true;
	}else{
		if(scaleStableStatus==true){	// stable -> unstable
			// call updateStable for each delegate
			NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
			id bleListener;
			while ((bleListener = [enumerator nextObject])) {
			    if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
			        [bleListener updateStable:false];
			    }
			}
		}
		scaleStableStatus=false;
	}
}

-(void) notifyBLECancelConnection
{
	// call BLECancelConnection for each delegate
	NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLECancelConnection];
        }
    }
}
-(void) notifyBLEScanDone
{
	NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLEScanDone];
        }
    }
}
-(void) notifyBLEReady
{
	scaleNetStatus=false;	// NET sign on the scale
	scaleStableStatus=false; // scale stable status
	
	// call BLEReady for each delegate
	NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener BLEReady];
        }
    }
}
-(void) notifyUpdateBattery:(int)batteryValue
{
    // call updateBattery for each delegate
    NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
    id bleListener;
    while ((bleListener = [enumerator nextObject])) {
        if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
            [bleListener updateBattery:batteryValue];
        }
    }
}
-(void) notifyNetSign:(char *)weightTypeString
{
	if (strcmp(weightTypeString, "NW") == 0 || strcmp(weightTypeString, "nw") == 0)
	{
		if(scaleNetStatus==false){	// NET set
			// call updateNetSign for each delegate
			NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
			id bleListener;
			while ((bleListener = [enumerator nextObject])) {
			    if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
			        [bleListener updateNetSign:true];
			    }
			}
		}
		scaleNetStatus=true;
	}else{
		if(scaleNetStatus==true){	// NET clear
			// call updateNetSign for each delegate
			NSEnumerator *enumerator = [BLEdelegateDictionary objectEnumerator];
			id bleListener;
			while ((bleListener = [enumerator nextObject])) {
			    if([bleListener conformsToProtocol:@protocol(BLEUIProtocol)]) {
			        [bleListener updateNetSign:false];
			    }
			}
		}
		scaleNetStatus=false;
	}
}
-(void) parserScaleCommand:(char*)commandString
{
	int i = 0;
	int commandLength = (int) strlen(commandString);
#ifdef DEBUG_SCALE_COMMAND
    NSLog(@"parserScaleCommand: (%s) len=%d",commandString,commandLength);
#endif
	if(commandLength<1)
		return;	// avoid empty string trigger updateBattery
    
    if (commandLength < 4)
	{
        for (i =0; i < commandLength; i++)
        {
            if ((commandString[i] < '0' || commandString[i] > '9') && commandString[i] != ' ')
                return;
        }
	    [self notifyUpdateBattery:atoi(commandString)];
		return;
	}
    
	if(commandLength == 14)
    {
        //    	NSLog(@"parsing command [%s]",commandString );
		commandString[8] = 0;
        commandString[11] = 0;
        
		if (strcmp(&commandString[9], "lb") == 0)
			inputWeightUnit = UNIT_LB;
        else if (strcmp(&commandString[9], "oz") == 0)
			inputWeightUnit = UNIT_OZ;
        else
			inputWeightUnit = UNIT_G;	// default is UNIT_G
        
        
        [self notifyUpdateStable:&commandString[12]];
        [self notifyNetSign:&commandString[12]];
        
        inputWeight = atof(commandString+1);
        if(commandString[0]=='-')
        	inputWeight *= -1;
        [OmniTool weightSimulation:inputWeight];
        
	    [self notifyWeightUpdate];
	}
	if(commandLength == 15 && commandString[0]=='W')
    {
        //    	NSLog(@"parsing command [%s]",commandString );
		commandString[9] = 0;
        commandString[12] = 0;
        
		if (strcmp(&commandString[10], "lb") == 0)
			inputWeightUnit = UNIT_LB;
        else if (strcmp(&commandString[10], "oz") == 0)
			inputWeightUnit = UNIT_OZ;
        else
			inputWeightUnit = UNIT_G;	// default is UNIT_G
        
        
        [self notifyUpdateStable:&commandString[13]];
        [self notifyNetSign:&commandString[13]];
        
        inputWeight = atof(commandString+2);
        if(commandString[1]=='-')
        	inputWeight *= -1;
        [OmniTool weightSimulation:inputWeight];
        
	    [self notifyWeightUpdate];
	}
}
#pragma mark - 判斷藍牙是否連線狀態。
-(BOOL) isPeripheralConnected
{
	if(!btModule)	return NO;
	if (!btModule.activePeripheral) return NO;
    return (btModule.activePeripheral.state==CBPeripheralStateConnected) ? YES : NO;
}
// Bluetooth log用
-(void) updateLog:(NSString *)text
{
#ifdef DEBUG_SCALE_COMMAND
    NSLog(@"(BT) %@", text);
#endif
}

- (BOOL)shouldProceedToMainInterface:(PFUser *)user {
    if ([PAPUtility userHasValidFacebookData:[PFUser currentUser]]) {
        NSLog(@"用戶擁有有效的Facebook數據，批准使用的應用程序。");
        return YES;
    }
    return NO;
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

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [self logOut];
        }
    }
}

- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    
    //    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    //    [MBProgressHUD hideHUDForView:self.paphomeViewController.view animated:YES];
    //    [self.paphomeViewController loadObjects];
}

- (BOOL)handleActionURL:(NSURL *)url {
    if ([[url host] isEqualToString:kPAPLaunchURLHostTakePicture]) {
        if ([PFUser currentUser]) {
            //偵測到拍照動作，就轉場至Ask畫面的拍照按鈕
            /*
             這裡原先的拍照按鈕剛好等於tabBar的中間鈕，所以現在就暫時取消。
             return [self.tabBarController shouldPresentPhotoCaptureController];
             */
        }
    }
    return NO;
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
}

#pragma mark - MinnaListenerServerProtocol

-(void) addMinnaListener:(id<MinnaNotificationProtocol>)listener
{
	if(!minnaNotificationDictionary)
		minnaNotificationDictionary=[[NSMutableDictionary alloc] init];
    
	if([listener conformsToProtocol:@protocol(MinnaNotificationProtocol)]) {
		[minnaNotificationDictionary setObject:listener forKey:[listener MinnaListenerID]];
	}else{
		NSLog(@"Error: addMinnaListener with none MinnaNotificationProtocol object");
	}
}

-(void) removeMinnaListener:(id<MinnaNotificationProtocol>)listener
{
	if(!minnaNotificationDictionary) return;
	
	if([listener conformsToProtocol:@protocol(MinnaNotificationProtocol)]) {
		[minnaNotificationDictionary removeObjectForKey:[listener MinnaListenerID]];
	}else{
		NSLog(@"Error: removeMinnaListener with none MinnaNotificationProtocol object");
	}
}

-(void) addMinnaOpenGraphRequest:(MinnaOpenGraphRequest *) opengraphObject
{
	if(!minnaOpenGraphQueue)
		minnaOpenGraphQueue=[[NSMutableArray alloc] init];
}
-(void) broadcastMinnaNotificationMessage:(NSString *)broadcastMessage
{
	if(!minnaNotificationDictionary) return;
	
	NSEnumerator *enumerator = [minnaNotificationDictionary objectEnumerator];
    id minnaListener;
    while ((minnaListener = [enumerator nextObject])) {
        if([minnaListener conformsToProtocol:@protocol(MinnaNotificationProtocol)]) {
            [minnaListener MinnaMessage:broadcastMessage];
        }
    }
}

@end
