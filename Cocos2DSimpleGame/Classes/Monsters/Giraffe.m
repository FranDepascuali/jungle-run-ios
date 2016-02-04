//
//  Giraffe.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Monster.h"
#import "Giraffe.h"
#import "CommonDefinitions.h"

#define GIRAFFE_IMAGE @"g1.png"
#define GIRAFFE_COLLISION @"monsterCollision"
#define GIRAFFE_SOUND @"dino.wav"


@implementation Giraffe{
    int imgForAnimation;
}

- (id)init
{
    self = [super init];
    if(self) {
        self = [super initWithImageNamed:GIRAFFE_IMAGE];
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.collisionGroup = MONSTER_COLLISION_GROUP;
        self.physicsBody.collisionType  = GIRAFFE_COLLISION;
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

- (void) animateGiraffe:(CCTime)dt{
    
    NSString *path = [NSString stringWithFormat:@"g%d.png",imgForAnimation];
    
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:path]];
    imgForAnimation++;
    if (imgForAnimation == 12)
        imgForAnimation = 1;
}

@end
