//
//  Cheetah.h
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/31/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Monster.h"

@interface Cheetah : Monster

- (id)initWithPosition:(CGPoint)position;

- (void) animateCheetah:(CCTime)dt;

- (void)makeSound;

@end
