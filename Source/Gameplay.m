//
//  Gameplay.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Dot.h"

@implementation Gameplay {
    CCNode *_background;
    CCNode *_palette;
    CCButton *_pauseButton;
    CCLabelTTF *_timeField;
    CCLabelTTF *_gameOver;
    BOOL colorPicking;
    BOOL gameOver;
    UITouch *colorPickTouch;
    float numSeconds;
    NSMutableArray *dotList;
    int deathTotal;
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {
    //tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self setMultipleTouchEnabled:TRUE];
    numSeconds = 0.0;
    Dot *dot = (Dot*)[CCBReader load:@"Dot"];
    dot.gameplayLayer = self;
    [_background addChild:dot];
    dotList = [NSMutableArray array];
    [dotList addObject:dot];
    self.pauseGame = FALSE;
    gameOver = FALSE;
}

-(void) update:(CCTime) delta
{
    if (!self.pauseGame) {
        numSeconds = numSeconds + delta;

        [_timeField setString:[NSString stringWithFormat:@"%.1f", numSeconds]];
        deathTotal = 0;
        int dotNum = [dotList count];
        if (numSeconds < 10) {
            _background.rotation += 3.60 * delta * numSeconds;
        }
        else if (numSeconds > 10) {
            _background.rotation += 36.0 * delta;
        }
        if ((numSeconds > 25) && (dotNum < 2)) {
            Dot *dot2 = (Dot*)[CCBReader load:@"Dot"];
            dot2.gameplayLayer = self;
            [_background addChild:dot2];
            dotNum++;
            [dotList addObject:dot2];
        }
        for (int i = 0; i < dotNum; i++) {
            Dot *dot = (Dot*) [dotList objectAtIndex:i];
            deathTotal += dot.deathLevel;
            if ((deathTotal/sqrtf(dotNum)) > 4) {
                gameOver = TRUE;
                self.pauseGame = TRUE;
                [_pauseButton setTitle:@"Retry"];
                [_gameOver setString:@"GAME OVER"];
                
            }
        }
    }
}

-(void) dotPopPuff:(CGPoint)positionPuff
{
    CCLOG(@"PUFF");
//    CCParticleSystem *pop = (CCParticleSystem*)[CCBReader load:@"DotPop"];
//    pop.position = positionPuff;
//    [_background addChild: pop z:10];
//    pop.autoRemoveOnFinish = YES;
}


-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint pointLocation = touch.locationInWorld;
    if (!colorPicking) {        
        CGPoint centered = ccpSub(pointLocation, ccp(59, 50));
        if (ccpLength(centered)<40){
            colorPicking = TRUE;
            colorPickTouch = touch;
            for (int i = 0; i < [dotList count]; i++) {
                Dot *dot = (Dot*) [dotList objectAtIndex:i];
                dot.userInteractionEnabled = FALSE;
                    
                
            }
        }
        
    }
    if (colorPicking) {
        
        
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        
        CGPoint centered = ccpSub(pointLocation, ccp(screenSize.width/2, screenSize.height/2));
        
        if (ccpLength(centered) < 160) {
            float Q =  fmod(CC_RADIANS_TO_DEGREES(atan2(centered.y, centered.x)) + _background.rotation +360, 360);
            if ((Q < 30) || (Q > 330)) {
                CCLOG(@"RED");
                self.colorState = RED;
                [_palette setColor:[CCColor redColor]];
                
            }
            else if (Q > 30 && Q < 90)
            {
                CCLOG(@"VIOLET");
                self.colorState = VIOLET;
                [_palette setColor:[CCColor purpleColor]];


            }
            else if (Q > 90 && Q < 150)
            {
                CCLOG(@"BLUE");
                self.colorState = BLUE;
                [_palette setColor:[CCColor blueColor]];

            }
            else if (Q > 150 && Q < 210)
            {
                CCLOG(@"GREEN");
                self.colorState = GREEN;
                [_palette setColor:[CCColor greenColor]];

            }
            else if (Q > 210 && Q < 270)
            {
                CCLOG(@"YELLOW");
                self.colorState = YELLOW;
                [_palette setColor:[CCColor yellowColor]];

            }
            else if (Q > 270 && Q < 330)
            {
                CCLOG(@"ORANGE");
                self.colorState = ORANGE;
                [_palette setColor:[CCColor orangeColor]];

            }
        }
    }
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (touch == colorPickTouch) {
        colorPicking = FALSE;
        colorPickTouch = nil;
    }
    
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (touch == colorPickTouch) {
        colorPicking = FALSE;
        colorPickTouch = nil;
        for (int i = 0; i < [dotList count]; i++) {
            Dot *dot = (Dot*) [dotList objectAtIndex:i];
            dot.userInteractionEnabled = TRUE;
            
        }
    
    }
}

-(void)pause
{
    //reload this level
    if (!self.pauseGame && !gameOver){
        [_gameOver setString:@"PAUSED"];
    }
    else if (gameOver && self.pauseGame) {
        self.pauseGame = FALSE;
        [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
    }
    else {
        [_gameOver setString:@" "];
    }
    self.pauseGame = !self.pauseGame;
}

@end
