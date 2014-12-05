//
//  MechanicsAssistant.h
//  DragDrop
//
//  Created by Richard Fox on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "cocos2d.h"
//#import "SelfRemove.h"
//#import "BoardMechanics.h"
#import "MoveEvent.h"
//typedef stuff Search Direction

typedef NSInteger skipDirection;
enum {
    skipLeft,
    skipRight,
    skipUp,
    skipDown,
    skipNone
};


@protocol moveListDelegate <NSObject>

-(NSArray*)playedMoves;
@end


@interface BoardMechanic : NSObject {

}
@property (nonatomic, assign) id<moveListDelegate> delegate;
@property (nonatomic, getter=notCaptured, setter=set_notCaptured:) BOOL notCaptured;
@property (nonatomic, retain, readonly) BoardMechanic *assist;

-(NSSet*)checkForCapture:(MoveEvent *)firstStone inside:(NSArray*)movesPlayed;
-(void)set_notCaptured:(BOOL)booly;
-(BOOL)notCaptured;
//-(BOOL)isCaptured:(MovePlayed *)firstStone inside:(NSArray*)movesPlayed;
//-(BOOL)checkCaptured:(MovePlayed *)firstStone inside:(NSArray*)movesPlayed;
@end
