//
//  Gameplay.h
//  ColorSpin
//
//  Created by Claire Treyz on 1/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "ColorState.h"

@interface Gameplay : CCNode

@property ColorState colorState;
@property BOOL pauseGame;
@property BOOL easy;

-(void) dotPopPuff:(CGPoint)positionPuff;

@end
