//
//  PAPCustomAlert.m
//  Test19284951
//
//  Created by pardnoj on 23/07/2014.
//  Copyright (c) 2014 pardnoj. All rights reserved.
//

#import "PAPCustomAlert.h"
#import "UIImage+ImageEffects.h"

static const CGFloat kAlertButtonBottomMargin = 10;
static const CGFloat kAlertButtonSideMargin = 15;
static const CGFloat kAlertButtonsBetweenMargin = 3;
static const CGFloat kAlertButtonHeight = 30;

static const CGFloat kAlertTitleLabelHeight = 30;
static const CGFloat kAlertTitleLabelTopMargin = 30;
static const CGFloat kALertDescriptionLabelTopMargin = 40;
static const CGFloat kAlertDescriptionLabelHeight = 100;

static const CGFloat kAlertTitleLabelFontSize = 24;
static const CGFloat kAlertDescriptionLabelFontSize = 14;
static const CGFloat kAlertButtonFontSize = 14;

static const CGFloat kAlertViewCornerRadius   = 8;
static const CGFloat kButtonsCornerRadius     = 5;

@interface PAPCustomAlert () {
    block p_okButtonClickedBlock;
    block p_cancelButtonClickedBlock;
}

@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * okButtonTitle;
@property (nonatomic, strong) NSString * cancelButtonTitle;

@property (nonatomic, strong) UIView   * alertView;
@property (nonatomic, strong) UILabel  * messageLabel;
@property (nonatomic, strong) UIButton * okButton;
@property (nonatomic, strong) UIButton * cancelButton;

@end

@implementation PAPCustomAlert

#pragma mark - Initializers

- (instancetype)initFoamyAlertWithMessage:(NSString *)message okButtonTitle:(NSString *)okButtonTitle {
    return [self initFoamyAlertWithMessage:message okButtonTitle:okButtonTitle cancelButtonTitle:nil okButtonClickedBlock:nil cancelButtonClickedBlock:nil];
}

- (instancetype)initFoamyAlertWithMessage:(NSString *)message okButtonTitle:(NSString *)okButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle okButtonClickedBlock:(block)okButtonClickedBlock {
    return [self initFoamyAlertWithMessage:message okButtonTitle:okButtonTitle cancelButtonTitle:cancelButtonTitle okButtonClickedBlock:okButtonClickedBlock cancelButtonClickedBlock:nil];
}

// Designated initializer
- (instancetype)initFoamyAlertWithMessage:(NSString *)message okButtonTitle:(NSString *)okButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle okButtonClickedBlock:(block)okButtonClickedBlock cancelButtonClickedBlock:(block)cancelButtonClickedBlock {
    self = [super init];
    if (!self) return nil;
    
    self.message = message;
    self.okButtonTitle = okButtonTitle;
    self.cancelButtonTitle = cancelButtonTitle;
    p_okButtonClickedBlock = okButtonClickedBlock;
    p_cancelButtonClickedBlock = cancelButtonClickedBlock;
    [self initDefaultColors];
    [self initFoamyAlertView];
    
    return self;
}

- (void)initDefaultColors {
    if (!self.alertViewColor)
        self.alertViewColor = [UIColor blueColor];
    if (!self.okButtonColor)
        self.okButtonColor = [UIColor greenColor];
    if (!self.cancelButtonColor)
        self.cancelButtonColor = [UIColor redColor];
}

- (void)initFoamyAlertView {
    self.frame = [self mainScreenFrame];
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self makeBackgroudBlur];
    [self makeAlertPopUp];
    [self makeMessageLabel];
    [self makeButtons:self.cancelButton == nil ? YES : NO];
}

#pragma mark - Setup alert view

- (void)makeBackgroudBlur {
    
}

- (void)makeAlertPopUp {
    CGRect frame = CGRectMake(0, 0, 240, 180);
    CGRect screen = [self mainScreenFrame];
    
    self.alertView = [[UIView alloc]initWithFrame:frame];
    
    self.alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetHeight(screen)/2);
    
    self.alertView.layer.masksToBounds = YES;
    self.alertView.layer.cornerRadius = kAlertViewCornerRadius;
    self.alertView.backgroundColor = self.alertViewColor;
    
    [self addSubview:self.alertView];

}

- (void)makeMessageLabel {
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.alertView.frame) - kAlertButtonSideMargin, kAlertTitleLabelHeight)];
    self.messageLabel.center = CGPointMake(CGRectGetWidth(self.alertView.frame)/2, kAlertTitleLabelTopMargin);
    self.messageLabel.text = self.message;
    self.messageLabel.textColor = [UIColor darkGrayColor];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
    self.messageLabel.font = [self.messageLabel.font fontWithSize:kAlertTitleLabelFontSize];
    
    [self.alertView addSubview:self.messageLabel];
}

-(void)makeButtons:(BOOL)hasCancelButton {
    self.okButton = [[UIButton alloc]init];
    if (hasCancelButton) {
        self.cancelButton = [[UIButton alloc]init];
        [self.okButton setFrame:CGRectMake(0, 0, CGRectGetWidth(self.alertView.frame)/2 - kAlertButtonSideMargin, kAlertButtonHeight)];
        [self.cancelButton setFrame:CGRectMake(0, 0, CGRectGetWidth(self.alertView.frame)/2 - kAlertButtonSideMargin, kAlertButtonHeight)];
        
        [self.okButton setCenter:CGPointMake(CGRectGetWidth(self.alertView.frame)/4 + kAlertButtonsBetweenMargin,
                                        CGRectGetHeight(self.alertView.frame) - CGRectGetHeight(self.okButton.frame)/2 - kAlertButtonBottomMargin)];
        [self.cancelButton setCenter:CGPointMake(CGRectGetWidth(self.alertView.frame)*3/4 - kAlertButtonsBetweenMargin,
                                            CGRectGetHeight(self.alertView.frame) - CGRectGetHeight(self.okButton.frame)/2 - kAlertButtonBottomMargin)];
        
        [self.cancelButton setBackgroundImage:[UIImage imageWithColor:self.cancelButtonColor] forState:UIControlStateNormal];
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.cornerRadius = kButtonsCornerRadius;
        [self.cancelButton setTitle:self.cancelButtonTitle
                       forState:UIControlStateNormal];
        [self.cancelButton.titleLabel setFont:[self.cancelButton.titleLabel.font fontWithSize:kAlertButtonFontSize]];
        [self.cancelButton addTarget:self
                          action:@selector(pressButton:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:self.cancelButton];
        
    } else {
        [self.okButton setFrame:CGRectMake(0, 0, CGRectGetWidth(self.alertView.frame) - (kAlertButtonSideMargin * 2), kAlertButtonHeight)];
        [self.okButton setCenter:CGPointMake(CGRectGetWidth(self.alertView.frame)/2, CGRectGetHeight(self.alertView.frame) - CGRectGetHeight(self.okButton.frame)/2 - kAlertButtonBottomMargin)];
    }
     [self.okButton setBackgroundImage:[UIImage imageWithColor:self.okButtonColor] forState:UIControlStateNormal];
    
    self.okButton.layer.masksToBounds = YES;
    self.okButton.layer.cornerRadius = kButtonsCornerRadius;
    [self.okButton setTitle:self.okButtonTitle
              forState:UIControlStateNormal];
    [self.okButton.titleLabel setFont:[self.okButton.titleLabel.font fontWithSize:kAlertButtonFontSize]];
    [self.okButton addTarget:self
                 action:@selector(pressButton:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView addSubview:self.okButton];
}

#pragma mark - Handle alert view

- (void)dismiss:(FoamyAlertButton)buttonType {
    block block;
    switch (buttonType) {
        case FoamyAlertButtonOk:
            p_okButtonClickedBlock ? block = p_okButtonClickedBlock : nil;
            break;
        case FoamyAlertButtonCancel:
            p_cancelButtonClickedBlock ? block = p_cancelButtonClickedBlock : nil;
            break;
        default:
            break;
    }
    
    // Dismiss animation
    CGRect screen = [self mainScreenFrame];
    self.alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetHeight(screen) / 2);
    [UIView animateWithDuration:0.7f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.alertView.center = CGPointMake(CGRectGetWidth(screen) / 2, CGRectGetHeight(screen) + CGRectGetHeight(self.alertView.frame) / 2);
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (block) block();
                     }];
}

- (void)pressButton:(UIButton *)sender {
    UIButton * button = sender;
    FoamyAlertButton buttonType;
    
    if( [button isEqual:self.okButton] ) {
        NSLog(@"Pressed Button is OkButton");
        buttonType = FoamyAlertButtonOk;

    }
    else {
        NSLog(@"Pressed Button is CancelButton");
        buttonType = FoamyAlertButtonCancel;

    }
    [self dismiss:buttonType];
}

- (void)showAnimation {
    CGRect screen = [self mainScreenFrame];
    self.alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetMinY(screen));
    [UIView animateWithDuration:0.7f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:25.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetHeight(screen)/2);
                     } completion:^(BOOL finished) {
                         //code
                     }];
}


#pragma mark - Public Methods

- (void)show {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self showAnimation];
}

#pragma mark - Utils Methods

- (CGRect)mainScreenFrame
{
    return [UIScreen mainScreen].bounds;
}

@end























