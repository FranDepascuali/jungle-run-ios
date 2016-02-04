//
//  Weapon.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 5/29/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon

- (id)initWithImageNamed:(NSString *)imageName {
	self = [super initWithImageNamed:imageName];
	if(self) {
		self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.width/2.0f andCenter:self.anchorPointInPoints];
		self.physicsBody.collisionGroup = @"playerGroup";
		self.physicsBody.type = CCPhysicsBodyTypeStatic;
	}
	return self;
}

@end
