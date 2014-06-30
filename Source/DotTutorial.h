//
//  DotTutorial.h
//  ColorSpin
//
//  Created by Claire Treyz on 1/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Dot.h"
#import "Tutorial.h"

@interface DotTutorial : Dot

@property Tutorial* tutorialLayer;
@property int dotNum; //number of times dot has been tapped
@property int dotColorNum; //color of dot
@property BOOL neutralizingColor;

@end
