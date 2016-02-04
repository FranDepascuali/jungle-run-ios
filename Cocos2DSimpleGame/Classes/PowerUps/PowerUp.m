//
//  PowerUp.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 5/29/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "PowerUp.h"
#import "CommonDefinitions.h"

#define DEFAULT_IMAGE @"star.png"

#define DEFAULT_COLLISION @"powerCollision"

@implementation PowerUp

- (id)initWithPosition:(CGPoint)position {
	self = [super initWithImageNamed:[self getImageString]];
	if (self) {
		self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
		self.physicsBody.sensor=YES;
		self.physicsBody.type=CCPhysicsBodyTypeStatic;
		self.physicsBody.collisionType = [self getCollisionTypeString];
		self.physicsBody.collisionGroup = @"powerCollision";
		self.rotation = 0;
		self.position = position;
	}
	return self;
}

- (NSString*)getCollisionTypeString {
	return DEFAULT_IMAGE;
}

- (NSString*)getImageString {
	return DEFAULT_COLLISION;
}

- (void)rotatePower:(CCTime)dt {
	self.rotation++;
}

@end
