//
//  MainMenuViewController.m
//  WizardView
//
//  Created by Junqiang You on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "WordWizardPuzzleViewController.h"
#import "DesignWizardCustomPuzzleListViewController.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"
#import "BrowseCommunityViewController.h"
#import "Puzzle.h"
#import "PuzzleView.h"
#import "ScoreViewController.h"
#import "PreferencesViewController.h"
#import "AboutViewController.h"

@implementation MainMenuViewController

- (IBAction)startDesign:(id)sender{

	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	DesignWizardCustomPuzzleListViewController *s = [[DesignWizardCustomPuzzleListViewController alloc] initWithStyle:UITableViewStylePlain];
	[delegate.navControllerMainmenu pushViewController:s animated:YES];
	[s release];
}

- (IBAction)playPuzzle:(id)sender{
	//get the puzzle view controller from delegate
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
	[delegate.wordWizardPuzzleViewController refreshCurrentPuzzle];
	[delegate.wordWizardPuzzleViewController.view setNeedsDisplay];
	[self.navigationController.view.superview addSubview:delegate.wordWizardPuzzleViewController.view];
	[self.navigationController.view removeFromSuperview];
	
}
- (IBAction)startSetting:(id)sender{

	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	PreferencesViewController *s = [[PreferencesViewController alloc] initWithStyle:UITableViewStyleGrouped];
	//SettingViewController *s = [[SettingViewController alloc] initWithNibName:@"SettingView" bundle:nil];
	[delegate.navControllerMainmenu pushViewController:s animated:YES];
	[s release];
}


- (IBAction)goScore:(id)sender{

	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	ScoreViewController *s = [[ScoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[delegate.navControllerMainmenu pushViewController:s animated:YES];
	[s release];
}

- (IBAction)goAbout:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	AboutViewController *s = [[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[delegate.navControllerMainmenu pushViewController:s animated:YES];
	[s release];
}

- (IBAction)browseCommunity:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	BrowseCommunityViewController *s = [[BrowseCommunityViewController alloc] initWithStyle:UITableViewStylePlain];
	[delegate.navControllerMainmenu pushViewController:s animated:YES];
	[s release];
}
/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//	UIApplication *app = [UIApplication sharedApplication];
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
	[self.view setFrame:[UIScreen mainScreen].bounds];
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	//alert
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delegate.configuration.alertWhenMemoryLow){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Memory low",@"Low memory, please exit application - restarting Iphone might help")
															message:nil
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close", @"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
	}
}


- (void)dealloc {

    [super dealloc];
}


@end
