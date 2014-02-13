//
//  BoardView.m
//  NadohsSgfReader
//
//  Created by Rich on 8/21/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

-(void)keyDown:(NSEvent *)event {
    NSLog(@"%hu",[event keyCode]);
    switch ([event keyCode])
    {
            
        case 0x02:
            // D key pressed
            break;
        case 0x03:
            // F key pressed
            break;
            // etc.
    }
}

@end