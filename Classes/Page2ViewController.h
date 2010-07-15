//
//  Page2ViewController.h
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainMenuViewController;
@interface Page2ViewController : UIViewController {
	MainMenuViewController *mainMenuViewController;
	
}
@property (retain, nonatomic) MainMenuViewController *mainMenuViewController;

-(IBAction)menu:(id)sender;
-(IBAction)previousPuzzle:(id)sender;
-(IBAction)nextPuzzle:(id)sender;
-(IBAction)undo:(id)sender;
-(IBAction)redo:(id)sender;
-(IBAction)hint:(id)sender;
-(IBAction)showMe:(id)sender;
@end
