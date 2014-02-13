//
//  MovePlayed.h
//  NadohsSgfReader
//
//  Created by Rich on 8/21/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovePlayed : NSObject
@property (nonatomic,assign)BOOL isBlack;
@property (nonatomic,assign)int boardLocation;
@property (nonatomic, assign)CGPoint position;

-(void)setBoardLocation:(int)boardLocation;

@end
