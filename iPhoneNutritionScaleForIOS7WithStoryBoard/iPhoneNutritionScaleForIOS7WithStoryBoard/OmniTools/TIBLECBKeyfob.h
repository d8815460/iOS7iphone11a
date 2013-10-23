//
//  TIBLECBKeyfob.h
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/31/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "TIBLECBKeyfobDefines.h"


@protocol TIBLECBKeyfobDelegate 
@optional
-(void) keyfobReady;                            // 連線成功的callback
@required
-(char *) stringValuesUpdated:(char *)sData;      // 資料輸入，在這裡處理資料輸入的部分。藍芽的資料會變char *
-(void) TXPwrLevelUpdated:(char)TXPwr;          // 說明是TX powerlevel values are updated，不過我沒用過
-(void) updateLog:(NSString *)text;             // log用，資料進來時也會被呼叫到，但是text會是Received xxxxx..
-(void) updateCMState:(int) state;
//-(void) updateStatus:(NSString *)text;
@end

@interface TIBLECBKeyfob : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    BOOL bServicesFound;
}

@property (nonatomic)   char TXPwrLevel;


@property (nonatomic,assign) id <TIBLECBKeyfobDelegate> delegate;
@property (strong, nonatomic)  NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *CM; 
@property (strong, nonatomic) CBPeripheral *activePeripheral;

-(void) enableTXPower:(CBPeripheral *)p;
-(void) disableTXPower:(CBPeripheral *)p;


-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p;
-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;


-(UInt16) swap:(UInt16) s;
-(int) controlSetup:(int) s;
-(int) findBLEPeripherals:(int) timeout;
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;
-(void) printKnownPeripherals;
-(void) printPeripheralInfo:(CBPeripheral*)peripheral;
// -(void) connectPeripheral:(CBPeripheral *)peripheral;

-(void) getAllServicesFromKeyfob:(CBPeripheral *)p;
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p;
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;
-(const char *) UUIDToString:(CFUUIDRef) UUID;
-(const char *) CBUUIDToString:(CBUUID *) UUID;
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2;
-(int) compareCBUUIDToInt:(CBUUID *) UUID1 UUID2:(UInt16)UUID2;
-(UInt16) CBUUIDToInt:(CBUUID *) UUID;
-(int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2;
-(NSString *) UUIDToNSString:(CFUUIDRef)UUID;	// convert UUID into NSString
	
-(void) enableUART_RX_Read:(CBPeripheral *)p;
-(void) txUART: (NSString *)txData p:(CBPeripheral *)p;

-(void) clearNotActivePeripherals;
-(void) disconnectFromCurrentPeripheral;	// disconnect the current connection

- (void) connectPeripheral:(CBPeripheral *)peripheral syncMode:(BOOL)sync;  // parameter sync: prevent from connect again while connecting
@end
