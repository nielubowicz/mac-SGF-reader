//
//  goAppDelegate.m
//  NadohsSgfReader
//
//  Created by Rich on 8/16/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import "goAppDelegate.h"
#import "BoardView.h"
#import <AppKit/AppKit.h>
#import "MovePlayed.h"
#import "BoardMechanic.h"
#import "SGFParser.h"



@implementation goAppDelegate{
    
    BoardMechanic *captureMaker;

    SGFParser *goParser;
    
    NSWindow *splashWindow;
    
    NSArray *moves;
    
    int indexClick;
    NSImageView *board;
    NSImage *grid;
    NSMutableArray * _myPlayedMoves;
    
}


#pragma mark -

-(NSArray*)playedMoves{
    return [NSArray arrayWithArray:_myPlayedMoves];
}


-(void)removeFromPMLocation:(int)loc {
    
    for (MovePlayed *move in self.playedMoves){
        if   ([move boardLocation] == loc){
            [_myPlayedMoves removeObject:move];
        }
    }
    
}

-(void)removeStones:(NSSet*)toRemove{
    
    if (toRemove.count>0) {
        NSLog(@"stones to remove found");
    }
    
    for (MovePlayed*move in toRemove){

        NSImageView *viewItem = [[self.window contentView] viewWithTag:move.boardLocation];
        
        NSImage     *newImage =  [self scaleImage:[NSImage imageNamed:@"empty2.png"]
                                          toFrame: viewItem.frame];
    
        [viewItem setImage:newImage];
        [self removeFromPMLocation:move.boardLocation];
    }
    
}

-(void)checkCapture:(MovePlayed*)myMove{
    if (!captureMaker){
        captureMaker= [[BoardMechanic alloc]init];
    }
    
    [self removeStones:[captureMaker checkForCapture:myMove inside:self.playedMoves]];
}


-(void)showBoard{
    for (int i=1; i<moves.count;i++){
        NSImage *newImage;
        CGRect frame;
        int index =  [[[moves objectAtIndex:i] objectAtIndex:0] intValue];
        NSLog(@"%i IS INDEX",index  );
        frame = [[[self.window contentView] viewWithTag:index] frame];
        
        NSString *testColor = [(NSString*)[[moves objectAtIndex:i] objectAtIndex:1] uppercaseString];
        
        if ([testColor isEqualToString:@"B"]) {
            NSLog(@"black");
            newImage = [NSImage imageNamed:@"black.png"];
        }
        else{
            NSLog(@"white");
            newImage = [NSImage imageNamed:@"white.png"];
        }
        
        newImage = [self scaleImage:newImage toFrame:frame];
        [[[self.window contentView] viewWithTag:index] setImage:newImage];
    }
}


#pragma mark - arrow nav Button actions
-(void)startButtonClicked{

    while (indexClick>2) {
        [self leftButtonClicked];
    }
    
}

-(void)endButtonClicked{
    
}

-(MovePlayed*)changeMoveIndexed:(int)indexClicked leftDirection:(BOOL)backward{
    int i = indexClick;
    NSImage *newImage;
    CGRect frame;
    MovePlayed *myMovePlay = [[MovePlayed alloc]init];
    
    int index =  [[[moves objectAtIndex:i] objectAtIndex:0] intValue];
    NSLog(@"%i IS INDEX",index  );
    
    frame = [[[self.window contentView] viewWithTag:index] frame];
    
    NSString *testColor = [(NSString*)[[moves objectAtIndex:i] objectAtIndex:1] uppercaseString];
    
    if ([testColor isEqualToString:@"B"]) {
        NSLog(@"black");
        newImage = [NSImage imageNamed:@"black.png"];
        [myMovePlay setIsBlack:YES];
    }
    else{
        NSLog(@"white");
        newImage = [NSImage imageNamed:@"white.png"];
        [myMovePlay setIsBlack:NO];
    }
    
    if (backward) {
        newImage = [NSImage imageNamed:@"empty2.png"];
    }
    
    newImage = [self scaleImage:newImage toFrame:frame];
    [[[self.window contentView] viewWithTag:index] setImage:newImage];
    
    [myMovePlay setBoardLocation:index];
    return myMovePlay;
}

-(void)rightButtonClicked
{
    
    MovePlayed *myMovePlay = [self changeMoveIndexed:indexClick leftDirection:NO];
    
    //ADD TO MOVES PLAYED
    [_myPlayedMoves addObject:myMovePlay];
    
    if ((indexClick+1) <moves.count) {
        indexClick++;
    }
    
    [self checkCapture:myMovePlay];
    
    [self.currentCoordinateText setStringValue:NSStringFromPoint( myMovePlay.position)];
}


-(void)leftButtonClicked{
    
        if ((indexClick-1) >1) {
            indexClick--;
        }
    MovePlayed *myMovePlay = [self changeMoveIndexed:indexClick leftDirection:YES];
    
    //REMOVE FROM MOVES PLAYED
    int q =0;
    for (MovePlayed*movez in [self playedMoves]){
        if (movez.boardLocation == myMovePlay.boardLocation) {
            [_myPlayedMoves removeObjectAtIndex:q];
        }
        q++;
    }
}


#pragma mark - Resizing

-(void)fitBoardSize{
    CGPoint upLeft  = [self centerForView:[[self.window contentView] viewWithTag:1]];
    CGPoint dwRight = [self centerForView:[[self.window contentView] viewWithTag:361]];
    
    CGSize newSize = CGSizeMake(dwRight.x-upLeft.x, dwRight.y-upLeft.y);
    CGRect newFrame;
    newFrame.size = newSize;
    newFrame.origin = upLeft;
    [board setFrame:newFrame];
}


-(void)windowDidEndLiveResize:(NSNotification *)aNotification{
    NSLog(@"live resized");
}

- (void)windowDidExitFullScreen:(NSNotification *)notification{
    NSLog(@"exit fullscreen");
       // [self resizeGoban];
    
}
- (void)windowDidEnterFullScreen:(NSNotification *)notification{
    NSLog(@"fullscreen");
       // [self resizeGoban];
}

#pragma mark - Sizing
-(CGPoint)centerForView:(NSView*)myView{
    
     return CGPointMake((myView.frame.origin.x + (myView.frame.size.width / 2)),
                (myView.frame.origin.y + (myView.frame.size.height / 2)));
}

-(CGPoint)iSize //RETURNS CURRENT SCREEN DIMENSIONS
{
    CGRect screenBound =[self.window frame];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    CGPoint retPoint;
    retPoint.x = screenWidth;
    retPoint.y = screenHeight;
    return retPoint;
}


-(NSImage*)scaleImage:(NSImage*)img toFrame:(CGRect)frame{
    NSImage *scaledImage = [img copy];
    [scaledImage setScalesWhenResized:YES];
    [scaledImage setSize:NSMakeSize(frame.size.width,
                                    frame.size.height)];
    return scaledImage;
}



#pragma mark - setup
-(void)buildGoban{
    int index = 1;
    int dimensions = 19;
    int topBotMargins    = 120;
    int leftRightMargins = 160;
    float blockSize = [self iSize].x;
    if ([self iSize].y<[self iSize].x){
        blockSize= [self iSize].y;
    }
    float height = ([self iSize].y -topBotMargins)/dimensions;
    float width = ([self iSize].y -leftRightMargins)/dimensions;
    
    int x = leftRightMargins/2;
    int y =topBotMargins/2;
    
    //build background of board
    NSImageView *backdrop = [[NSImageView alloc]initWithFrame:board.frame];
    [backdrop setTag:1200];
    [backdrop setImage:[self scaleImage:[NSImage imageNamed:@"woodback.jpg"] toFrame:backdrop.frame]];
    [backdrop setAlphaValue:0.3];
    
    [[self.window contentView] addSubview: backdrop];
    
    
    for (int i =0; i<19; i++) {
        x = leftRightMargins/2;
        for (int j=0; j<19; j++) {
            NSImageView *stone = [[NSImageView alloc]initWithFrame:CGRectMake(x+(1.6*x/width),
                                                                              y+(1.85*y/height),
                                                                              width,
                                                                              height)];
            [stone setTag:index];
            NSLog(@"STONE TAG IS %li",(long)stone.tag);
            [stone setImage:[self scaleImage:[NSImage imageNamed:@"empty2.png"] toFrame:stone.frame]];
            
            [[self.window contentView] addSubview: stone];
            x+=width;
            index++;
        }
        y += height;
        
    }
    
    [self fitBoardSize];
    
    
    NSButton *leftButton = [[NSButton alloc]initWithFrame:CGRectMake([self iSize].x-120, [self iSize].y/2+10, 40, 20)];
    [leftButton setTitle:@" < "];
    [leftButton setTag:201];
    [[self.window contentView] addSubview: leftButton];
    [leftButton setTarget:self];
    [leftButton setAction:@selector(leftButtonClicked)];
    [leftButton setButtonType:NSMomentaryLightButton];
    [leftButton setBezelStyle:NSTexturedSquareBezelStyle];
    NSButton *rightButton = [[NSButton alloc]initWithFrame:CGRectMake([self iSize].x-80, [self iSize].y/2+10, 40, 20)];
    [rightButton setTitle:@" > "];
    [rightButton setTag:202];
    [[self.window contentView] addSubview: rightButton];
    [rightButton setTarget:self];
    [rightButton setAction:@selector(rightButtonClicked)];
    [rightButton setButtonType:NSMomentaryLightButton];
    [rightButton setBezelStyle:NSTexturedSquareBezelStyle];
    
    NSButton *startButton = [[NSButton alloc]initWithFrame:CGRectMake([self iSize].x-160, [self iSize].y/2+10, 40, 20)];
    [startButton setTitle:@" << "];
    [startButton setTag:201];
    [[self.window contentView] addSubview: startButton];
    [startButton setTarget:self];
    [startButton setAction:@selector(startButtonClicked)];
    [startButton setButtonType:NSMomentaryLightButton];
    [startButton setBezelStyle:NSTexturedSquareBezelStyle];
    NSButton *endButton = [[NSButton alloc]initWithFrame:CGRectMake([self iSize].x-40, [self iSize].y/2+10, 40, 20)];
    [endButton setTitle:@" >> "];
    [endButton setTag:202];
    [[self.window contentView] addSubview: endButton];
    [endButton setTarget:self];
    [endButton setAction:@selector(endButtonClicked)];
    [endButton setButtonType:NSMomentaryLightButton];
    [endButton setBezelStyle:NSTexturedSquareBezelStyle];
    
}


-(void)addDrawBoard{

    float topBotMargins = 120;
    float leftRightMargins = 160;
    float blockSize = [self iSize].x;
    if ([self iSize].y<[self iSize].x){
        blockSize= [self iSize].y;
    }
    float height = ([self iSize].y -topBotMargins);///dimensions;
    float width = ([self iSize].y -leftRightMargins);///dimensions;
    
    board = [[NSImageView alloc]init];
    CGRect frame =CGRectMake(leftRightMargins/2.0f+(16), topBotMargins*.5f+(17.0f), width, height  );
    
    [board setFrame:frame];
    grid = [NSImage imageNamed:@"19x19grid.png"];
    [board setImage:
     [self scaleImage: grid toFrame:frame]];
    [[self.window contentView] addSubview:board];

}


-(void)setupKeyInputBlocks{
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent*(NSEvent *event){
        NSLog(@"%hu",[event keyCode]);
        NSLog(@"%lu",(unsigned long)[event modifierFlags]);
        ///Shift+ leftarrow
        if  ([event keyCode]==123 && [event modifierFlags]==10617090){
            [self startButtonClicked];
        }
        //leftarrow
        else if  ([event keyCode]==123){
            [self leftButtonClicked];
        }
        ///Shift+ rightarrow
        else if  ([event keyCode]==124 && [event modifierFlags]==10617090){
            [self endButtonClicked];
        }
        //rightarrow
        else if  ([event keyCode]==124){
            [self rightButtonClicked];
        }
        
        return event;
    }];
}

-(void)startSGFParser{
     goParser = [[SGFParser alloc]init];
    [goParser sgfFileToString:@"test5.sgf"];
     moves = [goParser buildMovesList];
}


#pragma mark - It All Starts Here
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    indexClick=1;
    self.window.delegate=self;
    _myPlayedMoves = [[NSMutableArray alloc]init];
    [self addDrawBoard];
    [self buildGoban];
    [self startSGFParser];
    [self setupKeyInputBlocks];
    
    float qw = 100;
    int i=0;
    while (i<10) {
        qw =qw*1.05f;
        i++;
    }
    NSLog(@"from 100 to %f",qw);
    
    //[self showBoard];
}

@end
