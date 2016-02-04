//
//  SlowPowerUp.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "TimeLapsePowerUp.h"

#define SLOW_IMAGE @"blue_star.png"
#define SLOW_COLLISION @"sloCollision";

@implementation TimeLapsePowerUp

- (NSString*)getCollisionTypeString {
	return SLOW_COLLISION;
}

- (NSString*)getImageString {
	return SLOW_IMAGE;
}

@end
