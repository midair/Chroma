//
//  DotTutorial.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "DotTutorial.h"

@implementation DotTutorial {
    int oldColor;
}

-(void) didLoadFromCCB {
    oldColor = 4;
    rate = 1.0;
    self.userInteractionEnabled = TRUE;
    _dotNum = 0;
    [self randomizeValues];
    
}

-(void) update:(CCTime)delta {
    if (!self.tutorialLayer.pauseGame) {
        if (neutralizeColor == self.tutorialLayer.colorState){
            self.neutralizingColor = TRUE;
        }
        else {
            self.neutralizingColor = FALSE;
        }
        
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (neutralizeColor == self.tutorialLayer.colorState && !self.tutorialLayer.pauseGame) {
        self.scale = self.scale / 2;
        rate += 0.5;
        if (TRUE) {
            rate = 1.0;
            [self randomizeValues];
            [[OALSimpleAudio sharedInstance] playEffect:@"pop.wav"];
            _dotNum++;
//            CCLOG(@"%i",_dotNum);
        }
        
    }
}

-(void) randomizeValues {
    int radius = arc4random_uniform(100);
    int angle = arc4random_uniform(360);
    dotColor = arc4random_uniform(6);
//    NSLog(@"color state %i", dotColor);
    while (dotColor == oldColor) {
        dotColor = arc4random_uniform(6);
    }
    oldColor = dotColor;
    
    if (dotColor == RED) {
        neutralizeColor = GREEN;
        self.dotColorNum = 3;
        [[self animationManager] runAnimationsForSequenceNamed:@"Red"];
    }
    else if (dotColor == ORANGE) {
        neutralizeColor = BLUE;
        self.dotColorNum = 4;
        [[self animationManager] runAnimationsForSequenceNamed:@"Orange"];
    }
    else if (dotColor == YELLOW) {
        neutralizeColor = PURPLE;
        self.dotColorNum = 5;
        [[self animationManager] runAnimationsForSequenceNamed:@"Yellow"];
    }
    else if (dotColor == GREEN) {
        neutralizeColor = RED;
        self.dotColorNum = 0;
        [[self animationManager] runAnimationsForSequenceNamed:@"Green"];
    }
    else if (dotColor == BLUE) {
        neutralizeColor = ORANGE;
        self.dotColorNum = 1;
        [[self animationManager] runAnimationsForSequenceNamed:@"Blue"];
    }
    else if (dotColor == PURPLE) {
        neutralizeColor = YELLOW;
        self.dotColorNum = 2;
        [[self animationManager] runAnimationsForSequenceNamed:@"Purple"];
    }
  
    x = radius * cos(CC_DEGREES_TO_RADIANS(angle))-25;
    y = radius * sin(CC_DEGREES_TO_RADIANS(angle))-25;

    self.position = ccpAdd(ccp(x,y), ccp(162, 162));
    self.scale = 0.15;
  
}



@end
