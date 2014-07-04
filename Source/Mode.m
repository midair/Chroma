//
//  Mode.m
//  ColorSpin
//
//  Created by Claire Treyz on 1/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Mode.h"
#import "Gameplay.h"

@implementation Mode


-(void) easy {
    Gameplay *gameplay = (Gameplay*) [CCBReader load:@"Gameplay"];
    gameplay.easy =TRUE;
    CCScene *gameplayScene = [[CCScene alloc] init];
    
    [gameplayScene addChild:gameplay];
    
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void) hard {
    Gameplay *gameplay = (Gameplay*) [CCBReader load:@"Gameplay"];
    gameplay.easy =FALSE;
    CCScene *gameplayScene = [[CCScene alloc] init];
    
    [gameplayScene addChild:gameplay];
    
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}


-(void) mainMenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}
@end
