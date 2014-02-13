//
//  goAppDelegate.h
//  NadohsSgfReader
//
//  Created by Rich on 8/16/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BoardView.h"

@interface goAppDelegate : NSResponder <NSApplicationDelegate,NSWindowDelegate,NSTextInput,keyboardButtonDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSMutableArray *checkList;
@property (nonatomic, assign) NSArray *playedMoves;
@property (weak) IBOutlet NSTextField *currentCoordinateText;


-(void)removeFromPMLocation:(int)loc ;


#pragma mark - keyPressActions
-(void)rightButtonClicked;
-(void)startButtonClicked;
-(void)leftButtonClicked;
-(void)endButtonClicked;

@end
