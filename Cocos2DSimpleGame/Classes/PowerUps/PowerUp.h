//
//  PowerUp.h
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 5/29/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface PowerUp : CCSprite

- (id)initWithPosition:(CGPoint)position;

- (void)rotatePower:(CCTime)dt;

- (NSString*)getCollisionTypeString;

- (NSString*)getImageString;

@end
