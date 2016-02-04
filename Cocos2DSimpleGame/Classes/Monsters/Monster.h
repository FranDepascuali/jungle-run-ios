//
//  Monster.h
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 5/24/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "HelloWorldScene.h"

@interface Monster : CCSprite

+ (Monster*)createMonster:(HelloWorldScene*)scene;

+ (Monster *)createDayLightMonster:(HelloWorldScene*)scene;

+ (Monster *)createNightMonster:(HelloWorldScene*)scene;

- (void)makeSound;

@end
