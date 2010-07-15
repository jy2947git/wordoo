//
//  DesignHelper.m
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignHelper.h"
#import "WizardViewAppDelegate.h"
#import "Puzzle.h"

@implementation DesignHelper

-(void)savePuzzle:(NSArray*)userSteps{
	NSLog(@"entering designHelper.savePuzzle");
	//populdate solution steps by reverse the user-steps
	Puzzle *currentPuzzle = [self getCurrentWorkingPuzzle];
	if(userSteps!=nil){
		for(int i=[userSteps count]-1;i>=0;i--){
			NSString *s = [userSteps objectAtIndex:i];
			
			//reverse step x1 y1 x2 y2 -> x2 y2 x1 y1
			NSMutableString *rs = [[NSMutableString alloc]initWithString:@""];
			[rs appendFormat:@"%@%@",[s substringFromIndex:2],[s substringToIndex:2]];
			
			[[currentPuzzle solutionSteps] addObject:rs];
			[rs release];
		}
	}
	//save customized puzzle
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSMutableArray *puzzleDesc = [[NSMutableArray alloc]init];
	NSString *puzzleName = delegate.currentPuzzle.name;
	NSString *hint = delegate.currentPuzzle.hint;
	[puzzleDesc addObject:puzzleName];
	if(hint!=nil){
		[puzzleDesc addObject:hint];
	}
	//now save data matrix, solution steps and display dictionary
	[currentPuzzle.dataMatrix writeToFile:[PuzzleHelper getCustomPuzzleFilePath:[PuzzleHelper getPuzzleDataFileName:puzzleName]] atomically:YES];
	[currentPuzzle.solutionSteps writeToFile:[PuzzleHelper getCustomPuzzleFilePath:[PuzzleHelper getPuzzleSolutionStepsFileName:puzzleName]] atomically:YES];
	[currentPuzzle.displayMap writeToFile:[PuzzleHelper getCustomPuzzleFilePath:[PuzzleHelper getPuzzleDisplayMapFileName:puzzleName]] atomically:YES];
	//save the puzzle name and strings
	[puzzleDesc writeToFile:[PuzzleHelper getCustomPuzzleFilePath:[PuzzleHelper getPuzzleDescriptionFileName:puzzleName isStandard:NO]] atomically:YES];
	NSLog(@"final puzzle saved to %@", [PuzzleHelper getCustomPuzzleFilePath:[PuzzleHelper getPuzzleDescriptionFileName:puzzleName isStandard:NO]]);
	[puzzleDesc release];
	[PuzzleHelper printPuzzle:currentPuzzle];
}



- (id)initWithPuzzleId:(NSString*)puzzleId{
	NSLog(@"enter designHelper:initWithPuzzleid %@", puzzleId);
	if(puzzleId!=nil){
		return [super initWithPuzzleId:puzzleId];
	}
	//adding a new puzzle
	if((self = [super init])!=nil){
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		Puzzle *currentPuzzle = [self getCurrentWorkingPuzzle];
		
		//get the name and rows from shared delegate
		if(puzzleId==nil){
			NSLog(@"brand new puzzle to design");
			if(currentPuzzle==nil){
				currentPuzzle = [[Puzzle alloc] init];
				delegate.currentPuzzle = currentPuzzle;
			}
		}
		
		//refresh data matrix and solution steps
		if(currentPuzzle.solutionSteps==nil){
			currentPuzzle.solutionSteps = [[NSMutableArray alloc]init];
		}
		if(currentPuzzle.dataMatrix==nil){
			currentPuzzle.dataMatrix = [[NSMutableArray alloc] init];
		}
		//load puzzle from file (existing) or from delegate (new)
		[self loadPuzzle:puzzleId];
		
			//refresh display-lookup map from the first design page
			NSMutableArray *keys = [[NSMutableArray alloc] init];
			NSMutableArray *objects = [[NSMutableArray alloc] init];
			[keys addObject:@"#"];
			[objects addObject:@"#"];
		[keys addObject:@"^"];
		[objects addObject:@"^"];
		
			for(int i=1;i<[[delegate rows] count];i++){
				NSString *s = [[delegate rows] objectAtIndex:i];
				NSMutableString *key = nil;
				switch (i){
					case 1:
						key = [[NSMutableString alloc] initWithString:@"a"];
						break;
					case 2:
						key = [[NSMutableString alloc] initWithString:@"b"];
						break;
					case 3:
						key = [[NSMutableString alloc] initWithString:@"c"];
						break;
					case 4:
						key = [[NSMutableString alloc] initWithString:@"d"];
						break;
					case 5:
						key = [[NSMutableString alloc] initWithString:@"e"];
						break;
					default:
						NSLog(@"Unexpected Error!!!! brows of designed puzzle exceeds the limit of 5");
						break;
				}
				for(int j=0;j<[s length];j++){
					NSString *letter = [s substringWithRange:NSMakeRange(j, 1)];
					[keys addObject:[NSString stringWithFormat:@"%@%i",key,j]];
					[objects addObject:letter];
				
				}
				for(int j=[s length];j<[currentPuzzle matrixCols];j++){
					[keys addObject:[NSString stringWithFormat:@"%@%i",key,j]];
					[objects addObject:@"#"];
				}
				[key release];
			}
		
			currentPuzzle.displayMap = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
			[keys release];
			[objects release];
			
	}
	NSLog(@"leaving designHelper:initWithPuzzleId");
	return self;
}

- (void)loadPuzzle:(NSString*)puzzleId{
	NSLog(@"Enter designHelper:refreshPuzzle");
	NSLog(@"refreshing puzzle from memory or file with puzzle id %i", puzzleId);
	if(puzzleId!=nil){
		[super loadPuzzle:puzzleId];
		return;
	}
	//new
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delegate.currentPuzzle.solutionSteps!=nil){
		[delegate.currentPuzzle.solutionSteps removeAllObjects];
	}

	if(delegate.currentPuzzle.dataMatrix!=nil){
		[delegate.currentPuzzle.dataMatrix removeAllObjects];
	}
	//refresh puzzle with data in delegate if new
	delegate.currentPuzzle.name=[[delegate rows] objectAtIndex:0];
	delegate.currentPuzzle.matrixRows = 0;
	int maxcol=0;
	for(int i=1;i<[[delegate rows] count];i++){
		NSString *s = [[delegate rows] objectAtIndex:i];
		if(s==nil ||[s compare:@""]==0){
			continue;
		}
		delegate.currentPuzzle.matrixRows++;
		if([s length]>maxcol){
			maxcol=[s length];
		}
	}
	delegate.currentPuzzle.matrixCols = maxcol;
	for(int i=1;i<[[delegate rows] count];i++){
		NSString *s = [[delegate rows] objectAtIndex:i];
		if(s==nil ||[s compare:@""]==0){
			continue;
		}
		//NSLog(@"get user input row %@", s);
		NSMutableArray* keys = [[NSMutableArray alloc] init];

		for(int j=0;j<[s length];j++){
			NSMutableString *key = nil;
			switch (i){
				case 1:
					key = [[NSMutableString alloc] initWithString:@"a"];
					break;
				case 2:
					key = [[NSMutableString alloc] initWithString:@"b"];
					break;
				case 3:
					key = [[NSMutableString alloc] initWithString:@"c"];
					break;
				case 4:
					key = [[NSMutableString alloc] initWithString:@"d"];
					break;
				case 5:
					key = [[NSMutableString alloc] initWithString:@"e"];
					break;
				default:
					NSLog(@"unexpected error - matrix rows beyond limit of 5");
					break;
			}
			[key appendFormat:@"%i",j];
			
			[keys addObject:key];
			[key release];
		}
		//fill in those spaces
		for(int k=([s length]);k<delegate.currentPuzzle.matrixCols;k++){
			[keys addObject:@"#"];
		}
		
		[delegate.currentPuzzle.dataMatrix addObject:keys];
		[keys release];

	}
	[PuzzleHelper printPuzzle:delegate.currentPuzzle];
	NSLog(@"leaving designHelper.refreshPuzzle");
}

- (void)dealloc {
	[super dealloc];
}
@end
