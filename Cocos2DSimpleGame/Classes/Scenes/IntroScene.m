//
//  IntroScene.m
//  Cocos2DSimpleGame
//
//  Created by Martin Walsh on 18/01/2014.
//  Copyright Razeware LLC 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "SelectLevelScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
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
    

    // Spinning scene button
    CCButton *startButton = [CCButton buttonWithTitle:@"Start" fontName:@"Verdana-Bold" fontSize:30.0f];
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.75f, 0.45f);
    [startButton setTarget:self selector:@selector(onStartClicked:)];
    [self addChild:startButton];

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

// -----------------------------------------------------------------------
@end
