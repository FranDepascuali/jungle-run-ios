//
//  LiveUp.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "LifePowerUp.h"

#define LIVE_UP_IMAGE @"heart.png"
#define LIVE_UP_COLLISION @"liveCollision"

@implementation LifePowerUp

- (NSString*)getCollisionTypeString {
	return LIVE_UP_COLLISION;
}

- (NSString*)getImageString {
	return LIVE_UP_IMAGE;
}

@end
