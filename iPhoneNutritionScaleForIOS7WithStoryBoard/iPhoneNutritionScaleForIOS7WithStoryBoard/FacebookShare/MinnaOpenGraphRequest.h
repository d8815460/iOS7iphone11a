//
//  MinnaOpenGraphRequest.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by Orange Chang on 13/10/13.
//  Copyright (c) 2013年 Proch Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinnaOpenGraphRequest : NSObject
{
    UIImage *postImage;
    NSString *postMessage;
}
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic)NSString *postMessage;
@end
