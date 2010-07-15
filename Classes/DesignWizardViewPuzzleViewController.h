//
//  DesignWizardViewPuzzle.h
//  WizardView
//
//  Created by Junqiang You on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ALERT_TAGS {
	RESTART_TO_SAVED_STATE=997222,
	RESTART_TO_INITIAL_STATE=997223,
	DELETE_PUZZLE=997224,
	UPLOAD_PUZZLE=997225,
	RATE_PUZZLE=997226
};
@class DesignWizardCustomPuzzleListViewController;
@class DesignPuzzleView;
@interface DesignWizardViewPuzzleViewController : UIViewController <UIActionSheetDelegate>{
	IBOutlet UIBarButtonItem *ratingButton;
	IBOutlet DesignPuzzleView *puzzleView;
	IBOutlet UIBarButtonItem *uploadButton;
}

@property (nonatomic, retain) IBOutlet DesignPuzzleView *puzzleView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *ratingButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *uploadButton;
-(IBAction)undo:(id)sender;
-(IBAction)redo:(id)sender;

- (IBAction)savePuzzle:(id)sender;
- (IBAction)restartDesignPuzzle:(id)sender;
- (IBAction)reInitiateDesignPuzzle:(id)sender;
- (IBAction)deletePuzzle:(id)sender;
-(void)restartDesignPuzzleToSavedState;
-(void)restartDesignPuzzleToInitialState;
-(IBAction)emailPuzzle:(id)sender;
-(IBAction)uploadPuzzle:(id)sender;
- (void)uploadPuzzleToServer;
-(IBAction)playPuzzle:(id)sender;
-(IBAction)ratePuzzle:(id)sender;
-(void)uploadRating:(int)rating OfPuzzle:(NSString*)systemId;
@end
