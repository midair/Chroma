//
//  Gameplay.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Dot.h"
#import "OALSimpleAudio.h"
#include "claireLibrary.h"

#ifndef APPORTABLE
#import <Appsee/Appsee.h>
#endif

#import <HeyzapAds/HeyzapAds.h>


#define SCREEN_WIDTH [[CCDirector sharedDirector] viewSize].width
#define SCREEN_HEIGHT [[CCDirector sharedDirector] viewSize].height

const int PALETTE_RADIUS_IN_PIXELS = 160;
const float EASY_GAME_LENGTH = 90.0;

const float EASY_BACKGROUND_ROTATION_SPEED_1 = 1.80;
const float EASY_BACKGROUND_ROTATION_SPEED_2 = 18.0;
const float EASY_BACKGROUND_ROTATION_SPEED_3 = 27.0;

const float HARD_BACKGROUND_ROTATION_SPEED_1 = 3.60;
const float HARD_BACKGROUND_ROTATION_SPEED_2 = 36.0;
const float HARD_BACKGROUND_ROTATION_SPEED_3 = 56.0;
const float HARD_BACKGROUND_ROTATION_SPEED_4 = 72.0;



@implementation Gameplay {
  CCNode *_background;
  //    CCNode *_backgroundColor;
  CCNode *_palette;
  CCNode *_lifeBar;
  CCButton *_pauseButton;
  CCButton *_mainMenu;
  CCButton *_modeButton;
  CCLabelTTF *_timeField;
  CCLabelTTF *_gameOver;
  CCLabelTTF *_lastLabel;
  CCLabelTTF *_bestLabel;
  CCLabelTTF *_mode;
  BOOL gameOver;
  float numSeconds;
  NSMutableArray *dotList;
  float deathTotal;
  int numberOfDotsPopped;
  BOOL pulseGrow;
  BOOL best;
  BOOL checked;
  BOOL adShown;
  int hsEasy;
  int oldHSEasy;
  float hsHard;
  float bestTime; //time when the new best happened
  float oldHSHard;
  Dot *dot;
  Dot *dot2;
  Dot *dot3;
}

-(void)didLoadFromCCB {
  self.userInteractionEnabled = TRUE;
  [self setMultipleTouchEnabled:TRUE];
  [self unPauseGame];
  numSeconds = 0.0;
  oldHSHard = 0.0;
  dot = (Dot*)[CCBReader load:@"Dot"];
  dot.gameplayLayer = self;
  dot.dotCreationNumber = 1;
  [_background addChild:dot];
  dotList = [NSMutableArray array];
  [dotList addObject:dot];
  self.pauseGame = FALSE;
  pulseGrow = TRUE;
  gameOver = FALSE;
  [_lifeBar setColor:[CCColor greenColor]];
  self.colorState = 6;
  best = FALSE;
  checked = FALSE;
  NSNumber *currentHighScoreEasy = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreE"];
  hsEasy = [currentHighScoreEasy intValue];
  NSNumber *currentHighScoreHard = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreH"];
  hsHard = [currentHighScoreHard floatValue];
}

-(void) easyUpdate:(CCTime) delta {
  [_mode setString: [NSString stringWithFormat:@"%@\r%@", @"Time:",@"Dots:"]];
  
  numSeconds = numSeconds + delta;
  float timeLeft = EASY_GAME_LENGTH - numSeconds;
  
  numberOfDotsPopped = 0;
  int dotNum = [dotList count];
  if (numSeconds < 10) {
    _background.rotation += EASY_BACKGROUND_ROTATION_SPEED_1 * delta * numSeconds;
  }
  else if (numSeconds < 20){
    _background.rotation += EASY_BACKGROUND_ROTATION_SPEED_2 * delta;
  }
  else {
    _background.rotation += EASY_BACKGROUND_ROTATION_SPEED_3 * delta;
  }
  if ((numSeconds > 20) && (dotNum < 2)) {
    dot2 = (Dot*)[CCBReader load:@"Dot"];
    dot2.gameplayLayer = self;
    dot2.dotCreationNumber = 2;
    [_background addChild:dot2];
    dotNum++;
    [dotList addObject:dot2];
  }
  
  for (int i = 0; i < dotNum; i++) {
    dot = (Dot*) [dotList objectAtIndex:i];
    numberOfDotsPopped += dot.numberOfTimesPopped;
  }
  
  if (timeLeft > 0.0) {
    [_timeField setString: [NSString stringWithFormat:@"%@\r%@", [NSString stringWithFormat:@"%.1f", fabsf(timeLeft)],[NSString stringWithFormat:@"%i", numberOfDotsPopped]]];
    if (!best) {
      if (numberOfDotsPopped > hsEasy && hsEasy > 0 && !checked) {
        
        [_gameOver setString:@"NEW BEST"];
        bestTime = numSeconds + 0.4;
        checked = TRUE;
      }
      
      if (numSeconds > bestTime && checked) {
        [_gameOver setString:@""];
        best = TRUE;
      }
    }
  } else {
    [self endEasyGame];
  }
}

-(void) hardUpdate:(CCTime) delta {
  
  _lifeBar.opacity = 1.0;
  numSeconds = numSeconds + delta;
  
  [_timeField setString:[NSString stringWithFormat:@"%.1f", numSeconds]];
  deathTotal = 0.0;
  float dotNum = [dotList count];
  if (numSeconds < 10) {
    _background.rotation += HARD_BACKGROUND_ROTATION_SPEED_1 * delta * numSeconds;
  }
  else if (numSeconds < 15) {
    _background.rotation += HARD_BACKGROUND_ROTATION_SPEED_2 * delta;
  }
  else if (numSeconds < 20){
    _background.rotation += HARD_BACKGROUND_ROTATION_SPEED_3 * delta;
  }
  else if (numSeconds <40) {
    _background.rotation += HARD_BACKGROUND_ROTATION_SPEED_3 * delta;
    if (pulseGrow){
      _background.scale = _background.scale+0.007;
      if (_background.scale >= 1.21) {
        pulseGrow = FALSE;
      }
    }
    else if (!pulseGrow && _background.scale > 1.0){
      _background.scale = _background.scale-0.007;
    }
    else {
      if (_background.scale <= 1.0 && fmod(numSeconds, 25) > 10) {
        pulseGrow = TRUE;
      }
    }
  }
  else if (numSeconds < 55){
    _background.rotation -= HARD_BACKGROUND_ROTATION_SPEED_4 * delta;
    
  }
  else {
    _background.rotation -= HARD_BACKGROUND_ROTATION_SPEED_4 * delta;
    
    if (pulseGrow){
      _background.scale = _background.scale+0.007;
      if (_background.scale >= 1.21) {
        pulseGrow = FALSE;
      }
    }
    else if (!pulseGrow && _background.scale > 1.0){
      _background.scale = _background.scale-0.007;
    }
    else {
      if (_background.scale <= 1.0 && fmod(numSeconds, 25) > 10) {
        pulseGrow = TRUE;
      }
    }
  }
  if ((numSeconds > 25) && (dotNum < 2)) {
    dot2 = (Dot*)[CCBReader load:@"Dot"];
    dot2.dotCreationNumber = 2;
    dot2.gameplayLayer = self;
    [_background addChild:dot2];
    dotNum++;
    [dotList addObject:dot2];
  }
  if ((numSeconds > 65) && (dotNum < 3)) {
    dot3 = (Dot*)[CCBReader load:@"Dot"];
    dot3.gameplayLayer = self;
    dot3.dotCreationNumber = 3;
    [_background addChild:dot3];
    dotNum++;
    [dotList addObject:dot3];
  }
  
  
  if (!best) {
    
    if (numSeconds > hsHard && hsHard > 0.0 && !checked) {
      
      [_gameOver setString:@"NEW BEST"];
      bestTime = numSeconds + 0.4;
      checked = TRUE;
    }
    
    if (numSeconds > bestTime && checked) {
      
      [_gameOver setString:@""];
      best = TRUE;
      
    }
  }
  
  for (int i = 0; i < dotNum; i++) {
    Dot *doti = (Dot*) [dotList objectAtIndex:i];
    deathTotal += doti.deathLevel;
    if ((deathTotal/sqrtf(dotNum)) > 3){
      [_lifeBar setColor:[CCColor redColor]];
    }
    else if ((deathTotal/sqrtf(dotNum)) >1.5){
      [_lifeBar setColor:[CCColor yellowColor]];
    }
    else {
      [_lifeBar setColor:[CCColor greenColor]];
    }
    
    _lifeBar.scaleY = (5.0 * sqrtf(dotNum) - (deathTotal))/(2.0*sqrtf(dotNum));
    if ((deathTotal/sqrtf(dotNum)) > 4) {
      [self endHardGame];
    }
  }
  
}

-(void) endHardGame {
  [self showAdWithProbablility:80];
  _lifeBar.scaleY = 0.0;
  [_gameOver setString:@"GAME OVER"];
  [self endGame];
  
  NSNumber *currentHighScoreH = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreH"];
  float hsH = [currentHighScoreH floatValue];
  
  
  if (best) {
    [_lastLabel setString:[NSString stringWithFormat:@"OLD BEST: %.2f", oldHSHard]];
    [_bestLabel setString:[NSString stringWithFormat:@"NEW BEST: %.2f", hsH]];
    
  }
  else {
    [_lastLabel setString:[NSString stringWithFormat:@"LAST: %.2f", numSeconds]];
    [_bestLabel setString:[NSString stringWithFormat:@"BEST: %.2f", hsH]];
    
  }
  
  [_mode setString:@"Mode:    "];
  [_timeField setString:@"Chaos"];
  
}

-(void) endEasyGame {
  [self endGame];
  [self showAdWithProbablility:55];
  [_gameOver setString:@"TIME'S UP"];
  
  NSNumber *currentHighScoreE = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreE"];
  int hsE = [currentHighScoreE intValue];
  
  [_mode setString:@"Mode:  "];
  [_timeField setString:@"Calm"];
  
  if (best) {
    [_lastLabel setString:[NSString stringWithFormat:@"OLD BEST: %i", oldHSEasy]];
    [_bestLabel setString:[NSString stringWithFormat:@"NEW BEST: %i", hsE]];
    
  }
  else {
    [_lastLabel setString:[NSString stringWithFormat:@"LAST: %i", numberOfDotsPopped]];
    [_bestLabel setString:[NSString stringWithFormat:@"BEST: %i", hsE]];
  }
}

-(void) endGame {
  _mainMenu.visible = TRUE;
  _mainMenu.userInteractionEnabled = TRUE;
  _modeButton.visible = TRUE;
  _modeButton.userInteractionEnabled = TRUE;
  
  [self saveScore];
  
  gameOver = TRUE;
  self.pauseGame = TRUE;
  [_pauseButton setTitle:@"Retry"];

}

-(void) showAdWithProbablility:(int) percentage {
  adShown = FALSE;
  int randomNumber = arc4random_uniform(100);
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"OGUser"]){
    adShown = TRUE;
  }
  else if (randomNumber > percentage) {
    [self scheduleBlock:^(CCTimer *timer) {
      [HZInterstitialAd show];
      adShown = TRUE;
    } delay:2.0];
  } else {
    adShown = TRUE;
  }
}

-(void) update:(CCTime) delta {
  self.currentRotation = _background.rotation;
  if (!self.pauseGame) {
    if (_easy) {
      [self easyUpdate:delta];
    }
    else {
      [self hardUpdate:delta];
    }
  }
  _palette.rotation = -_background.rotation;
}


-(void) saveScore {
  if (_easy) {
    [self easyScoreSave];
  }
  else {
    [self hardScoreSave];
  }
}

-(void) easyScoreSave {
  NSDictionary *properties = @{@"easyScore": [NSNumber numberWithInt:numberOfDotsPopped]};
  
#ifndef APPORTABLE
  [Appsee addEvent:@"easyGameEnded" withProperties:properties];
#endif
  
  NSNumber *currentHighScoreE = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreE"];
  int hsE = [currentHighScoreE intValue];
  if (numberOfDotsPopped > hsE) {
    [_gameOver setString:@"NEW RECORD"];
    oldHSEasy = hsE;
    NSNumber *highScoreE = [NSNumber numberWithInt:numberOfDotsPopped];
    [[NSUserDefaults standardUserDefaults] setObject:highScoreE forKey:@"highScoreE"];
  }
}

-(void) hardScoreSave {
  NSDictionary *properties = @{@"hardScore": [NSNumber numberWithFloat:numSeconds]};
  
#ifndef APPORTABLE
  [Appsee addEvent:@"hardGameEnded" withProperties:properties];
#endif
  
  NSNumber *currentHighScoreH = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreH"];
  float hsH = [currentHighScoreH floatValue];
  if (numSeconds > hsH) {
    [_gameOver setString:@"NEW RECORD"];
    oldHSHard = hsH;
    NSNumber *highScoreH = [NSNumber numberWithFloat:numSeconds];
    [[NSUserDefaults standardUserDefaults] setObject:highScoreH forKey:@"highScoreH"];
  }
}

-(void) reorderDot:(Dot*) dotToChange {
  [dotToChange removeFromParent];
  [_background addChild:dotToChange];
  
}


-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)even
{
  CGPoint pointLocation = touch.locationInWorld;
  if (!self.pauseGame) {
    CGPoint centered = ccpSub(pointLocation, ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2));
    int radius = PALETTE_RADIUS_IN_PIXELS * _background.scale;
    if (ccpLength(centered) < radius) {
      float Q =  fmod(CC_RADIANS_TO_DEGREES(atan2(centered.y, centered.x)) + _background.rotation +360, 360);
      [self colorStateTouchOccured:Q];
      [[self animationManager] runAnimationsForSequenceNamed:ColorState_toString[self.colorState]];
      
    }
  }
}

-(void) colorStateTouchOccured:(float) Q {
  if ((Q < 30) || (Q > 330)) {
    self.colorState = RED;
  }
  else if (Q > 30 && Q < 90)
  {
    self.colorState = PURPLE;
  }
  else if (Q > 90 && Q < 150)
  {
    self.colorState = BLUE;
  }
  else if (Q > 150 && Q < 210)
  {
    self.colorState = GREEN;
  }
  else if (Q > 210 && Q < 270)
  {
    self.colorState = YELLOW;
  }
  else if (Q > 270 && Q < 330)
  {
    self.colorState = ORANGE;
  }
}


-(void) flipBest {
  best = !best;
}

-(void) mainMenu {
  [self saveScore];
  
  CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:mainScene];
}

-(void) switchModes {
  _easy =!_easy;
  [self restartGame];
}

-(void)pause {
  [self setModeSwitchButton];
  if (!self.pauseGame && !gameOver){
    [self setPauseScreen];
  }
  else if (gameOver && self.pauseGame) {
    [self restartGame];
  }
  else {
    [self unPauseGame];
  }
  self.pauseGame = !self.pauseGame;
}

-(void) restartGame {
  self.pauseGame = FALSE;
  Gameplay *gameplayNew = (Gameplay*) [CCBReader load:@"Gameplay"];
  gameplayNew.easy =_easy;
  CCScene *gameplayScene = [[CCScene alloc] init];
  [gameplayScene addChild:gameplayNew];
  if (!adShown){
    [HZInterstitialAd show];
  }
  [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void) setPauseScreen {
  [_gameOver setString:@"PAUSED"];
  [_pauseButton setTitle:@"Unpause"];
  _mainMenu.visible = TRUE;
  _mainMenu.userInteractionEnabled = TRUE;
  _modeButton.visible = TRUE;
  _modeButton.userInteractionEnabled = TRUE;
}

-(void) unPauseGame {
  [_gameOver setString:@" "];
  _mainMenu.visible = FALSE;
  [_pauseButton setTitle:@"Pause"];
  _mainMenu.userInteractionEnabled = FALSE;
  _modeButton.visible = FALSE;
  _modeButton.userInteractionEnabled = FALSE;
}

-(void) setModeSwitchButton {
  if (self.easy) {
    [_modeButton setTitle: @"Chaos Mode"];
  }
  else {
    [_modeButton setTitle: @"Calm Mode"];
  }
}

@end
