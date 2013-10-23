//
//  AppDelegate.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OmniVar.h"
#import "MinnaNotificationProtocol.h"

#define INPUT_QUEUE_SIZE 32


@interface AppDelegate : UIResponder <UIApplicationDelegate, TIBLECBKeyfobDelegate, PFLogInViewControllerDelegate, MinnaListenerServerProtocol>{
    TIBLECBKeyfob *btModule;    //藍芽模組
    NSTimer *timer_update_weight;
    NSTimer *timer_update_battery;
    NSMutableDictionary *BLEdelegateDictionary;
	char bluetoothMessageInputBuffer[INPUT_QUEUE_SIZE];
	int bluetoothInputBufferIndex;
	
	BOOL startupAutoConnect;	// after the bluetooth manager up, will it auto connect ?
	NSString *retryConnectDeviceName;
	BOOL scanDoneAutoConnect;

    // Minna in APP notification
    // used to store ID -> Listener
    NSMutableDictionary *minnaNotificationDictionary;
    // store MinnaOpenGraphRequest
    NSMutableArray *minnaOpenGraphQueue;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) int networkStatus;
@property (retain, nonatomic) TIBLECBKeyfob *btModule;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, readonly) ConnectionState connectionState;
@property (nonatomic, strong) UINavigationController *HomeVC;
@property (nonatomic, strong) UIStoryboard *mainStoryboard;


-(BOOL) initBluetoothModule;	// initialize bluetooth module, if the module is already initialized, return YES
-(void) connectBluetooth;
// connect to device with the Name
-(void) connectPeripheralWithName:(NSString *) strName ResetReconnectCounter:(BOOL) doResetReconnectCounter;
-(void) cancelBluetooth;
// add BLE listener
-(void) addBLEListener:(NSObject *)ble;
-(void) removeBLEListenerWithID:(NSString *) listenerUniqueID;
// remove BLE listener
-(void) removeBLEListener:(id)ble;

-(void) scanAndConnectDefaultPeripheral;
-(void) requestNetData; // request net data
-(void) parserScaleCommand:(char*)commandString;	// parse command from scale

//Parse連線狀況
- (BOOL)isParseReachable;

//登入畫面
- (void)presentLoginViewController;
- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)presentHomeController;
- (void)logOut;
- (void)facebookRequestDidLoad:(id)result;
- (void)facebookRequestDidFailWithError:(NSError *)error;

-(void) scanPeripheral:(float) forSeconds;
-(NSMutableArray *) getCurrentPeripherals;
-(BOOL) isPeripheralConnected;	// if the peripheral is already connected, return YES

@end
