//
//  Mode.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/29/14.
//  Copyright (c) 2014 Claire Treyz. All rights reserved.
//

#import "Mode.h"
#import "Gameplay.h"

typedef enum {
    Easy,
    Hard,
    MainMenu
}NextScene;

@implementation Mode {
    NextScene sceneType;
}

-(void) exitMode {
    if (sceneType == Easy) {
        Gameplay *gameplay = (Gameplay*) [CCBReader load:@"Gameplay"];
        gameplay.easy =TRUE;
        CCScene *gameplayScene = [[CCScene alloc] init];
        
        [gameplayScene addChild:gameplay];
        
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }
    else if (sceneType == Hard) {
        Gameplay *gameplay = (Gameplay*) [CCBReader load:@"Gameplay"];
        gameplay.easy =FALSE;
        CCScene *gameplayScene = [[CCScene alloc] init];
        
        [gameplayScene addChild:gameplay];
        
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }
    else if (sceneType == MainMenu) {
        [[self animationManager] runAnimationsForSequenceNamed:@"Exit"];
        CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
        [[CCDirector sharedDirector] replaceScene:mainScene];
    }
}

-(void) easy {
    sceneType = Easy;
    [[self animationManager] runAnimationsForSequenceNamed:@"Exit"];
}

-(void) hard {
    sceneType = Hard;
    [[self animationManager] runAnimationsForSequenceNamed:@"Exit"];
}


-(void) mainMenu {
    sceneType = MainMenu;
    [[self animationManager] runAnimationsForSequenceNamed:@"Exit"];
}

@end
