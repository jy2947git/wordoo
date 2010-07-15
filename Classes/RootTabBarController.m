//
//  RootTabBarController.m
//  WizardView
//
//  Created by Junqiang You on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootTabBarController.h"
#import "DesignWizardCustomPuzzleListViewController.h"
#import "BrowseCommunityViewController.h"
#import "WordWizardPuzzleHelper.h"
#import "WordWizardPuzzleViewController.h"
#import "WizardViewAppDelegate.h"
#import "Puzzle.h"
@implementation RootTabBarController

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	//refresh the data when user select tab bar
	/*
	if(viewController.tabBarItem.tag==1){
		UINavigationController *nav = (UINavigationController*)viewController;
		
		WordWizardPuzzleViewController *playController = (WordWizardPuzzleViewController*)([nav.viewControllers objectAtIndex:0]);
		DebugLog(@"clicked play");
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		//make sure the session variable always valid
		DebugLog(@"mainMenuController.playPuzzle:selected puzzle id is %@", delegate.selectedPuzzleId);
		if(delegate.selectedPuzzleId==nil && delegate.currentPuzzle.name!=nil){
			DebugLog(@"selected puzzle id is null, while current puzzle is not, reset");
			delegate.selectedPuzzleId = delegate.currentPuzzle.name;
		}
		if(delegate.selectedPuzzleId==nil && [delegate.allPuzzles count]>0){
			DebugLog(@"both selected puzzle id and current puzzle is nil, use first puzzle");
			delegate.selectedPuzzleId = [delegate.allPuzzles objectAtIndex:0];
		}
		if(delegate.selectedPuzzleId!=nil && ![delegate.allPuzzles containsObject:delegate.selectedPuzzleId] && [delegate.allPuzzles count]>0){
			DebugLog(@"selected puzzle id is not nil, but it doesn't exist, use first puzzle");
			delegate.selectedPuzzleId = [delegate.allPuzzles objectAtIndex:0];
		}
		DebugLog(@"mainMenuController.playPuzzle:selected puzzle id is finally %@", delegate.selectedPuzzleId);
		//refresh view
		[playController refreshCurrentPuzzle];
		[playController.view setNeedsDisplay];

	}
	 */
	if(viewController.tabBarItem.tag==2){
		UINavigationController *nav = (UINavigationController*)viewController;

		DesignWizardCustomPuzzleListViewController *listController = (DesignWizardCustomPuzzleListViewController*)([nav.viewControllers objectAtIndex:0]);
		DebugLog(@"clicked my-puzzles");
		if(listController.customPuzzles!=nil){
			DebugLog(@"reloading after user click tab");
			[listController.customPuzzles removeAllObjects];
			[WordWizardPuzzleHelper addAllCustomizedPuzzles:listController.customPuzzles];
			[listController.tableView reloadData];
		}
	}
	/*
	if(viewController.tabBarItem.tag==3){
		BrowseCommunityViewController *listController = (BrowseCommunityViewController*)viewController;
		DebugLog(@"clicked community");
		if(listController.puzzles!=nil){
			DebugLog(@"reloading community");
			[listController.puzzles removeAllObjects];
			[listController downloadPuzzleList:0];
			[listController.tableView reloadData];
		}
	}
 */
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
