//
//  MovePlayed.h
//  NadohsSgfReader
//
//  Created by Rich on 8/21/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveEvent : NSObject
@property (nonatomic, assign) BOOL isBlack;
@property (nonatomic, assign) int  boardLocation;
@property (nonatomic, assign) CGPoint position;

@property (nonatomic, strong) NSArray  *LBpoints;
@property (nonatomic, strong) NSString *comment;
-(void)setBoardLocation:(int)boardLocation;

@end
