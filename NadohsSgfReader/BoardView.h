//
//  BoardView.h
//  NadohsSgfReader
//
//  Created by Rich on 8/21/13.
//  Copyright (c) 2013 NadohsInc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol keyboardButtonDelegate <NSObject>
-(void)rightButtonClicked;
-(void)startButtonClicked;
-(void)leftButtonClicked;
-(void)endButtonClicked;
@end

@interface BoardView : NSView{

}

@property (nonatomic, assign) id<keyboardButtonDelegate> keyDelegate;


@end
