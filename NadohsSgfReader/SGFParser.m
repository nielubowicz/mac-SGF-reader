//
//  SGFParser.m
//  NadohsSgfReader
//
//  Created by Rich on 2/12/14.
//  Copyright (c) 2014 NadohsInc. All rights reserved.
//

#import "SGFParser.h"
#import "MoveEvent.h"

@implementation SGFParser{
        NSMutableArray *lines;
        NSArray *aplhaConvert;
}

#pragma mark - alphaConvert
-(void)buildAlphaConvert{
    NSMutableArray *alphabetArray = [[NSMutableArray alloc] init];
    [alphabetArray insertObject:@"0" atIndex:0];
    [alphabetArray insertObject:@"A" atIndex:1];
    [alphabetArray insertObject:@"B" atIndex:2];
    [alphabetArray insertObject:@"C" atIndex:3];
    [alphabetArray insertObject:@"D" atIndex:4];
    [alphabetArray insertObject:@"E" atIndex:5];
    [alphabetArray insertObject:@"F" atIndex:6];
    [alphabetArray insertObject:@"G" atIndex:7];
    [alphabetArray insertObject:@"H" atIndex:8];
    [alphabetArray insertObject:@"I" atIndex:9];
    [alphabetArray insertObject:@"J" atIndex:10];
    [alphabetArray insertObject:@"K" atIndex:11];
    [alphabetArray insertObject:@"L" atIndex:12];
    [alphabetArray insertObject:@"M" atIndex:13];
    [alphabetArray insertObject:@"N" atIndex:14];
    [alphabetArray insertObject:@"O" atIndex:15];
    [alphabetArray insertObject:@"P" atIndex:16];
    [alphabetArray insertObject:@"Q" atIndex:17];
    [alphabetArray insertObject:@"R" atIndex:18];
    [alphabetArray insertObject:@"S" atIndex:19];
    [alphabetArray insertObject:@"T" atIndex:20];
    [alphabetArray insertObject:@"U" atIndex:21];
    [alphabetArray insertObject:@"V" atIndex:22];
    [alphabetArray insertObject:@"W" atIndex:23];
    [alphabetArray insertObject:@"X" atIndex:24];
    [alphabetArray insertObject:@"Y" atIndex:25];
    [alphabetArray insertObject:@"Z" atIndex:26];
    aplhaConvert = (NSArray*)alphabetArray;
}


-(int)alphaToNum:(NSString*)let{
    //  int retInt=0;
    for (int i =0;i<aplhaConvert.count;i++){
        // NSLog(@"%@ \n%@", [aplhaConvert objectAtIndex:i],let);
        if ([[aplhaConvert objectAtIndex:i]isEqualTo:let]) {
            return i-1;
            break;
        }
    }
    return 0;
}





-(void)parseSgfFile{
    
    NSScanner* scanner = [NSScanner scannerWithString:self.masterSGFString];
    
    lines = [[NSMutableArray alloc] init];
    [scanner scanUpToString:@"(;" intoString:nil];
    
    NSString * text = nil;
    [scanner scanUpToString:@";" intoString:&text];
    
    if (text) {
        [lines addObject:text];
    }
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@";" intoString:nil];
        [scanner     scanString:@";" intoString:nil];
        NSString *text = nil;
        [scanner scanUpToString:@";" intoString:&text];
        if (text) {
            [lines addObject:text];
        }
    }
    
      NSLog(@"%@ \n\n\ncount %li",lines,(unsigned long)lines.count);
}


//test5.sgf

-(void)sgfFromURL:(NSURL*)fullPath{
    NSError *error;
    
    self.masterSGFString=[NSString stringWithContentsOfFile:[fullPath path]
                                                   encoding:NSASCIIStringEncoding
                                                      error:&error];
//    self.masterSGFString = [self.masterSGFString substringFromIndex:8];
    if (error) {
        NSLog(@"INPUT ERROR %@ \n ERROR : %@ \n PATH : %@", error.domain, error,[fullPath absoluteString]);
    }
    
    NSLog(@"%@",self.masterSGFString);
    [self parseSgfFile];
}


-(void)sgfFileToString:(NSString*)sgfName{

    NSArray *docDirs = NSSearchPathForDirectoriesInDomains(
                                                           NSDocumentDirectory,
                                                           NSUserDomainMask, YES);
    NSString *doc = [docDirs objectAtIndex:0];
    
    doc = [doc stringByAppendingPathComponent:@"sgf_files"];
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", doc,sgfName];
}//C[White continues with 'a' or 'b'.]



-(NSString*)findPattern:(NSString*)pattern FromString:(NSString*)inputString{
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern : pattern
                                  options : NSRegularExpressionCaseInsensitive
                                  error : nil];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString : inputString
                                                                 options : 0
                                                                   range : NSMakeRange(0, inputString.length)];
    
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match    = [inputString substringWithRange:matchRange];
    
    NSLog(@"Found string '%@'", match);
    
    if (match.length<1) {
        return nil;
    }
    
    return match;
}



#pragma mark - Moves From String

-(NSArray*)buildMovesList{
    
    NSMutableArray *moveOuts =[[NSMutableArray alloc]init];
    NSArray *linez = [NSArray arrayWithArray:lines];
    
    for (NSString* moveIn in linez){
        
        MoveEvent *aMove   = [[MoveEvent alloc]init];
        NSString *moveInUp = [moveIn uppercaseString];
        
        int num1;
        int num2;
        
        NSString*bStone = [self findPattern:@"^B\\[(.*?)\\]" FromString:moveInUp];
        
        if (bStone && bStone.length >=2) {
             num1= (int)[aplhaConvert indexOfObject:[bStone substringWithRange:NSMakeRange(0, 1)]];
             num2= (int)[self alphaToNum:[bStone substringWithRange:NSMakeRange(1, 1)]];
        }
        
        NSString*wStone = [self findPattern:@"^W\\[(.*?)\\]" FromString:moveInUp];
        
        if (wStone && wStone.length >=2) {
            num1= (int)[aplhaConvert indexOfObject:[wStone substringWithRange:NSMakeRange(0, 1)]];
            num2= (int)[self alphaToNum:[wStone substringWithRange:NSMakeRange(1, 1)]];
        }
        

        
        double moveIndex = num2*19+num1;
        [aMove setBoardLocation:moveIndex];
        
        if (bStone) {
            [aMove setIsBlack:YES];
            
        }else if (wStone){
            [aMove setIsBlack:NO];
            
        }else{
            //NO STONE FOUND
            continue;
        }
        
        
        NSString*comment = [self findPattern:@"C\\[(.*?)\\]" FromString:moveInUp];
        if (comment) {
            aMove.comment =comment;
        }

        [moveOuts addObject:aMove];
    }
    
    return (NSArray*)moveOuts;
    
    
    //    NSLog(@"%@",moves);
}



-(id)init{
    if ((self = [super init])) {
        [self buildAlphaConvert];
    }
    return self;
}



@end
