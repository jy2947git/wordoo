//
//  PuzzleHelper.h
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Puzzle;
@interface PuzzleHelper : NSObject {


}


+(void)savePuzzle:(NSArray*)userSteps;
+ (Boolean)isTotalCompleteOfPuzzle:(Puzzle*)currentPuzzle;
+ (Boolean)isRowComplete:(NSArray*)row OfPuzzle:(Puzzle*)currentPuzzle;
+ (NSString *)getDisplayOfCellAtRow:(int)row AtCol:(int)col OfPuzzle:(Puzzle*)currentPuzzle;
+ (void)loadPuzzleToMemory:(NSString*)puzzleId;
+ (void)printPuzzle:(Puzzle*)puzzle;
+ (NSString*)getStandardPuzzleFilePath:(NSString*)fileName;
+ (NSString*)getCustomPuzzleFilePath:(NSString*)fileName;
+ (void)addAllStandardPuzzles:(NSMutableArray*)allPuzzles;
+ (void)addAllCustomizedPuzzles:(NSMutableArray*)allPuzzles;


+ (void)deleteCustomPuzzle:(NSString *)puzzleId;
+ (void)deleteAllCustomPuzzles;
@end
