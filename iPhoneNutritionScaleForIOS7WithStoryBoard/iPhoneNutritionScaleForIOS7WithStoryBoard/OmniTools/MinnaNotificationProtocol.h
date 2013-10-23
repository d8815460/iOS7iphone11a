//
//  MinnaNotificationProtocol.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by Orange Chang on 13/10/13.
//  Copyright (c) 2013年 Proch Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinnaOpenGraphRequest.h"

@protocol MinnaNotificationProtocol <NSObject>

-(void) MinnaMessage:(NSString *)message;

-(NSNumber *) MinnaListenerID;

@end

@protocol MinnaListenerServerProtocol <NSObject>

-(void) addMinnaListener:(id<MinnaNotificationProtocol>)listener;

-(void) removeMinnaListener:(id<MinnaNotificationProtocol>)listener;

-(void) addMinnaOpenGraphRequest:(MinnaOpenGraphRequest *) opengraphObject;

-(void) broadcastMinnaNotificationMessage:(NSString *)broadcastMessage;

@end