//
//  SGFParser.h
//  NadohsSgfReader
//
//  Created by Rich on 2/12/14.
//  Copyright (c) 2014 NadohsInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGFParser : NSObject

@property (nonatomic, retain) NSURL *sgfFilePath;
@property (nonatomic, retain) NSString *masterSGFString;

-(void)sgfFileToString:(NSString*)sgfName;
-(void)sgfFromURL:(NSURL*)fullPath;
-(void)parseSgfFile;
-(NSArray*)buildMovesList;
@end
