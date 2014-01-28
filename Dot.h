//
//  Dot.h
//  ColorSpin
//
//  Created by Claire Treyz on 1/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Gameplay.h"
#import "ColorState.h"


@interface Dot : CCSprite {
    int x;
    int y; //in degrees
    ColorState dotColor;
    ColorState neutralizeColor;
    float rate;
}


@property int deathLevel;
@property Gameplay* gameplayLayer;

-(void) randomizeValues;

@end
