//
//  Puzzle.m
//  WizardView
//
//  Created by Junqiang You on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Puzzle.h"


@implementation Puzzle
@synthesize dataMatrix;
@synthesize displayMap;
@synthesize hint;
@synthesize solutionSteps;
@synthesize  matrixRows;
@synthesize  matrixCols;
@synthesize name;
@synthesize completeStrategy;
@synthesize completeData;
-(void)clear{
	if(self.dataMatrix!=nil){
		[self.dataMatrix removeAllObjects];
	}
	if(self.solutionSteps!=nil){
		[self.solutionSteps removeAllObjects];
	}
	if(self.displayMap!=nil){
		[self.displayMap removeAllObjects];
	}
	self.matrixRows=0;
	self.matrixCols=0;
	if(self.name!=nil){
		self.name=@"";
	}
	if(self.hint!=nil){
		self.hint=@"";
	}
	if(self.completeStrategy!=nil){
		self.completeStrategy = @"DISPLAY";
	};
	if(self.completeData!=nil){
		[self.completeData removeAllObjects];
	}
}
- (void)dealloc {
	if(self.dataMatrix!=nil){
		[self.dataMatrix removeAllObjects];
		[self.dataMatrix release];
		self.dataMatrix = nil;
	}
	if(self.solutionSteps!=nil){
		[self.solutionSteps removeAllObjects];
		[self.solutionSteps release];
		self.solutionSteps=nil;
	}
	if(self.displayMap!=nil){
		[self.displayMap removeAllObjects];
		[self.displayMap release];
		self.displayMap=nil;
	}
	if(self.name!=nil){
		[self.name release];
		self.name=nil;
	}
	if(self.hint!=nil){
		[self.hint release];
		self.hint=nil;
	}
	if(self.completeStrategy!=nil){
		[self.completeStrategy release];
		self.completeStrategy = nil;
	};
	if(self.completeData!=nil){
		[self.completeData removeAllObjects];
		[self.completeData release];
		self.completeData=nil;
	}
	[super dealloc];
}
@end
