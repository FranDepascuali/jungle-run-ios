//
//  Background.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 6/19/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Background.h"

@implementation Background

- (id)init {
	self = [super init];
	if(self){
		self.position = ccp(0.5f,0.5f);
		self.opacity = 1;
	}
	return self;
}

- (void)backgroundFadeAway {
	self.opacity-=0.2f;
	if(self.opacity <= 0) {
		[self removeFromParentAndCleanup:YES];
	}
}

@end
