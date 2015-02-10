//
//  Dot.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "OALSimpleAudio.h"
#import "Dot.h"

float const INITIAL_SCALE = 0.15f;
float const INITIAL_RATE = 0.15f;
float const DOT_POP_SCALE = 0.2f;
float const EASY_SCALE_RATE_DIVIDER = 4.4f;
float const HARD_SCALE_RATE_DIVIDER = 2.2f;
int const DEATH_LEVEL_MULTIPLIER = 7;

@implementation Dot {
  BOOL sameColorMode;
}

-(void) didLoadFromCCB {
  [[OALSimpleAudio sharedInstance] preloadEffect:@"pop.wav"];
  self.userInteractionEnabled = TRUE;
  _numberOfTimesPopped = 0;
  self.rotation = -self.gameplayLayer.currentRotation;
  sameColorMode = [[NSUserDefaults standardUserDefaults]  boolForKey:@"Easy Mode"];
  [self randomizeValues];
}

-(void) update:(CCTime)delta {
  if (!self.gameplayLayer.pauseGame) {
    self.rotation = -self.gameplayLayer.currentRotation; //Make it appear dot is not rotating
    if (self.gameplayLayer.easy) {
      [self easyScaleRate:delta];
    }
    else {
      [self hardScaleRate:delta];
    }
  }
}

-(void) easyScaleRate:(CCTime)delta {
  if (self.scale*DEATH_LEVEL_MULTIPLIER < 3.0) {
    self.scale = self.scale + rate*delta/EASY_SCALE_RATE_DIVIDER;
    _deathLevel = (self.scale*DEATH_LEVEL_MULTIPLIER);
  }
}

-(void) hardScaleRate:(CCTime)delta {
  if (self.scale*DEATH_LEVEL_MULTIPLIER < 7.0) {
    self.scale = self.scale + rate*delta/HARD_SCALE_RATE_DIVIDER;
    _deathLevel = (self.scale*DEATH_LEVEL_MULTIPLIER);
  }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if (neutralizeColor == self.gameplayLayer.colorState && !self.gameplayLayer.pauseGame) {
    self.scale = self.scale / 2;
    rate += 0.05;
    if (self.scale < DOT_POP_SCALE) {
      [self popDot];
    }
  }
}

-(void) popDot {
  rate = INITIAL_RATE;
  [[OALSimpleAudio sharedInstance] playEffect:@"pop.wav"];
  [self randomizeValues];
  _numberOfTimesPopped++;
}

-(void) randomizeValues {
  int radius = arc4random_uniform(110);
  int angle = arc4random_uniform(360);
  dotColor = arc4random_uniform(6);
  [self setDotColorAnimation];
  [self setNeutralizeColor];
  x = radius * cos(CC_DEGREES_TO_RADIANS(angle));
  y = radius * sin(CC_DEGREES_TO_RADIANS(angle));
  self.position = ccpAdd(ccp(x,y), ccp(163, 163));
  self.scale = INITIAL_SCALE;
  rate = INITIAL_RATE;
  [self.gameplayLayer reorderDot:self];
}

-(void) setDotColorAnimation {
  NSString *dotColorString = ColorState_toString[dotColor];
  [[self animationManager] runAnimationsForSequenceNamed:dotColorString];
}

-(void) setNeutralizeColor {
  if (sameColorMode) {
    neutralizeColor = dotColor;
  } else {
    neutralizeColor = (dotColor + 3) % 6;
  }
}

@end
