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

@implementation Gameplay {
    CCNode *_background;
    CCNode *_palette;
    CCNode *_lifeBar;
    CCButton *_pauseButton;
    CCButton *_mainMenu;
    CCLabelTTF *_timeField;
    CCLabelTTF *_gameOver;
    CCLabelTTF *_lastLabel;
    CCLabelTTF *_bestLabel;
    CCLabelTTF *_mode;
    BOOL colorPicking;
    BOOL gameOver;
    UITouch *colorPickTouch;
    float numSeconds;
    NSMutableArray *dotList;
    int deathTotal;
    int killNumberTotal;
    BOOL pulseGrow;
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {


    //tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self setMultipleTouchEnabled:TRUE];
    [_mainMenu setTitle:@""];
    _mainMenu.userInteractionEnabled = FALSE;
    numSeconds = 0.0;
    Dot *dot = (Dot*)[CCBReader load:@"Dot"];
    dot.gameplayLayer = self;
    [_background addChild:dot];
    dotList = [NSMutableArray array];
    [dotList addObject:dot];
    self.pauseGame = FALSE;
    pulseGrow = TRUE;
    gameOver = FALSE;
    [_lifeBar setColor:[CCColor greenColor]];
    self.colorState = 6;

    
}

-(void) update:(CCTime) delta
{
    if (!self.pauseGame) {
        if (_easy) {
            [_mode setString: [NSString stringWithFormat:@"%@\r%@", @"Time:",@"Dots:"]];

            numSeconds = numSeconds + delta;
            float timeLeft = 60.0 - numSeconds;


            killNumberTotal = 0;
            int dotNum = [dotList count];
            if (numSeconds < 10) {
                _background.rotation += 1.80 * delta * numSeconds;
            }
            else if (numSeconds < 20){
                _background.rotation += 18.0 * delta;
            }
            else {
                _background.rotation += 27.0 * delta;
            }
            if ((numSeconds > 40) && (dotNum < 2)) {
                Dot *dot2 = (Dot*)[CCBReader load:@"Dot"];
                dot2.gameplayLayer = self;
                [_background addChild:dot2];
                dotNum++;
                [dotList addObject:dot2];
            }
            
            for (int i = 0; i < dotNum; i++) {
                Dot *dot = (Dot*) [dotList objectAtIndex:i];
                killNumberTotal += dot.killNumber;
                

            
                
                
//                _lifeBar.scaleY = (5.0 * sqrtf(dotNum) - (deathTotal))/(5.0*sqrtf(dotNum));
                if (timeLeft <= 0.0) {
                    gameOver = TRUE;
                    self.pauseGame = TRUE;
                    [_pauseButton setTitle:@"Retry"];
                    [_gameOver setString:@"TIME'S UP"];
                    [_mainMenu setTitle:@"Main Menu"];
                    _mainMenu.userInteractionEnabled = TRUE;
                    [self saveScore];
                    
                    [_lastLabel setString:[NSString stringWithFormat:@"LAST: %i", killNumberTotal]];
                    
                    NSNumber *currentHighScoreE = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreE"];
                    int hsE = [currentHighScoreE intValue];
                    
                    [_bestLabel setString:[NSString stringWithFormat:@"BEST: %i", hsE]];
                    [_mode setString:@"Mode:"];
                    [_timeField setString:@"Calm"];
                }
            }
            if (timeLeft > 0.0) {
                [_timeField setString: [NSString stringWithFormat:@"%@\r%@", [NSString stringWithFormat:@"%.1f", fabsf(timeLeft)],[NSString stringWithFormat:@"%i", killNumberTotal]]];
            }
        }
        
        else {
            _lifeBar.opacity = 1.0;
            numSeconds = numSeconds + delta;
            
            [_timeField setString:[NSString stringWithFormat:@"%.1f", numSeconds]];
            deathTotal = 0;
            int dotNum = [dotList count];
            if (numSeconds < 10) {
                _background.rotation += 3.60 * delta * numSeconds;
            }
            else if (numSeconds < 15) {
                _background.rotation += 36.0 * delta;
            }
            else if (numSeconds < 20){
                _background.rotation += 56.0 * delta;
            }
            else if (numSeconds <40) {
                _background.rotation += 56.0 * delta;
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
                _background.rotation -= 72.0 * delta;
                
            }
            else {
                _background.rotation -= 72.0 * delta;

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
                Dot *dot2 = (Dot*)[CCBReader load:@"Dot"];
                dot2.gameplayLayer = self;
                [_background addChild:dot2];
                dotNum++;
                [dotList addObject:dot2];
            }
            if ((numSeconds > 65) && (dotNum < 3)) {
                Dot *dot3 = (Dot*)[CCBReader load:@"Dot"];
                dot3.gameplayLayer = self;
                [_background addChild:dot3];
                dotNum++;
                [dotList addObject:dot3];
            }
            for (int i = 0; i < dotNum; i++) {
                Dot *dot = (Dot*) [dotList objectAtIndex:i];
                deathTotal += dot.deathLevel;
                if ((deathTotal/sqrtf(dotNum)) > 3){
                    [_lifeBar setColor:[CCColor redColor]];
                }
                else if ((deathTotal/sqrtf(dotNum)) >1){
                    [_lifeBar setColor:[CCColor yellowColor]];
                }
                else {
                    [_lifeBar setColor:[CCColor greenColor]];
                }
                
                
                
                _lifeBar.scaleY = (5.0 * sqrtf(dotNum) - (deathTotal))/(5.0*sqrtf(dotNum));
                if ((deathTotal/sqrtf(dotNum)) > 4) {
                    _lifeBar.scaleY = 0.0;
                    gameOver = TRUE;
                    self.pauseGame = TRUE;
                    [_pauseButton setTitle:@"Retry"];
                    [_gameOver setString:@"GAME OVER"];
                    [self saveScore];
                    
                    [_lastLabel setString:[NSString stringWithFormat:@"LAST: %.2f", numSeconds]];
                    
                    NSNumber *currentHighScoreH = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreH"];
                    float hsH = [currentHighScoreH floatValue];

                    [_bestLabel setString:[NSString stringWithFormat:@"BEST: %.2f", hsH]];
                    
                    [_mode setString:@"Mode:"];
                    [_timeField setString:@"Chaos"];

                    [_mainMenu setTitle:@"Main Menu"];
                    _mainMenu.userInteractionEnabled = TRUE;
                    
                }
            }
        }
        
    }
}

-(void) saveScore {
    if (_easy) {
        NSNumber *currentHighScoreE = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreE"];
        int hsE = [currentHighScoreE intValue];
        if (killNumberTotal > hsE) {
            NSNumber *highScoreE = [NSNumber numberWithInt:killNumberTotal];
            [[NSUserDefaults standardUserDefaults] setObject:highScoreE forKey:@"highScoreE"];
        }
    }
    else {
        NSNumber *currentHighScoreH = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScoreH"];
        float hsH = [currentHighScoreH floatValue];
        if (numSeconds > hsH) {
            NSNumber *highScoreH = [NSNumber numberWithFloat:numSeconds];
            [[NSUserDefaults standardUserDefaults] setObject:highScoreH forKey:@"highScoreH"];
        }
    }
    
    


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
    if (TRUE && !self.pauseGame) {
        
        
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        
        CGPoint centered = ccpSub(pointLocation, ccp(screenSize.width/2, screenSize.height/2));
        int radius = 160 * _background.scale;
        if (ccpLength(centered) < radius) {
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

-(void) mainMenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

-(void)pause
{
    //reload this level
    if (!self.pauseGame && !gameOver){
        [_gameOver setString:@"PAUSED"];
        [_mainMenu setTitle:@"Main Menu"];
        _mainMenu.userInteractionEnabled = TRUE;
        
    }
    else if (gameOver && self.pauseGame) {
        self.pauseGame = FALSE;
        [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
    }
    else {
        [_gameOver setString:@" "];
        [_mainMenu setTitle:@""];
        _mainMenu.userInteractionEnabled = FALSE;
    }
    self.pauseGame = !self.pauseGame;
}

@end
