//
//  Wolf.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Monster.h"
#import "Wolf.h"
#import "CommonDefinitions.h"

#define WOLF_IMAGE @"w1.png"
#define WOLF_COLLISION @"monsterCollision"
#define WOLF_SOUND @"wolf.mp3"

@implementation Wolf{
    int imgForAnimation;
}

- (id)init
{
    self = [super init];
    if(self) {
        self = [super initWithImageNamed:WOLF_IMAGE];
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.collisionGroup = MONSTER_COLLISION_GROUP;
        self.physicsBody.collisionType  = WOLF_COLLISION;
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

- (void) animateWolf:(CCTime)dt{
    
    NSString *path = [NSString stringWithFormat:@"w%d.png",imgForAnimation];
    
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:path]];
    imgForAnimation++;
    if (imgForAnimation == 15)
        imgForAnimation = 1;
}

- (void)makeSound {
    [[OALSimpleAudio sharedInstance] playEffect:WOLF_SOUND];
}

@end

