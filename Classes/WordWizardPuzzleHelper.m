//
//  WordWizardPuzzleHelper.m
//  WizardView
//
//  Created by Junqiang You on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WordWizardPuzzleHelper.h"
#import "Puzzle.h"

@implementation WordWizardPuzzleHelper
+ (Boolean)isRowComplete:(NSArray*)row OfPuzzle:(Puzzle*)currentPuzzle{
	NSMutableString *s = [[NSMutableString alloc] initWithString:@""];
	//check each letter
	for(int i=0;i<[row count];i++){
		NSString *displayLetter = [currentPuzzle.displayMap objectForKey:[row objectAtIndex:i]];
		if([[row objectAtIndex:i] compare:@"#"]==0 || [[row objectAtIndex:i] compare:@"^"]==0){
			continue;
		}
		if([displayLetter compare:@"#"]==0 || [displayLetter compare:@"^"]==0){
			continue;
		}
		[s appendFormat:@"%@", displayLetter];
	}
	
	//compare with the complete data
	Boolean found=NO;
	for(int j=0;j<[currentPuzzle.completeData count];j++){
		if([s caseInsensitiveCompare:[currentPuzzle.completeData objectAtIndex:j]]==0){
			found=YES;
			break;
		}
	}
	[s release];
	if(!found){
			return NO;
		}
	
	return YES;

}

+ (Boolean)isTotalCompleteOfPuzzle:(Puzzle*)currentPuzzle{
	Boolean result=YES;
	for(int i=0; i<[currentPuzzle matrixRows];i++){
		NSMutableArray *row = [[currentPuzzle dataMatrix] objectAtIndex:i];
		if(![self isRowComplete:row OfPuzzle:currentPuzzle]){
			result=NO;
			break;
		}
		
	}
	if(result){
		DebugLog(@"puzzle complete");
	}
	return result;
}
- (void)dealloc {
	[super dealloc];
}
@end
