//
//  Tutorial.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"
#import "DotTutorial.h"

@implementation Tutorial {
    CCNode *_background;
    CCNode *_palette;
    CCNode *_lifeBar;
    CCButton *_pauseButton;
    CCLabelTTF *_gameOver;
    NSMutableArray *dotList;
    BOOL colorPicking;
    BOOL gameOver;
    UITouch *colorPickTouch;
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {
    //tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self setMultipleTouchEnabled:TRUE];
    DotTutorial *dot = (DotTutorial*)[CCBReader load:@"DotTutorial"];
    dot.tutorialLayer = self;
    [_background addChild:dot];
    dotList = [NSMutableArray array];
    [dotList addObject:dot];
    self.pauseGame = FALSE;
    gameOver = FALSE;
}

-(void) update:(CCTime) delta
{
    if (!self.pauseGame) {
       
                
            
        
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
                DotTutorial *dot = (DotTutorial*) [dotList objectAtIndex:i];
                dot.userInteractionEnabled = FALSE;
                
                
            }
        }
        
    }
    if (TRUE && !self.pauseGame) {
        
        
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
            DotTutorial *dot = (DotTutorial*) [dotList objectAtIndex:i];
            dot.userInteractionEnabled = TRUE;
            
        }
        
    }
}


-(void) mainMenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
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
