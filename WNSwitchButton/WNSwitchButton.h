//
//  WNSwitchButton.h
//  WNSwitchButton
//
//  Created by weinee on 16/4/11.
//  Copyright © 2016年 weinee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WNSwitchButtonConfigModel, WNSwitchButton;
typedef enum WNSwitchButtonState {
	WNSwitchButtonStateNormal,
	/** 等待转换消息的状态*/
	WNSwitchButtonStateLoading,
	WNSwitchButtonStateReversal
} WNSwitchButtonState;

//定义代码块链
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonConfig)();
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToState)(WNSwitchButtonState state);
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToRect)(CGRect rect);
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToView)(UIView *view);
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToColor)(UIColor *normalColor, UIColor *reversalColor);
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToString)(NSString *normalStr, NSString *reversalStr);
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToFont)(UIFont *normalFont, UIFont *reversalStr);
//当按钮被点击时调用代码块，需要主动发送可以转换的消息给switchButton, currentState为转换前的状态
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToSwitchBlock)(void (^ switchStateBlock)(WNSwitchButton *switchButton, WNSwitchButtonState currentState));
typedef WNSwitchButtonConfigModel *(^WNSwitchButtonToFinishConfig)();

@interface WNSwitchButton : UIButton

@property (nonatomic, assign, readonly) WNSwitchButtonState switchButtonState;

@property (nonatomic, strong, readonly) WNSwitchButtonConfigModel *config;

+(instancetype)switchButton;

/** 发送可以转换的消息*/
-(void)reversed;

@end


@interface WNSwitchButtonConfigModel : NSObject

//-(instancetype)initWithSwitchButton:(WNSwitchButton *)switchButton;

//进行设置
@property (nonatomic, copy, readonly) WNSwitchButtonToString title;
@property (nonatomic, copy, readonly) WNSwitchButtonToFont titleFont;
@property (nonatomic, copy, readonly) WNSwitchButtonToColor titleColor;
@property (nonatomic, copy, readonly) WNSwitchButtonToColor tintColor;
@property (nonatomic, copy, readonly) WNSwitchButtonToColor backColor;
@property (nonatomic, copy, readonly) WNSwitchButtonToSwitchBlock switchButtonClick;
@property (nonatomic, copy, readonly) WNSwitchButtonToView loadingView;

@property (nonatomic, copy, readonly) WNSwitchButtonToRect frame;
@property (nonatomic, copy, readonly) WNSwitchButtonToState switchButtonState;

// 设置完成必须调用
@property (nonatomic, assign, readonly) WNSwitchButtonToFinishConfig endConfig;
@end


