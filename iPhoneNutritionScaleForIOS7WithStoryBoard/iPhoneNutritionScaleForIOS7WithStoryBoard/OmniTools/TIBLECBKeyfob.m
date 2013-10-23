//
//  TIBLECBKeyfob.m
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/31/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//
// 
// Added UART TX/RX data communication by Bighead Chen on 06/18/2012
// Copyright (c) 2012 Joybien Technologies. All right reserved.
//
#import "TIBLECBKeyfob.h"

@implementation TIBLECBKeyfob

@synthesize delegate;
@synthesize CM;
@synthesize peripherals;
@synthesize activePeripheral;
@synthesize TXPwrLevel;

//
//  Added by Bighead 
//  Send Data to BLE Device
//
//
-(void) txUART: (NSString *) txData p:(CBPeripheral *)p {
    
    NSData* data = [txData dataUsingEncoding:NSUTF8StringEncoding]; 
    data = [data subdataWithRange:NSMakeRange(0, [data length])];
    [self writeValue:JB_UART_TX_PRIMARY_SERVICE_UUID characteristicUUID:JB_UART_TX_SECOND_UUID p:p data: data];
    // NSLog(@"******** txUART send out data= (%@)\n",data);
    // [OmniTool printInfoNSData:data];
    
}
  /*!
 *  @method enableTXPower:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Enables notifications on the TX Power level service
 *
 */
-(void) enableTXPower:(CBPeripheral *)p {
    [self notification:TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID p:p on:YES];
}
//
/*! Added by Bighead
 *  @method string Values:
 *
 *  @param  
 *  @param  
 *
 *  @discussion ECG This method writes a value 
 *
 */
-(void) enableUART_RX_Read:(CBPeripheral *) p{
    [self notification:JB_UART_RX_PRIMARY_SERVICE_UUID characteristicUUID:JB_UART_RX_NOTIFICATION_UUID p:p on:YES];
}

/*!
 *  @method disableTXPower:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Disables notifications on the TX Power level service
 *
 */
-(void) disableTXPower:(CBPeripheral *)p {
    [self notification:TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID p:p on:NO];
}
/*!
 *  @method writeValue:
 *
 *  @param serviceUUID Service UUID to write to (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to write to (e.g. 0x2401)
 *  @param data Data to write to peripheral
 *  @param p CBPeripheral to write to
 *
 *  @discussion Main routine for writeValue request, writes without feedback. It converts integer into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service. 
 *  If this is found, value is written. If not nothing is done.
 *
 */

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
	if(p.state!=CBPeripheralStateConnected){
        [self.delegate updateLog:[NSString stringWithFormat:@"writeValue: Could not write on closed peripheral ( peripheral UUID=%@)",[p.identifier UUIDString]]];
        return;
	}
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        [self.delegate updateLog:[NSString stringWithFormat:@"writeValue: Could not find service with UUID %s on peripheral with UUID %@",[self CBUUIDToString:su],[p.identifier UUIDString]]];
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        [self.delegate updateLog:[NSString stringWithFormat:@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@",[self CBUUIDToString:cu],[self CBUUIDToString:su],[p.identifier UUIDString]]];
        return;
    }
    // CBCharacteristicWriteWithResponse
    // CBCharacteristicWriteWithoutResponse
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}


/*!
 *  @method readValue:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for read value request. It converts integers into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service. 
 *  If this is found, the read value is started. When value is read the didUpdateValueForCharacteristic 
 *  routine is called.
 *
 *  @see didUpdateValueForCharacteristic
 */

-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    NSLog(@"readValue from Peripheral %@",[p name]);
    
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        if (p.identifier == NULL) return; // zach ios6 added 09202012
        [self.delegate updateLog:[NSString stringWithFormat:@"readValue: Could not find service with UUID %s on peripheral with UUID %@",[self CBUUIDToString:su],[p.identifier UUIDString]]];
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        if (p.identifier == NULL) return; // zach ios6 added 09202012
        [self.delegate updateLog:[NSString stringWithFormat:@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@",[self CBUUIDToString:cu],[self CBUUIDToString:su],[p.identifier UUIDString]]];
        return;
    }  
    [p readValueForCharacteristic:characteristic];
}


/*!
 *  @method notification:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for enabling and disabling notification services. It converts integers 
 *  into CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service. 
 *  If this is found, the notfication is set. 
 *
 */
-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        if (p.identifier == NULL) return; // zach ios6 added
        [self.delegate updateLog:[NSString stringWithFormat:@"notification: Could not find service with UUID %s on peripheral with UUID %@",[self CBUUIDToString:su],[p.identifier UUIDString]]];
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        if (p.identifier == NULL) return; // zach ios6 added
        [self.delegate updateLog:[NSString stringWithFormat:@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@",[self CBUUIDToString:cu],[self CBUUIDToString:su],[p.identifier UUIDString]]];
        return;
    }
#ifdef DEBUG_SCALE_COMMAND
    NSLog(@" setting notify %@ for char.(%s) of service(%s) ",(on)? @"ON" : @"OFF",
                                                                [self CBUUIDToString:service.UUID],[self CBUUIDToString:characteristic.UUID]);
#endif
    [p setNotifyValue:on forCharacteristic:characteristic];
}


/*!
 *  @method swap:
 *
 *  @param s Uint16 value to byteswap
 *
 *  @discussion swap byteswaps a UInt16 
 *
 *  @return Byteswapped UInt16
 */

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

/*!
 *  @method controlSetup:
 *
 *  @param s Not used
 *
 *  @return Allways 0 (Success)
 *  
 *  @discussion controlSetup enables CoreBluetooths Central Manager and sets delegate to TIBLECBKeyfob class 
 *
 */
- (int) controlSetup: (int) s{
    check_time1 = CFAbsoluteTimeGetCurrent();
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return 0;
}

/*!
 *  @method findBLEPeripherals:
 *
 *  @param timeout timeout in seconds to search for BLE peripherals
 *
 *  @return 0 (Success), -1 (Fault)
 *  
 *  @discussion findBLEPeripherals searches for BLE peripherals and sets a timeout when scanning is stopped
 *
 */
- (int) findBLEPeripherals:(int) timeout {
    [self.delegate updateLog:[NSString stringWithFormat:@"findBLEPeripherals"]];
    if (self->CM.state  != CBCentralManagerStatePoweredOn) {
        [self.delegate updateLog:[NSString stringWithFormat:@"CoreBluetooth not correctly initialized !"]];
        [self.delegate updateLog:[NSString stringWithFormat:@"State = %d (%s)",(int) self->CM.state,[self centralManagerStateToString:self.CM.state]]];
        return -1;
    }
    
    [self.CM scanForPeripheralsWithServices:nil options:0]; // Start scanning
    return 0; // Started scanning OK !
}


/*!
 *  @method connectPeripheral:
 *
 *  @param p Peripheral to connect to
 *
 *  @discussion connectPeripheral connects to a given peripheral and sets the activePeripheral property of TIBLECBKeyfob.
 *
 */
- (void) connectPeripheral:(CBPeripheral *)peripheral syncMode:(BOOL)sync{
	if(connectingPeripheral==YES && sync==YES){
	    [self.delegate updateLog:[NSString stringWithFormat:@"Multiple connection detected and canceled. peripheral's UUID : %@",[peripheral.identifier UUIDString]]];
		return;
	}
    [self.delegate updateLog:[NSString stringWithFormat:@"Connecting to peripheral with Name : %@",[peripheral name]]];
    // activePeripheral = peripheral;
    // activePeripheral.delegate = self;
    check_time3 = CFAbsoluteTimeGetCurrent();
    connectingPeripheral=YES;
    [CM connectPeripheral:peripheral options:nil];
}

/*!
 *  @method centralManagerStateToString:
 *
 *  @param state State to print info of
 *
 *  @discussion centralManagerStateToString prints information text about a given CBCentralManager state
 *
 */
- (const char *) centralManagerStateToString: (int)state{
    switch(state) {
        case CBCentralManagerStateUnknown: 
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    return "Unknown state";
}

/*!
 *  @method scanTimer:
 *
 *  @param timer Backpointer to timer
 *
 *  @discussion scanTimer is called when findBLEPeripherals has timed out, it stops the CentralManager from scanning further and prints out information about known peripherals
 *
 */
- (void) scanTimer:(NSTimer *)timer {
    [self.CM stopScan];
    [self.delegate updateLog:[NSString stringWithFormat:@"Stopped Scanning"]];
    [self.delegate updateLog:[NSString stringWithFormat:@"Known peripherals : %lu",(unsigned long)[self->peripherals count]]];
	
    [self printKnownPeripherals];	
}

/*!
 *  @method printKnownPeripherals:
 *
 *  @discussion printKnownPeripherals prints all curenntly known peripherals stored in the peripherals array of TIBLECBKeyfob class 
 *
 */
- (void) printKnownPeripherals {
    int i;
    [self.delegate updateLog:[NSString stringWithFormat:@"List of currently known peripherals : "]];
    for (i=0; i < self->peripherals.count; i++)
    {
        CBPeripheral *p = [self->peripherals objectAtIndex:i];
        if(p.identifier == NULL) return;
        [self printPeripheralInfo:p];
    }
}

/*
 *  @method printPeripheralInfo:
 *
 *  @param peripheral Peripheral to print info of 
 *
 *  @discussion printPeripheralInfo prints detailed info about peripheral 
 *
 */
- (void) printPeripheralInfo:(CBPeripheral*)peripheral {
    if(peripheral.identifier == NULL) return; // zach ios6 added
    
    [self.delegate updateLog:[NSString stringWithFormat:@"------------------------------------"]];
    [self.delegate updateLog:[NSString stringWithFormat:@"Peripheral Info :"]];
    [self.delegate updateLog:[NSString stringWithFormat:@"UUID : %@",[peripheral.identifier UUIDString]]];
    [self.delegate updateLog:[NSString stringWithFormat:@"RSSI : %d",[peripheral.RSSI intValue]]];
    [self.delegate updateLog:[NSString stringWithFormat:@"Name : %s",[peripheral.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy]]];
    [self.delegate updateLog:[NSString stringWithFormat:@"isConnected : %@"
                              ,(peripheral.state==CBPeripheralStateConnected) ? @"YES" : @"NO"]];
    [self.delegate updateLog:[NSString stringWithFormat:@"-------------------------------------"]];
}

/*
 *  @method UUIDSAreEqual:
 *
 *  @param u1 CFUUIDRef 1 to compare
 *  @param u2 CFUUIDRef 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compares two CFUUIDRef's
 *
 */

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}


/*
 *  @method getAllServicesFromKeyfob
 *
 *  @param p Peripheral to scan
 *
 *
 *  @discussion getAllServicesFromKeyfob starts a service discovery on a peripheral pointed to by p.
 *  When services are found the didDiscoverServices method is called
 *
 */
-(void) getAllServicesFromKeyfob:(CBPeripheral *)p{
    [p discoverServices:nil]; // Discover all services without filter
    
}

/*
 *  @method getAllCharacteristicsFromKeyfob
 *
 *  @param p Peripheral to scan
 *
 *
 *  @discussion getAllCharacteristicsFromKeyfob starts a characteristics discovery on a peripheral
 *  pointed to by p
 *
 */
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p{
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        // printf("Fetching characteristics for service with UUID : %s",[self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}


/*
 *  @method CBUUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion CBUUIDToString converts the data of a CBUUID class to a character pointer for easy printout using printf()
 *
 */
-(const char *) CBUUIDToString:(CBUUID *) UUID {
    //if (!UUID) return "NULL";
    if (UUID == NULL) return "NULL"; // zach ios6 added
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


/*
 *  @method UUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion UUIDToString converts the data of a CFUUIDRef class to a character pointer for easy printout using printf()
 *
 */
-(const char *) UUIDToString:(CFUUIDRef)UUID {
    const char *uuidStr;
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    uuidStr=CFStringGetCStringPtr(s, 0);
	CFRelease(s);
    return uuidStr;
    
}
// a wrapper of UUIDToString
-(NSString *) UUIDToNSString:(CFUUIDRef)UUID {
	return [[NSString alloc] initWithCString:[self UUIDToString:UUID] encoding:NSISOLatin1StringEncoding];
}
/*
 *  @method compareCBUUID
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUID compares two CBUUID's to each other and returns 1 if they are equal and 0 if they are not
 *
 */

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

/*
 *  @method compareCBUUIDToInt
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UInt16 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUIDToInt compares a CBUUID to a UInt16 representation of a UUID and returns 1 
 *  if they are equal and 0 if they are not
 *
 */
-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2 {
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}
/*
 *  @method CBUUIDToInt
 *
 *  @param UUID1 UUID 1 to convert
 *
 *  @returns UInt16 representation of the CBUUID
 *
 *  @discussion CBUUIDToInt converts a CBUUID to a Uint16 representation of the UUID
 *
 */
-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

/*
 *  @method IntToCBUUID
 *
 *  @param UInt16 representation of a UUID
 *
 *  @return The converted CBUUID
 *
 *  @discussion IntToCBUUID converts a UInt16 UUID to a CBUUID
 *
 */
-(CBUUID *) IntToCBUUID:(UInt16)UUID {
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}


/*
 *  @method findServiceFromUUID:
 *
 *  @param UUID CBUUID to find in service list
 *  @param p Peripheral to find service on
 *
 *  @return pointer to CBService if found, nil if not
 *
 *  @discussion findServiceFromUUID searches through the services list of a peripheral to find a 
 *  service with a specific UUID
 *
 */
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

/*
 *  @method findCharacteristicFromUUID:
 *
 *  @param UUID CBUUID to find in Characteristic list of service
 *  @param service Pointer to CBService to search for charateristics on
 *
 *  @return pointer to CBCharacteristic if found, nil if not
 *
 *  @discussion findCharacteristicFromUUID searches through the characteristic list of a given service 
 *  to find a characteristic with a specific UUID
 *
 */
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

//----------------------------------------------------------------------------------------------------
//
//
//
//
//CBCentralManagerDelegate protocol methods beneeth here
// Documented in CoreBluetooth documentation
//
//
//
//
//----------------------------------------------------------------------------------------------------




- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    [self.delegate updateLog:[NSString stringWithFormat:@"Status of CoreBluetooth central manager changed %ld (%s)",central.state,[self centralManagerStateToString:central.state]]];
    [self.delegate updateLog:[NSString stringWithFormat:@"Status of CoreBluetooth central manager changed (%s)",[self centralManagerStateToString:central.state]]];
    check_time2 = CFAbsoluteTimeGetCurrent();
	[self.delegate updateCMState:central.state];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	[self.delegate updateLog:[NSString stringWithFormat:@"Did discover peripheral.  UUID: %@ Name %@", [peripheral.identifier UUIDString],peripheral.name]];
	
	// UUID filter
	if(certifiedDeviceNameDictionary && [certifiedDeviceNameDictionary count]>0)
	{
		if(!peripheral.name){
			NSLog(@"Ignore peripheral with NULL Name! UUID:%@",[peripheral.identifier UUIDString]);
            
			return;
		}
		if([certifiedDeviceNameDictionary objectForKey:peripheral.name]==nil)
		{
			NSLog(@"Ignore non-registered device name: %@  UUID:%@",peripheral.name,[peripheral.identifier UUIDString]);
			return;	// not registered name, ignore it.
		}
	}
    
	
    if (!self.peripherals) {
    	self.peripherals = [[NSMutableArray alloc] init];
	}
    for(int i = 0; i < self.peripherals.count; i++) {
        CBPeripheral *p = [self.peripherals objectAtIndex:i];
        // this is not right. UUID might be created AFTER the peripheral has been connected. Use name field to identify instead.
        /*
         if(p.UUID == NULL || peripheral.UUID == NULL ) {
         [self.delegate updateLog:[NSString stringWithFormat:@"Peripheral UUID null, skip."]];
         return; // zach ios6 added
         }
         */
        if(p.name == NULL || peripheral.name == NULL ) {
			[self.delegate updateLog:[NSString stringWithFormat:@"Peripheral name null, skip."]];
        	return; // orange added
        }
        // if ([self UUIDSAreEqual:p.UUID u2:peripheral.UUID]) {
        if ([p.name isEqualToString:peripheral.name]) {
            // [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
            // printf("Duplicate UUID found(%s,%s) updating ...",[self UUIDToString:p.UUID],[peripheral.identifier UUIDString]);
			[self.delegate updateLog:[NSString stringWithFormat:@"Peripheral name duplicate, skip."]];
            return;
        }
    }
    [self->peripherals addObject:peripheral];
    
	[self.delegate updateLog:[NSString stringWithFormat:@"Peripheral added into the list"]];
    //	[self.delegate updateLog:[NSString stringWithFormat:@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %s advertisementData: %@ ", peripheral, RSSI, [peripheral.identifier UUIDString], advertisementData]];
    
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    // printf("Connection to peripheral with UUID : %s successfull",[peripheral.identifier UUIDString]);
    // save as default connect peripheral
	// NSLog(@"save defaultPeripheralName=(%@) ",[self UUIDToNSString:peripheral.UUID]);
    [userPrefs setObject:peripheral.name forKey:@"defaultPeripheralName"];
    [userPrefs synchronize];
    
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    // printf("Calling discoverServices of peripheral with UUID : %s",[peripheral.identifier UUIDString]);
    bServicesFound=NO;
    [peripheral discoverServices:nil];
	// todo: sometimes it will just stop here, not knowning why....
	// I try to by-pass this issue by setting timer and recall again
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(discoverServiceTimer:) userInfo:nil repeats:NO];
}
// if the service is not found, call it again.
-(void) discoverServiceTimer:(NSTimer*)timer
{
#ifdef DEBUG_LOG_TIMER
NSLog(@"Timer:discoverServiceTimer triggered");
#endif
	if(bServicesFound==NO)
	{
		if(activePeripheral.state==CBPeripheralStateConnected){
		    [self.delegate updateLog:[NSString stringWithFormat:@"Re-calling discoverServices of peripheral with UUID : %@",[activePeripheral.identifier UUIDString]]];
			[activePeripheral discoverServices:nil];
			[NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(discoverServiceTimer:) userInfo:nil repeats:NO];
		}else if(activePeripheral.state==CBPeripheralStateDisconnected){
			// reconnect
		    [self.delegate updateLog:[NSString stringWithFormat:@"Re-connecting discoverServices of peripheral with UUID : %@",[activePeripheral.identifier UUIDString]]];
			[self connectPeripheral:activePeripheral syncMode:NO];
		}
	}else{
		connectingPeripheral=NO;	// connection established and service found.
	}
}
//----------------------------------------------------------------------------------------------------
//
//
//
//
//
//CBPeripheralDelegate protocol methods beneeth here
//
//
//
//
//
//----------------------------------------------------------------------------------------------------


/*
 *  @method didDiscoverCharacteristicsForService
 *
 *  @param peripheral Pheripheral that got updated
 *  @param service Service that characteristics where found on
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverCharacteristicsForService is called when CoreBluetooth has discovered 
 *  characteristics on a service, on a peripheral after the discoverCharacteristics routine has been called on the service
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (!error) {
        [self.delegate updateLog:[NSString stringWithFormat:@"Characteristics of service with UUID : %s found",[self CBUUIDToString:service.UUID]]];
        
        for(int i=0; i < service.characteristics.count; i++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
		    [self.delegate updateLog:[NSString stringWithFormat:@"Found characteristic %s",[self CBUUIDToString:c.UUID]]];

        }
        CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
        
        if(service.UUID == NULL || s.UUID == NULL){
            NSLog(@"Null abort discovering characteristics");
            return; // zach ios6 added
        }
        
        if([self compareCBUUID:service.UUID UUID2:s.UUID]) {
#ifdef DEBUG_SCALE_COMMAND
            NSLog(@"Finished discovering characteristics");
#endif
            [[self delegate] keyfobReady];
        }

        bServicesFound=YES;
    }
    else {
        [self.delegate updateLog:@"Characteristic discorvery unsuccessfull !"];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
}

/*
 *  @method didDiscoverServices
 *
 *  @param peripheral Pheripheral that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverServices is called when CoreBluetooth has discovered services on a 
 *  peripheral after the discoverServices routine has been called on the peripheral
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    // printf("didDiscoverServices:");
    if( peripheral.identifier == NULL  ) return; // zach ios6 added
    
    if (!error) {
        [self.delegate updateLog:[NSString stringWithFormat:@"Services of peripheral with UUID : %@ found",[peripheral.identifier UUIDString]]];
	    check_time4 = CFAbsoluteTimeGetCurrent();
        [self getAllCharacteristicsFromKeyfob:peripheral];
    }
    else {
        [self.delegate updateLog:[NSString stringWithFormat:@"Service discovery was unsuccessfull !"]];
    }
}

/*
 *  @method didUpdateNotificationStateForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateNotificationStateForCharacteristic is called when CoreBluetooth has updated a 
 *  notification state for a characteristic
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
   

    if( characteristic.UUID == NULL ||peripheral.identifier == NULL  )
    {
        NSLog(@"Null abort didUpdateNotificationStateForCharacteristic");
        return; // zach ios6 added
    }
    if (!error) {
        [self.delegate updateLog:[NSString stringWithFormat:@"Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with name=%@"
        	,[self CBUUIDToString:characteristic.UUID]
        	,[self CBUUIDToString:characteristic.service.UUID]
        	,[peripheral name]]];
    }
    else {
        [self.delegate updateLog:[NSString stringWithFormat:@"Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %@",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[peripheral.identifier UUIDString]]];
        [self.delegate updateLog:[NSString stringWithFormat:@"Error code was %s",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]]];
    }
    
}

/*
 *  @method didUpdateValueForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateValueForCharacteristic is called when CoreBluetooth has updated a 
 *  characteristic for a peripheral. All reads and notifications come here to be processed.
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    [self.delegate updateLog:[NSString stringWithFormat:@"didUpdateValueForCharacteristic"]];

#ifdef DEBUG_SCALE_COMMAND
    // [self.delegate updateLog:[NSString stringWithFormat:@"didUpdateValueForCharacteristic"]];
#endif
    if( characteristic.UUID == NULL  ) return; // zach ios6 added
    
    UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
    if (!error) {
        switch(characteristicUUID){
            case JB_UART_RX_NOTIFICATION_UUID:   //Added by Joybien
            {
                char sdata[128];
                int readLen=127;
                // orange fix: read only what it got, and add a tailing \0 for the array
                //[characteristic.value getBytes:&sdata length:JB_UART_RX_NOTIFICATION_READ_LEN];
                if(characteristic.value.length<128)
                	readLen=(int) characteristic.value.length;
                [characteristic.value getBytes:&sdata length:readLen];
                sdata[readLen]='\0';
                
#ifdef DEBUG_SCALE_COMMAND
// [self.delegate updateLog:[NSString stringWithFormat:@"Received Data:(%s),len=%d", sdata,readLen]];
#endif
                [[self delegate] stringValuesUpdated:sdata];
                break;
            }

         }
    }    
    else {
       [self.delegate updateLog:[NSString stringWithFormat:@"updateValueForCharacteristic failed !"]];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if(error)
    {
        NSLog(@"Error writing value to Peripheral.");
    }else{
//        NSLog(@" write successed");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

-(void) clearNotActivePeripherals
{
    if (!self.peripherals) 
    	self.peripherals = [[NSMutableArray alloc] init];
	

	// Find the things to remove
	NSMutableArray *toDelete = [NSMutableArray array];
	for (id object in self.peripherals ){
		CBPeripheral *p=object;
	   if (p.state==CBPeripheralStateDisconnected){
	       [toDelete addObject:object];
	    }
    }
	
	// Remove them
	[self.peripherals removeObjectsInArray:toDelete];
		
	
	[self.delegate updateLog:[NSString stringWithFormat:@"clearNotActivePeripherals, now peripheral count=%lu", (unsigned long)self.peripherals.count]];
}
-(void) disconnectFromCurrentPeripheral
{
    if (!self.activePeripheral)
    	return;
	
	if(self.activePeripheral.state!=CBPeripheralStateDisconnected){
		[self.CM cancelPeripheralConnection:self.activePeripheral];
	}
	
}
@end
