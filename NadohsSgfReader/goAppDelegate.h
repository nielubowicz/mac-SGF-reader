//
//  goAppDelegate.h
//  NadohsSgfReader
//
//  Created by Rich on 8/16/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BoardView.h"
#import "MoveEvent.h"
#import "BoardMechanic.h"
#import "SGFParser.h"


@interface goAppDelegate : NSResponder <NSApplicationDelegate,NSWindowDelegate,NSTextInput,boardViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *currentCoordinateText;

- (IBAction)openSGFPressed:(id)sender;

@property (nonatomic, retain) NSMutableArray *checkList;
@property (nonatomic, assign) NSArray *playedMoves;


-(void)removeFromPMLocation:(int)loc ;


@property (nonatomic, retain)BoardMechanic *captureMaker;
@property (nonatomic, retain)SGFParser *goParser;
@property (nonatomic, retain)BoardView *myBoardView;

@property (nonatomic, retain)NSWindow *splashWindow;
@property (nonatomic, retain)NSImageView *board;
@property (nonatomic, retain)NSImage *grid;



@property (nonatomic, assign)int indexClick;

@property (nonatomic, retain)NSArray *moves;
@property (nonatomic, retain)NSMutableArray *myPlayedMoves;
@property (nonatomic, retain)NSMutableDictionary *removalHistory;

@property (nonatomic, assign) BOOL processingMove;

@property (unsafe_unretained) IBOutlet NSTextView *commentsBox;
@property (weak) IBOutlet NSTextField *commentLabel;


#pragma mark - keyPressActions
-(void)rightButtonClicked;
-(void)startButtonClicked;
-(void)leftButtonClicked;
-(void)endButtonClicked;

#pragma mark - Category Classes
-(void)promptOpenFile;

@end
