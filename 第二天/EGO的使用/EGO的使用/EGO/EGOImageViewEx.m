//
//  EGOImageViewEx.m
//  WingletterIOS
//
//  Created by Hubert Ryan on 11-5-24.
//  Copyright 2011 suning. All rights reserved.
//

#import "EGOImageViewEx.h"


@implementation EGOImageViewEx

@synthesize exDelegate = exDelegate_;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	
	
//	DLog(@"UIImageViewEx touchesBegan \n");
}
//捕获手指拖拽消息
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
}

//捕获手指拿开消息
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
	
//	DLog(@"EGOImageViewEx touchesEnded \n");
	if ([exDelegate_ conformsToProtocol:@protocol(EGOImageViewExDelegate)]) {
		if ([exDelegate_ respondsToSelector:@selector(imageExViewDidOk:)]) {
			[exDelegate_ imageExViewDidOk:self];
		}		
	}
}

@end
