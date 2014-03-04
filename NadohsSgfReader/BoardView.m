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
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    // This method displays the panel and returns immediately.
    // The completion handler is called when the user selects an
    // item or cancels the panel.
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *theDoc = [[panel URLs] objectAtIndex:0];
            
            // Open  the document.
        }
        
    }];
}

-(NSURL*)promptOpenFile{
    [self openExistingDocument:Nil];
//    return ;
//    NSOpenPanel *panel;
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"sgf", @"SGF",@"pdf", @"PDF", nil];
    _panel = [NSOpenPanel openPanel];
    [_panel setFloatingPanel:YES];
    [_panel setCanChooseDirectories:NO];
    [_panel setCanChooseFiles:YES];
    [_panel setAllowsMultipleSelection:YES];
  [_panel setAllowedFileTypes:fileTypes];
    [_panel setAllowsOtherFileTypes:YES];
   int i = (int)[_panel runModal];
//    int i = [panel runModalForTypes:fileTypes];
    if(i == NSOKButton){
        for (NSURL *fileURL in [_panel URLs]) {
            if (fileURL){
                return fileURL;
                break;
//                _panel
//                [self.parent.goParser setSgfFilePath:fileURL];
//                return;
            }
        }
    }
    
//    return;
//    NSOpenPanel *panel = [NSOpenPanel openPanel];
//    
//    // Configure your panel the way you want it
//    [panel setCanChooseFiles:YES];
//    [panel setCanChooseDirectories:NO];
//    [panel setAllowsMultipleSelection:NO];
//    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"sgf",@"SGF",@".sgf",@".sgf file", nil];
//    [panel setAllowedFileTypes:fileTypes];
//    [panel beginWithCompletionHandler:^(NSInteger result){
//        if (result == NSFileHandlingPanelOKButton) {
//            
//            for (NSURL *fileURL in [panel URLs]) {
//                if (fileURL){                    
//                    [self.parent.goParser setSgfFilePath:fileURL];
//                    return;
//                }
//            }
//        }
//        
//    }];
}




@end