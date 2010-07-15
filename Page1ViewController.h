//
//  Page1ViewController.h
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Page2ViewController;

@class DesignWizardCustomPuzzleListViewController;

@interface Page1ViewController : UIViewController {
	//Page2ViewController *viewControllerPage2;
	
	DesignWizardCustomPuzzleListViewController *viewControllerCustomPuzzleList;
	UINavigationController *navControllerDesignPuzzleList;
}
//@property (retain, nonatomic) Page2ViewController *viewControllerPage2;
@property (retain, nonatomic) UINavigationController *navControllerDesignPuzzleList;

@property (retain, nonatomic) DesignWizardCustomPuzzleListViewController *viewControllerCustomPuzzleList;
//-(IBAction)nextView:(id)sender;
-(void)applicationWillTerminate:(NSNotification *)notification;
- (IBAction)startDesign:(id)sender;
@end
