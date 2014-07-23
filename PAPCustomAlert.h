//
//  PAPCustomAlert.h
//  Test19284951
//
//  Created by pardnoj on 23/07/2014.
//  Copyright (c) 2014 pardnoj. All rights reserved.
//

#import <UIKit/UIKit.h>
// Supports only two types of buttons - OK and CANCEL
typedef NS_ENUM(NSInteger, FoamyAlertButton) {
    FoamyAlertButtonOk,
    FoamyAlertButtonCancel
};
// TODO: Animations types. Change all initializers, add private methods etc.
typedef NS_ENUM(NSInteger, FoamyAlertAnimationType) {
    FoamyAlertAnimationTypeFromTopToBottom,
    FoamyAlertAnimationTypeFromBottomToTop,
    FoamyAlertAnimationTypeFromLeftToRight,
    FoamyAlertAnimationTypeFromRightToLeft
};

// Callback fired after clicking OK or CANCEL button
typedef void (^block)(void);

@interface PAPCustomAlert : UIView
// Self-explanatory properties and methods
@property (nonatomic, strong) UIColor * alertViewColor;
@property (nonatomic, strong) UIColor * okButtonColor;
@property (nonatomic, strong) UIColor * cancelButtonColor;

- (instancetype)initFoamyAlertWithMessage:(NSString *)message okButtonTitle:(NSString *)okButtonTitle;
- (instancetype)initFoamyAlertWithMessage:(NSString *)message okButtonTitle:(NSString *)okButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle okButtonClickedBlock:(block)okButtonClickedBlock;
- (instancetype)initFoamyAlertWithMessage:(NSString *)message okButtonTitle:(NSString *)okButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle okButtonClickedBlock:(block)okButtonClickedBlock cancelButtonClickedBlock:(block)cancelButtonClickedBlock;

- (void)show;

@end
