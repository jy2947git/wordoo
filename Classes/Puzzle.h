//
//  Puzzle.h
//  WizardView
//
//  Created by Junqiang You on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Puzzle : NSObject {
	NSMutableArray *dataMatrix;
	NSMutableDictionary *displayMap;
	NSMutableArray *solutionSteps;
	NSString *hint;
	NSString *name;
	int matrixRows;
	int matrixCols;
	NSString *completeStrategy;
	NSMutableArray *completeData;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *dataMatrix;
@property (nonatomic, retain) NSMutableDictionary *displayMap;
@property (nonatomic, retain) NSString *hint;
@property (nonatomic, retain) NSMutableArray *solutionSteps;
@property (nonatomic, retain) NSString *completeStrategy;
@property (nonatomic, retain) NSMutableArray *completeData;
@property int matrixRows;
@property int matrixCols;
-(void)clear;

@end
