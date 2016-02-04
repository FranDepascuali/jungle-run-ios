//
//  Dino.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/31/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Dino.h"
#import "Monster.h"
#import "CommonDefinitions.h"



#define DINO_IMAGE @"dino1.png"
#define DINO_COLLISION @"monsterCollision"
#define DINO_SOUND @"dino.wav"

@implementation Dino{
    int imgForAnimation;
}

- (id)init
{
    self = [super init];
    if(self) {
        self = [super initWithImageNamed:DINO_IMAGE];
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.collisionGroup = MONSTER_COLLISION_GROUP;
        self.physicsBody.collisionType  = DINO_COLLISION;
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
    return self;
}

- (void) animateDino:(CCTime)dt{
    
    NSString *path = [NSString stringWithFormat:@"dino%d.png",imgForAnimation];
    
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:path]];
    imgForAnimation++;
    if (imgForAnimation == 28)
        imgForAnimation = 1;
}

- (void)makeSound {
	[[OALSimpleAudio sharedInstance] playEffect:DINO_SOUND];
}

@end
