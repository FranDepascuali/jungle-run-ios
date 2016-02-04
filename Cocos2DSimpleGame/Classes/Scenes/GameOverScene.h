//
//  GameOverScene.h
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/16/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "CCScene.h"

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface GameOverScene : CCScene


+ (GameOverScene *)sceneWithScore: (int) score andNewBest:(BOOL) new;
- (id)initWithScore: (int) s andNewBest:(BOOL) new;

@end
