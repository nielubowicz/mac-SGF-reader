//
//  MechanicsAssistant.m
//  DragDrop
//
//  Created by Richard Fox on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoardMechanic.h"

//MAKE MovePlayed Objects into An Array



@implementation BoardMechanic{
//    NSMutableArray *_stonesToDel;
    BOOL emptySpot;
}
@synthesize notCaptured;
@synthesize assist;
@synthesize delegate;


-(NSArray*)noCapArray{
    return [NSArray arrayWithObject:@"noCaps"];
}


-(BOOL)isOnBoard:(CGPoint)checking{
        if ((checking.x > 19) || (checking.x < 1 ) ||
            (checking.y > 19) || (checking.y < 1)) {
            return NO;
        }
        else{
            return YES;
        }
}



-(CGPoint)getCheckingPoint:(skipDirection)blockSkip
                   ofStone:(MoveEvent*) lastStone{
    int checkingX;
    int checkingY;
    
    switch (blockSkip) {
        case skipUp:
            checkingX = lastStone.position.x + 0;
            checkingY = lastStone.position.y + 1;
            break;
        case skipDown:
            checkingX = lastStone.position.x + 0;
            checkingY = lastStone.position.y - 1;
            break;
        case skipLeft:
            checkingX = lastStone.position.x - 1;
            checkingY = lastStone.position.y + 0;
            break;
        case skipRight:
            checkingX = lastStone.position.x + 1;
            checkingY = lastStone.position.y + 0;
            break;
    }
    return CGPointMake(checkingX, checkingY);
}



-(NSArray*)checkStone:(MoveEvent *)lastStone
               inside:(NSArray*)movesPlayed
                 skip:(skipDirection)skipDirec
{
    NSMutableArray *_stonesToDel;
    _stonesToDel= [[NSMutableArray alloc]init];
    
    //check direction of stone on block to reduce repetition in code
    
///////////////////START processStone BLOCK//////////////////////

    BOOL (^processStone)(skipDirection blockSkip)= ^BOOL(skipDirection blockSkip){
        
        CGPoint checking = [self getCheckingPoint:blockSkip ofStone:lastStone];
        NSLog(@"checking value %@",NSStringFromPoint(checking));
        
        if (![self isOnBoard:checking]){
            return NO;
        }
        
        BOOL empty= YES;
        for(MoveEvent *stone in movesPlayed)
        {
            
            if (CGPointEqualToPoint(stone.position, checking)){
                empty = NO;
            }
            else{
                continue;
            }
            
            if (stone == lastStone) {
                [_stonesToDel addObject:stone];
            }
            else if(stone.isBlack == lastStone.isBlack){
                
                [_stonesToDel addObject:stone];
                
                NSArray *additionDel = [self checkStone:stone
                                                inside:movesPlayed
                                                  skip:blockSkip];
                NSLog(@"additionalDel info %@",additionDel);
                if ([additionDel[0]isKindOfClass:NSString.class]) {
                    return YES;
                }
                
                [_stonesToDel addObjectsFromArray:additionDel];
            }
            
            if(stone.isBlack!=lastStone.isBlack){
                empty = NO;
            }
            break;
        }
        if (empty) {
            emptySpot = YES;
            return YES;
        }
        else{
            return NO;
        }
    };
///////////////////END processStone BLOCK//////////////////////

    [_stonesToDel addObject:lastStone];
    if (skipDirec!=skipUp) {
        if (processStone(skipDown)) {
            return self.noCapArray;
        }
    }
    if (skipDirec!=skipDown) {
        if (processStone(skipUp)){
            return self.noCapArray;
        }
    }
    if (skipDirec!=skipLeft) {
        if (processStone(skipRight)){
            return self.noCapArray;
        }
    }
    if (skipDirec!=skipRight) {
        if (processStone(skipLeft)){
            return self.noCapArray;
        }
    }
    
    NSArray *retRay = [NSArray arrayWithArray:(NSArray*)_stonesToDel];
    
    return retRay;
}



-(NSSet*)checkForCapture:(MoveEvent *)firstStone inside:(NSArray*)movesPlayed
{
    
    NSMutableArray *_stonesToDel= [[NSMutableArray alloc]init];
    NSArray *retDelQueue;

    emptySpot = NO;
    NSLog(@"played move pos%@",NSStringFromPoint(firstStone.position));
    
    
    BOOL (^processStone)(skipDirection blockSkip)= ^BOOL(skipDirection blockSkip){
        
        
        
        return NO;
    };
    
    
    
    if (firstStone.boardLocation-19 > 0) {
        MoveEvent *testMove = [[MoveEvent alloc]init];
        [testMove setIsBlack:firstStone.isBlack];
        [testMove setBoardLocation:firstStone.boardLocation-19];
        BOOL found=NO;
        for(MoveEvent *stone in movesPlayed)
        {
            
            if (CGPointEqualToPoint(stone.position, testMove.position)){
                [testMove setIsBlack:stone.isBlack];
                found = YES;
            }
            
        }
        
        if (found) {
            NSLog(@"test move pos%@",NSStringFromPoint(testMove.position));
            retDelQueue = [self checkStone:testMove inside:movesPlayed skip:skipNone];
            if (!emptySpot) {
                [_stonesToDel addObjectsFromArray:retDelQueue];
            }
        }

    }
    
    emptySpot = NO;
    
    if (firstStone.boardLocation+19 < 361) {
        MoveEvent *testMove = [[MoveEvent alloc]init];
        [testMove setIsBlack:firstStone.isBlack];
        [testMove setBoardLocation:firstStone.boardLocation+19];
        BOOL found=NO;
        for(MoveEvent *stone in movesPlayed)
        {
            
            if (CGPointEqualToPoint(stone.position, testMove.position)){
                [testMove setIsBlack:stone.isBlack];
                found = YES;
            }
            
        }
        
        if (found) {
            NSLog(@"test move pos%@",NSStringFromPoint(testMove.position));
            retDelQueue = [self checkStone:testMove inside:movesPlayed skip:skipNone];
            
            if (!emptySpot) {
                [_stonesToDel addObjectsFromArray:retDelQueue];
            }
        }
    }
    
    emptySpot = NO;
    
    
    if (firstStone.boardLocation+1 < 361) {
        MoveEvent *testMove = [[MoveEvent alloc]init];
        [testMove setIsBlack:firstStone.isBlack];
        [testMove setBoardLocation:firstStone.boardLocation+1];
        BOOL found=NO;
        for(MoveEvent *stone in movesPlayed)
        {
            
            if (CGPointEqualToPoint(stone.position, testMove.position)){
                [testMove setIsBlack:stone.isBlack];
                found = YES;
            }
        }
        if (found) {
        NSLog(@"test move pos%@",NSStringFromPoint(testMove.position));
        retDelQueue = [self checkStone:testMove inside:movesPlayed skip:skipNone];
        if (!emptySpot) {
            [_stonesToDel addObjectsFromArray:retDelQueue];
        }
        }
    }
    
    emptySpot = NO;
    
    if (firstStone.boardLocation-1 > 0) {
        MoveEvent *testMove = [[MoveEvent alloc]init];
        [testMove setIsBlack:firstStone.isBlack];
        [testMove setBoardLocation:firstStone.boardLocation-1];
        BOOL found=NO;
        for(MoveEvent *stone in movesPlayed)
        {
            
            if (CGPointEqualToPoint(stone.position, testMove.position)){
                [testMove setIsBlack:stone.isBlack];
                found = YES;
            }
        }
        if (found) {
        NSLog(@"test move pos%@",NSStringFromPoint(testMove.position));
        retDelQueue = [self checkStone:testMove inside:movesPlayed skip:skipNone];
        if (!emptySpot) {
            [_stonesToDel addObjectsFromArray:retDelQueue];
        }
        }
    }
    
    NSSet* retSet = [NSSet setWithArray:_stonesToDel];
    return retSet;
}



- (id)init {
    
    if ((self = [super init]))
    {   
        notCaptured = FALSE;
	}
	
	return self;
}


@end
