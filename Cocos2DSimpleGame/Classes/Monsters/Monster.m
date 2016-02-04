//
//  Monster.m
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 5/24/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Monster.h"
#import "HelloWorldScene.h"
#import "Bird.h"
#import "Cheetah.h"
#import "Dino.h"
#import "Wolf.h"
#import "Giraffe.h"


@implementation Monster : CCSprite

+ (Monster*)createMonster:(HelloWorldScene*)scene {
       
    int rand = arc4random()%100;
    
    if (rand<50){
        int r = arc4random() % 100;
        if (r<50)
            return [self createCheetah:scene];
        else
            return [self createWolf:scene];
    }
    if (rand<65){
        return [self createBird:scene];
    }
    else{
        int r = arc4random() % 100;
        if (r<60)
            return [self createGiraffe:scene];
        else
            return [self createDino:scene];
    }
}

+ (Monster *)createDayLightMonster:(HelloWorldScene*)scene {
	int r = arc4random() % 100;
	if (r < 30) {
		return [self createCheetah:scene];
	}
	if (r < 60) {
		return [self createGiraffe:scene];
	}
	return [self createBird:scene];
}

+ (Monster *)createNightMonster:(HelloWorldScene*)scene {
	int r = arc4random() % 100;
	if (r < 60) {
		return [self createWolf:scene];
	}
	return [self createDino:scene];
}

+ (Monster *)createBird:(HelloWorldScene*)scene {
    Bird * bird = [[Bird alloc] initWithPosition:ccp(scene.contentSize.width-10, 0.75*scene.contentSize.height)];
    [scene resizeSprite:bird toWidth:0.15*scene.contentSize.width toHeight:0.15*scene.contentSize.height];
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [scene startMoving:bird withDuration:randomDuration toPosition: CGPointMake(-bird.contentSize.width/2, 0.75*scene.contentSize.height)];
    [bird schedule:@selector(animateBird:) interval:0.03];
    
    return bird;
}

+ (Monster *)createCheetah:(HelloWorldScene*)scene {
    Cheetah * cheetah = [[Cheetah alloc] initWithPosition:ccp(scene.contentSize.width-10, 0.3*scene.contentSize.height)];
    [scene resizeSprite:cheetah toWidth:0.2*scene.contentSize.width toHeight:0.2*scene.contentSize.height];
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [scene startMoving:cheetah withDuration:randomDuration toPosition: CGPointMake(-cheetah.contentSize.width/2, 0.3*scene.contentSize.height)];
    [cheetah schedule:@selector(animateCheetah:) interval:0.03];
    
    return cheetah;
}


+ (Monster *)createDino:(HelloWorldScene*)scene {
    Dino * dino = [[Dino alloc] initWithPosition:ccp(scene.contentSize.width-5, 0.5*scene.contentSize.height)];
    [scene resizeSprite:dino toWidth:0.4*scene.contentSize.width toHeight:0.4*scene.contentSize.height];
    int minDuration = 8.0;
    int maxDuration = 10.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [scene startMoving:dino withDuration:randomDuration toPosition: CGPointMake(-dino.contentSize.width/2, 0.5*scene.contentSize.height)];
    [dino schedule:@selector(animateDino:) interval:0.03];
    
    return dino;
}

+ (Monster *)createWolf:(HelloWorldScene*)scene {
    Wolf * wolf = [[Wolf alloc] initWithPosition:ccp(scene.contentSize.width-5, 0.5*scene.contentSize.height)];
    [scene resizeSprite:wolf toWidth:0.15*scene.contentSize.width toHeight:0.15*scene.contentSize.height];
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [scene startMoving:wolf withDuration:randomDuration toPosition: CGPointMake(-wolf.contentSize.width/2, 0.5*scene.contentSize.height)];
    [wolf schedule:@selector(animateWolf:) interval:0.03];
    
    return wolf;
}

+ (Monster *)createGiraffe:(HelloWorldScene*)scene {
    Giraffe * giraffe = [[Giraffe alloc] initWithPosition:ccp(scene.contentSize.width-5, 0.5*scene.contentSize.height)];
    [scene resizeSprite:giraffe toWidth:0.25*scene.contentSize.width toHeight:0.35*scene.contentSize.height];
    int minDuration = 9.0;
    int maxDuration = 11.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [scene startMoving:giraffe withDuration:randomDuration toPosition: CGPointMake(-giraffe.contentSize.width/2, 0.5*scene.contentSize.height)];
    [giraffe schedule:@selector(animateGiraffe:) interval:0.06];
    
    return giraffe;
}
- (void)makeSound {
	
}

@end
