//
//  PuzzleView.h
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonPuzzleView.h"

@class Puzzle;
@class GlobalConfiguration;

@interface PuzzleView : CommonPuzzleView {
	

	
	
	
	
	//store for onMove
	Boolean goodTouch;
	CGPoint firstTouch;
	CGPoint lastTouch;
	int touchedLetterRow;
	int touchedLetterCol;
	int fromLetterRow;
	int fromLetterCol;
	int destLetterRow;
	int destLetterCol;
	int lastMoveDirection;
	int globalPoint0x;
	int globalPoint1x;
	int globalPoint2x;
	int globalPoint0y;
	int globalPoint1y;
	int globalPoint2y;
	Boolean moving;

	
}

@property int globalPoint0x;
@property int globalPoint1x;
@property int globalPoint2x;
@property int globalPoint0y;
@property int globalPoint1y;
@property int globalPoint2y;
@property int lastMoveDirection;
@property Boolean moving;
@property Boolean goodTouch;
@property int touchedLetterRow;
@property int touchedLetterCol;
@property int fromLetterRow;
@property int fromLetterCol;
@property int destLetterRow;
@property int destLetterCol;

@property CGPoint firstTouch;
@property CGPoint lastTouch;


//---------- puzzle loading, refreshing, saving
- (void)initMoveVariables;





//-------------handlers of touch movements, undo, redo, and show-me

- (Boolean)onTouchBegin:(CGPoint) touchedPoint isUndo:(Boolean)isUndo;
- (Boolean)onTouchMove:(CGPoint) touchedPoint isUndo:(Boolean)isUndo;
- (void)onTouchEnd:(CGPoint) touchedPoint isUndo:(Boolean)isUndo;
- (Boolean)handleTouchMove:(CGPoint)touchedPoint isUndo:(Boolean)isUndo ofPuzzle:(Puzzle*)currentPuzzle;






@end
