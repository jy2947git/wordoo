//
//  CommonPuzzleView.m
//  WizardView
//
//  Created by Junqiang You on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CommonPuzzleView.h"
#import "WordWizardPuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"
#import "Puzzle.h"
#import "WordWizardPuzzleViewController.h"

@implementation CommonPuzzleView
@synthesize stepsTaken;
@synthesize matrixCenter;
@synthesize puzzleRowNumber;
@synthesize puzzleColNumber;
@synthesize matrixRect;
@synthesize controller;
@synthesize userSteps;
@synthesize undoSteps;
@synthesize allowTouch;
@synthesize puzzlePar;
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
	DebugLog(@"entering PuzzleView.initWithCoder");
	
	if((self = [super initWithCoder:coder])){
        // Initialization code
		allowTouch=YES;
		//matrix center might be different for puzzle view and design puzzle view
		self.matrixCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

		//init arrays
		if(self.userSteps==nil){
			NSMutableArray *tuser = [[NSMutableArray alloc]init];
			self.userSteps = tuser;
			[tuser release];
		}
		if(self.undoSteps==nil){
			NSMutableArray *tundo = [[NSMutableArray alloc]init];
			self.undoSteps = tundo;
			[tundo release];
		}
	}
	DebugLog(@"leaving PuzzleView.initWithCoder");
	return self;
}

- (void)drawRect:(CGRect)rect {
	DebugLog(@"entering CommonMatrixView.drawRect with %f %f %f %f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	Puzzle *currentPuzzle = delegate.currentPuzzle;
	

	//redraw whole puzzle
	[self drawScreenBackgroundInRect:rect];
	[self drawMatrixBoundry];
	[self drawPuzzle:currentPuzzle];
	
	DebugLog(@"leaving CommonMatrixView.drawRect");
}

- (void)dealloc {
	[self.puzzlePar release];
	[self.stepsTaken release];
	[self.controller release];
	[self.userSteps release];
	[self.undoSteps release];
    [super dealloc];
}



- (Puzzle*)getCurrentWorkingPuzzle{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	Puzzle *currentPuzzle = delegate.currentPuzzle;
	return currentPuzzle;
}

- (GlobalConfiguration*)getConfiguration{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	return delegate.configuration;
}


-(void)doWhenSuccess{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	//self.message.text=@"success!";
	if(delegate.configuration.playSound){
		AudioServicesPlaySystemSound(delegate.configuration.soundId);
	}
	//
	
	NSString *filePath = [delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:delegate.configuration.scoreFileName];
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		//create the file
		NSString *p = [[NSString alloc] initWithFormat:@"%i", [delegate.currentPuzzle.solutionSteps count]];
		NSString *s = [[NSString alloc] initWithFormat:@"%i", [self.userSteps count]];
		NSDictionary *score = [[NSDictionary alloc] initWithObjectsAndKeys:delegate.selectedPuzzleId, @"name", p, @"par", s, @"score", nil];
		NSArray *scores = [[NSArray alloc] initWithObjects:score, nil];
		[scores writeToFile:filePath atomically:YES];
		[p release];
		[s release];
		[score release];
		[scores release];
	}else{
		NSMutableArray *scores = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
		NSMutableDictionary *score = nil;
		for(int i=0; i<[scores count];i++){
			NSMutableDictionary *s = (NSMutableDictionary*)[scores objectAtIndex:i];
			if([delegate.selectedPuzzleId caseInsensitiveCompare:[s objectForKey:@"name"]]==0){
				//found it
				score = s;
				break;
			}
		}
		if(score==nil){
			//add
			NSString *p = [[NSString alloc] initWithFormat:@"%i", [delegate.currentPuzzle.solutionSteps count]];
			NSString *s = [[NSString alloc] initWithFormat:@"%i", [self.userSteps count]];
			NSDictionary *score = [[NSDictionary alloc] initWithObjectsAndKeys:delegate.selectedPuzzleId, @"name", p, @"par",  s, @"score", nil];
			[scores addObject:score];
			[scores writeToFile:filePath atomically:YES];
			[p release];
			[s release];
			[score release];
		}else{
			//update
			NSString *currentScore = [score objectForKey:@"score"];
			if([currentScore intValue]>[self.userSteps count]){
				NSString *s = [[NSString alloc] initWithFormat:@"%i", [self.userSteps count]];
				[score setObject:s forKey:@"score"];
				[scores writeToFile:filePath atomically:YES];
				[s release];
			}
		}
		
		[scores release];
		
	}
	WordWizardPuzzleViewController* vc = (WordWizardPuzzleViewController*)self.controller;
	vc.checkImg.hidden=NO;
	[vc.checkImg setNeedsDisplay];
	if(delegate.currentPuzzle.hint!=nil && [delegate.currentPuzzle.hint compare:@""]!=0){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:delegate.currentPuzzle.hint
														   delegate:self
											      cancelButtonTitle:@"Ok"
											      otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
	}else{
		//no ending, then display default message
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"Puzzle Solved!",@"Puzzle Solved!")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
												  otherButtonTitles:nil,nil];
		
		
		[alertView show];
		
		[alertView release];
	}
}










- (void)refreshPuzzle{
	DebugLog(@"PuzzleViewHelper.refreshPuzzle:starts");
	
	//call the puzzle helper to get initialized data matrix, and display matrix
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delegate.selectedPuzzleId!=nil){
		//existing puzzle, load from file
		DebugLog(@"loading puzzle %@ from file",delegate.selectedPuzzleId);
		[WordWizardPuzzleHelper loadPuzzleToMemory:delegate.selectedPuzzleId];
	}else{
		//only happen in design page
		DebugLog(@"selected puzzle id is null");
	}
	
	
	if(self.undoSteps!=nil){
		[self.undoSteps removeAllObjects];
	}
	if(self.userSteps!=nil){
		[self.userSteps removeAllObjects];
	}
	if(delegate.lastPuzzleId!=nil&&delegate.lastTakenSteps!=nil && [delegate.lastTakenSteps count]>0){
		DebugLog(@"it appears there is lastPuzzleId %@ and %i steps, use the lastTakenSteps to fill current puzzle", delegate.lastPuzzleId, [delegate.lastTakenSteps count]);
		[self.userSteps addObjectsFromArray:delegate.lastTakenSteps];
		delegate.lastPuzzleId=nil;
		DebugLog(@"now they are cleared");
	}
	//	.puzzleName.text=delegate.currentPuzzle.name;
	//	NSString *temp = [NSString stringWithFormat:@"%i",[self.userSteps count]];
	//	self.callerView.stepsTaken.text=temp;
	//	[temp release];
	
	//	[self printPuzzle:currentPuzzle];
	self.puzzleRowNumber = delegate.currentPuzzle.matrixRows;
	self.puzzleColNumber = delegate.currentPuzzle.matrixCols;
	GlobalConfiguration *configuration = [self getConfiguration];
	//
	CGFloat widthOfMatrix = self.puzzleColNumber*configuration.widthOfCell+(self.puzzleColNumber+1)*configuration.marginOfRow;
	CGFloat heightOfMatrix = self.puzzleRowNumber*configuration.heightOfCell+(self.puzzleRowNumber+1)*configuration.marginOfCol;
	//rec origin is the lower left of the rect
	self.matrixRect = CGRectMake(self.matrixCenter.x-widthOfMatrix/2, self.matrixCenter.y-heightOfMatrix/2, widthOfMatrix, heightOfMatrix);
	DebugLog(@"matrix rect x=%f y=%f width=%f height=%f",self.matrixRect.origin.x,self.matrixRect.origin.y,self.matrixRect.size.width,self.matrixRect.size.height);
	DebugLog(@"Leaving viewHelper.refreshPuzzle");
	//initialize the display matrix
	for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
			displayMatrixX[i][j]=-1;
			displayMatrixY[i][j]=-1;
		}
	}
	//calculate the center of each cell and put in the display matrix
	for(int i=0;i<self.puzzleRowNumber;i++){
		for(int j=0;j<self.puzzleColNumber;j++){
			CGPoint centerOfCell = [self getCenterOfCellAtRow:i AndCol:j];
			displayMatrixX[i][j]=centerOfCell.x;
			displayMatrixY[i][j]=centerOfCell.y;
		}
	}
	
	NSString *s = [[NSString alloc] initWithFormat:@"%i",[self.userSteps count]];
	self.stepsTaken.text=s;
	[s release];
	NSString *temp = [[NSString alloc] initWithFormat:@"%i",[delegate.currentPuzzle.solutionSteps count]];
	self.puzzlePar.text=temp;
	[temp release];
	DebugLog(@"PuzzleViewHelper.refreshPuzzle:ends");
}

- (void)loadSolutionStepsToUserSteps{
	if(self.userSteps!=nil){
		[self.userSteps removeAllObjects];
	}
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	Puzzle *currentPuzzle = delegate.currentPuzzle;
	if(currentPuzzle.solutionSteps!=nil && [currentPuzzle.solutionSteps count]>0){
		DebugLog(@"loading %i solution steps to user steps", [currentPuzzle.solutionSteps count]);
		for(int i=[currentPuzzle.solutionSteps count]-1;i>=0;i--){
			NSString *solutionString = [currentPuzzle.solutionSteps objectAtIndex:i];
			int x1 = [[solutionString substringWithRange:NSMakeRange(0, 1)] intValue];
			int y1 = [[solutionString substringWithRange:NSMakeRange(1, 1)]  intValue];
			int x2 = [[solutionString substringWithRange:NSMakeRange(2, 1)] intValue];
			int y2 = [[solutionString substringWithRange:NSMakeRange(3, 1)]  intValue];
			
			NSString *userStepString = [[NSString alloc] initWithFormat:@"%i%i%i%i",x2,y2,x1,y1];
			[self.userSteps addObject:userStepString];
			[userStepString release];
		}
	}
}


- (void)savePuzzlePlayState{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delegate.selectedPuzzleId==nil){
		return;
	}
	if(delegate.currentPuzzle==nil){
		return;
	}
	if(![delegate.allPuzzles containsObject:delegate.currentPuzzle.name]){
		//may deleted from the design page
		return;
	}
	//save it regardless user steps
	//	if(self.userSteps==nil || [self.userSteps count]<1){
	//		return;
	//	}
	DebugLog(@"saving the puzzle state of %@", delegate.currentPuzzle.name);
	NSMutableArray *keys = [[NSMutableArray alloc] init];
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	[keys addObject:@"puzzle-id"];
	[objects addObject:delegate.currentPuzzle.name];
	[keys addObject:@"user-steps"];
	[objects addObject:self.userSteps];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	//save file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *path = [documentDirectory stringByAppendingPathComponent:@"puzzle-play-state.dat"];
	
	DebugLog(@"saving play state to %@", path);
	[dictionary writeToFile:path atomically:YES];
	[keys removeAllObjects];
	[objects removeAllObjects];
	[keys release];
	[objects release];
}

- (void)printPuzzle:(Puzzle*)currentPuzzle{
	//first print puzzle data
	[WordWizardPuzzleHelper printPuzzle:currentPuzzle];
	if(currentPuzzle!=nil && [currentPuzzle dataMatrix]!=nil){
		DebugLog(@"display matrix----");
		for(int i=0;i<[currentPuzzle matrixRows];i++){
			NSMutableString *s = [[NSMutableString alloc] initWithString:@""];
			for(int j=0;j<[currentPuzzle matrixCols];j++){
				NSString *displayLetter = [self getDisplayonRow:i AndCol:j OfPuzzle:currentPuzzle];
				[s appendFormat:@"%@ %",displayLetter];
			}
			DebugLog(@"%@",s);
			[s release];
		}
	}
	
}



//-------------------------------------------------------
// drawing
//
//
//-------------------------------------------------------

//draw the puzzle data - rows and cols, not the matrix boundry
- (void)drawPuzzle:(Puzzle*)currentPuzzle{
	DebugLog(@"WordWizardPuzzleViewHelper.drawPuzzle:starts");
	//[self printPuzzle:currentPuzzle];
	
	for(int i=0; i<[currentPuzzle matrixRows];i++){
		
		for(int j=0; j<[currentPuzzle matrixCols];j++){
			[self drawDataAtRow:i AndCol:j ofPuzzle:currentPuzzle];
		}
	}
	DebugLog(@"WordWizardPuzzleViewHelper.drawPuzzle:ends");
}

//draw the matrix boundry and paint internal area
-(void)drawMatrixBoundry{
	DebugLog(@"viewHeper.drawMatrixBoundry:starts");
	GlobalConfiguration *configuration = [self getConfiguration];
	CGContextRef context = UIGraphicsGetCurrentContext();
	//	CGContextSaveGState(context);
	//draw frame
	CGContextSetLineWidth(context, configuration.boundryWidth);
	CGContextSetStrokeColorWithColor(context, configuration.matrixBoundryColor.CGColor);
	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextAddRect(context, CGRectMake(self.matrixRect.origin.x-configuration.boundryWidth/2, self.matrixRect.origin.y-configuration.boundryWidth/2, self.matrixRect.size.width+configuration.boundryWidth, self.matrixRect.size.height+configuration.boundryWidth));
	CGContextDrawPath(context, kCGPathFillStroke);
	//	CGContextFillRect();
	//	UIRectFrame( CGRectMake(self.matrixRect.origin.x-configuration.boundryWidth/2, self.matrixRect.origin.y-configuration.boundryWidth/2, self.matrixRect.size.width+configuration.boundryWidth, self.matrixRect.size.height+configuration.boundryWidth));
	//draw matrix internal area
	//	CGContextSetLineWidth(context, 1.0f);
	//	CGContextSetStrokeColorWithColor(context, configuration.matrixInternalColor.CGColor);
	CGContextSetFillColorWithColor(context, configuration.matrixInternalColor.CGColor);
	//	CGContextAddRect(context, CGRectMake(self.matrixRect.origin.x, self.matrixRect.origin.y, self.matrixRect.size.width, self.matrixRect.size.height));
	//	CGContextDrawPath(context, kCGPathFillStroke);
	UIRectFill(CGRectMake(self.matrixRect.origin.x, self.matrixRect.origin.y, self.matrixRect.size.width, self.matrixRect.size.height));
	
	//	CGContextRestoreGState(context);
	DebugLog(@"viewHeper.drawMatrixBoundry:ends");
}

//draw a cell with image
- (void)drawCellInRect:(CGRect)rectOfCell WithImage:(UIImage*)image InRect:(CGRect)rectOfLetter{
	[image drawInRect:rectOfLetter];
}

//draw a cell with letter string
- (void)drawCellInRect:(CGRect)rectOfCell WithLetter:(NSString*)letter InRect:(CGRect)rectOfLetter{
	GlobalConfiguration *configuration = [self getConfiguration];
	
	[configuration.imageBackground drawInRect:rectOfCell];
	CGContextRef context = UIGraphicsGetCurrentContext();
	//	CGContextSaveGState(context);
	CGContextSetFillColorWithColor(context,  [UIColor whiteColor].CGColor);
	[letter drawInRect:rectOfLetter withFont:configuration.letterFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	//	CGContextRestoreGState(context);
}

//clear a cell with screen color
- (void)drawScreenBackgroundInRect:(CGRect)rect{
	
	//[delegate.configuration.screenBackground drawInRect:self.frame];
	GlobalConfiguration *configuration = [self getConfiguration];
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//	CGContextSaveGState(context);
	//	float lineWidth=1.0f;
	//	CGContextSetLineWidth(context, lineWidth);
	//	CGContextSetStrokeColorWithColor(context, configuration.screenBackgroundColor.CGColor);
	CGContextSetFillColorWithColor(context,  configuration.screenBackgroundColor.CGColor);
	//	CGContextAddRect(context,rect);
	//	CGContextDrawPath(context, kCGPathFillStroke);
	//	CGContextRestoreGState(context);
	UIRectFill(rect);
}

//clear a cell with matrix internal color
- (void)drawMatrixBackgroundColorInRect:(CGRect)rect{	
	//[delegate.configuration.screenBackground drawInRect:self.frame];
	GlobalConfiguration *configuration = [self getConfiguration];
	CGContextRef context = UIGraphicsGetCurrentContext();
	//	CGContextSaveGState(context);
	//	float lineWidth=1.0f;
	//	CGContextSetLineWidth(context, lineWidth);
	//	CGContextSetStrokeColorWithColor(context, configuration.matrixInternalColor.CGColor);
	CGContextSetFillColorWithColor(context,  configuration.matrixInternalColor.CGColor);
	//CGContextAddRect(context,rect);
	//	CGContextDrawPath(context, kCGPathFillStroke);
	//	CGContextRestoreGState(context);
	UIRectFill(rect);
}

//draw a matrix data - space, stone or letter
- (void)drawDataAtRow:(int)row AndCol:(int)col ofPuzzle:(Puzzle*)currentPuzzle{
	if(row>=0 && row<currentPuzzle.matrixRows && col>=0 && col<currentPuzzle.matrixCols){
		NSString *data = [[[currentPuzzle dataMatrix] objectAtIndex:row]  objectAtIndex:col];
		NSString *displayletter = [[currentPuzzle displayMap] valueForKey:data];
		DebugLog(@"displaying %i %i %@ %@", row, col, data, displayletter);
		if([data caseInsensitiveCompare:@"#"]==0 || [displayletter caseInsensitiveCompare:@"#"] == 0){
			//space display nothing
		}else if([data caseInsensitiveCompare:@"^"]==0 || [displayletter caseInsensitiveCompare:@"^"] == 0){
			//stone, display pic
			//[self drawImage:configuration.stoneImage AsNumberX:row AsNumberY:col];
			[self drawStoneAtRow:row AndCol:col];
		}else{
			[self drawOneLetter:displayletter AsNumberX:row AsNumberY:col];
		}
	}
}

//draw a stone
-(void)drawStoneAtRow:(int)row AndCol:(int)col{
	if(displayMatrixX[row][col]==-1){
		return;
	}
	GlobalConfiguration *configuration = [self getConfiguration];
	CGPoint centerOfCell = CGPointMake(displayMatrixX[row][col], displayMatrixY[row][col]);
	CGRect rectOfCell = CGRectMake(centerOfCell.x-configuration.widthOfCell/2, centerOfCell.y-configuration.heightOfCell/2, configuration.widthOfCell, configuration.heightOfCell);
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextSaveGState(context);
	//	float lineWidth=2.0f;
	//	CGContextSetLineWidth(context, lineWidth);
	//	CGContextSetStrokeColorWithColor(context, configuration.matrixBoundryColor.CGColor);
	CGContextSetFillColorWithColor(context,  configuration.matrixBoundryColor.CGColor);
	//CGContextAddRect(context,rectOfCell);
	//	CGContextDrawPath(context, kCGPathFillStroke);
	//	CGContextRestoreGState(context);
	
	UIRectFill(rectOfCell);
}

- (void)drawImage:(UIImage *)image AsNumberX:(int)row AsNumberY:(int)col{
	if(displayMatrixX[row][col]==-1){
		return;
	}
	GlobalConfiguration *configuration = [self getConfiguration];
	CGPoint centerOfCell = CGPointMake(displayMatrixX[row][col], displayMatrixY[row][col]);
	CGRect rectOfCell = CGRectMake(centerOfCell.x-configuration.widthOfCell/2, centerOfCell.y-configuration.heightOfCell/2, configuration.widthOfCell, configuration.heightOfCell);
	[self drawCellInRect:rectOfCell WithImage:image InRect:rectOfCell];
}

- (void)drawOneLetter:(NSString *)letter AsNumberX:(int)row AsNumberY:(int)col{
	if(displayMatrixX[row][col]==-1){
		return;
	}
	GlobalConfiguration *configuration = [self getConfiguration];
	CGPoint centerOfCell = CGPointMake(displayMatrixX[row][col], displayMatrixY[row][col]);
	CGRect rectOfCell = CGRectMake(centerOfCell.x-configuration.widthOfCell/2, centerOfCell.y-configuration.heightOfCell/2, configuration.widthOfCell, configuration.heightOfCell);
	CGRect rectOfLetter = CGRectMake(centerOfCell.x-configuration.widthOfLetter/2, centerOfCell.y-configuration.heightOfLetter/2, configuration.widthOfLetter, configuration.heightOfLetter);
	[self drawCellInRect:rectOfCell WithLetter:letter InRect:rectOfLetter];
}



//--------------------------------------------------------
// matrix helper functions
//
//
//
//--------------------------------------------------------

- (CGRect)getCoveredRectBetweenRow1:(int)row1 Col1:(int)col1 Row2:(int)row2 Col2:(int)col2{
	CGPoint upleft1 = [self getTopLeftPointOfCellAtRow:row1 AndCol:col1];
	CGPoint upleft2 = [self getTopLeftPointOfCellAtRow:row2 AndCol:col2];
	CGPoint lowerRight1 = [self getLowerRightPointOfCellAtRow:row1 AndCol:col1];
	CGPoint lowerRight2 = [self getLowerRightPointOfCellAtRow:row2 AndCol:col2];
	CGRect rect = CGRectMake(min(upleft1.x, upleft2.x), min(upleft1.y, upleft2.y), max(lowerRight1.x, lowerRight2.x)-min(upleft1.x, upleft2.x), max(lowerRight1.y, lowerRight2.y)-min(upleft1.y, upleft2.y));
	return rect;
}

- (CGPoint)getCenterOfCellAtRow:(int)row AndCol:(int)col{
	GlobalConfiguration *configuration = [self getConfiguration];
	
	return CGPointMake(self.matrixRect.origin.x+col*(configuration.widthOfCell+configuration.marginOfRow)+configuration.marginOfRow+configuration.widthOfCell/2, self.matrixRect.origin.y+row*(configuration.heightOfCell+configuration.marginOfCol)+configuration.marginOfCol+configuration.heightOfCell/2);
	
}
- (CGPoint)getTopLeftPointOfCellAtRow:(int)row AndCol:(int)col{
	GlobalConfiguration *configuration = [self getConfiguration];
	//return CGPointMake(self.matrixRect.origin.x+col*(configuration.widthOfCell+configuration.marginOfRow)+configuration.marginOfRow, self.matrixRect.origin.y+row*(configuration.heightOfCell+configuration.marginOfCol)+configuration.marginOfCol);
	CGPoint center = [self getCenterOfCellAtRow:row AndCol:col];
	return CGPointMake(center.x-configuration.widthOfCell/2, center.y-configuration.heightOfCell/2);
}

- (CGPoint)getLowerRightPointOfCellAtRow:(int)x AndCol:(int)col{
	GlobalConfiguration *configuration = [self getConfiguration];
	CGPoint center = [self getCenterOfCellAtRow:x AndCol:col];
	return CGPointMake(center.x+configuration.widthOfCell/2, center.y+configuration.heightOfCell/2);
	
}
- (id)getDisplayDataOnKey:(id)key OfPuzzle:(Puzzle*)currentPuzzle{
	id displayData = [[currentPuzzle displayMap] valueForKey:key];
	if(displayData == nil){
		DebugLog(@"cound not find display data for key %@", key);
	}
	return displayData;
}

-(id)getDataOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle{
	if(row<0 || col<0){
		DebugLog(@"row or col less than 0 when calling getDataOnRow");
		return nil;
	}
	if(row>=[[currentPuzzle dataMatrix] count]){
		DebugLog(@"row %i is beyond matrix size %i", row, [[currentPuzzle dataMatrix] count]);
		return nil;
	}
	if(col>=[[[currentPuzzle dataMatrix] objectAtIndex:row] count]){
		DebugLog(@"col %i is beyong matrix size %i", col, [[[currentPuzzle dataMatrix] objectAtIndex:row] count]);
		return nil;
	}
	return [[[currentPuzzle dataMatrix] objectAtIndex:row] objectAtIndex:col];
}

-(id)getDisplayonRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle{
	return [self getDisplayDataOnKey:[self getDataOnRow:row AndCol:col OfPuzzle:currentPuzzle] OfPuzzle:currentPuzzle];
}

- (Boolean)isSpaceOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle{
	if(([@"#" compare:[self getDisplayonRow:row AndCol:col OfPuzzle:currentPuzzle]]==0) || ([@"#" compare:[self getDataOnRow:row AndCol:col OfPuzzle:currentPuzzle]]==0)){
		return YES;
	}else{
		return NO;
	}
}

- (Boolean)isStoneOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle{
	if(([@"^" compare:[self getDisplayonRow:row AndCol:col OfPuzzle:currentPuzzle]]==0) || ([@"^" compare:[self getDataOnRow:row AndCol:col OfPuzzle:currentPuzzle]]==0)){
		return YES;
	}else{
		return NO;
	}
}
- (Boolean)isNeighborToSpaceAtRow:(int)tX AndCol:(int)tY OfPuzzle:(Puzzle*)currentPuzzle{
	if(tX>=1 && ([@"#" compare:[self getDataOnRow:(tX-1) AndCol:tY OfPuzzle:currentPuzzle]]==0)){
		return YES;
	}else if(tY+1<[currentPuzzle matrixRows] && ([@"#" compare:[self getDataOnRow:tX AndCol:(tY+1) OfPuzzle:currentPuzzle]]==0)){
		return YES;
	}else if(tX+1<[currentPuzzle matrixCols] && ([@"#" compare:[self getDataOnRow:(tX+1) AndCol:tY OfPuzzle:currentPuzzle]]==0)){
		return YES;
	}else if(tY>=1 && ([@"#" compare:[self getDataOnRow:tX AndCol:(tY-1) OfPuzzle:currentPuzzle]]==0)){
		return YES;
	}else{
		return NO;
	}
}

- (Boolean)areTheyNeighborAtRow1:(int)row1 AndCol1:(int)col1 AndRow2:(int)row2 Andcol2:(int)col2 OfPuzzle:(Puzzle*)currentPuzzle{
	//there are only 4 possibilities
	if(row1==row2){
		if((col1==col2+1) || (col1==col2-1)){
			return YES;
		}else{
			return NO;
		}
	}else if(col1==col2){
		if((row1==row2+1) || (row1==row2-1)){
			return YES;
		}else{
			return NO;
		}
	}else{
		return NO;
	}
}

- (Boolean)isValidOnRow:(int)row AndCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle{
	if(row>=0 && row<[currentPuzzle matrixRows] && col>=0 && col<[currentPuzzle matrixCols]){
		return YES;
	}else{
		return NO;
	}
}



//-----------------------------------------------------
// animation of undo, redo, show-me
//
//
//
//-----------------------------------------------------

-(void)redrawPlease{
	DebugLog(@"PuzzleViewHelper.redrawPlease:starts");
	[self setNeedsDisplay];
	DebugLog(@"PuzzleViewHelper.redrawPlease:ends");
}

- (void)redrawPleaseInRect:(id)rect{
//	[self  setNeedsDisplayInRect:rect];
	@throw [NSException exceptionWithName:@"abstract method redrawPleaseInRect" reason:@"abstract method redrawPleaseInRect" userInfo:nil];

}
- (Boolean)onTouchBegin:(CGPoint) touchedPoint isUndo:(Boolean)isUndo{
	@throw [NSException exceptionWithName:@"abstract method onTouchBegin" reason:@"abstract method onTouchBegin" userInfo:nil];

}
- (Boolean)onTouchMove:(CGPoint) touchedPoint isUndo:(Boolean)isUndo{
	@throw [NSException exceptionWithName:@"abstract method onTouchMove" reason:@"abstract method onTouchMove" userInfo:nil];

}
- (void)onTouchEnd:(CGPoint) touchedPoint isUndo:(Boolean)isUndo{
	@throw [NSException exceptionWithName:@"abstract method onTouchEnd" reason:@"abstract method onTouchEnd" userInfo:nil];

}




- (void)undoStep{
	if(!self.allowTouch){
		return;
	}
	NSString *stepString = [userSteps lastObject];
	if(stepString!=nil){
		DebugLog(@"undo step %@", stepString);
		int x1 = [[stepString substringWithRange:NSMakeRange(0, 1)] intValue];
		int y1 = [[stepString substringWithRange:NSMakeRange(1, 1)]  intValue];
		int x2 = [[stepString substringWithRange:NSMakeRange(2, 1)] intValue];
		int y2 = [[stepString substringWithRange:NSMakeRange(3, 1)]  intValue];
		DebugLog(@"from %i %i to %i %i",x2,y2,x1,y1);
		NSString *step = [[NSString alloc] initWithFormat:@"%i%i%i%i",x2,y2,x1,y1];
		NSMutableArray *steps = [NSMutableArray arrayWithObject:step];
		[step release];
		
		
		[NSThread detachNewThreadSelector:@selector(animateUndo:) toTarget:self withObject:steps]; 
		
		//[self autoMoveFromRow:x2 Col:y2 ToRow:x1 Col:y1 isUndo:YES];
		NSString *undoStep = [[NSString alloc] initWithString:stepString];
		[undoSteps addObject:undoStep];
		[undoStep release];
		[userSteps removeLastObject];
		//		self.callerView.stepsTaken.text=[NSString stringWithFormat:@"%i",[userSteps count]];
		DebugLog(@"current user step %i", [userSteps count]);
	}
	
}
- (void)redoStep{
	if(!self.allowTouch){
		return;
	}
	NSString *stepString = [undoSteps lastObject];
	if(stepString!=nil){
		DebugLog(@"redo step %@", stepString);
		NSMutableArray *steps =[NSMutableArray arrayWithObject:stepString];
		
		[NSThread detachNewThreadSelector:@selector(animate:) toTarget:self withObject:steps]; 
		
		//		[self autoMoveFromRow:x1 Col:y1 ToRow:x2 Col:y2  isUndo:NO];
		[undoSteps removeLastObject];
		
	}
	
}


- (void)showMe:(int)stepNum{
	if(!self.allowTouch){
		return;
	}
	//first re-initiate the matrix
	DebugLog(@"PuzzleViewHelper.showMe:starts");
	[self refreshPuzzle];
	
	
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delegate.currentPuzzle.solutionSteps!=nil && [delegate.currentPuzzle.solutionSteps count]>0){
		//show me only show first 1/5 steps
		
		//self.tempSolutionsCopy = [NSMutableArray arrayWithArray:delegate.currentPuzzle.solutionSteps];
		NSMutableArray *steps = [NSMutableArray array];
		
		for(int i=0;i<stepNum;i++){
			[steps addObject:[delegate.currentPuzzle.solutionSteps objectAtIndex:i]];
		}
		
		//[self startTimer];
		[NSThread detachNewThreadSelector:@selector(animate:) toTarget:self withObject:steps]; 
		//[self animate];
		
	}
	
	DebugLog(@"PuzzleViewHelper.showMe:ends");
}

- (void)blockTouchEvent{
	DebugLog(@"blocking touch event now");
	PuzzleView *view = (PuzzleView*)self;
	[view setAllowTouch:NO];
	DebugLog(@"ViewHelper.blockTouchEvent:setting allow touch NO");
}

- (void)openTouchEvent{
	DebugLog(@"opening touch event now");
	PuzzleView *view = (PuzzleView*)self;
	[view setAllowTouch:YES];
	DebugLog(@"VieHelper.openTouchEvent:setting allow touch YES");
}

-(void)animate:(id)object{
	NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	//[[self callerView] setNeedsDisplay];
	[self performSelectorOnMainThread:@selector(redrawPlease) withObject:nil waitUntilDone:YES];
	
	DebugLog(@"PuzzleViewHelper.animate:starts");
	[self blockTouchEvent];
	
	NSMutableArray *steps = (NSMutableArray*)object;
    [self animateSteps:steps isUndo:NO];    
	
	[self openTouchEvent];
	
	//
	DebugLog(@"is it success?");
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if([WordWizardPuzzleHelper isTotalCompleteOfPuzzle:delegate.currentPuzzle]){
		DebugLog(@"sure it is success");
		//display hint
		if(delegate.currentPuzzle.hint!=nil && [delegate.currentPuzzle.hint compare:@""]!=0){
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																message:delegate.currentPuzzle.hint
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
													  otherButtonTitles:nil,nil];
			
			//alertView.opaque=NO;

			[alertView show];
//			[UIView beginAnimations:nil context:nil];
//			[UIView setAnimationDuration:5];
//			alertView.hidden=YES;
//			[UIView commitAnimations];
			[alertView release];
		}else{
			//no ending, then display default message
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																message:NSLocalizedString(@"Puzzle Solved!",@"Puzzle Solved!")
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
													  otherButtonTitles:nil,nil];
			
			
			[alertView show];

			[alertView release];
		}
		
	}
	DebugLog(@"PuzzleViewHelper.animate:ends");
	[p release];
}  

-(void)animateUndo:(id)object{
	NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	DebugLog(@"PuzzleViewHelper.animate:starts");
	[self blockTouchEvent];
	
    NSMutableArray *steps = (NSMutableArray*)object;
    [self animateSteps:steps isUndo:YES];      
    
	[self openTouchEvent];
	//
	DebugLog(@"is it success?");
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if([WordWizardPuzzleHelper isTotalCompleteOfPuzzle:delegate.currentPuzzle]){
		DebugLog(@"sure it is success");
		//display hint
		
		if(delegate.currentPuzzle.hint!=nil && [delegate.currentPuzzle.hint compare:@""]!=0){
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																message:delegate.currentPuzzle.hint
															   delegate:self
													  cancelButtonTitle:@"Ok"
													  otherButtonTitles:nil,nil];
			alertView.opaque=YES;
			[alertView show];
			[alertView release];
		}else{
			//no ending, then display default message
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																message:NSLocalizedString(@"Puzzle Solved!",@"Puzzle Solved!")
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
													  otherButtonTitles:nil,nil];
			
			
			[alertView show];
			
			[alertView release];
		}
		
	}
	DebugLog(@"PuzzleViewHelper.animateUndo:ends");
	[p release];
}  

-(void)animateSteps:(NSMutableArray*)steps isUndo:(Boolean)isUndo{
	DebugLog(@"PuzzleViewHelper.animateSteps:starts");
	
	while([steps count]>0){
        //[NSThread sleepForTimeInterval:1]; //30 FPS
		//[self showOneStep];
        //[self performSelectorOnMainThread:@selector(showOneStep) withObject:nil waitUntilDone:YES];
		NSString *stepString =[steps objectAtIndex:0];
		
		int x1 = [[stepString substringWithRange:NSMakeRange(0, 1)] intValue];
		int y1 = [[stepString substringWithRange:NSMakeRange(1, 1)]  intValue];
		int x2 = [[stepString substringWithRange:NSMakeRange(2, 1)] intValue];
		int y2 = [[stepString substringWithRange:NSMakeRange(3, 1)]  intValue];
		DebugLog(@"show me:from %i %i to %i %i",x1,y1,x2,y2);
		[self autoMoveFromRow:x1 Col:y1 ToRow:x2 Col:y2 isUndo:isUndo];
		
		[steps  removeObjectAtIndex:0];
		
    }
	
	DebugLog(@"PuzzleViewHelper.animateSteps:ends");
}

- (void)autoMoveFromRow:(int)row1 Col:(int)col1 ToRow:(int)row2 Col:(int)col2 isUndo:(Boolean)undo{
	
	DebugLog(@"PuzzleViewHelper:autoMoveFromRow: starts [%i,%i] to [%i,%i]", row1, col1, row2, col2);
	//get the start center
	CGPoint centerOfStart = [self getCenterOfCellAtRow:row1 AndCol:col1];
	//get the dest center
	CGPoint centerOfDest = [self getCenterOfCellAtRow:row2 AndCol:col2];
	//issue series of begin, move, and end events
	[self onTouchBegin:centerOfStart isUndo:undo];
	int moveDirection=-1;
	int delta = abs(centerOfDest.x-centerOfStart.x);
	if(delta==0 || delta<4){
		delta = abs(centerOfDest.y-centerOfStart.y);
		//move vertically
		if(centerOfDest.y<centerOfStart.y){
			//up
			moveDirection=2;
		}else{
			//down
			moveDirection=3;
		}
	}else{
		//move horizonally
		if(centerOfDest.x<centerOfStart.x){
			//left
			moveDirection=0;
		}else{
			//right
			moveDirection=1;
		}
	}
	//send a series of onMove events
	DebugLog(@"delta=%i",delta);
	float speedFactor = 1.5;
	for(int i=0;i<delta/speedFactor-1;i++){
		DebugLog(@"step %i of delta %i", i, delta);
		CGPoint movePoint;
		if(moveDirection==0){
			//left
			movePoint = CGPointMake(centerOfStart.x-speedFactor*i, centerOfDest.y);
		}else if(moveDirection==1){
			//right
			movePoint = CGPointMake(centerOfStart.x+speedFactor*i, centerOfDest.y);
		}else if(moveDirection==2){
			//up
			movePoint = CGPointMake(centerOfDest.x, centerOfStart.y-speedFactor*i);
		}else if(moveDirection==3){
			//down
			movePoint = CGPointMake(centerOfDest.x, centerOfStart.y+speedFactor*i);
		}
		[self onTouchMove:movePoint isUndo:undo];
		//update affected area
		
		[self performSelectorOnMainThread:@selector(redrawPleaseInRect:) withObject:nil waitUntilDone:NO];
		[NSThread sleepForTimeInterval:0.01];
	}
	[self onTouchEnd:centerOfDest isUndo:undo];
	[self performSelectorOnMainThread:@selector(redrawPlease) withObject:nil waitUntilDone:NO];
	[NSThread sleepForTimeInterval:0.05];
	DebugLog(@"PuzzleViewHelper:autoMoveFromRow: ends");
}

@end
