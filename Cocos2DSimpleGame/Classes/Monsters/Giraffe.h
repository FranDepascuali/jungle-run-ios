//
//  Giraffe.h
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 7/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Monster.h"

@interface Giraffe : Monster


- (id)initWithPosition:(CGPoint)position;

- (void) animateGiraffe:(CCTime)dt;

- (void)makeSound;

@end
