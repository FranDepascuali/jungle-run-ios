//
//  GameOverScene.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/16/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "GameOverScene.h"
#import "HelloWorldScene.h"
#import "SelectLevelScene.h"

@implementation GameOverScene

+ (GameOverScene *)sceneWithScore: (int) s andNewBest:(BOOL)new
{
    return [[self alloc] initWithScore: s andNewBest: new];
}

- (id)initWithScore: (int) s andNewBest:(BOOL) new
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCSprite * background = [CCSprite spriteWithImageNamed:@"presentacion.png"];
    background.scaleX = self.contentSize.width / background.contentSize.width;
    background.scaleY = self.contentSize.height / background.contentSize.height;
    background.anchorPoint = ccp(0, 0);
    background.opacity = 0.9f;
    [self addChild:background];
    
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Verdana" fontSize:50.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.65f, 0.62f); // Middle of screen
    [self addChild:label];
    
    CCLabelTTF *labelS = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d",s] fontName:@"Verdana" fontSize:30.0f];
    labelS.positionType = CCPositionTypeNormalized;
    labelS.color = [CCColor whiteColor];
    labelS.position = ccp(0.65f, 0.5f); // Middle of screen
    [self addChild:labelS];
    
    // Spinning scene button
    CCButton *startButton = [CCButton buttonWithTitle:@"Play Again!" fontName:@"Verdana-Bold" fontSize:30.0f];
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.75f, 0.35f);
    [startButton setTarget:self selector:@selector(onStartClicked:)];
    [self addChild:startButton];
    
    if (new){
        CCLabelTTF *labelNew = [CCLabelTTF labelWithString:@"Congratulations, new Record!" fontName:@"Verdana-Bold" fontSize:25.0f];
        labelNew.positionType = CCPositionTypeNormalized;
        labelNew.color = [CCColor whiteColor];
        labelNew.position = ccp(0.6f, 0.1f); // Middle of screen
        [self addChild:labelNew];
    }

    
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onStartClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[SelectLevelScene scene]];
}

// -------

@end
