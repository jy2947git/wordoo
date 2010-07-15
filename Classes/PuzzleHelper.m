//
//  PuzzleHelper.m
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PuzzleHelper.h"
#import "Puzzle.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"

@implementation PuzzleHelper




+ (void)populdatePuzzle:(Puzzle*)puzzle WithDictionary:(NSDictionary*)dictionary{
	if(puzzle==nil){
		return;
	}

	puzzle.name=[dictionary objectForKey:@"name"];
	puzzle.hint = [dictionary objectForKey:@"hint"];
	puzzle.completeStrategy=[dictionary objectForKey:@"complete-strategy"];
	NSMutableArray *c = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"complete-data"]];
	puzzle.completeData = c;
	[c release];
	NSMutableArray *s = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"solution-steps"]];
	puzzle.solutionSteps = s;
	[s release];
	puzzle.displayMap = [dictionary objectForKey:@"display-map"];
	NSMutableArray *d = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"matrix-data"]];
	puzzle.dataMatrix=d;
	[d release];
	
	puzzle.matrixRows=[puzzle.dataMatrix count];
	if(puzzle.matrixRows>0){
		puzzle.matrixCols=[[puzzle.dataMatrix objectAtIndex:0] count];
	}
}

+ (void)loadPuzzleToMemory:(NSString*)puzzleId{
	DebugLog(@"PuzzleHelper.loadPuzzleToMemory:starts %@", puzzleId);
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if([delegate currentPuzzle]!=nil){
		DebugLog(@"not the first time.");
		[delegate.currentPuzzle clear];
		
	}
	else{
		Puzzle *p = [[Puzzle alloc] init];
		delegate.currentPuzzle = p;
		[p release];
	}
	
	NSString *puzzleFileName = [[NSString alloc] initWithFormat:@"%@.pz",puzzleId];
	if([[NSFileManager defaultManager] fileExistsAtPath:[PuzzleHelper getStandardPuzzleFilePath:puzzleFileName]]){
		DebugLog(@"loadig puzzle from stanaard path");
		NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[PuzzleHelper getStandardPuzzleFilePath:puzzleFileName]];
		[PuzzleHelper populdatePuzzle:delegate.currentPuzzle WithDictionary:dictionary];
		[dictionary release];
	}else{
		DebugLog(@"loadig puzzle from custom path");
		NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[PuzzleHelper getCustomPuzzleFilePath:puzzleFileName]];
		[PuzzleHelper populdatePuzzle:delegate.currentPuzzle WithDictionary:dictionary];
		[dictionary release];
	}
	[puzzleFileName release];
	if(delegate.lastPuzzleId!=nil && [delegate.lastPuzzleId compare:puzzleId]==0 && delegate.lastTakenSteps!=nil && [delegate.lastTakenSteps count]>0){
		//update data matrix with last time progress
		DebugLog(@"updating puzzle with last progress data from file");
		for(int i=0;i<[delegate.lastTakenSteps count];i++){
			NSString *stepString =[delegate.lastTakenSteps objectAtIndex:i];
			
			int x1 = [[stepString substringWithRange:NSMakeRange(0, 1)] intValue];
			int y1 = [[stepString substringWithRange:NSMakeRange(1, 1)]  intValue];
			int x2 = [[stepString substringWithRange:NSMakeRange(2, 1)] intValue];
			int y2 = [[stepString substringWithRange:NSMakeRange(3, 1)]  intValue];
			NSString *temp = [[delegate.currentPuzzle.dataMatrix objectAtIndex:x1] objectAtIndex:y1];
			[[delegate.currentPuzzle.dataMatrix objectAtIndex:x1] replaceObjectAtIndex:y1 withObject:[[delegate.currentPuzzle.dataMatrix objectAtIndex:x2] objectAtIndex:y2]];
			[[delegate.currentPuzzle.dataMatrix objectAtIndex:x2] replaceObjectAtIndex:y2 withObject:temp];
		}
	}
	//[PuzzleHelper printPuzzle:delegate.currentPuzzle];
	DebugLog(@"PuzzleHelper.loadPuzzleToMemory:ends");
}


+ (void)printPuzzle:(Puzzle*)puzzle{
	DebugLog(@"puzzle:%@", puzzle.name);
	DebugLog(@"hint:%@", puzzle.hint);
	DebugLog(@"row=%i col=%i", puzzle.matrixRows, puzzle.matrixCols);
	DebugLog(@"complete strategy:%@", puzzle.completeStrategy);
	DebugLog(@"complte data---");
	if(puzzle.completeData!=nil){
		for(int i=0;i<[puzzle.completeData count];i++){
			DebugLog(@"%@", [puzzle.completeData objectAtIndex:i]);
		}
	}else{
		DebugLog(@"null");
	}
	DebugLog(@"data matrix----");
	if(puzzle.dataMatrix!=nil){
		for(int i=0;i<[puzzle.dataMatrix count];i++){
			NSMutableArray *x = [puzzle.dataMatrix objectAtIndex:i];
			NSMutableString *s = [[NSMutableString alloc] initWithString:@""];
			for(int j=0;j<[x count];j++){
				[s appendFormat:@"%@ %",[x objectAtIndex:j]];
			}
			DebugLog(@"%@",s);
			[s release];
		}
	}else{
		DebugLog(@"null");
	}
	DebugLog(@"solution steps---");
	if(puzzle.solutionSteps!=nil){
		
		for(int i=0;i<[puzzle.solutionSteps count];i++){
			DebugLog(@"%@", [puzzle.solutionSteps objectAtIndex:i]);
		}
	}else{
		DebugLog(@"null");
	}
	if(puzzle.displayMap!=nil){
		DebugLog(@"display dictionary---");
		for (id key in puzzle.displayMap){
			DebugLog(@"key: %@, value: %@", key, [puzzle.displayMap objectForKey:key]);
		}
	}

}
+(NSString *)getDisplayOfCellAtRow:(int)row AtCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle{
	NSString* key = [[currentPuzzle.dataMatrix objectAtIndex:row] objectAtIndex:col];
	NSString* obj =  [currentPuzzle.displayMap objectForKey:key];
	//DebugLog(@"find %@ for %@", obj , key);
	return obj;
}
+ (Boolean)isRowComplete:(NSArray*)row OfPuzzle:(Puzzle*)currentPuzzle{

	@throw [NSException exceptionWithName:@"abstract method isRowComplete" reason:@"abstract method isRowComplete" userInfo:nil];

}

+ (Boolean)isTotalCompleteOfPuzzle:(Puzzle*)currentPuzzle{

	@throw [NSException exceptionWithName:@"abstract method isTotalCompleteOfPuzzle" reason:@"abstract method isTotalCompleteOfPuzzle" userInfo:nil];

}


+ (NSString*)getStandardPuzzleFilePath:(NSString*)fileName{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *filePath = [delegate.configuration.standardPuzzleDirectory stringByAppendingPathComponent:fileName];
	return filePath;
}

+ (NSString*)getCustomPuzzleFilePath:(NSString*)fileName{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *filePath = [delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:fileName];

	return filePath;
}

+ (void)deleteAllCustomPuzzles{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *documentDirectory = delegate.configuration.customPuzzleDirectory;
	NSFileManager *fm = [NSFileManager defaultManager];
	DebugLog(@"looking up custom puzzles in %@", documentDirectory);
	NSArray *allFiles = [fm directoryContentsAtPath:documentDirectory];
	NSArray *fileExt = [[NSArray alloc] initWithObjects:@"pz", nil];
	NSArray *allPuzzleFiles = [allFiles pathsMatchingExtensions:fileExt];
	[fileExt release];
	if(allPuzzleFiles!=nil){
		NSString *fileName;
		for(fileName in allPuzzleFiles){
			[fm removeItemAtPath:[delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:fileName] error:nil];
		}
	}
}

+ (void)deleteCustomPuzzle:(NSString *)puzzleId{
	NSFileManager *fm = [NSFileManager defaultManager];
	DebugLog(@"deleting puzzle:%@", puzzleId);
	NSString *puzzleFileName = [[NSString alloc] initWithFormat:@"%@.pz",puzzleId];
	if([fm isDeletableFileAtPath:[self getCustomPuzzleFilePath:puzzleFileName]]){
		[fm removeItemAtPath:[self getCustomPuzzleFilePath:puzzleFileName] error:nil];
	}
	[puzzleFileName release];
	DebugLog(@"deleted!");
}
+ (void)addAllStandardPuzzles:(NSMutableArray*)allPuzzles{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *documentDirectory = delegate.configuration.standardPuzzleDirectory;
	DebugLog(@"looking up custom puzzles in %@", documentDirectory);
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *allFiles = [fm directoryContentsAtPath:documentDirectory];
	if(allFiles==nil){
		DebugLog(@"no files in directory %@", documentDirectory);
		return;
	}
	NSArray *fileExt = [[NSArray alloc] initWithObjects:@"pz", nil];
	NSArray *allPuzzleFiles = [allFiles pathsMatchingExtensions:fileExt];
	[fileExt release];
	if(allPuzzleFiles!=nil){
		NSString *fileName;
		for(fileName in allPuzzleFiles){
			[allPuzzles addObject:[fileName stringByReplacingOccurrencesOfString:@".pz" withString:@""]];
		}
	}
}

+ (void)addAllCustomizedPuzzles:(NSMutableArray*)allPuzzles{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *documentDirectory = delegate.configuration.customPuzzleDirectory;
	NSFileManager *fm = [NSFileManager defaultManager];
	DebugLog(@"looking up custom puzzles in %@", documentDirectory);
	NSArray *allFiles = [fm directoryContentsAtPath:documentDirectory];
	NSArray *fileExt = [[NSArray alloc] initWithObjects:@"pz", nil];
	NSArray *allPuzzleFiles = [allFiles pathsMatchingExtensions:fileExt];
	[fileExt release];
	if(allPuzzleFiles!=nil){
		NSString *fileName;
		for(fileName in allPuzzleFiles){
			[allPuzzles addObject:[fileName stringByReplacingOccurrencesOfString:@".pz" withString:@""]];
		}
	}
}



+(void)savePuzzle:(NSArray*)userSteps{
	DebugLog(@"entering designHelper.savePuzzle");
	//populdate solution steps by reverse the user-steps
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	Puzzle *currentPuzzle = delegate.currentPuzzle;
	if(currentPuzzle.solutionSteps!=nil){
		[currentPuzzle.solutionSteps removeAllObjects];
	}else{
		NSMutableArray *temp =  [[NSMutableArray alloc]init];
		currentPuzzle.solutionSteps= temp;
		[temp release];
	}
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
	NSMutableArray *keys = [[NSMutableArray alloc]init];
	NSMutableArray *objects = [[NSMutableArray alloc]init];
	[keys addObject:@"name"];
	[keys addObject:@"hint"];
	[keys addObject:@"complete-strategy"];
	[keys addObject:@"complete-data"];
	[keys addObject:@"matrix-data"];
	[keys addObject:@"solution-steps"];
	[keys addObject:@"display-map"];
	[objects addObject:currentPuzzle.name];
	[objects addObject:currentPuzzle.hint];
	[objects addObject:currentPuzzle.completeStrategy];
	[objects addObject:currentPuzzle.completeData];
	[objects addObject:currentPuzzle.dataMatrix];
	[objects addObject:currentPuzzle.solutionSteps];
	[objects addObject:currentPuzzle.displayMap];
	
	NSDictionary *puzzleDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	NSString *puzzleFileName = [[NSString alloc] initWithFormat:@"%@.pz",currentPuzzle.name];
	[puzzleDictionary writeToFile:[PuzzleHelper getCustomPuzzleFilePath:puzzleFileName] atomically:YES];
	[puzzleFileName release];
	[keys release];
	[objects release];
	[puzzleDictionary release];
	//[PuzzleHelper printPuzzle:currentPuzzle];
	DebugLog(@"NAME=[%@]",currentPuzzle.name);
	DebugLog(@"data=[%@]", currentPuzzle.completeData);
	DebugLog(@"file=[%@]", [NSString stringWithContentsOfFile:[PuzzleHelper getCustomPuzzleFilePath:puzzleFileName] encoding:NSUTF8StringEncoding error:nil]);
}
- (void)dealloc {
	[super dealloc];
}
@end
