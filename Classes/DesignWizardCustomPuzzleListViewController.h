//
//  DesignWizardCustomPuzzleListViewController.h
//  WizardView
//
//  Created by Junqiang You on 3/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesignWiardPage1ViewController;
@class DesignWizardPage2ViewController;
@class DesignWizardViewPuzzleViewController;

@interface DesignWizardCustomPuzzleListViewController : UITableViewController  {
	//data source
	NSMutableArray *customPuzzles;
	UIImage *solvedImg;
	UIImage *unsolvedImg;


}
@property (nonatomic, retain) NSMutableArray *customPuzzles;

@property (nonatomic, retain) UIImage *solvedImg;
@property (nonatomic, retain) UIImage *unsolvedImg;

- (void)addButtonWasPressed;
- (void)addCustomPuzzle:(NSString*)puzzleId;
- (void)deletePuzzle:(NSString*)puzzleId;
-(void)applicationWillTerminate:(NSNotification *)notification;
@end
