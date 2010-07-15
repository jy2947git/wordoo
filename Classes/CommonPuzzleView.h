//
//  CommonPuzzleView.h
//  WizardView
//
//  Created by Junqiang You on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Puzzle;
@class GlobalConfiguration;
@interface CommonPuzzleView : UIView {
	
	UIViewController *controller;
	IBOutlet UILabel *stepsTaken;
	IBOutlet UILabel *puzzlePar;
	CGPoint matrixCenter;
	CGRect matrixRect;
	NSMutableArray *userSteps;
	NSMutableArray *undoSteps;
	//
	int puzzleRowNumber;
	int puzzleColNumber;
	
	
	//store the point of each cell in current matrix
	int displayMatrixX[10][10];
	int displayMatrixY[10][10];
	
	Boolean allowTouch;
}
@property (nonatomic, retain) IBOutlet UILabel *puzzlePar;
@property (nonatomic, retain) UIViewController *controller;
@property (nonatomic, retain) IBOutlet UILabel *stepsTaken;
@property CGPoint matrixCenter;
@property int puzzleRowNumber;
@property int puzzleColNumber;
@property CGRect matrixRect;
@property (nonatomic, retain) NSMutableArray *userSteps;
@property (nonatomic, retain) NSMutableArray *undoSteps;
@property Boolean allowTouch;

- (GlobalConfiguration*)getConfiguration;
- (Puzzle*)getCurrentWorkingPuzzle;

- (void)refreshPuzzle;
- (void)doWhenSuccess;
- (void)printPuzzle:(Puzzle*)currentPuzzle;

- (void)loadSolutionStepsToUserSteps;
- (void)savePuzzlePlayState;

//-------------------methods to help draw puzzle
- (void)drawOneLetter:(NSString *)letter AsNumberX:(int)numberX AsNumberY:(int)numberY;
- (void)drawImage:(UIImage *)image AsNumberX:(int)numberX AsNumberY:(int)numberY;
- (void)drawPuzzle:(Puzzle*)currentPuzzle;
- (void)drawDataAtRow:(int)row AndCol:(int)col ofPuzzle:(Puzzle*)currentPuzzle;

- (void)drawMatrixBoundry;
- (void)drawCellInRect:(CGRect)rectOfCell WithLetter:(NSString*)letter InRect:(CGRect)rectOfLetter;
- (void)drawCellInRect:(CGRect)rectOfCell WithImage:(UIImage*)image InRect:(CGRect)rectOfLetter;
- (void)drawScreenBackgroundInRect:(CGRect)rect;
- (void)drawMatrixBackgroundColorInRect:(CGRect)rect;
-(void)drawStoneAtRow:(int)row AndCol:(int)col;

//----------------animation
- (void)redrawPlease;
- (void)redrawPleaseInRect:(id)rect;
- (void)blockTouchEvent;
- (void)openTouchEvent;
- (void)undoStep;
- (void)redoStep;
- (void)showMe:(int)stepNum;
-(void)animateSteps:(NSMutableArray*)tempSolutionsCopy isUndo:(Boolean)isUndo;
-(void)animate:(id)object;
-(void)animateUndo:(id)object;
- (void)autoMoveFromRow:(int)row1 Col:(int)col1 ToRow:(int)row2 Col:(int)col2 isUndo:(Boolean)undo;
//---------------assistant methods
- (CGRect)getCoveredRectBetweenRow1:(int)row1 Col1:(int)col1 Row2:(int)row2 Col2:(int)col2;
- (CGPoint)getCenterOfCellAtRow:(int)x AndCol:(int)col;
- (CGPoint)getTopLeftPointOfCellAtRow:(int)x AndCol:(int)col;
- (CGPoint)getLowerRightPointOfCellAtRow:(int)x AndCol:(int)col;
- (id)getDisplayDataOnKey:(id)key OfPuzzle:(Puzzle*)currentPuzzle;
- (id)getDataOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle;
- (id)getDisplayonRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle;
- (Boolean)isValidOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle;
- (Boolean)isSpaceOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle;
- (Boolean)isStoneOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle;
- (Boolean)isNeighborToSpaceAtRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle;
- (Boolean)areTheyNeighborAtRow1:(int)row1 AndCol1:(int)col1 AndRow2:(int)row2 Andcol2:(int)col2 OfPuzzle:(Puzzle*)currentPuzzle;

@end
