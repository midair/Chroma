//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "OALSimpleAudio.h"

#ifdef __CC_PLATFORM_IOS

#import <Appsee/Appsee.h>

#endif
@implementation MainScene {
    CCButton *_onToggle;
    CCButton *_offToggle;
    BOOL musicOn;
}


-(void)didLoadFromCCB {
#ifdef __CC_PLATFORM_IOS
        [Appsee start:@"de3d1420e63f4ebb9659b9747fb3adb0"];

#endif
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"OGUser"]) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"OGUser"];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"musicOn"] isEqualToString:@"Off"] && ![OALSimpleAudio sharedInstance].bgPlaying) {
        [[OALSimpleAudio sharedInstance] playBg:@"credit.wav" volume:0.5 pan:0.0 loop:YES];
        musicOn = TRUE;
        

    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicOn"] isEqualToString:@"Off"]){
        musicOn = FALSE;
    }
    else {
        musicOn = TRUE;

    }
    _onToggle.visible = musicOn;
    _offToggle.visible = !musicOn;

    

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

-(void) credits {
    [[self animationManager] runAnimationsForSequenceNamed:@"Setting2Credit"];
}

-(void) backToSetting {
    [[self animationManager] runAnimationsForSequenceNamed:@"Credit2Setting"];
}

-(void) musicOn {
    
    
    _onToggle.visible = FALSE;
    _offToggle.visible = TRUE;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:@"musicOn"];
    [[OALSimpleAudio sharedInstance] stopBg];

    
}

-(void) musicOff {
    _onToggle.visible = TRUE;
    _offToggle.visible = FALSE;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:@"musicOn"];
    [[OALSimpleAudio sharedInstance] stopBg];
    [[OALSimpleAudio sharedInstance] playBg:@"credit.wav" volume:0.5 pan:0.0 loop:YES];

}

-(void) tutorial {
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutorialScene];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight);
}

@end
