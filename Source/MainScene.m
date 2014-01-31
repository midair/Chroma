//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "OALSimpleAudio.h"

@implementation MainScene


-(void)didLoadFromCCB {

    [[OALSimpleAudio sharedInstance] playBg:@"chromaMUSIC.mp3" volume:0.5 pan:0.0 loop:YES];
    
}

-(void) chroma {
    [[OALSimpleAudio sharedInstance] stopBg];
    [[OALSimpleAudio sharedInstance] playBg:@"chromaMUSIC.mp3" volume:0.5 pan:0.0 loop:YES];

}

-(void) credit {
    [[OALSimpleAudio sharedInstance] stopBg];
    [[OALSimpleAudio sharedInstance] playBg:@"credit.wav" volume:0.5 pan:0.0 loop:YES];

}

-(void) space {
    [[OALSimpleAudio sharedInstance] stopBg];
    [[OALSimpleAudio sharedInstance] playBg:@"spaceMUSIC.mp3" volume:0.5 pan:0.0 loop:YES];

}


-(void) play {
    CCScene *modeScene = [CCBReader loadAsScene:@"Mode"];
    [[CCDirector sharedDirector] replaceScene:modeScene];
}

-(void) tutorial {
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutorialScene];
}

@end
