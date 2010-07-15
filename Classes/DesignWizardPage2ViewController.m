//
//  DesignWizardPage2ViewController.m
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignWizardPage2ViewController.h"
#import "DesignPuzzleView.h"
#import "WordWizardPuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "Puzzle.h"
#import "WizardViewAppDelegate.h"
#import "DesignWizardCustomPuzzleListViewController.h"
#import "GlobalConfiguration.h"
#import "WizardViewAppDelegate.h"


@implementation DesignWizardPage2ViewController

@synthesize tipPictureView;
@synthesize puzzleView;
- (IBAction)savePuzzle:(id)sender{
	DebugLog(@"saving puzzle");
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	//populate solution steps
	DesignPuzzleView *designPuzzleView = (DesignPuzzleView*)self.puzzleView;
	
	NSMutableArray *userSteps = [designPuzzleView userSteps];
	//save puzzle file
	[WordWizardPuzzleHelper savePuzzle:userSteps];
	//add to allpuzzles
	[delegate.allPuzzles addObject:delegate.currentPuzzle.name];
	//back to custom list page
	NSArray *allViewControllersInStack = [self.navigationController viewControllers];
	if([allViewControllersInStack count]>=1){
		DesignWizardCustomPuzzleListViewController *listController = [allViewControllersInStack objectAtIndex:0];
		[listController addCustomPuzzle:delegate.currentPuzzle.name];
		[self.navigationController popToViewController:listController animated:YES];
	}else{
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	
}
- (IBAction)restartDesignPuzzle:(id)sender{
	DesignPuzzleView *designPuzzleView = (DesignPuzzleView*)self.puzzleView;
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	//reinitiate data matrix
	//with a0,a1,a2...b0,b1....
	for(int i=0;i<delegate.currentPuzzle.matrixRows;i++){
		NSMutableArray* keys = [delegate.currentPuzzle.dataMatrix objectAtIndex:i];
		[keys removeAllObjects];
		for(int j=0;j<delegate.currentPuzzle.matrixCols;j++){
			NSMutableString *s = [[NSMutableString alloc] initWithFormat:@""];
			switch (i){
				case 0:
					[s appendFormat:@"a%i",j];
					[keys addObject:s];
					break;
				case 1:
					[s appendFormat:@"b%i",j];
					[keys addObject:s];
					break;
				case 2:
					[s appendFormat:@"c%i",j];
					[keys addObject:s];
					break;
				case 3:
					[s appendFormat:@"d%i",j];
					[keys addObject:s];
					break;
				case 4:
					[s appendFormat:@"e%i",j];
					[keys addObject:s];
					break;
				case 5:
					[s appendFormat:@"f%i",j];
					[keys addObject:s];
					break;
				default:
					DebugLog(@"unexpected error - matrix rows beyond limit of 6");
					break;
			}
			[s release];
		}
		
		
	}
	
	//clear uesr steps
	[designPuzzleView.userSteps removeAllObjects];
	[designPuzzleView refreshPuzzle];
	[designPuzzleView setNeedsDisplay];
}

- (IBAction)makeTipDisappear:(id)sender{
	[self.tipPictureView removeFromSuperview];
}
-(IBAction)undo:(id)sender{
	
	DesignPuzzleView *view = (DesignPuzzleView*)self.puzzleView;
	[view undoStep];
	
}
-(IBAction)redo:(id)sender{
	DesignPuzzleView *view = (DesignPuzzleView*)self.puzzleView;
	[view redoStep];
	
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	DebugLog(@"DesignWizardPage2ViewController.initWithNibName: starts");

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization


    }
	DebugLog(@"DesignWizardPage2ViewController.initWithNibName: ends");
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
		
    [super viewDidLoad];
	self.title=@"Matrix";
	
	UIBarButtonItem	*saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(savePuzzle:)];
	
    self.navigationItem.rightBarButtonItem = saveItem;
	[saveItem release];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:10];
	[self.tipPictureView setAlpha:0];
	[UIView commitAnimations];
	[self.puzzleView refreshPuzzle];
	[self.puzzleView setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animate{


	DesignPuzzleView *designPuzzleView = (DesignPuzzleView*)self.puzzleView;
	[designPuzzleView setAllowTouch:YES];
	[self restartDesignPuzzle:nil];

	[super viewWillAppear:animate];
	
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
    // Release anything that's not essential, such as cached data
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
	[tipPictureView release];

	[puzzleView release];
    [super dealloc];
}


@end
