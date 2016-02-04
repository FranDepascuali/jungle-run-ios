//
//  HelloWorldScene.m
//  Cocos2DSimpleGame
//
//  Created by  on 18/01/2014.
//  Copyright Razeware LLC 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "GameOverScene.h"
#import "Monster.h"
#import "CCAction.h"
#import "CCActionInterval.h"
#import "CommonDefinitions.h"
#import "PowerUp.h"
#import "LifePowerUp.h"
#import "GravityPowerUp.h"
#import "ShotsPowerUp.h"
#import "TimeLapsePowerUp.h"
#import "HeavyPowerUp.h"
#import "OALSimpleAudio.h"
#import "CCScheduler.h"
#import "Background.h"
#import "LifePowerUp.h"
#import "GravityPowerUp.h"
#import <UIKit/UIResponder.h>
#import "FireShot.h"

#define GRAVITY -1000.f
#define MASS 100.f
#define GROUND_HEIGHT 0.18 * SCREEN_HEIGHT
#define SCREEN_HEIGHT self.contentSize.height
#define SCREEN_WIDTH self.contentSize.width
#define LEFT_BOUND_WIDTH 50
#define AUDIO_SOURCE @"rainforest.mp3"
#define BACKGROUND_IMAGE @"jungle.jpg"
#define INCREMENT 10.f
#define UPDATES_TO_LAPSE 8
#define DIVISION_SCREEN 0.25
#define MAX_LIVES 5
#define TIME_IN_SPACE 10
#define TIME_HEAVY 10
#define ORIGINAL_JUMP_FORCE 180000

@implementation HelloWorldScene {
	
	CGRect *_screenRect;
	
	CCPhysicsNode *_physicsWorld;
	CCNode *_ground;
	CCNode *_dynamicScreen;
	
    CCSprite *_player;
    CCSprite *_background1;
    CCSprite *_background2;
	
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_maxScoreLabel;
    CCLabelTTF *_livesLabel;
    CCLabelTTF *_shotsLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_waveLabel;
    
    CCButton *_backButton;
    CCButton *_resumeButton;
    CCButton *_endButton;
	
    int lives;
    int quantityMonsters;
    int quantityJumps;
    int score;
    int shotsLeft;
    int imgForPlayer;
    int level;
    int touchTime;
    int slowMotion;
	int currentTime;
    int selectedLevel;
    
    NSInteger highScore;
    
    BOOL hasPower;
    BOOL animationPlayerStopped;
    BOOL firstTimeScheduler;
    BOOL inTouch;
    BOOL inTimeLapse;
    BOOL newBestScore;
    BOOL firstTimeSpecial;
    BOOL inSpace;
    BOOL isHeavy;
	BOOL dayLight;
    
    float probForLevel;
    float timePerStar;
    float timePerMonster;
    float timeInWave;
    float timeOutOfWave;
    float timePerBird;
    float timeToGetForSpecial;
    float timeToAddMonster;
    float waitTimeMonster;
    float timeToThrowGoodPower;
    float timeToThrowBadPower;
    float waitTimeGoodPower;
    float waitTimeHeavy;
    float waitTimeSpace;
    float waitTimeBadPower;
    float jumpForce;
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
	if(self) {
		[self initGameConfiguration];
	}
    return self;
}

- (void)initGameConfiguration {
	self.userInteractionEnabled = YES;
	[[OALSimpleAudio sharedInstance] preloadBg:AUDIO_SOURCE];
    [[OALSimpleAudio sharedInstance] playBgWithLoop:YES];
	[self initBackground];
	[self initPhysicsWorld];
	[self initGround];
	//	[self initDynamicScreen];
	[self initRoof];
	[self initLeftBounds];
	[self initRightBounds];
    [self initGroundBounds];
	[self initVariables];
	[self initPlayer];
	[self initBackButton];
	[self initScoreLabel];
    [self initMaxScoreLabel];
	[self initLivesLabel];
	[self initShotsLabel];
    [self initWaveLabel];
}

// -----------------------------------------------------------------------
#pragma mark - Monsters
// -----------------------------------------------------------------------

- (void)addMonster{
    //PARA QUE NO APAREZCAN MONSTRUOS
    //return;
	Monster *monster;
//	if(dayLight) {
//		monster = [Monster createDayLightMonster:self];
//	} else {
//		monster = [Monster createNightMonster:self];
//	}
    monster = [Monster createMonster:self];
    [_ground addChild:monster];
	[monster makeSound];
}

// -----------------------------------------------------------------------
#pragma mark - Powers
// -----------------------------------------------------------------------

-(void) throwGoodPower {
    int rand = arc4random() % 100;
    if (rand < 33){
        [self throwNewLive];
        return;
    }
    if (rand < 50){
        [self throwSloMo];
        return;
    }
    if (rand < 90){
        [self throwShots];
        return;
    }
}

-(void) throwBadPower {
//    int rand = arc4random() % 100;
//    if (rand < 50){
//        [self throwHeavy];
//        return;
//    }
//    if (rand < 90){
//        [self throwSpace];
//        return;
//    }
    
    [self throwHeavy];
    return;
}

- (void)throwShots {

    float height = (arc4random() % 60) + 30 ;
    
	ShotsPowerUp* power = [[ShotsPowerUp alloc] initWithPosition:CGPointMake(SCREEN_WIDTH, (height / 100)*SCREEN_HEIGHT)];
	[self resizeSprite:power toWidth:0.05*SCREEN_WIDTH toHeight:0.05*SCREEN_HEIGHT];
	[_physicsWorld addChild:power];
	
	int minDuration = 2.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    
	[self startMoving:power withDuration:randomDuration toPosition:CGPointMake(-power.contentSize.width/2, (height / 100) * SCREEN_HEIGHT)];
	[power schedule:@selector(rotatePower:) interval:0.005];
}

- (void)throwNewLive {
    if (firstTimeSpecial || lives==MAX_LIVES){
        firstTimeSpecial=NO;
        return;
    }
    
    float height = (arc4random() % 60) + 30 ;

    
    LifePowerUp* power = [[LifePowerUp alloc] initWithPosition:CGPointMake(SCREEN_WIDTH, (height / 100)*SCREEN_HEIGHT)];
    [self resizeSprite:power toWidth:0.07*SCREEN_WIDTH toHeight:0.07*SCREEN_HEIGHT];
    [_physicsWorld addChild:power];
    
    int minDuration = 5.0;
    int maxDuration = 7.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [self startMoving:power withDuration:randomDuration toPosition:CGPointMake(-power.contentSize.width/2, (height / 100) * SCREEN_HEIGHT)];
    [power schedule:@selector(rotatePower:) interval:0.01];
}

- (void)throwSloMo {
   
    float height = (arc4random() % 60) + 30 ;

    
    TimeLapsePowerUp* power = [[TimeLapsePowerUp alloc] initWithPosition:CGPointMake(SCREEN_WIDTH, (height / 100)*SCREEN_HEIGHT)];
    [self resizeSprite:power toWidth:0.07*SCREEN_WIDTH toHeight:0.07*SCREEN_HEIGHT];
    [_physicsWorld addChild:power];
    
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [self startMoving:power withDuration:randomDuration toPosition:CGPointMake(-power.contentSize.width/2, (height / 100) * SCREEN_HEIGHT)];
    [power schedule:@selector(rotatePower:) interval:0.01];
}

- (void)throwSpace {
    
    float height = (arc4random() % 60) + 30 ;

    
    GravityPowerUp* power = [[GravityPowerUp alloc] initWithPosition:CGPointMake(SCREEN_WIDTH, (height / 100)*SCREEN_HEIGHT)];
    [self resizeSprite:power toWidth:0.07*SCREEN_WIDTH toHeight:0.09*SCREEN_HEIGHT];
    [_physicsWorld addChild:power];
    
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [self startMoving:power withDuration:randomDuration toPosition:CGPointMake(-power.contentSize.width/2, (height / 100) * SCREEN_HEIGHT)];
    [power schedule:@selector(rotatePower:) interval:0.01];
}

- (void)throwHeavy {
    
    float height = (arc4random() % 60) + 30 ;

    
    HeavyPowerUp* power = [[HeavyPowerUp alloc] initWithPosition:CGPointMake(SCREEN_WIDTH, (height / 100)*SCREEN_HEIGHT)];
    [self resizeSprite:power toWidth:0.07*SCREEN_WIDTH toHeight:0.08*SCREEN_HEIGHT];
    [_physicsWorld addChild:power];
    
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    [self startMoving:power withDuration:randomDuration toPosition:CGPointMake(-power.contentSize.width/2, (height / 100) * SCREEN_HEIGHT)];
    [power schedule:@selector(rotatePower:) interval:0.01];
}

// -----------------------------------------------------------------------
#pragma mark - Auxiliar Methods
// -----------------------------------------------------------------------

- (void)startMoving:(CCSprite*)npc withDuration:(int)randomDuration toPosition:(CGPoint)position {
	CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:position];
	CCAction *actionRemove = [CCActionRemove action];
	[npc runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

- (void)setBackground:(CCSprite*)background forScreen:(CGRect)screen startingAt:(NSInteger)position {
	background.scaleX=screen.size.width/background.contentSize.width;
	background.scaleY=screen.size.height/background.contentSize.height;
	[background setAnchorPoint:ccp(0, 0)];
	background.position=ccp(position, 0);
	[self addChild:background];
}

- (void)scrollBackground:(CCTime)dt {
	_background1.position = ccp( _background1.position.x - 1, _background1.position.y );
	_background2.position = ccp( _background2.position.x - 1, _background2.position.y );
	if ( _background1.position.x < -[_background1 boundingBox].size.width ) {
		_background1.position = ccp(_background2.position.x + [_background2 boundingBox].size.width, _background1.position.y );
	}
	if ( _background2.position.x < -[_background2 boundingBox].size.width ) {
		_background2.position = ccp(_background1.position.x + [_background1 boundingBox].size.width, _background2.position.y );
	}
}

- (void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
	sprite.scaleX = width / sprite.contentSize.width;
	sprite.scaleY = height / sprite.contentSize.height;
}

- (void)animatePlayer {
    NSString *path;
//    if (!inSpace && !isHeavy){
//        path= [NSString stringWithFormat:@"run%d.png",imgForPlayer];
//    }else{
//        path= [NSString stringWithFormat:@"runm%d.png",imgForPlayer];
//    }

    path=[NSString stringWithFormat:@"run%d.png",imgForPlayer];
    
    [_player setSpriteFrame:[CCSpriteFrame frameWithImageNamed:path]];
    imgForPlayer++;
    if (imgForPlayer==10)
        imgForPlayer=1;
}

- (void)updateShotsLabel {
	[_shotsLabel setString: [NSString stringWithFormat:@"Shots: %i",shotsLeft]];
}

- (void)updateFreezeLabel {
    [_waveLabel setString: [NSString stringWithFormat:@"Freeze: %i",slowMotion]];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ([[CCDirector sharedDirector] isPaused])
        return;
    
    
	CGPoint touchLocation = [touch locationInNode:self];
	int force;
   
	
//	//NSLog(@"q: %i",quantityJumps);
	
    if (_player.position.y <= GROUND_HEIGHT + 0.08*SCREEN_HEIGHT ){
        ////NSLog(@"Reseteo de los saltos");
        animationPlayerStopped = NO;
		quantityJumps=0;
    }
	
	switch (quantityJumps) {
		case 0:
			force=jumpForce;
			break;
		case 1:
			force=jumpForce;
			break;
		case 2:
			force=jumpForce;
			break;
	}
	if (touchLocation.x < DIVISION_SCREEN * SCREEN_WIDTH) {
		//NSLog(@"Jump!");
        inTouch = YES;
        [self unschedule:@selector(animatePlayer)];
        animationPlayerStopped = YES;
		if (quantityJumps >= 3) {
			return;
		}
		quantityJumps++;
		[[_player physicsBody] applyImpulse:ccp(0, _player.physicsBody.mass*force)];
	} else {
		//NSLog(@"Shoot!");
		if (hasPower && shotsLeft > 0){
           [[OALSimpleAudio sharedInstance] playEffect:@"shot.wav"];
			shotsLeft--;
			if (shotsLeft == 0)
				hasPower=NO;
			[self updateShotsLabel];
			FireShot *shot = [[FireShot alloc] initWithPosition:_player.position];
			[self resizeSprite:shot toWidth:0.03*SCREEN_WIDTH toHeight:0.03*SCREEN_HEIGHT];
            if (inTimeLapse)
                [self startMoving:shot withDuration:1 toPosition:[self getTargetPositionFromTouch:touch]];
            else
                [self startMoving:shot withDuration:2 toPosition:[self getTargetPositionFromTouch:touch]];
			[_physicsWorld addChild:shot];
		}
	}
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:self];
    if (touchLocation.x < DIVISION_SCREEN * SCREEN_WIDTH){
        inTouch = NO;
        touchTime = 0;
    }
}

- (CGPoint)getTargetPositionFromTouch:(UITouch *)touch {
	CGPoint touchLocation = [touch locationInNode:self];
	CGPoint offset = ccpSub(touchLocation, _player.position);
	float ratio = offset.y/offset.x;
	int targetX = _player.contentSize.width/2 + SCREEN_WIDTH;
	int targetY = (targetX*ratio) + _player.position.y;
	return ccp(targetX,targetY);
}

// -----------------------------------------------------------------------
#pragma mark - Collision Handlers
// -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
	[monster removeFromParentAndCleanup:YES];
    [self scoreUp];
    [self monsterDown];
	[projectile removeFromParentAndCleanup:YES];
	return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_rightCollision:(CCNode *)goal projectileCollision:(CCNode *)projectile {
	[projectile removeFromParentAndCleanup:YES];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair groundCollision:(CCNode *)ground projectileCollision:(CCNode *)projectile {
    //NSLog(@"Proyectil al piso");
    [projectile removeFromParentAndCleanup:YES];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_rightCollision:(CCNode *)goal monsterCollision:(CCNode *)monster {
    //NSLog(@"Choca!");
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair powerCollision:(CCNode *)power playerCollision:(CCNode *)player {
	hasPower=YES;
	[power removeFromParentAndCleanup:YES];
	//NSLog(@"POWER!");
	shotsLeft+=10;
    [[OALSimpleAudio sharedInstance] playEffect:@"coin.wav"];
	[_shotsLabel setString: [NSString stringWithFormat:@"Shots: %i",shotsLeft]];
	return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair liveCollision:(CCNode *)live playerCollision:(CCNode *)player {
    [live removeFromParentAndCleanup:YES];
    lives+=1;
    [[OALSimpleAudio sharedInstance] playEffect:@"coin.wav"];
    [_livesLabel setString: [NSString stringWithFormat:@"Lives: %i",lives]];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair sloCollision:(CCNode *)slo playerCollision:(CCNode *)player {
    [slo removeFromParentAndCleanup:YES];
    slowMotion+=50;
    [[OALSimpleAudio sharedInstance] playEffect:@"coin.wav"];
    [_waveLabel setString: [NSString stringWithFormat:@"Freeze: %i",slowMotion]];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair spaceCollision:(CCNode *)space playerCollision:(CCNode *)player {
    [space removeFromParentAndCleanup:YES];
    _physicsWorld.gravity = ccp(0,GRAVITY/2);
    inSpace=YES;
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heavyCollision:(CCNode *)heavy playerCollision:(CCNode *)player {
    [heavy removeFromParentAndCleanup:YES];
    jumpForce/=1.5;
    [[OALSimpleAudio sharedInstance] playEffect:@"SFX_Powerup_02.wav"];
    isHeavy=YES;
    return YES;
}

-(void) scoreUp{
    score++;
    if (score > highScore){
        highScore = score;
        newBestScore=YES;
    }
    [_scoreLabel setString: [NSString stringWithFormat:@"Score: %i",score]];
    [_maxScoreLabel setString: [NSString stringWithFormat:@"Best: %ld",(long)highScore]];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster playerCollision:(CCNode *)player {
		
	float p_y=player.position.y-(player.contentSize.height*player.scaleY)/2;
	float m_y=monster.position.y+(monster.contentSize.height*monster.scaleY)/2;
	
	if (p_y>=m_y-7 && p_y<=m_y+7) {
		[monster removeFromParentAndCleanup:YES];
		quantityJumps=0;
        [self scoreUp];
        [self monsterDown];
		return NO;
	}
	lives--;
    [self liveDown];
	[_livesLabel setString: [NSString stringWithFormat:@"Lives: %i",lives]];
	[monster removeFromParentAndCleanup:YES];
	if (lives == 0) {
		//NSLog(@"Game Over");
		[[OALSimpleAudio sharedInstance] stopBg];
		if(inTimeLapse){
			[self endTimeLapse];
		}
        [self gameOverWithScore:score andNewBest:newBestScore];
	}
	return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_leftCollision:(CCNode *)goal monsterCollision:(CCNode *)monster {
	[monster removeFromParentAndCleanup:YES];
    [self scoreUp];
	return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_leftCollision:(CCNode *)goal powerCollision:(CCNode *)power {
    [power removeFromParentAndCleanup:YES];
	return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_leftCollision:(CCNode *)goal liveCollision:(CCNode *)live {
    [live removeFromParentAndCleanup:YES];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_leftCollision:(CCNode *)goal sloCollision:(CCNode *)slo {
    [slo removeFromParentAndCleanup:YES];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_leftCollision:(CCNode *)goal spaceCollision:(CCNode *)slo {
    [slo removeFromParentAndCleanup:YES];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair goal_leftCollision:(CCNode *)goal heavyCollision:(CCNode *)slo {
    [slo removeFromParentAndCleanup:YES];
    return YES;
}

// -----------------------------------------------------------------------
#pragma mark - Init methods
// -----------------------------------------------------------------------

- (void)initDynamicScreen {
	_dynamicScreen=[CCNode node];
	_dynamicScreen.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:CGRectMake(0, GROUND_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - GROUND_HEIGHT) cornerRadius:0.0f];
	_dynamicScreen.physicsBody.type = CCPhysicsBodyTypeStatic;
	_dynamicScreen.physicsBody.friction = 0;
	_dynamicScreen.physicsBody.elasticity = 0;
	[_physicsWorld addChild:_dynamicScreen];
}

- (void)initBackButton {
	_backButton = [CCButton buttonWithTitle:@"Pause" fontName:@"Verdana-Bold" fontSize:14.0f];
	_backButton.positionType = CCPositionTypeNormalized;
	_backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
	[_backButton setTarget:self selector:@selector(onBackClicked:)];
	[self addChild:_backButton];
}

- (void)initScoreLabel {
	_scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Verdana-Bold" fontSize:18.0f];
	_scoreLabel.positionType = CCPositionTypeNormalized;
	_scoreLabel.position = ccp(0.5f, 0.95f); // Top Right of screen
	[self addChild:_scoreLabel];
}

- (void)initMaxScoreLabel {
    _maxScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Best: %ld",(long)highScore] fontName:@"Verdana-Bold" fontSize:15.0f];
	NSLog(@"highscore: %ld",(long)highScore);
    _maxScoreLabel.positionType = CCPositionTypeNormalized;
    _maxScoreLabel.position = ccp(0.5f, 0.90f); // Top Right of screen
    [self addChild:_maxScoreLabel];
}

- (void)initWaveLabel {
    _waveLabel = [CCLabelTTF labelWithString:@"Freeze: 0" fontName:@"Verdana-Bold" fontSize:10.0f];
    _waveLabel.positionType = CCPositionTypeNormalized;
    _waveLabel.position = ccp(0.70f, 0.95f); // Top Right of screen
    [self addChild:_waveLabel];
}

- (void)initLivesLabel {
	_livesLabel = [CCLabelTTF labelWithString:@"Lives: 3" fontName:@"Verdana-Bold" fontSize:10.0f];
	_livesLabel.positionType = CCPositionTypeNormalized;
	_livesLabel.position = ccp(0.3f, 0.95f);
	[self addChild:_livesLabel];
}

- (void)initShotsLabel {
	_shotsLabel = [CCLabelTTF labelWithString:@"Shots: 10" fontName:@"Verdana-Bold" fontSize:10.0f];
	_shotsLabel.positionType = CCPositionTypeNormalized;
	_shotsLabel.position = ccp(0.15f, 0.95f);
	[self addChild:_shotsLabel];
}

- (void)initPlayer {
	_player = [CCSprite spriteWithImageNamed:@"run1.png"];
	[self resizeSprite:_player toWidth:0.1*SCREEN_WIDTH toHeight:0.15*SCREEN_HEIGHT];
	_player.position  = ccp(SCREEN_WIDTH/8,GROUND_HEIGHT+0.075*SCREEN_HEIGHT);
	_player.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _player.contentSize} cornerRadius:0];
	_player.physicsBody.type = CCPhysicsBodyTypeDynamic;
	_player.physicsBody.friction = 0;
	_player.physicsBody.elasticity=0.1f;
	_player.physicsBody.mass= 10;
	_player.physicsBody.collisionGroup=@"playerGroup";
	_player.physicsBody.collisionType=@"playerCollision";
	[_ground addChild:_player];
}

- (void)initLeftBounds {
	CCNode* _goalleft = [CCNode node];
	_goalleft.position = ccp(0, 0);
	_goalleft.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(-LEFT_BOUND_WIDTH, 0, LEFT_BOUND_WIDTH, SCREEN_HEIGHT) cornerRadius:0.0f];
	_goalleft.physicsBody.type = CCPhysicsBodyTypeStatic;
	_goalleft.physicsBody.collisionGroup=@"goal";
	_goalleft.physicsBody.collisionType=@"goal_leftCollision";
	_goalleft.physicsBody.sensor=YES;
	[_physicsWorld addChild:_goalleft];
}

- (void)initRightBounds {
	CCNode* _goalright = [CCNode node];
	_goalright.position = ccp(SCREEN_WIDTH,0);
	_goalright.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(SCREEN_WIDTH, 0, 100, SCREEN_HEIGHT) cornerRadius:0.0f];
	_goalright.physicsBody.type = CCPhysicsBodyTypeStatic;
	_goalright.physicsBody.collisionGroup=@"goal";
	_goalright.physicsBody.collisionType=@"goal_rightCollision";
	_goalright.physicsBody.sensor=YES;
	[_physicsWorld addChild:_goalright];
}

- (void)initGroundBounds {
    CCNode* _groundBounds = [CCNode node];
    _groundBounds.position = ccp(SCREEN_WIDTH,0);
    _groundBounds.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(-100, 0, SCREEN_WIDTH+100, GROUND_HEIGHT) cornerRadius:0.0f];
    _groundBounds.physicsBody.type = CCPhysicsBodyTypeStatic;
    _groundBounds.physicsBody.collisionType = @"groundCollision";
    _groundBounds.physicsBody.sensor=YES;
    [_physicsWorld addChild:_groundBounds];
}

- (void)initGround {
	_ground=[CCNode node];
//	_ground.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:CGRectMake(0, 0, SCREEN_WIDTH, GROUND_HEIGHT) cornerRadius:0.0f];
	_ground.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:CGRectMake(-100, GROUND_HEIGHT, SCREEN_WIDTH+100, SCREEN_HEIGHT) cornerRadius:0.0f];
	_ground.physicsBody.type = CCPhysicsBodyTypeStatic;
	_ground.physicsBody.friction = 0;
	_ground.physicsBody.elasticity = 0;
	[_physicsWorld addChild:_ground];
}

- (void)initPhysicsWorld {
	_physicsWorld = [CCPhysicsNode node];
	_physicsWorld.gravity = ccp(0,GRAVITY);
	_physicsWorld.debugDraw = NO;
	_physicsWorld.collisionDelegate = self;
	_physicsWorld.debugDraw = NO;
	[self addChild:_physicsWorld];
}

- (void)initRoof {
	CCNode *_roof = [CCNode node];
	_roof.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:CGRectMake(-50, 0.9*SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) cornerRadius:0.0f];
	_roof.color=[CCColor redColor];
	_roof.physicsBody.type = CCPhysicsBodyTypeStatic;
	_roof.physicsBody.friction = 0;
	_roof.physicsBody.collisionType=@"roofCollision";
	_roof.physicsBody.elasticity = 0;
	[_physicsWorld addChild:_roof];
}

- (void)initBackground {
    CGRect screenRect = CGRectMake(-100, 0, SCREEN_WIDTH+100, SCREEN_HEIGHT);
	_background1 = [CCSprite spriteWithImageNamed:BACKGROUND_IMAGE];
	_background2 = [CCSprite spriteWithImageNamed:BACKGROUND_IMAGE];
	[self setBackground:_background1 forScreen: screenRect startingAt:0];
	[self setBackground:_background2 forScreen: screenRect startingAt:self.contentSize.width];
}


-(void) setLevelSelected: (int) l {
    if (l==EASY){
        selectedLevel = EASY;
        timeToAddMonster = 3.f;
    }else if (l==MEDIUM){
        selectedLevel = MEDIUM;
        timeToAddMonster = 2.f;
    }else if (l==EXTREME){
        selectedLevel = EXTREME;
        timeToAddMonster = 1.f;
    }
}

- (void)initVariables {
	quantityJumps = 0;
	score = 0;
	quantityMonsters = 0;
	lives = 3;
	hasPower = YES;
	shotsLeft = 10;
    imgForPlayer = 1;
    animationPlayerStopped = NO;
    level = 0;
    probForLevel = 50.f;
    jumpForce = 180000.f;
    timePerStar = .1f;
    timePerMonster = 1;
   // onWave = NO;
    timeOutOfWave = 10;
    timeInWave = 10;
    firstTimeScheduler = YES;
    timePerBird = 4;
    inTouch = NO;
    touchTime = 0;
    inTimeLapse = NO;
    timeToGetForSpecial = 5.f;
    slowMotion = 0;
    firstTimeSpecial = YES;
    timeToAddMonster = 3.f;
    waitTimeMonster = 0.f;
    timeToThrowGoodPower = 7.f;
    timeToThrowBadPower = 10.f;
    waitTimeGoodPower = 0.f;
    waitTimeBadPower = 0.f;
    waitTimeHeavy = 0.f;
    waitTimeSpace = 0.f;
	currentTime = 0;
    highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    if (highScore == nil){
        highScore = 0;
    }
//    [self resetVariable];
    newBestScore=NO;
    isHeavy = NO;
    inSpace = NO;
	dayLight = YES;
}

-(void) resetVariable{
    highScore = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:highScore forKey:@"HighScore"];
}

- (void) startTimeLapse {
//	NSLog(@"start time lapse");
   // [self unschedule:@selector(upOpacity)];
    [[CCDirector sharedDirector] scheduler].timeScale = 0.25f;
     [[OALSimpleAudio sharedInstance] playEffect:@"slow_down.mp3"];
   // [self schedule:@selector(downOpacity) interval:(0.01f)];
}

-(void) endTimeLapse {
//	NSLog(@"end time lapse");
   // [self unschedule:@selector(downOpacity)];
    [[CCDirector sharedDirector] scheduler].timeScale = 1;
   // [self schedule:@selector(upOpacity) interval:(0.01f)];
}

-(void) upOpacity {
//	NSLog(@"opacity going up");
    if (_background1.opacity >= 1 && _background2.opacity >= 1){
		[self unschedule:@selector(upOpacity)];
        return;
    }
	if(dayLight) {
		_background1.opacity += 0.2f;
		_background2.opacity += 0.2f;
	}
}

-(void) downOpacity {
//	NSLog(@"opacity going down");
    if (_background1.opacity <= 0.25f && _background2.opacity <= 0.25f){
		[self unschedule:@selector(downOpacity)];
        return;
    }
    _background1.opacity -= 0.2f;
    _background2.opacity -= 0.2f;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void) resume{
    [[CCDirector sharedDirector] resume];
    [self addChild:_backButton];
    [_resumeButton removeFromParent];
    [_endButton removeFromParent];
}

-(void) endGame {
    NSLog(@"Exit presionado");
    [[CCDirector sharedDirector] resume];
    //NSLog(@"Game Over");
    [[OALSimpleAudio sharedInstance] stopBg];
    if(inTimeLapse){
        [self endTimeLapse];
    }
    [self gameOverWithScore:score andNewBest:newBestScore];
}

- (void)onBackClicked:(id)sender {
    if (![[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] pause];
        
        _resumeButton = [CCButton buttonWithTitle:@"Resume" fontName:@"Verdana-Bold" fontSize:30.0f];
        _resumeButton.positionType = CCPositionTypeNormalized;
        _resumeButton.position = ccp(0.5f, 0.6f);
        [_resumeButton setTarget:self selector:@selector(resume)];
        [self addChild:_resumeButton];
        
        _endButton = [CCButton buttonWithTitle:@"Exit" fontName:@"Verdana-Bold" fontSize:30.0f];
        _endButton.positionType = CCPositionTypeNormalized;
        _endButton.position = ccp(0.5f, 0.3f);
        [_endButton setTarget:self selector:@selector(endGame)];
        [self addChild:_endButton];
        
        
         [_backButton removeFromParent];
    
    }

//	[[OALSimpleAudio sharedInstance] stopBg];
//	[[CCDirector sharedDirector] replaceScene:[IntroScene scene]
//							   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}



- (void)gameOverWithScore: (int) sc andNewBest: (BOOL) new {
    [[NSUserDefaults standardUserDefaults] setInteger:highScore forKey:@"HighScore"];
    [self removeAllChildrenWithCleanup:YES];
    [[CCDirector sharedDirector] replaceScene:[GameOverScene sceneWithScore:sc andNewBest: new]
							   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter {
	[super onEnter];
	[self schedule:@selector(scrollBackground:) interval:0.005];
    [self schedule:@selector(animatePlayer) interval:0.03];
}

- (void)onExit {
	// always call super onExit last
	[super onExit];
}

- (void)dealloc {
	// clean up code goes here
}

- (void)toggleLight {
	dayLight = !dayLight;
	if(!inTimeLapse) {
		if(dayLight) {
			NSLog(@"dia");
			_background1.opacity = 1;
			_background2.opacity = 1;
		} else {
			NSLog(@"noche");
			_background1.opacity = 0.2;
			_background2.opacity = 0.2;
		}
	}
}

-(void) transitionOpacity {
    if (_background1.opacity == 1){
        [self schedule:@selector(opacityDown) interval:0.05f];
    }
    else{
        [self schedule:@selector(opacityUp) interval:0.05f];

    }
}

-(void) opacityDown{
    _background1.opacity -= 0.005f;
    _background2.opacity -= 0.005f;
    if (_background1.opacity < 0.4f){
        [self unschedule:@selector(opacityDown)];
    }
}

-(void) opacityUp{
    _background1.opacity += 0.005f;
    _background2.opacity += 0.005f;
    if (_background1.opacity > 1.f){
        [self unschedule:@selector(opacityUp)];
    }
}

- (void)update:(CCTime)delta{
	currentTime += 1;
	if( currentTime == 500) {
		[self transitionOpacity];
		currentTime = 0;
	}
    if (_player.position.y<=GROUND_HEIGHT + 0.08*SCREEN_HEIGHT && animationPlayerStopped){
        [self schedule:@selector(animatePlayer) interval:0.03];
        animationPlayerStopped = NO;
    }
    if (inTouch){
        touchTime++;
        //NSLog(@"Count Touch: %d",touchTime);
    }
    if (inTimeLapse){
		//NSLog(@"touchTime");
        if (touchTime % 5 == 0){
            slowMotion--;
            [self updateFreezeLabel];
        }
		if (slowMotion == 0 || !inTouch){
			[self endTimeLapse];
			inTimeLapse = NO;
		}
    }
    if (touchTime == UPDATES_TO_LAPSE && slowMotion > 0){
        //NSLog(@"LAPSE");
        [self startTimeLapse];
        inTimeLapse = YES;
    }
    waitTimeMonster+=delta;
	//if(timeToAddMonster >= 0.3){
		if (waitTimeMonster >= timeToAddMonster){
			waitTimeMonster=0;
            if ((selectedLevel == EASY && timeToAddMonster >1) || (selectedLevel ==MEDIUM && timeToAddMonster > 0.7f) || (selectedLevel == EXTREME && timeToAddMonster > 0.4f)){
                if (selectedLevel == EASY)
                    timeToAddMonster -= 0.02f;
                if (selectedLevel == MEDIUM)
                    timeToAddMonster -= 0.03f;
                if (selectedLevel == EXTREME)
                    timeToAddMonster -= 0.035f;
            }
			NSLog(@"Time to add monster: %f",timeToAddMonster);
			[self addMonster];
		}
	//}
    waitTimeGoodPower+=delta;
    waitTimeBadPower+=delta;
    if (waitTimeGoodPower >= timeToThrowGoodPower){
        waitTimeGoodPower=0;
        timeToThrowGoodPower += 0.02f;
        [self throwGoodPower];
    }
    if (waitTimeBadPower >= timeToThrowBadPower){
        waitTimeBadPower=0;
        timeToThrowBadPower += 0.015f;
        [self throwBadPower];
    }
    if (inSpace){
        waitTimeSpace+=delta;
        if (waitTimeSpace >= TIME_IN_SPACE){
            inSpace = NO;
            waitTimeSpace = 0.f;
            _physicsWorld.gravity = ccp(0,GRAVITY);
        }
    }
    if (isHeavy){
        waitTimeHeavy += delta;
        if (waitTimeHeavy >= TIME_HEAVY){
            isHeavy = NO;
            jumpForce = ORIGINAL_JUMP_FORCE;
            waitTimeHeavy = 0.f;
        }
    }

}

- (int)getLevel {
    return level;
}

- (void)liveDown {
	Background* redBackground = [[Background alloc] initWithImageNamed:@"red.png"];
	//NSLog(@"Live Down!");
	[self resizeSprite:redBackground toWidth:SCREEN_WIDTH*2 toHeight:SCREEN_HEIGHT*2];
	[self addChild:redBackground];
	[redBackground schedule:@selector(backgroundFadeAway) interval:0.05];
	[[OALSimpleAudio sharedInstance] playEffect:@"hurt.wav"];
}

- (void) monsterDown {
	Background* whiteBackground = [[Background alloc] initWithImageNamed:@"white.png"];
    //NSLog(@"Monster Down!");
    [self resizeSprite:whiteBackground toWidth:SCREEN_WIDTH*2 toHeight:SCREEN_HEIGHT*2];
    [self addChild:whiteBackground];
    [whiteBackground schedule:@selector(backgroundFadeAway) interval:0.05];
}

- (void)labelFadeAway {
    _levelLabel.opacity -= 0.05f;
    if (_levelLabel.opacity <= 0){
        [_levelLabel removeFromParentAndCleanup:YES];
    }
}

@end
