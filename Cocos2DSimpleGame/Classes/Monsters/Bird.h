//
//  Bird.h
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/31/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Monster.h"

@interface Bird : Monster

- (id)initWithPosition:(CGPoint)position;

- (void) animateBird:(CCTime)dt;

- (void)makeSound;

@end
