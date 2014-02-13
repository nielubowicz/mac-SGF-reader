//
//  MovePlayed.m
//  NadohsSgfReader
//
//  Created by Rich on 8/21/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import "MovePlayed.h"

@implementation MovePlayed
@synthesize boardLocation=_boardLocation;
@synthesize position =_position;
@synthesize isBlack=_isBlack;

-(void)setBoardLocation:(int)boardLocation{
    _boardLocation = boardLocation;
    int y = (boardLocation/19);
    int x = boardLocation - (y*19) ;
    y++;
    _position =CGPointMake((float)x, (float)y);
}



@end
