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


- (IBAction)openExistingDocument:(id)sender {

    
}

-(NSURL*)promptOpenFile{

    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"sgf", @"SGF",@"pdf", @"PDF", nil];
    _panel = [NSOpenPanel openPanel];
    [_panel setFloatingPanel:YES];
    [_panel setCanChooseDirectories:NO];
    [_panel setCanChooseFiles:YES];
    [_panel setAllowsMultipleSelection:YES];
  [_panel setAllowedFileTypes:fileTypes];
    [_panel setAllowsOtherFileTypes:YES];
   int i = (int)[_panel runModal];

    if(i == NSOKButton){
        for (NSURL *fileURL in [_panel URLs]) {
            if (fileURL){
                [_panel close];
                return fileURL;
                break;
            }
        }
    }
    
    return nil;
}




@end