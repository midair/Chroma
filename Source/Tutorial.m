//
//  Tutorial.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"
#import "DotTutorial.h"

#ifndef APPORTABLE
#import <Appsee/Appsee.h>
#endif

@implementation Tutorial {
    CCNode *_background;
    CCNode *_palette;
    CCNode *_lifeBar;
    CCSprite *_blue;
    CCSprite *_purple;
    CCSprite *_red;
    CCSprite *_orange;
    CCSprite *_yellow;
    CCSprite *_green;
    CCButton *_pauseButton;
    CCLabelTTF *_gameOver;
    CCLabelTTF *_dotNeut;
    CCLabelTTF *_dotPal;
    CCLabelTTF *_palateLabel;
    CCButton *_mainMenu;
    CCLabelTTF *_tutorialBlink;
    CCLabelTTF *_tutorialLabel;
    NSInteger blinkNum;
    NSMutableArray *dotList;
    BOOL colorPicking;
    BOOL gameOver;
    UITouch *colorPickTouch;
    float numSeconds;
    int numDots;
    BOOL playMode;
    float timeToCompleteTutorial;
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {
    //tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self setMultipleTouchEnabled:TRUE];
    timeToCompleteTutorial = 0.0;
    DotTutorial *dot = (DotTutorial*)[CCBReader load:@"DotTutorial"];
    dot.tutorialLayer = self;
    [_background addChild:dot];
    dotList = [NSMutableArray array];
    [dotList addObject:dot];
    self.pauseGame = FALSE;
    gameOver = FALSE;
    playMode = FALSE;
    numSeconds = 0.0;
    blinkNum = 0;
    self.colorState = 6;
    _blue.visible = FALSE;
    _purple.visible = FALSE;
    _red.visible = FALSE;
    _orange.visible = FALSE;
    _yellow.visible = FALSE;
    _green.visible = FALSE;

}

-(void) update:(CCTime) delta
{
    timeToCompleteTutorial+=delta;
    if (!self.pauseGame) {
        DotTutorial *dot = (DotTutorial*) [dotList objectAtIndex:0];
        numSeconds += delta;
        if (dot.neutralizingColor && dot.dotNum<3) {
            [_dotNeut setString:@"Tap the dot to neutralize it."];
            [_dotPal setString: @""];
        }
        else if (!dot.neutralizingColor && dot.dotNum<3) {
            [_dotNeut setString:@""];
            [_dotPal setString: @"Tap the dot’s opposite color."];
        }
        
        if (dot.dotNum > 2) {
            _red.visible = FALSE;
            _blue.visible = FALSE;
            _purple.visible = FALSE;
            _orange.visible = FALSE;
            _yellow.visible = FALSE;
            _green.visible = FALSE;
            [_tutorialBlink setString:@""];
            [_tutorialLabel setString:@""];
            [_gameOver setString:@"YOU GOT IT!"];
            [_dotNeut setString:@""];
            [_mainMenu setTitle:@"Play"];
            [_tutorialBlink setString:@""];
            [_mainMenu.label setFontSize:55.0];
            playMode = TRUE;
            dot.visible = FALSE;

        }
        if (dot.dotNum < 3) {
            if (dot.dotColorNum == 0 && blinkNum== 5) {
                _red.visible = !_red.visible;
                _blue.visible = FALSE;
                _purple.visible = FALSE;
                _orange.visible = FALSE;
                _yellow.visible = FALSE;
                _green.visible = FALSE;
            }
            else if (dot.dotColorNum==1&& blinkNum== 5) {
                _orange.visible = !_orange.visible;
                _blue.visible = FALSE;
                _purple.visible = FALSE;
                _red.visible = FALSE;
                _yellow.visible = FALSE;
                _green.visible = FALSE;
            }
            else if (dot.dotColorNum==2&& blinkNum== 5) {
                _yellow.visible = !_yellow.visible;
                _blue.visible = FALSE;
                _purple.visible = FALSE;
                _red.visible = FALSE;
                _orange.visible = FALSE;
                _green.visible = FALSE;
                
            }
            else if (dot.dotColorNum==3&& blinkNum== 5) {
                _green.visible = !_green.visible;
                _blue.visible = FALSE;
                _purple.visible = FALSE;
                _red.visible = FALSE;
                _orange.visible = FALSE;
                _yellow.visible = FALSE;
            }
            else if (dot.dotColorNum==4&& blinkNum== 5) {
                _blue.visible = !_blue.visible;
                _purple.visible = FALSE;
                _red.visible = FALSE;
                _orange.visible = FALSE;
                _yellow.visible = FALSE;
                _green.visible = FALSE;
            }
            else if (dot.dotColorNum==5&& blinkNum== 5) {
                _purple.visible = !_purple.visible;
                _blue.visible = FALSE;
                _red.visible = FALSE;
                _orange.visible = FALSE;
                _yellow.visible = FALSE;
                _green.visible = FALSE;
            }
            
            blinkNum++;
            if (blinkNum == 8) {
                blinkNum = 0;
            }
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
                self.colorState = RED;
                [[self animationManager] runAnimationsForSequenceNamed:@"Red"];
                
            }
            else if (Q > 30 && Q < 90)
            {
                self.colorState = VIOLET;
                [[self animationManager] runAnimationsForSequenceNamed:@"Purple"];
                
                
            }
            else if (Q > 90 && Q < 150)
            {
                self.colorState = BLUE;
                [[self animationManager] runAnimationsForSequenceNamed:@"Blue"];
                
            }
            else if (Q > 150 && Q < 210)
            {
                self.colorState = GREEN;
                [[self animationManager] runAnimationsForSequenceNamed:@"Green"];
                
            }
            else if (Q > 210 && Q < 270)
            {
                self.colorState = YELLOW;
                [[self animationManager] runAnimationsForSequenceNamed:@"Yellow"];
                
            }
            else if (Q > 270 && Q < 330)
            {

                self.colorState = ORANGE;
                [[self animationManager] runAnimationsForSequenceNamed:@"Orange"];
                
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
    if (playMode) {

        NSDictionary *properties = @{@"tutorialCompletionTime":[NSNumber numberWithFloat:timeToCompleteTutorial]};
#ifndef APPORTABLE
                [Appsee addEvent:@"tutorialEnded" withProperties:properties];

#endif
        CCScene *modeScene = [CCBReader loadAsScene:@"Mode"];
        [[CCDirector sharedDirector] replaceScene:modeScene];

    }
    else {
        NSDictionary *properties = @{@"tutorialQuitTime":[NSNumber numberWithFloat:timeToCompleteTutorial]};
#ifndef APPORTABLE
                [Appsee addEvent:@"tutorialQuit" withProperties:properties];

#endif
        CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
        [[CCDirector sharedDirector] replaceScene:mainScene];
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
