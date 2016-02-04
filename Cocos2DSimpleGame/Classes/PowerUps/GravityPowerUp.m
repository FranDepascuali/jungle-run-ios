//
//  Moon.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "GravityPowerUp.h"

#define MOON_IMAGE @"astro.png"
#define SPACE_COLLISION @"spaceCollision";

@implementation GravityPowerUp

- (NSString*)getCollisionTypeString {
	return SPACE_COLLISION;
}

- (NSString*)getImageString {
	return MOON_IMAGE;
}

@end
