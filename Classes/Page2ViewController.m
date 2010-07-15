//
//  Page2ViewController.m
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Page2ViewController.h"
#import "MainMenuViewController.h"
#import "PuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "PuzzleView.h"
#import "PuzzleViewHelper.h"
#import "Puzzle.h"

@implementation Page2ViewController
@synthesize mainMenuViewController;

-(IBAction)menu:(id)sender{
	if(self.mainMenuViewController==nil){
		self.mainMenuViewController =  [[MainMenuViewController alloc]initWithNibName:@"MainMenuView" bundle:nil];
	}
	[self.view.superview addSubview:self.mainMenuViewController.view];
	[self.view removeFromSuperview];
}
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	 
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		PuzzleView *view = self.view;
		view.puzzleName.text=delegate.selectedPuzzleId;
		view.stepsTaken.text=@"0";
    }
	
    return self;
}

-(IBAction)previousPuzzle:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	int selectedIndexOfPuzzle = [delegate.allPuzzles indexOfObject:delegate.selectedPuzzleId];
	NSLog(@"current puzzle is no %i", selectedIndexOfPuzzle);
	if(selectedIndexOfPuzzle>0){
		delegate.selectedPuzzleId = [delegate.allPuzzles objectAtIndex:selectedIndexOfPuzzle-1];
		
		//refresh view
		PuzzleView *view = (PuzzleView*)self.view;
		[view refreshPuzzle:delegate.selectedPuzzleId];
		[view setNeedsDisplay];
	}

}
-(IBAction)nextPuzzle:(id)sender{
	NSLog(@"entering ViewController.nextPuzzle");
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	int selectedIndexOfPuzzle = [delegate.allPuzzles indexOfObject:delegate.selectedPuzzleId];
	NSLog(@"current puzzle is no %i of %i", selectedIndexOfPuzzle, [delegate.allPuzzles count]);
	if(selectedIndexOfPuzzle<[delegate.allPuzzles count]-1){
		delegate.selectedPuzzleId = [delegate.allPuzzles objectAtIndex:(selectedIndexOfPuzzle+1)];
		
		//refresh view
		PuzzleView *view = (PuzzleView*)self.view;
		view.currentPuzzleOfTotal.text=[NSString stringWithFormat:@"%i of %i puzzles",selectedIndexOfPuzzle+1,[delegate.allPuzzles count]];
		[view refreshPuzzle:delegate.selectedPuzzleId];
		[view setNeedsDisplay];
	}
	NSLog(@"leaving ViewController.nextPuzzle");
}
-(IBAction)undo:(id)sender{
	PuzzleView *view = (PuzzleView*)self.view;
	PuzzleViewHelper *viewHelper = view.viewHelper;
	[viewHelper undoStep];
}
-(IBAction)redo:(id)sender{
	PuzzleView *view = (PuzzleView*)self.view;
	PuzzleViewHelper *viewHelper = view.viewHelper;
	[viewHelper redoStep];
}
-(IBAction)hint:(id)sender{
	//allert view to display hint
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delegate.currentPuzzle.hint!=nil && [delegate.currentPuzzle.hint compare:@""]!=0){
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"hint"
												  message:delegate.currentPuzzle.hint
												  delegate:self
											      cancelButtonTitle:@"Ok"
											      otherButtonTitles:nil,nil];
	
	[alertView show];
	[alertView release];
	}
}
-(IBAction)showMe:(id)sender{
	PuzzleView *view = (PuzzleView*)self.view;
	PuzzleViewHelper *viewHelper = view.viewHelper;
	[viewHelper showMe];
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

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
}


- (void)dealloc {
	[mainMenuViewController release];
	[super dealloc];
}


@end
