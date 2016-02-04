//
//  GameOverScene.m
//  Cocos2DSimpleGame
//
//  Created by Ivan Itzcovich on 5/16/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

#import "SelectLevelScene.h"
#import "HelloWorldScene.h"
#import "CommonDefinitions.h"

@implementation SelectLevelScene

+ (SelectLevelScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCSprite * background = [CCSprite spriteWithImageNamed:@"level.png"];
    background.scaleX = self.contentSize.width / background.contentSize.width;
    background.scaleY = self.contentSize.height / background.contentSize.height;
    background.anchorPoint = ccp(0, 0);
    background.opacity = 0.9f;
    [self addChild:background];
    
    
    CCButton *startButton1 = [CCButton buttonWithTitle:@"Easy" fontName:@"Verdana-Bold" fontSize:30.0f];
    startButton1.positionType = CCPositionTypeNormalized;
    startButton1.position = ccp(0.5f, 0.75f);
    [startButton1 setTarget:self selector:@selector(onStartClickedEasy:)];
    [self addChild:startButton1];

    CCButton *startButton2 = [CCButton buttonWithTitle:@"Medium" fontName:@"Verdana-Bold" fontSize:30.0f];
    startButton2.positionType = CCPositionTypeNormalized;
    startButton2.position = ccp(0.5f, 0.5f);
    [startButton2 setTarget:self selector:@selector(onStartClickedMedium:)];
    [self addChild:startButton2];
    
    
    // Spinning scene button
    CCButton *startButton3 = [CCButton buttonWithTitle:@"Extreme!" fontName:@"Verdana-Bold" fontSize:30.0f];
    startButton3.positionType = CCPositionTypeNormalized;
    startButton3.position = ccp(0.5f, 0.25f);
    [startButton3 setTarget:self selector:@selector(onStartClickedExtreme:)];
    [self addChild:startButton3];
    
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onStartClickedEasy:(id)sender
{
    HelloWorldScene *h = [HelloWorldScene scene];
    [h setLevelSelected: EASY];
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:h
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onStartClickedMedium:(id)sender
{
    HelloWorldScene *h = [HelloWorldScene scene];
    [h setLevelSelected: MEDIUM];
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:h
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];}

- (void)onStartClickedExtreme:(id)sender
{
    HelloWorldScene *h = [HelloWorldScene scene];
    [h setLevelSelected: EXTREME];
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:h
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -------

@end
