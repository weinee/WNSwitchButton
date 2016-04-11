//
//  WNSwitchButton.m
//  WNSwitchButton
//
//  Created by weinee on 16/4/11.
//  Copyright © 2016年 weinee. All rights reserved.
//

#import "WNSwitchButton.h"
#define WS(ws) __weak typeof (self) ws = self

@interface WNSwitchButton (){
	
}

@end

@interface WNSwitchButtonConfigModel ()

//model数据缓存
@property (nonatomic, assign) WNSwitchButtonState modelSwitchButtonState;
@property (nonatomic, strong) UIView *modelLoadingView;
@property (nonatomic, assign) CGRect modelFrame;
@property (nonatomic, copy) NSString *modelNormalTitle;
@property (nonatomic, copy) NSString *modelRevesalTitle;
@property (nonatomic, strong) UIFont *modelNormalTitleFont;
@property (nonatomic, strong) UIFont *modelReversalTitleFont;
@property (nonatomic, strong) UIColor *modelNormalTitleColor;
@property (nonatomic, strong) UIColor *modelReversalTitleColor;
@property (nonatomic, strong) UIColor *modelNormalTintColor;
@property (nonatomic, strong) UIColor *modelReversalTintColor;
@property (nonatomic, strong) UIColor *modelNormalBackColor;
@property (nonatomic, strong) UIColor *modelReversalBackColor;
@property (nonatomic, copy) void(^ modelSwitchButtonClick)(WNSwitchButton *switchButton, WNSwitchButtonState currentState);
//结束配置
@property (nonatomic, copy) void (^ modelFinishConfig) ();
@end

@implementation WNSwitchButton
@synthesize config = _config;

+(instancetype)switchButton{
	WNSwitchButton *btn = [WNSwitchButton buttonWithType:UIButtonTypeRoundedRect];
	[btn addTarget:btn action:@selector(loading) forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

-(void)reversed{
	//绘制状态变化后的样式
	[self drawByState];
}

-(void)loading{
	if (_switchButtonState == WNSwitchButtonStateLoading) {
		return;
	}
	WNSwitchButtonState currentState = _switchButtonState;
	_switchButtonState = WNSwitchButtonStateLoading;
	[self drawByState];
	if (currentState == WNSwitchButtonStateReversal) {
		_switchButtonState = WNSwitchButtonStateNormal;
	} else if (currentState == WNSwitchButtonStateNormal){
		_switchButtonState = WNSwitchButtonStateReversal;
	}
	
	//触发drawRect
	[self setNeedsDisplay];
	
	//调用代码块
	if (_config.modelSwitchButtonClick) {
		_config.modelSwitchButtonClick(self, currentState);
	}
}

#pragma mark WNSwitchButton getter
-(WNSwitchButtonConfigModel *)config{
	if (_config) {
		return _config;
	}
	_config = [[WNSwitchButtonConfigModel alloc] init];//所有的配置数据将从config中获取
	//TODO: 有问题，为什么用Strong
	__weak typeof(self) weakSelf = self;
	__strong typeof(weakSelf) strongSelf = weakSelf;
	//实现结束的代码块，在endconfig中调用
	_config.modelFinishConfig = ^(){
		weakSelf.frame = weakSelf.config.modelFrame;
		_switchButtonState = weakSelf.config.modelSwitchButtonState;
		[strongSelf drawByState];
	};
	return _config;
}

-(void)drawByState{
	//根据状态绘制
	switch (_switchButtonState) {
		case WNSwitchButtonStateNormal:
			self.userInteractionEnabled = YES;
			[self setTitle:_config.modelNormalTitle forState:UIControlStateNormal];
			[self setTitleColor:_config.modelNormalTitleColor forState:UIControlStateNormal];
			self.titleLabel.font = _config.modelNormalTitleFont;
			self.backgroundColor = _config.modelNormalBackColor;
			self.layer.borderColor = _config.modelNormalTintColor.CGColor;
			[_config.modelLoadingView removeFromSuperview];
			break;
		case WNSwitchButtonStateReversal:
			self.userInteractionEnabled = YES;
			[self setTitle:_config.modelRevesalTitle forState:UIControlStateNormal];
			[self setTitleColor:_config.modelReversalTitleColor forState:UIControlStateNormal];
			self.titleLabel.font = _config.modelReversalTitleFont;
			self.backgroundColor = _config.modelReversalBackColor;
			self.layer.borderColor = _config.modelReversalTintColor.CGColor;
			[_config.modelLoadingView removeFromSuperview];
			break;
		case WNSwitchButtonStateLoading:
			self.userInteractionEnabled = NO;
			[self setTitle:nil forState:UIControlStateNormal];
			[self setTitleColor:nil forState:UIControlStateNormal];
			[self addSubview:_config.modelLoadingView];
			break;
		default:
			break;
	}
	
	self.layer.borderWidth = 2;
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	switch (_switchButtonState) {
		case WNSwitchButtonStateNormal:
			CGContextSetStrokeColorWithColor(context, _config.modelNormalTintColor.CGColor);//设置画笔颜色;
			CGContextMoveToPoint(context, 15, 5);
			CGContextAddLineToPoint(context, 15, 15);
			break;
		case WNSwitchButtonStateReversal:
			CGContextSetStrokeColorWithColor(context, _config.modelReversalTintColor.CGColor);//设置画笔颜色;
			break;
		default:
			break;
	}
	
	CGContextMoveToPoint(context, 10, 10);
	CGContextAddLineToPoint(context, 20, 10);
	CGContextSetLineWidth(context, 2);
	CGContextStrokePath(context);
}

@end

@implementation WNSwitchButtonConfigModel

- (instancetype)init
{
	self = [super init];
	if (self) {
		
		//设置默认值
		_modelSwitchButtonState = WNSwitchButtonStateNormal;
		_modelFrame = CGRectMake(0, 0, 100, 40);
		
		_modelNormalBackColor = [UIColor whiteColor];
		_modelNormalTintColor = [UIColor colorWithRed:0 green:183 blue:196 alpha:1];
		_modelNormalTitleColor = [UIColor colorWithRed:0 green:183 blue:196 alpha:1];
		_modelNormalTitle = @"normal";
		_modelNormalTitleFont = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
		
		_modelReversalBackColor = [UIColor whiteColor];
		_modelReversalTintColor = [UIColor redColor];
		_modelReversalTitleColor = [UIColor redColor];
		_modelRevesalTitle = @"reversal";
		_modelReversalTitleFont = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
		
		//默认的loading视图
		UIActivityIndicatorView *aView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[aView startAnimating];
		_modelLoadingView = [[UIView alloc] initWithFrame:_modelFrame];
		aView.center = _modelLoadingView.center;
		[_modelLoadingView addSubview:aView];
	}
	return self;
}

#pragma mark - WNSwitchButtonConfigModel getter 设置配置项
-(WNSwitchButtonToString)title{
	WS(ws);
	//getter方法 return
	//实现代码块
	return ^(NSString *normalStr, NSString *reversalStr){
		_modelNormalTitle = normalStr;
		_modelRevesalTitle = reversalStr;
		return ws;
	};
}

-(WNSwitchButtonToFont)titleFont{
	WS(ws);
	return ^(UIFont *font1, UIFont *font2){
		_modelNormalTitleFont = font1;
		_modelReversalTitleFont = font2;
		return ws;
	};
}

-(WNSwitchButtonToColor)titleColor{
	WS(ws);
	return ^(UIColor *color1, UIColor *color2){
		_modelNormalTitleColor = color1;
		_modelReversalTitleColor = color2;
		return ws;
	};
}

-(WNSwitchButtonToColor)tintColor{
	WS(ws);
	return ^(UIColor *color1, UIColor *color2){
		_modelNormalTintColor = color1;
		_modelReversalTintColor = color2;
		return ws;
	};
}

-(WNSwitchButtonToColor)backColor{
	WS(ws);
	return ^(UIColor *color1, UIColor *color2){
		_modelNormalBackColor = color1;
		_modelReversalBackColor = color2;
		return ws;
	};
}

-(WNSwitchButtonToState)switchButtonState{
	WS(ws);
	return ^(WNSwitchButtonState state){
		_modelSwitchButtonState = state;
		return ws;
	};
}

-(WNSwitchButtonToRect)frame{
	WS(ws);
	return ^(CGRect rect){
		_modelFrame = rect;
		return ws;
	};
}

-(WNSwitchButtonToView)loadingView{
	WS(ws);
	return ^(UIView *view){
		_modelLoadingView = view;
		return ws;
	};
}

-(WNSwitchButtonToSwitchBlock)switchButtonClick{
	WS(ws);
	return ^(void (^ switchButtonClick)(WNSwitchButton *switchButton, WNSwitchButtonState currentState)){
		_modelSwitchButtonClick = switchButtonClick;
		return ws;
	};
}

-(WNSwitchButtonToFinishConfig)endConfig{
	WS(ws);
	return ^(){
		if (ws.modelFinishConfig) {
			ws.modelFinishConfig();
		}
		return ws;
	};
}
@end
