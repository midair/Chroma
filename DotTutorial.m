//
//  DotTutorial.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "DotTutorial.h"

@implementation DotTutorial

-(void) update:(CCTime)delta {
    if (!self.tutorialLayer.pauseGame) {
        
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (neutralizeColor == self.tutorialLayer.colorState && !self.tutorialLayer.pauseGame) {
        self.scale = self.scale / 2;
        rate += 0.5;
        if (self.scale < 1) {
            rate = 1.0;
            [self.tutorialLayer dotPopPuff:ccp(x,y)];
            [self randomizeValues];
        }
    }
}



@end
