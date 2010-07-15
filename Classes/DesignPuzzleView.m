//
//  DesignPuzzleView.m
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignPuzzleView.h"
#import "WordWizardPuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"
#import "Puzzle.h"

@implementation DesignPuzzleView

- (id)initWithCoder:(NSCoder *)coder{
	if((self = [super initWithCoder:coder])){
//		self.matrixCenter = CGPointMake(160.00, 180.00);

//			WordWizardPuzzleViewHelper *vw = [[WordWizardPuzzleViewHelper alloc]initWithView:self];
//			self.viewHelper = vw;
//			[vw release];
//			//[ph release];
//		
//		[self.viewHelper initPuzzle];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}
- (GlobalConfiguration*)getConfiguration{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	return delegate.configuration;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!allowTouch){
		DebugLog(@"touched is not allowed");
		return;
	}
	DebugLog(@"DesignPuzzleView.touchesBegin:start");
	UITouch *touch = [[event touchesForView:self] anyObject];

	//check whether it is double-tap or single-tap. Double-Tap will flip stone-space, Single-Tap
	//begin the moving space
	NSInteger tapCount = [touch tapCount];

	
	if(tapCount==1){
		//move cell
		[self performSelector:@selector(singleTap:) withObject:touch afterDelay:0.2];
	}else if(tapCount==2){
		//switch between space and stone
		[self doubleTap:touch];
	}else{
		DebugLog(@"multiple touch found, dont know what to do");
	}
	DebugLog(@"DesignPuzzleView.touchesBegin:end");
}

- (void)singleTap:(UITouch *)touch{
	DebugLog(@"DesignPuzzleView.singleTap:starts");
	[self onTouchBegin:[touch locationInView:self] isUndo:NO];
	DebugLog(@"DesignPuzzleView.singleTap:ends");
}

- (void)doubleTap:(UITouch*)touch{
	DebugLog(@"DesignPuzzleView.doubleTap:starts");
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:touch];
	[self onDoubleTouchBegin:[touch locationInView:self]];
	DebugLog(@"DesignPuzzleView.doubleTap:ends");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//	if(!allowTouch){
//		DebugLog(@"touched is not allowed");
//		return;
//	}
//	DebugLog(@"DesignPuzzleView.touchesMoved:starts");
//	UITouch *touch = [touches anyObject];
//	CGPoint touchedPoint = [touch locationInView:self];
//	[self onTouchMove:touchedPoint isUndo:NO];
//	[self.viewHelper redrawPleaseInRect:nil];
//	DebugLog(@"DesignPuzzleView.touchesMoved:ends");
	[super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!allowTouch){
		DebugLog(@"touched is not allowed");
		return;
	}
	DebugLog(@"DesignPuzzleView.touchedEnd:start");
	UITouch *touch = [touches anyObject];
	CGPoint touchedPoint = [touch locationInView:self];
	[self onTouchEnd:touchedPoint isUndo:NO];
//	self.stepsTaken.text=[NSString stringWithFormat:@"%i",[self.userSteps count]];
	
	[self setNeedsDisplay];
	DebugLog(@"DesignPuzzleView.touchedEnd:end");

}

- (void)onDoubleTouchBegin:(CGPoint) touchedPoint{
	DebugLog(@"PuzzleViewHelper.onDoubleTouchBegin:starts");
	GlobalConfiguration *configuration = [self getConfiguration];
	Puzzle *currentPuzzle = [self getCurrentWorkingPuzzle];
	//[WordWizardPuzzleHelper printPuzzle:currentPuzzle];
	int currentCol = (touchedPoint.x-self.matrixRect.origin.x)/(configuration.widthOfCell+configuration.marginOfRow);
	int currentRow = (touchedPoint.y-self.matrixRect.origin.y)/(configuration.heightOfCell+configuration.marginOfCol);
	if([self isValidOnRow:currentRow AndCol:currentCol OfPuzzle:currentPuzzle]){
		NSString *data = [[currentPuzzle.dataMatrix objectAtIndex:currentRow] objectAtIndex:currentCol];
		if([self isSpaceOnRow:currentRow AndCol:currentCol OfPuzzle:currentPuzzle]){
			//change it to stone
			DebugLog(@"changint space to stone in display");
			
			[currentPuzzle.displayMap setObject:@"^" forKey:data];
			//redraw
			
			[self  setNeedsDisplay];
		}else if([self isStoneOnRow:currentRow AndCol:currentCol OfPuzzle:currentPuzzle]){
			//change it to space
			DebugLog(@"changing stone to space");
			[currentPuzzle.displayMap setObject:@"#" forKey:data];
			//redraw
			
			[self setNeedsDisplay];
		}else{
			//nothing
			DebugLog(@"touched cell is neither space or stone, ignore");
		}
	}else{
		//nothing
	}
	[WordWizardPuzzleHelper printPuzzle:currentPuzzle];
	DebugLog(@"PuzzleViewHelper.onDoubleTouchBegin:ends");
}

@end
