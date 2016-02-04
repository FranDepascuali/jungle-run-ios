//
//  Bird.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/31/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Bird.h"
#import "Monster.h"
#import "CommonDefinitions.h"



#define BIRD_IMAGE @"bird1.png"
#define BIRD_COLLISION @"monsterCollision"
#define BIRD_SOUND @"bird.wav"

@implementation Bird {
    int imgForAnimation;
}

- (id)init
{
    self = [super init];
    if(self) {
        self = [super initWithImageNamed:BIRD_IMAGE];
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.collisionGroup = MONSTER_COLLISION_GROUP;
        self.physicsBody.collisionType  = BIRD_COLLISION;
        self.physicsBody.mass = 100;
        self.physicsBody.friction = 0;
        imgForAnimation=1;
    }
    return self;
}

- (id)initWithPosition:(CGPoint)position {
    self = [self init];
    if(self) {
        self.position = position;
    }
  // self.physicsBody.type = CCPhysicsBodyTypeStatic;
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    self.physicsBody.affectedByGravity = NO;
    return self;
}

- (void) animateBird:(CCTime)dt{
    
    NSString *path = [NSString stringWithFormat:@"bird%d.png",imgForAnimation];
    
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:path]];
    imgForAnimation++;
    if (imgForAnimation == 16)
        imgForAnimation = 1;
}

- (void)makeSound {
	[[OALSimpleAudio sharedInstance] playEffect:BIRD_SOUND];
}

@end
