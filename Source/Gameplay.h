//
//  Gameplay.h
//  ColorSpin
//
//  Created by Claire Treyz on 1/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "ColorState.h"
@class Dot;

@interface Gameplay : CCNode

@property ColorState colorState;
@property BOOL pauseGame;
@property BOOL easy;

-(void) saveScore;
-(void) reorderDot:(Dot*) dotToChange;


@end
