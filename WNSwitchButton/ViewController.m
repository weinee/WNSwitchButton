//
//  ViewController.m
//  WNSwitchButton
//
//  Created by weinee on 16/4/11.
//  Copyright © 2016年 weinee. All rights reserved.
//

#import "ViewController.h"
#import "WNSwitchButton.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	WNSwitchButton *switchBtn = [WNSwitchButton switchButton];
	
	UIImageView *view = [[UIImageView alloc] init];
	view.backgroundColor = [UIColor blueColor];
	
	switchBtn.config
	.frame(CGRectMake(100, 100, 120, 35))
	.switchButtonClick(^(WNSwitchButton *switchButton, WNSwitchButtonState currentState){
		if (currentState == WNSwitchButtonStateNormal) {
			NSLog(@"关注");
		} else if (currentState == WNSwitchButtonStateReversal){
			NSLog(@"取消关注");
		}
		
		//注释这句，控件将永远保持loading状态
		[switchButton reversed];
	})
//	.loadingView(view)
	.title(@"关注", @"取消关注")
	.endConfig();
	[self.view addSubview:switchBtn];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
