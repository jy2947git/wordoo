//
//  DesignWizardPage2ViewController.h
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DesignPuzzleView;
@interface DesignWizardPage2ViewController : UIViewController {
	

	IBOutlet UIImageView *tipPictureView;
	IBOutlet DesignPuzzleView *puzzleView;
}

@property (nonatomic, retain) IBOutlet UIImageView *tipPictureView;
@property (nonatomic, retain) IBOutlet DesignPuzzleView *puzzleView;
-(IBAction)undo:(id)sender;
-(IBAction)redo:(id)sender;
- (IBAction)savePuzzle:(id)sender;
- (IBAction)restartDesignPuzzle:(id)sender;
- (IBAction)makeTipDisappear:(id)sender;

@end
