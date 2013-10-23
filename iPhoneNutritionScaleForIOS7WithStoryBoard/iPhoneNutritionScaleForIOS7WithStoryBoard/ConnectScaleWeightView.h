//
//  ConnectScaleWeightView.h
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectScaleWeightView : UIView
{
    Boolean scaleIsOpen;
}
@property (nonatomic, strong) UIButton *tareButton;
@property (nonatomic, strong) IBOutlet UILabel *iWeightLabel;
@property (nonatomic, strong) IBOutlet UIButton *iUnitButton;
@property (nonatomic, strong) IBOutlet UIButton *iPhoneChangeButton;
@property (nonatomic, strong) IBOutlet UIView *weightLabelAnimateView;
@property (nonatomic, strong) UILabel *netLabel;

@property (nonatomic, strong) UIButton *connectButton;

// Universal message label
@property (nonatomic, strong) UILabel *messageLabel;

// state: connecting
//		abort connection button
@property (nonatomic, strong) UIButton *cancelConnectingButton;
//		Connecting label
// @property (nonatomic, strong) UILabel *connectingLabel;
// state: connection failed
//		Connection failed Label
// @property (nonatomic, strong) UILabel *connectionFailedLabel;
//		try again Label
// @property (nonatomic, strong) UILabel *tryAgainLabel;
//		OK button
@property (nonatomic, strong) UIButton *okReconnectButton;
//		cancel button
@property (nonatomic, strong) UIButton *cancelConnectButton;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
//電池無電量訊息Image及數值
@property (nonatomic, strong) UIImageView *batteryImageView;
@property (nonatomic, strong) UILabel *bateryLabel;

// - (UIImage *)imageFromColor:(UIColor *)color;

- (void) setNetLabelHidden:(BOOL) netLabelHidden;
@end
