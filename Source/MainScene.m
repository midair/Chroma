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
@implementation MainScene {
    CCButton *_onButton;
    CCButton *_offButton;
}


-(void)didLoadFromCCB {
    [Appsee start:@"de3d1420e63f4ebb9659b9747fb3adb0"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"OGUser"]) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"OGUser"];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"musicOn"] isEqualToString:@"Off"] && ![OALSimpleAudio sharedInstance].bgPlaying) {
        [[OALSimpleAudio sharedInstance] playBg:@"credit.wav" volume:0.5 pan:0.0 loop:YES];
        [_onButton setTitle:@"ON"];
        [_offButton setTitle:@"off"];
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicOn"] isEqualToString:@"Off"]){
        [_onButton setTitle:@"on"];
        [_offButton setTitle:@"OFF"];
    }
    else {
        [_onButton setTitle:@"ON"];
        [_offButton setTitle:@"off"];

    }

    

}


-(void) facebook {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://facebook.com/TheChromaGame"]];
}

-(void) twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/TheChromaGame"]];

}

-(void) play {
    [[self animationManager] runAnimationsForSequenceNamed:@"Exit"];
}

-(void) modeSelect {
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

-(void) settings {
    [[self animationManager] runAnimationsForSequenceNamed:@"Main2Setting"];
}

-(void) mainMenu {
    [[self animationManager] runAnimationsForSequenceNamed:@"Setting2Main"];

}

-(void) soundOn {
    [_onButton setTitle:@"ON"];
    [_offButton setTitle:@"off"];
    

    [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:@"musicOn"];
    [[OALSimpleAudio sharedInstance] stopBg];
    [[OALSimpleAudio sharedInstance] playBg:@"credit.wav" volume:0.5 pan:0.0 loop:YES];
    
}

-(void) soundOff {
    [_onButton setTitle:@"on"];
    [_offButton setTitle:@"OFF"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:@"musicOn"];
    [[OALSimpleAudio sharedInstance] stopBg];
}

-(void) tutorial {
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutorialScene];
}

@end
