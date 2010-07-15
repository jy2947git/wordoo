//
//  WordWizardPuzzleViewController.h
//  WizardView
//
//  Created by Junqiang You on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


enum ALERT_TAG {
	alert_menu=999202,
	alert_restart=999203,
	alert_showme=999204
	
};
@class PuzzleView;
@interface WordWizardPuzzleViewController : UIViewController{

	IBOutlet UIButton *nextPuzzleButton;
	IBOutlet UIButton *previousPuzzleButton;
	IBOutlet UILabel *message;

	IBOutlet UILabel *puzzleName;
	
//	IBOutlet UILabel *currentPuzzleOfTotal;
	IBOutlet PuzzleView *puzzleView;
	IBOutlet UIImageView *checkImg;
	
	UINavigationController *informationController;
}
@property (nonatomic, retain) UINavigationController *informationController;
@property (nonatomic, retain) IBOutlet UIImageView *checkImg;
@property (nonatomic, retain) IBOutlet PuzzleView *puzzleView;
@property (nonatomic, retain) IBOutlet UIButton *nextPuzzleButton;
@property (nonatomic, retain) IBOutlet UIButton *previousPuzzleButton;
@property (nonatomic, retain) IBOutlet UILabel *message;

@property (nonatomic, retain) IBOutlet UILabel *puzzleName;
//@property (nonatomic, retain) IBOutlet UILabel *currentPuzzleOfTotal;

-(void)applicationWillTerminate:(NSNotification *)notification;

-(IBAction)menu:(id)sender;
-(IBAction)previousPuzzle:(id)sender;
-(IBAction)nextPuzzle:(id)sender;
-(IBAction)undo:(id)sender;
-(IBAction)redo:(id)sender;
-(IBAction)hint:(id)sender;
-(IBAction)restart:(id)sender;
-(IBAction)showMe:(id)sender;
-(void)refreshCurrentPuzzle;
-(void)setPreviousAndNextPuzzleButtons;
- (void)hideOrDisplayCheckImage;
-(IBAction)information:(id)sender;
-(IBAction)showHelp:(id)sender;
-(BOOL)isPuzzleSolved:(NSString*)puzzleId;
@end