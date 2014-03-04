   //
//  goAppDelegate.m
//  NadohsSgfReader
//
//  Created by Rich on 8/16/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import "goAppDelegate.h"
#import <AppKit/AppKit.h>


@implementation goAppDelegate


#pragma mark - setters/getters

-(NSArray*)playedMoves{
    return [NSArray arrayWithArray:_myPlayedMoves];
}


#pragma mark - adding/removing stones

-(void)addToFromPM:(MovePlayed*)move {
    int loc = move.boardLocation;
    BOOL exists = NO;
    for (MovePlayed *move in self.playedMoves){
        if   ([move boardLocation] == loc){
            [_myPlayedMoves addObject:move];
            exists=YES;
        }
    }
    if  (!exists){
        MovePlayed *newMove = [[MovePlayed alloc]init];
        [newMove setBoardLocation:loc];
        [newMove setIsBlack:move.isBlack];
        [_myPlayedMoves addObject:newMove];
        
    }

}

-(void)removeFromPMLocation:(int)loc {
    
    for (MovePlayed *move in self.playedMoves){
        if   ([move boardLocation] == loc){
            [_myPlayedMoves removeObject:move];
        }
    }
    
}

-(void)reviveStones{
    NSDictionary *revive = [NSDictionary dictionaryWithDictionary:_removalHistory];
    int totalRevSets = (int)revive.count;
    for (int i = totalRevSets; i>_indexClick; i--) {
        NSArray *didRemove = [revive  objectForKey:[[NSNumber numberWithInt:i] stringValue]];
        for (MovePlayed*move in didRemove){
            NSImageView *viewItem = [[self.window contentView] viewWithTag:move.boardLocation];
            NSImage     *newImage;
            if ([move isBlack]) {
                NSLog(@"black");
                newImage = [NSImage imageNamed:@"black.png"];
            }
            else{
                NSLog(@"white");
                newImage = [NSImage imageNamed:@"white.png"];
            }
            
            newImage =  [self scaleImage: newImage
                                 toFrame: viewItem.frame];
            
            [viewItem setImage:newImage];
            
            [self addToFromPM:move];
            [_removalHistory removeObjectForKey:[[NSNumber numberWithInt:i] stringValue]];
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
    if (!_captureMaker){
        _captureMaker= [[BoardMechanic alloc]init];
    }
    NSSet *toRemove = [_captureMaker checkForCapture:myMove inside:self.playedMoves];
    [self removeStones:toRemove];
    [_removalHistory setObject:toRemove forKey:[[NSNumber numberWithInt:_indexClick] stringValue]];
}


-(void)showBoard{
    for (int i=1; i<_moves.count;i++){
        NSImage *newImage;
        CGRect frame;
        int index =  [[[_moves objectAtIndex:i] objectAtIndex:0] intValue];
        NSLog(@"%i IS INDEX",index  );
        frame = [[[self.window contentView] viewWithTag:index] frame];
        
        NSString *testColor = [(NSString*)[[_moves objectAtIndex:i] objectAtIndex:1] uppercaseString];
        
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
    
    while (_indexClick>1) {
        [self leftButtonClicked];
    }
    
}

-(void)endButtonClicked{
    
}

-(MovePlayed*)changeMoveIndexed:(int)indexClicked leftDirection:(BOOL)backward{
    int i = _indexClick;
    NSImage *newImage;
    CGRect frame;
    MovePlayed *myMovePlay = [[MovePlayed alloc]init];
    
    int index =  [[[_moves objectAtIndex:i] objectAtIndex:0] intValue];
    NSLog(@"%i IS INDEX",index );
    
    frame = [[[self.window contentView] viewWithTag:index] frame];
    
    NSString *testColor = [(NSString*)[[_moves objectAtIndex:i] objectAtIndex:1] uppercaseString];
    
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
    [self reviveStones];
    return myMovePlay;
}

-(void)rightButtonClicked{
    
    if(_processingMove){
        return;
    }
    
    _processingMove = YES;
    
    MovePlayed *myMovePlay = [self changeMoveIndexed:_indexClick leftDirection:NO];
    
    //ADD TO MOVES PLAYED
    [_myPlayedMoves addObject:myMovePlay];
    
    if ((_indexClick+1) <_moves.count) {
        _indexClick++;
    }
    
    [self checkCapture:myMovePlay];
    
    [self.currentCoordinateText setStringValue:NSStringFromPoint( myMovePlay.position)];
    
    _processingMove = NO;
}


-(void)leftButtonClicked{
    
    if(_processingMove){
        return;
    }
    
    _processingMove = YES;
    
    if ((_indexClick-1) >0) {
        _indexClick--;
    }
    MovePlayed *myMovePlay = [self changeMoveIndexed:_indexClick leftDirection:YES];
    
    //REMOVE FROM MOVES PLAYED
    int q =0;
    for (MovePlayed*movez in [self playedMoves]){
        if (movez.boardLocation == myMovePlay.boardLocation) {
            [_myPlayedMoves removeObjectAtIndex:q];
        }
        q++;
    }
    
    _processingMove = NO;
}


#pragma mark - Resizing

-(void)fitBoardSize{
    CGPoint upLeft  = [self centerForView:[[self.window contentView] viewWithTag:1]];
    CGPoint dwRight = [self centerForView:[[self.window contentView] viewWithTag:361]];
    
    CGSize newSize = CGSizeMake(dwRight.x-upLeft.x, dwRight.y-upLeft.y);
    CGRect newFrame;
    newFrame.size = newSize;
    newFrame.origin = upLeft;
    [_board setFrame:newFrame];
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
    NSImageView *backdrop = [[NSImageView alloc]initWithFrame:_board.frame];
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
    
    _board = [[NSImageView alloc]init];
    CGRect frame =CGRectMake(leftRightMargins/2.0f+(16), topBotMargins*.5f+(17.0f), width, height  );
    
    [_board setFrame:frame];
     _grid = [NSImage imageNamed:@"19x19grid.png"];
    [_board setImage:
    [self scaleImage: _grid toFrame:frame]];
    [[self.window contentView] addSubview:_board];
    
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
     _goParser = [[SGFParser alloc]init];
    [_goParser sgfFileToString:@"test5.sgf"];
     _moves = [_goParser buildMovesList];
}


#pragma mark - It All Starts Here
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    _indexClick=1;
    self.window.delegate=self;
    _myPlayedMoves = [[NSMutableArray alloc]init];
    _removalHistory = [[NSMutableDictionary alloc]init];
    
    [self addDrawBoard];
    [self buildGoban];
    [self startSGFParser];
    [self setupKeyInputBlocks];
    
    _myBoardView = [[[NSApplication sharedApplication] mainWindow] contentView];
    
    [_myBoardView setParent:self];
    
    if(!_myBoardView){
        NSLog(@"boardview issue");
        //    [NSException raise:@"nil boardView" format:@""];
    }
}

- (IBAction)openSGFPressed:(id)sender {
    if  (!_myBoardView){
        _myBoardView = [[[NSApplication sharedApplication] mainWindow] contentView];
        [_myBoardView setParent:self];
    }
    if(!_myBoardView){
        NSLog(@"boardview issue");
        //    [NSException raise:@"nil boardView" format:@""];
    }
    NSURL *newsgf = [self.myBoardView promptOpenFile];
    if (newsgf) {
    [self startButtonClicked];
    }
//    [self.goParser setSgfFilePath:newsgf];
    [self.goParser sgfFromURL:newsgf];

    _indexClick=1;
    _moves = [_goParser buildMovesList];
}


@end
