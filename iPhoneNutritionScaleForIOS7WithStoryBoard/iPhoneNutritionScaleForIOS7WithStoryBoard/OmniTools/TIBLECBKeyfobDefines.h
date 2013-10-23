 //
//  TIBLECBKeyfobDefines.h
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/31/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//
// 
// Added UART TX/RX data communication by Bighead Chen on 06/18/2012
// Copyright (c) 2012 Joybien Technologies. All right reserved.
//
#ifndef TI_BLE_Demo_TIBLECBKeyfobDefines_h
#define TI_BLE_Demo_TIBLECBKeyfobDefines_h

// Defines for the TI CC2540 keyfob peripheral

#define TI_KEYFOB_PROXIMITY_ALERT_UUID                      0x1802
#define TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID             0x2a06
#define TI_KEYFOB_PROXIMITY_ALERT_ON_VAL                    0x01
#define TI_KEYFOB_PROXIMITY_ALERT_OFF_VAL                   0x00
#define TI_KEYFOB_PROXIMITY_ALERT_WRITE_LEN                 1
#define TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID             0x1804
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID        0x2A07
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_READ_LEN    1

//
// define by Joybien for UART data communication
//

/*#define JB_UART_RX_PRIMARY_SERVICE_UUID                      0x1809  // for STRING RX UUID
#define JB_UART_RX_NOTIFICATION_UUID                         0x2A1E  // for STRING RX NOTIFY
#define JB_UART_RX_NOTIFICATION_READ_LEN                         20  // bytes

#define JB_UART_TX_PRIMARY_SERVICE_UUID                      0x180A  // for STRING TX UUID
#define JB_UART_TX_SECOND_UUID                               0x2A24 
#define JB_UART_TX_WRITE_LEN                                     20  // bytes  
*/


//
// define by Joybien for UART/UNO data Communication
//
#define JB_UART_RX_PRIMARY_SERVICE_UUID                      0xFFE0  // for STRING RX UUID
#define JB_UART_RX_NOTIFICATION_UUID                         0xFFE2  // for STRING RX NOTIFY
#define JB_UART_RX_NOTIFICATION_READ_LEN                         20  // bytes

#define JB_UART_TX_PRIMARY_SERVICE_UUID                      0xFFF0  // for STRING TX UUID
#define JB_UART_TX_SECOND_UUID                               0xFFF5 
#define JB_UART_TX_WRITE_LEN                                     20  // bytes  



#endif
