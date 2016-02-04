//
//  Cheetah.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/31/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Cheetah.h"
#import "Monster.h"
#import "CommonDefinitions.h"



#define CHEETAH_IMAGE @"leo1.png"
#define CHEETAH_COLLISION @"monsterCollision"
#define CHEETAH_SOUND @"cut_roar.mp3"


@implementation Cheetah {
    int imgForAnimation;
}

- (id)init
{
    self = [super init];
    if(self) {
        self = [super initWithImageNamed:CHEETAH_IMAGE];
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.collisionGroup = MONSTER_COLLISION_GROUP;
        self.physicsBody.collisionType  = CHEETAH_COLLISION;
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

- (void)animateCheetah:(CCTime)dt{
    
    NSString *path = [NSString stringWithFormat:@"leo%d.png",imgForAnimation];
    
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:path]];
    imgForAnimation++;
    if (imgForAnimation == 13)
        imgForAnimation = 1;
}

- (void)makeSound {
	[[OALSimpleAudio sharedInstance] playEffect:CHEETAH_SOUND];
}

@end
