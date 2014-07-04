//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "OALSimpleAudio.h"
#import <Appsee/Appsee.h>
@implementation MainScene


-(void)didLoadFromCCB {
    [Appsee start:@"de3d1420e63f4ebb9659b9747fb3adb0"];
    [[OALSimpleAudio sharedInstance] playBg:@"chromaMUSIC.mp3" volume:0.5 pan:0.0 loop:YES];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"OGUser"]) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"OGUser"];
    }
    
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

-(void) soundOn {
    [[OALSimpleAudio sharedInstance] playBg:@"chromaMUSIC.mp3" volume:0.5 pan:0.0 loop:YES];
}

-(void) soundOff {
    [[OALSimpleAudio sharedInstance] stopBg];
}

-(void) facebook {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://facebook.com/TheChromaGame"]];
}

-(void) twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/TheChromaGame"]];

}

-(void) play {

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"True" forKey:@"tutorial"];
        CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial"];
        [[CCDirector sharedDirector] replaceScene:tutorialScene];
    }
    else {
        CCScene *modeScene = [CCBReader loadAsScene:@"Mode"];
        [[CCDirector sharedDirector] replaceScene:modeScene];
    }
}

-(void) tutorial {
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutorialScene];
}

@end
