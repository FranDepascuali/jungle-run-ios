//
//  HeavyPowerUp.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "HeavyPowerUp.h"

#define HEAVY_IMAGE @"mush.png"
#define HEAVY_COLLISION @"heavyCollision";

@implementation HeavyPowerUp

- (NSString*)getCollisionTypeString {
	return HEAVY_COLLISION;
}

- (NSString*)getImageString {
	
	return HEAVY_IMAGE;
}

@end
