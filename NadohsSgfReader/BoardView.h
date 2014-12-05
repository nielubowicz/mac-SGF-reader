//
//  BoardView.h
//  NadohsSgfReader
//
//  Created by Rich on 8/21/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SGFParser.h"


@protocol boardViewDelegate <NSObject>
-(void)rightButtonClicked;
-(void)startButtonClicked;
-(void)leftButtonClicked;
-(void)endButtonClicked;
@property (nonatomic, retain)SGFParser *goParser;
@end

@interface BoardView : NSView{

}

@property (nonatomic, assign) id<boardViewDelegate> parent;
@property (nonatomic, retain) NSOpenPanel* panel;

-(NSURL*)promptOpenFile;


@end
