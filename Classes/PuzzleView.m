//
//  PuzzleView.m
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PuzzleView.h"
#import "WordWizardPuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"
#import "Puzzle.h"
#import "WordWizardPuzzleViewController.h"

@implementation PuzzleView


@synthesize goodTouch;

@synthesize moving;
@synthesize firstTouch;
@synthesize lastTouch;

@synthesize touchedLetterRow;
@synthesize touchedLetterCol;
@synthesize destLetterRow;
@synthesize destLetterCol;
@synthesize fromLetterRow;
@synthesize fromLetterCol;
@synthesize lastMoveDirection;
@synthesize globalPoint0x;
@synthesize globalPoint1x;
@synthesize globalPoint2x;
@synthesize globalPoint0y;
@synthesize globalPoint1y;
@synthesize globalPoint2y;
- (void)dealloc {



    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		allowTouch=YES;
		//matrix center might be different for puzzle view and design puzzle view
		self.matrixCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		self.goodTouch=NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
	DebugLog(@"entering PuzzleView.initWithCoder");

	if((self = [super initWithCoder:coder])){
        
		self.goodTouch=NO;
		
		//init touch-move-related variables
		[self initMoveVariables];
		
	}
	DebugLog(@"leaving PuzzleView.initWithCoder");
	return self;
}

-(void)initMoveVariables{
	self.touchedLetterRow=-1;
	self.touchedLetterCol=-1;
	self.fromLetterRow=-1;
	self.fromLetterCol=-1;
	self.destLetterRow=-1;
	self.destLetterCol=-1;
	self.moving=NO;
	self.lastMoveDirection=-1;
	self.globalPoint0x=-1;
	self.globalPoint1x=-1;
	self.globalPoint2x=-1;
	self.globalPoint0y=-1;
	self.globalPoint1y=-1;
	self.globalPoint2y=-1;
}

//override
- (void)drawRect:(CGRect)rect {
	DebugLog(@"entering CommonMatrixView.drawRect with %f %f %f %f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
	DebugLog(@"view bounds with %f %f %f %f ", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	Puzzle *currentPuzzle = delegate.currentPuzzle;
	
	if(!CGRectEqualToRect(self.bounds,rect)){
		//redraw only the changed area
		[self drawMatrixBackgroundColorInRect:rect];
		[self drawDataAtRow:[self touchedLetterRow]  AndCol:[self touchedLetterCol] ofPuzzle:currentPuzzle];
		//[[self viewHelper] drawMatrixBoundry];
		//[[self viewHelper] drawPuzzle:currentPuzzle];
	}else{
		//redraw whole puzzle
		[self drawScreenBackgroundInRect:rect];
		[self drawMatrixBoundry];
		[self drawPuzzle:currentPuzzle];
	}
	DebugLog(@"leaving CommonMatrixView.drawRect");
}

//---------------------------------------------------
//    tap and movement handlers
//
//
//
//---------------------------------------------------


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!allowTouch){
		DebugLog(@"touched is not allowed");
		return;
	}
	[self initMoveVariables];
	//
	UITouch *touch = [[event touchesForView:self] anyObject];
	CGPoint touchedPoint = [touch locationInView:self];
	self.goodTouch = [self onTouchBegin:touchedPoint isUndo:NO];
	
}

int countMoveEvent=0;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!allowTouch){
		DebugLog(@"touched is not allowed");
		return;
	}
	DebugLog(@"PuzzleView.touchesMoved:starts");
	UITouch *touch = [touches anyObject];
	
	CGPoint touchedPoint = [touch locationInView:self];
	countMoveEvent++;
//	if(countMoveEvent%2==0){
//		DebugLog(@"ignore onMove");
//		return;
//	}
	
	Boolean isGoodTouch = [self onTouchMove:touchedPoint isUndo:NO];
	if(isGoodTouch){
		//[self setNeedsDisplay];
		
		[self setNeedsDisplayInRect:[self getCoveredRectBetweenRow1:self.fromLetterRow Col1:self.fromLetterCol Row2:self.destLetterRow Col2:self.destLetterCol]];
	}
	DebugLog(@"PuzzleView.touchesMoved:ends");
	self.goodTouch=isGoodTouch;
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!allowTouch){
		DebugLog(@"touched is not allowed");
		return;
	}
	self.moving=NO;
	UITouch *touch = [touches anyObject];
	CGPoint touchedPoint = [touch locationInView:self];
	[self onTouchEnd:touchedPoint isUndo:NO];
	
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	Puzzle *currentPuzzle = delegate.currentPuzzle;
	DebugLog(@"checking whether matrix completed");
	if([WordWizardPuzzleHelper isTotalCompleteOfPuzzle:currentPuzzle]){
		[self doWhenSuccess];
	}
	
	[self setNeedsDisplay];
	[self.stepsTaken setNeedsDisplay];
}


- (Boolean)onTouchBegin:(CGPoint) touchedPoint isUndo:(Boolean)isUndo{
	DebugLog(@"PuzzleViewHelper:onTouchBegin;starts");
	//check whether it is double-tap or single-tap. Double-Tap will flip stone-space, Single-Tap
	//begin the moving space
	GlobalConfiguration *configuration = [self getConfiguration];
	//clear
	[self initMoveVariables];
	//check whether the user click any non-empty cell
	int currentCol = (touchedPoint.x-self.matrixRect.origin.x)/(configuration.widthOfCell+configuration.marginOfRow);
	int currentRow = (touchedPoint.y-self.matrixRect.origin.y)/(configuration.heightOfCell+configuration.marginOfCol);
	
	Puzzle *currentPuzzle = [self getCurrentWorkingPuzzle];
	if(![self isValidOnRow:currentRow AndCol:currentCol OfPuzzle:currentPuzzle]){
		DebugLog(@"touched out of bound, ignore it");
		return NO;
	}
	if([self isSpaceOnRow:currentRow AndCol:currentCol OfPuzzle:currentPuzzle]){
		DebugLog(@"touched space, ignore it");
		return NO;
	}
	
	//set the touched point to be the center of the touched cell
	self.firstTouch = [self getCenterOfCellAtRow:currentRow AndCol: currentCol];
	self.lastTouch = self.firstTouch;
	self.touchedLetterRow = currentRow;
	self.touchedLetterCol = currentCol;
	self.fromLetterRow=currentRow;
	self.fromLetterCol=currentCol;
	self.destLetterRow=currentRow;
	self.destLetterCol=currentCol;
	DebugLog(@"PuzzleViewHelper.onTouchBegin:ends current at %i %i at point %f %f", currentRow, currentCol, self.firstTouch.x, self.firstTouch.y);
	return YES;
}





- (void)onTouchEnd:(CGPoint) touchedPoint  isUndo:(Boolean)isUndo{
	DebugLog(@"PuzzleViewHelper.onTouchEnd:starts touched letter [%i,%i] from [%i, %i] dest[%i,%i]", self.touchedLetterRow, self.touchedLetterCol, self.fromLetterRow, self.fromLetterCol, self.destLetterRow,self.destLetterCol);
	if(self.touchedLetterRow==-1 || self.touchedLetterCol==-1){
		DebugLog(@"onTouchEnd:could not find touched letter row and col, ingore touchEnd event");
		[self initMoveVariables];
		return;
	}
	if(self.destLetterRow==-1 || self.destLetterCol==-1){
		DebugLog(@"onTouchEnd:could not find dest letter row and col, ingore touchEnd event");
		[self initMoveVariables];
		return;
	}
	
	//regardless where the user stop touching (can be anywhere), we always use the dest-cell as the place to swap
	int currentRow = self.destLetterRow;
	int currentCol = self.destLetterCol;
	if(!(currentRow==self.touchedLetterRow && currentCol==self.touchedLetterCol)){
		//stop touching at the destination
		if(!isUndo && !(self.fromLetterRow==self.destLetterRow && self.fromLetterCol==self.destLetterCol)){
			NSString *stepString = [[NSString alloc] initWithFormat:@"%i%i%i%i", self.fromLetterRow, self.fromLetterCol, currentRow, currentCol];
			if([stepString compare:[self.userSteps lastObject]]==0){
				//already in the steps array
			}else{
				[userSteps addObject:stepString];
				//				NSString *temp = [[NSString alloc] initWithFormat:@"%i",[userSteps count]];
				//				self.callerView.stepsTaken.text=temp;
				//				[temp release];
			}
			[stepString release];
		}
		
		//replace the touched letter and dest letter
		CGPoint centerOfTouchedLetter = [self getCenterOfCellAtRow:self.touchedLetterRow AndCol:self.touchedLetterCol];
		CGPoint centerOfDestLetter = [self getCenterOfCellAtRow:currentRow AndCol:currentCol];
		//swap
		displayMatrixX[self.touchedLetterRow][self.touchedLetterCol]=centerOfTouchedLetter.x;
		displayMatrixY[self.touchedLetterRow][self.touchedLetterCol]=centerOfTouchedLetter.y;
		displayMatrixX[self.destLetterRow][self.destLetterCol]=centerOfDestLetter.x;
		displayMatrixY[self.destLetterRow][self.destLetterCol]=centerOfDestLetter.y;
		//DebugLog(@"swap displayMatrix now [%i,%i] is at (%i,%i) and [%i,%i] is at (%i,%i)", self.touchedLetterRow,self.touchedLetterCol,displayMatrixX[self.touchedLetterRow][self.touchedLetterCol],displayMatrixY[self.touchedLetterRow][self.touchedLetterCol],self.destLetterRow,self.destLetterCol,displayMatrixX[self.destLetterRow][self.destLetterCol],displayMatrixY[self.destLetterRow][self.destLetterCol]);
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		
		NSString *movedData = [[NSString alloc] initWithString:[self getDataOnRow:self.touchedLetterRow AndCol:self.touchedLetterCol OfPuzzle:delegate.currentPuzzle]];
		NSString *destData = [[NSString alloc] initWithString:[self getDataOnRow:currentRow AndCol:currentCol OfPuzzle:delegate.currentPuzzle]];
		DebugLog(@"before swapping %@ %@", movedData, destData);
		DebugLog(@"before swapping in datamatrix (%i,%i)=%@ (%i,%i)=%@", self.touchedLetterRow, self.touchedLetterCol, [self getDataOnRow:self.touchedLetterRow AndCol:self.touchedLetterCol OfPuzzle:delegate.currentPuzzle], currentRow, currentCol, [self getDataOnRow:currentRow AndCol:currentCol OfPuzzle:delegate.currentPuzzle]);
		[[delegate.currentPuzzle.dataMatrix objectAtIndex:currentRow] replaceObjectAtIndex:currentCol withObject:movedData];
		[[delegate.currentPuzzle.dataMatrix objectAtIndex:self.touchedLetterRow] replaceObjectAtIndex:self.touchedLetterCol withObject:destData];
		DebugLog(@"after swapping in datamatrix (%i,%i)=%@ (%i,%i)=%@", self.touchedLetterRow, self.touchedLetterCol, [self getDataOnRow:self.touchedLetterRow AndCol:self.touchedLetterCol OfPuzzle:delegate.currentPuzzle], currentRow, currentCol, [self getDataOnRow:currentRow AndCol:currentCol OfPuzzle:delegate.currentPuzzle]);
		[movedData release];
		[destData release];
	}
	
	
	[self initMoveVariables];
	//self.firstTouch=nil;
	//self.lastTouch=nil;
	self.lastTouch = touchedPoint;
	DebugLog(@"PuzzleViewHelper.onTouchEnd:ends");
	//	[self printPuzzle:[self getCurrentWorkingPuzzle]];
	NSString *s = [[NSString alloc] initWithFormat:@"%i",[self.userSteps count]];
	self.stepsTaken.text=s;
	[s release];
}





- (Boolean)onTouchMove:(CGPoint) touchedPoint isUndo:(Boolean)isUndo{
	DebugLog(@"starts");
	self.moving=YES;
	if(self.touchedLetterRow==-1){
		//
		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove:not a good onTouchBegin, ignore onMove event");
		return NO;
	}
	//
	if(touchedPoint.x==lastTouch.x && touchedPoint.y==lastTouch.y){
		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove::same point, do nothing");
		return NO;
	}
	if(touchedPoint.x<matrixRect.origin.x || touchedPoint.x>matrixRect.origin.x+matrixRect.size.width){
		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove::out of bound at y");
		
		return NO;
	}
	if(touchedPoint.y<matrixRect.origin.y || touchedPoint.y>matrixRect.origin.y+matrixRect.size.height){
		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove::out of bound at x");
		
		return NO;
	}
	Puzzle *currentPuzzle = [self getCurrentWorkingPuzzle];
	if([self isSpaceOnRow:self.touchedLetterRow AndCol:self.touchedLetterCol OfPuzzle:currentPuzzle] 
	   || [self isStoneOnRow:self.touchedLetterRow AndCol:self.touchedLetterCol OfPuzzle:currentPuzzle]){
		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove:touched letter [%i,%i] is space or stone, ignore onMove event", self.touchedLetterRow, self.touchedLetterCol);
		return NO;
	}
	DebugLog(@"lastTouch (%f,%f) to (%f,%f)", self.lastTouch.x, self.lastTouch.y, touchedPoint.x, touchedPoint.y);
	
	
	
	return [self handleTouchMove:touchedPoint isUndo:isUndo ofPuzzle:currentPuzzle];
	//[self performSelector:@selector)() withObject:<#(id)anArgument#> afterDelay:0.01];
	
}

//orveride
- (void)redrawPleaseInRect:(id)rect{
	[self  setNeedsDisplayInRect:[self getCoveredRectBetweenRow1:self.fromLetterRow Col1:self.fromLetterCol Row2:self.destLetterRow Col2:self.destLetterCol]];
}


- (Boolean)handleTouchMove:(CGPoint)touchedPoint isUndo:(Boolean)isUndo ofPuzzle:(Puzzle*)currentPuzzle{
	DebugLog(@"starts");
	GlobalConfiguration *configuration = [self getConfiguration];
	
	//currently touched cell
	int currentCol = (touchedPoint.x-self.matrixRect.origin.x)/(configuration.widthOfCell+configuration.marginOfRow);
	int currentRow = (touchedPoint.y-self.matrixRect.origin.y)/(configuration.heightOfCell+configuration.marginOfCol);
	DebugLog(@"current cell [%i,%i]", currentRow, currentCol);
	//the current cell must be either the touched cell, or the dest cell or neighbor to destcell or neightbor to touched cell
	if((currentRow==self.touchedLetterRow && currentCol==self.touchedLetterCol) || ([self areTheyNeighborAtRow1:currentRow AndCol1:currentCol AndRow2:self.touchedLetterRow Andcol2:self.touchedLetterCol OfPuzzle:currentPuzzle])
	   || (currentRow==self.destLetterRow && currentCol==self.destLetterCol) || ([self areTheyNeighborAtRow1:currentRow AndCol1:currentCol AndRow2:self.destLetterRow Andcol2:self.destLetterCol OfPuzzle:currentPuzzle])){
	}else{
		DebugLog(@"current cell [%i,%i] is not or neighbor to touched cell [%i,%i], neither dest cell [%i,%i]", currentRow, currentCol, self.touchedLetterRow, self.touchedLetterCol, self.destLetterRow, self.destLetterCol);
		return NO;
	}
	if(self.lastMoveDirection==-1){
		//wait until 3 points available, to calculate the move direction, which will be used until touch-end
		if(self.globalPoint0x==-1 && self.globalPoint0y==-1){
			self.globalPoint0x = touchedPoint.x;
			self.globalPoint0y = touchedPoint.y;
			return NO;
		}else if(self.globalPoint1x==-1 && self.globalPoint1y==-1){
			self.globalPoint1x = touchedPoint.x;
			self.globalPoint1y = touchedPoint.y;
			//calculate move direction
			if(abs(self.globalPoint1x-self.globalPoint0x)>abs(self.globalPoint1y-self.globalPoint0y)){
				//horizonally
				if(self.globalPoint1x>self.globalPoint0x){
					//right
					self.lastMoveDirection=1;
				}else{
					//left
					self.lastMoveDirection=0;
				}
			}else{
				//vertically
				if(self.globalPoint1y-self.globalPoint0y){
					//down
					self.lastMoveDirection=3;
				}else{
					//up
					self.lastMoveDirection=2;
				}
			}
		}
	}else if(self.globalPoint2x==-1 && self.globalPoint2y==-1){
		self.globalPoint2x = touchedPoint.x;
		self.globalPoint2y = touchedPoint.y;
		//re-calculate in case the first 2 points were not accurate, in which case, use first and third points
		if(abs(self.globalPoint2x-self.globalPoint0x)>abs(self.globalPoint2y-self.globalPoint0y)){
			//horizonally
			if(self.globalPoint2x>self.globalPoint0x){
				//right
				self.lastMoveDirection=1;
			}else{
				//left
				self.lastMoveDirection=0;
			}
		}else{
			//vertically
			if(self.globalPoint2y>self.globalPoint0y){
				//down
				self.lastMoveDirection=3;
			}else{
				//up
				self.lastMoveDirection=2;
			}
		}
	}

	
	int moveDirection = -1;
	int x1=lastTouch.x;
	int y1=lastTouch.y;
	int x2=touchedPoint.x;
	int y2=touchedPoint.y;
	//
	if(abs(x2-x1)>abs(y2-y1)){
		//horizonally
		if(x2>x1){
			//right
			moveDirection=1;
		}else{
			//left
			moveDirection=0;
		}
	}else{
		//vertically
		if(y2>y1){
			//down
			moveDirection=3;
		}else{
			//up
			moveDirection=2;
		}
	}
	if(moveDirection!=self.lastMoveDirection){
		DebugLog(@"last move direction is %i this time it is %i, ignore", self.lastMoveDirection, moveDirection);
		return NO;
	}
	moveDirection = self.lastMoveDirection;
	int distance=0;
	if(moveDirection==0 || moveDirection==1){
		distance = abs(y2-y1);
	}else{
		distance = abs(x2-x1);
	}
//	//---------- begin of calculating move direction and distance ---------------
//	int x1=lastTouch.x;
//	int y1=lastTouch.y;
//	int x2=touchedPoint.x;
//	int y2=touchedPoint.y;
//	int distance=0;
//	int deltaX = abs(x2-x1);
//	int deltaY = abs(y2-y1);
//	if(deltaY>deltaX){ //
//		x2=x1;
//		distance = deltaY;
//		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove::moving vertically %i with delta %i %i", distance, deltaX, deltaY);
//	}else if(deltaX>deltaY){ //
//		y2=y1;
//		distance = deltaX;
//		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove::moving horizonally %i with delta %i %i", distance, deltaX,deltaY);
//	}else{
//		DebugLog(@"WordWizardPuzzleViewHelper.onTouchMove:delta of move unqualified %i %i", deltaX,deltaY);
//		self.lastTouch=touchedPoint;
//		return NO;
//	}
//	
//	int moveDirection=-1; //0 left, 1 right, 2 up, 3 down
//	
//	if(x2==x1){
//		//moving vertically
//		if(y2<y1){
//			DebugLog(@"onTouchMove:moving up");
//			moveDirection = 2; //up
//			
//		}else if(y2>y1){
//			DebugLog(@"onTouchMove:moving down");
//			moveDirection = 3; //down
//		}else{
//			DebugLog(@"onTouchMove:same spot, return");
//			self.lastTouch=touchedPoint;
//			return NO;
//		}
//	}else if(y2==y1){
//		//moving horizonally
//		if(x2<x1){
//			DebugLog(@"onTouchMove:moving left");
//			moveDirection = 0; //left
//			
//		}else if(x2>x1){
//			DebugLog(@"onTouchMove:moving right");
//			moveDirection = 1; //right
//			
//		}else{
//			DebugLog(@"onTouchMove:same spot");
//			self.lastTouch=touchedPoint;
//			return NO;
//		}
//	}
//	if(moveDirection<0){
//		self.lastTouch=touchedPoint;
//		return NO;
//	}
//	
	
		
	
	int toRow=currentRow;
	int toCol=currentCol;
	
	DebugLog(@"onTouchMove:fromCell [%i,%i] currentCell [%i,%i] destCell [%i,%i]", self.fromLetterRow, self.fromLetterCol, currentRow, currentCol, self.destLetterRow, self.destLetterCol);
	if([self isSpaceOnRow:currentRow AndCol:currentCol OfPuzzle:currentPuzzle]){
		//it is space alreay, so it is good move too
		DebugLog(@"onTouchMove:right now it is on space");
		//goodMove = YES;
		if(self.destLetterRow!=currentRow && self.destLetterCol!=currentCol){
			//dest pointer jump, put current value to previous from cell
			self.fromLetterRow=self.destLetterRow;
			self.fromLetterCol=self.destLetterCol;
		}
		self.destLetterRow = currentRow;
		self.destLetterCol = currentCol;
	}else{
		//it is not space, it is either the touchBegin cell or hit the wall
		if(currentRow==self.touchedLetterRow && currentCol==self.touchedLetterCol){
			DebugLog(@"onTouchMove:still at the start cell, check whether it is moving to space");
			//----------------begin of calculating the next neighbor cell on the moving direction-----
			//goodMove=NO;
			if(moveDirection==0){
				toCol=currentCol-1; //left
			}else if(moveDirection==1){
				toCol=currentCol+1; //right
				
			}else if(moveDirection==2){
				toRow=currentRow-1; //up
				
			}else if(moveDirection==3){
				toRow=currentRow+1; //down
			}
			DebugLog(@"onTouchMove:moving direction %i to [%i,%i]", moveDirection, toRow, toCol);
			//---------------end -----------
			
			//moving to space neighor?
			if([self isValidOnRow:toRow AndCol:toCol OfPuzzle:currentPuzzle] && [self isSpaceOnRow:toRow AndCol:toCol OfPuzzle:currentPuzzle]){
				//goodMove=YES;
				//dest always point to the current or next space. fromCell is always the previous
				self.destLetterRow = toRow;
				self.destLetterCol = toCol;
				self.fromLetterRow = currentRow;
				self.fromLetterCol = currentCol;
			}else{
				DebugLog(@"onTouchMove:target cell [%i,%i] is not empty", toRow, toCol);
				//goodMove=NO;
				self.lastTouch=touchedPoint;
				return NO;
			}
			//if(!goodMove){
			//				self.lastTouch=touchedPoint;
			//				return;
			//			}
			
		}else{
			//hit the wall, end the moving, update dataMatrix, same as touchEnd
			DebugLog(@"onTouchMove:moving hit the non-empty wall");
			//goodMove=NO;
			self.lastTouch=touchedPoint;
			return NO;
		}
		
	}
	
	//	if(!goodMove){
	//		DebugLog(@"onTouchMove:moving is not good");
	//		self.lastTouch=touchedPoint;
	//		return;
	//	}
	
	
	CGPoint movedPoint; //where we will draw the cell, it must be in the defined path
	//find the center of the touched letter, to make the path absolution horizonal or vertical
	CGPoint centerOfFromLetter = [self getCenterOfCellAtRow:self.fromLetterRow AndCol:self.fromLetterCol];
	if(moveDirection==0){
		//left
		movedPoint = CGPointMake(x1-distance, centerOfFromLetter.y);
	}else if(moveDirection==1){
		//right
		movedPoint = CGPointMake(x1+distance, centerOfFromLetter.y);
	}else if(moveDirection==2){
		//up
		movedPoint = CGPointMake(centerOfFromLetter.x, y1-distance);
	}else if(moveDirection==3){
		//down
		movedPoint = CGPointMake(centerOfFromLetter.x, y1+distance);
	}
	DebugLog(@"onTouchMove:good move to %i %i, disply center at %f %f distance %i", toRow, toCol, movedPoint.x, movedPoint.y, distance);
	
	//now that we know it is moving to the right place from right place, need to display the moving cell baesd on the touched point
	displayMatrixX[self.touchedLetterRow][self.touchedLetterCol]=movedPoint.x;
	displayMatrixY[self.touchedLetterRow][self.touchedLetterCol]=movedPoint.y;
	
	
	if(self.destLetterRow==currentRow && self.destLetterCol==currentCol){
		//already moved to the space cell
		DebugLog(@"onTouchMove:fromCell [%i,%i] current cell [%i,%i] dest cell[%i,%i]",self.fromLetterRow, self.fromLetterCol, currentRow, currentCol, self.destLetterRow, self.destLetterCol);
		if(!isUndo && !(self.fromLetterRow==self.destLetterRow && self.fromLetterCol==self.destLetterCol)){
			//passed the border, now add to steps
			NSString *stepString = [[NSString alloc] initWithFormat:@"%i%i%i%i", self.fromLetterRow, self.fromLetterCol, self.destLetterRow, self.destLetterCol];
			DebugLog(@"onTouchMove:may add step:%@", stepString);
			if([stepString compare:[userSteps lastObject]]==0){
				//already in the steps array
			}else{
				[userSteps addObject:stepString];
				
				//				[self.callerView.stepsTaken setText:[NSString stringWithFormat:@"%i",[userSteps count]]];
			}
			[stepString release];
		}
	}else{
		
	}
	
	//redraw
	//DebugLog(@"WordWizardPuzzleViewHelper:onTouchMove - issue redraw to view");
	//redraw the touched letter read
	//	CGRect redrawRect;
	//	if(moveDirection==1 || moveDirection==3){
	//		CGPoint topLeftPointOfRect = [self getTopLeftPointOfCellAtRow:self.touchedLetterRow AndCol:self.touchedLetterCol];
	//		redrawRect = CGRectMake(topLeftPointOfRect.x, topLeftPointOfRect.y, movedPoint.x+configuration.widthOfCell/2-topLeftPointOfRect.x, movedPoint.y+configuration.heightOfCell/2-topLeftPointOfRect.y);
	//	}else{
	//		CGPoint topLeftPointOfRect = CGPointMake(movedPoint.x-configuration.widthOfCell/2-configuration.marginOfRow, movedPoint.y-configuration.heightOfCell/2-configuration.marginOfCol);
	//		CGPoint centerOfTouchedLetter = [self getCenterOfCellAtRow:self.touchedLetterRow AndCol:self.touchedLetterCol];
	//		redrawRect = CGRectMake(topLeftPointOfRect.x, topLeftPointOfRect.y, centerOfTouchedLetter.x+configuration.widthOfCell/2+configuration.marginOfRow-topLeftPointOfRect.x, centerOfTouchedLetter.y+configuration.heightOfCell/2+configuration.marginOfCol-topLeftPointOfRect.y);
	//
	//	}
	//	[[self callerView] setNeedsDisplayInRect:redrawRect];
	
	self.lastTouch = touchedPoint;
	DebugLog(@"WordWizardPuzzleViewHelper.handleTouchMove:ends");
	return YES;
}







@end
