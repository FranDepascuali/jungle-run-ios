//
//  Banana.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 5/29/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "FireShot.h"
#import "CommonDefinitions.h"

#define SHOT_IMAGE @"fire.png"
#define SHOT_COLLISION @"projectileCollision"

@implementation FireShot

- (id)init {
	self = [super initWithImageNamed:SHOT_IMAGE];
	if(self) {
        self.physicsBody.collisionGroup = @"playerGroup";
		self.physicsBody.collisionType = SHOT_COLLISION;
		[self schedule:@selector(rotateShot:) interval:1];
	}
	return self;
}

- (id)initWithPosition:(CGPoint)position {
	self = [self init];
	if(self) {
		self.position = position;
	}
	return self;
}

- (void)rotateShot:(CCTime)dt {
	self.rotation++;
}

@end
