//
//  claireLibrary.m
//  Chroma
//
//  Created by Claire on 10/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#include "claireLibrary.h"

BOOL randTRUE(int percentage) {
  if (arc4random_uniform(100) > percentage){
    return TRUE;
  } else {
    return FALSE;
  }
}