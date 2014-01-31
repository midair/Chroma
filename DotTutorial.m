//
//  DotTutorial.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "DotTutorial.h"

@implementation DotTutorial

-(void) didLoadFromCCB {
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
        if (_dotNum > 1) {
            self.scale = 3.8;
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
            [self.tutorialLayer dotPopPuff:ccp(x,y)];
            [self randomizeValues];
            _dotNum++;
            CCLOG(@"%i",_dotNum);
        }
        
    }
}

-(void) randomizeValues {
    int radius = arc4random_uniform(180);
    int angle = arc4random_uniform(360);
    dotColor = arc4random_uniform(6);
    if (dotColor == RED) {
        neutralizeColor = GREEN;
        [self setColor:[CCColor redColor]];
    }
    else if (dotColor == ORANGE) {
        neutralizeColor = BLUE;
        [self setColor:[CCColor orangeColor]];
    }
    else if (dotColor == YELLOW) {
        neutralizeColor = VIOLET;
        [self setColor:[CCColor yellowColor]];
    }
    else if (dotColor == GREEN) {
        neutralizeColor = RED;
        [self setColor:[CCColor greenColor]];
    }
    else if (dotColor == BLUE) {
        neutralizeColor = ORANGE;
        [self setColor:[CCColor blueColor]];
    }
    else if (dotColor == VIOLET) {
        neutralizeColor = YELLOW;
        [self setColor:[CCColor purpleColor]];
    }
    

    
    x = max(20, radius * cos(CC_DEGREES_TO_RADIANS(angle))-25);
    y = max(20, radius * sin(CC_DEGREES_TO_RADIANS(angle))-25);
    
    if (_dotNum == 0) {
        
        dotColor = BLUE;
        [self setColor:[CCColor blueColor]];
        neutralizeColor = ORANGE;
        
    }
    
    if (_dotNum == 1) {
        
        dotColor = YELLOW;
        [self setColor:[CCColor yellowColor]];
        neutralizeColor = VIOLET;

        x = 44;
        y = 65;
        _dotNum++;
    }
    
    self.position = ccpAdd(ccp(x,y), ccp(327, 327));
    self.scale = 1;
    
    
}



@end
