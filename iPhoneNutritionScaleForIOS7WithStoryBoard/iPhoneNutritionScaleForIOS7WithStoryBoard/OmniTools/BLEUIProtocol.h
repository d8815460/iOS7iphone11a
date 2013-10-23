//
//  BLEUIProtocol.h
//  KitchenScale
//
//  Created by Orange on 13/4/16.
//  Copyright (c) 2013年 Orange Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLEUIProtocol <NSObject>
-(void) BLEinitializing;        // called when the bluetooth manager is just initializing
-(void) BLEinitializeDone;      // called when the bluetooth manager has been initialized
-(void) BLEinitializeFailed;	// called when the bluetooth manager initialization failed.

-(void) BLEScaning;             // called when the bluetooth manager is scanning for peripherals
-(void) BLEScanDone;            // called when the bluetooth manager has done scanning peripherals

-(void) BLEStartConnect;        // called when the bluetooth is connecting
-(void) weightUpdate;           // called when the bluetooth is asking a new weight, to simulate the weigh change
-(void) BLEReady;               // called when the bluetooth is connected and ready for service
-(void) BLECancelConnection;    // called when the bluetooth is canceled(disconnect)
-(void) BLELostConnect;         // called when the bluetooth failed to connect after 5 times try
-(void) updateBattery:(int)batteryValue;	// update battery status
-(void) updateNetSign:(bool)showNetSign;	// update net sign, called when the status is changed
-(void) updateStable:(bool)weightStable;    // update stable status, called when the status is changed
-(void) updateConnectionStatus:(bool)bIsConnected;	// update connection status
-(NSString *) BLEListenerUniqueID;                  // returns a uniqueID. different listener with same ID will be replaced. Used to avoid un-necessary listeners

@end
