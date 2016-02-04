//
//  StarPowerUp.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "ShotsPowerUp.h"

#define STAR_IMAGE @"star.png"
#define STAR_COLLISION @"powerCollision"


@implementation ShotsPowerUp

- (NSString*)getCollisionTypeString {
	return STAR_COLLISION;
}

- (NSString*)getImageString {
	return STAR_IMAGE;
}

@end
