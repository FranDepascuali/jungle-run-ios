//
//  Banana.h
//  Cocos2DSimpleGame
//
//  Created by Francisco Depascuali on 5/29/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "Weapon.h"

@interface FireShot : Weapon

- (id)initWithPosition:(CGPoint)position;

- (void)rotateShot:(CCTime)dt;

@end
