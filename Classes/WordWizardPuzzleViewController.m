//
//  WordWizardPuzzleViewController.m
//  WizardView
//
//  Created by Junqiang You on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WordWizardPuzzleViewController.h"
#import "MainMenuViewController.h"
#import "WordWizardPuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "PuzzleView.h"
#import "Puzzle.h"
#import "GlobalConfiguration.h"
#import "PreferencesViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WordWizardPuzzleViewController
@synthesize previousPuzzleButton;
@synthesize nextPuzzleButton;
@synthesize message;

@synthesize puzzleName;
@synthesize informationController;
//@synthesize currentPuzzleOfTotal;
@synthesize puzzleView;
@synthesize checkImg;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {  
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(alert_menu == alertView.tag){
		
		if (buttonIndex == 1) {  
			// go to menu
			[self.view.superview addSubview:delegate.navControllerMainmenu.view];
			[self.view removeFromSuperview];
		}  
		else {  
			// do nothing 
		}  
	}else if(alert_restart == alertView.tag){
		if (buttonIndex == 1) { 
			//restart puzzle
			[self refreshCurrentPuzzle];
		}else{
			//nothing
		}
	}else if(alert_showme == alertView.tag){
		if (buttonIndex == 1) { 
			//show the first some steps
			if(![self isPuzzleSolved:delegate.selectedPuzzleId]){
				//unsolved puzzle
				[self.puzzleView showMe:(int)(([delegate.currentPuzzle.solutionSteps count]*delegate.configuration.showMeValue)/100)];
			}else{
				//solved already
				if(delegate.configuration.showCompleteForSolvedPuzzle){
					[self.puzzleView showMe:[delegate.currentPuzzle.solutionSteps count]];
				}else{
					[self.puzzleView showMe:(int)(([delegate.currentPuzzle.solutionSteps count]*delegate.configuration.showMeValue)/100)];
				}
			}			
		}else{
			//nothing

		}
		
	}
	
}  
-(IBAction)menu:(id)sender{
	//alert
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Leave the puzzle?",@"leave the puzzle")
														message:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No", @"no")
											  otherButtonTitles:NSLocalizedString(@"Yes", @"yes"),nil];
	alertView.opaque=YES;
	alertView.tag=alert_menu;
	[alertView show];
	[alertView release];
	
	
}
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//load the nib along with puzzle view
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
    }
	UIBarButtonItem *a = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Previous",@"Previous")
																  style:UIBarButtonItemStyleBordered target:self action:@selector(previousPuzzle:)];
	//UIBarButtonItem *a = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previousPuzzle:)];
	self.navigationItem.leftBarButtonItem = a;
	[a release];
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next",@"Next")
														  style:UIBarButtonItemStyleBordered target:self action:@selector(nextPuzzle:)];
	//UIBarButtonItem *b = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextPuzzle:)];
	self.navigationItem.rightBarButtonItem = b;
	[b release];

    return self;
}

-(IBAction)previousPuzzle:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	DebugLog(@"selected puzzle id is %@", delegate.selectedPuzzleId);
	int selectedIndexOfPuzzle = [delegate.allPuzzles indexOfObject:delegate.selectedPuzzleId];
	DebugLog(@"current puzzle is no %i", selectedIndexOfPuzzle);
	if(selectedIndexOfPuzzle>0){
		delegate.selectedPuzzleId = [delegate.allPuzzles objectAtIndex:selectedIndexOfPuzzle-1];
		//refresh view
		[self refreshCurrentPuzzle];
		
		// Set up the animation
		CATransition *animation = [CATransition animation];
		[animation setDelegate:self];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromLeft];
		
		[animation setDuration:0.75f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[[self.puzzleView layer] addAnimation:animation forKey:@"transitionViewAnimation"];
	}
	
}



-(void)refreshCurrentPuzzle{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	//call the view(viewhelper) to refresh current puzzle
	[self.puzzleView refreshPuzzle];

	NSString *puzzleFileName = delegate.selectedPuzzleId;
	NSArray* components = [puzzleFileName componentsSeparatedByString:@"~"];
	if([components count]>=2){
		//self.puzzleName.text=[components objectAtIndex:1];
//		UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//		titleLabel.opaque=0;
//		titleLabel.text=[components objectAtIndex:1];
//		self.navigationItem.titleView=titleLabel;
//		[titleLabel release];
		self.navigationItem.title=[components objectAtIndex:1];
	}else{
		//self.puzzleName.text=[components objectAtIndex:0];
//		UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//		titleLabel.opaque=0;
//		titleLabel.text=[components objectAtIndex:0];
//		self.navigationItem.titleView=titleLabel;
//		[titleLabel release];
		self.navigationItem.title=[components objectAtIndex:0];
	}
//	int selectedIndexOfPuzzle = [delegate.allPuzzles indexOfObject:delegate.selectedPuzzleId];
//	NSString *s = [[NSString alloc] initWithFormat:@"%i/%i",selectedIndexOfPuzzle+1,[delegate.allPuzzles count]];
//	self.currentPuzzleOfTotal.text=s;
//	[s release];
	[self setPreviousAndNextPuzzleButtons];
	[self.view setNeedsDisplay];
	[self.puzzleView setNeedsDisplay];


}

-(void)setPreviousAndNextPuzzleButtons{
	//enable or disable the previous and next buttons
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	for(int i=0;i<[delegate.allPuzzles count];i++){
		DebugLog(@"puzzle %i - %@", i, [delegate.allPuzzles objectAtIndex:i]);
	}
	int selectedIndexOfPuzzle = [delegate.allPuzzles indexOfObject:delegate.selectedPuzzleId];
	if(selectedIndexOfPuzzle==0){
		[self.previousPuzzleButton setEnabled:NO];
		[self.previousPuzzleButton setHidden:YES];
		self.navigationItem.leftBarButtonItem.enabled=NO;
	}else{
		[self.previousPuzzleButton setEnabled:YES];
		[self.previousPuzzleButton setHidden:NO];
		self.navigationItem.leftBarButtonItem.enabled=YES;
	}
	if(selectedIndexOfPuzzle==[delegate.allPuzzles count]-1){
		[self.nextPuzzleButton setEnabled:NO];
		[self.nextPuzzleButton setHidden:YES];
		self.navigationItem.rightBarButtonItem.enabled=NO;
	}else{
		[self.nextPuzzleButton setEnabled:YES];
		[self.nextPuzzleButton setHidden:NO];
		self.navigationItem.rightBarButtonItem.enabled=YES;
	}
	[self hideOrDisplayCheckImage];
}


-(IBAction)nextPuzzle:(id)sender{
	DebugLog(@"entering ViewController.nextPuzzle");
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	DebugLog(@"selected puzzle id is %@", delegate.selectedPuzzleId);
	int selectedIndexOfPuzzle = [delegate.allPuzzles indexOfObject:delegate.selectedPuzzleId];
	DebugLog(@"current puzzle is no %i of %i", selectedIndexOfPuzzle, [delegate.allPuzzles count]);
//	if(delegate.configuration.releaseTypeOfApp<STANDARD_APP){
//		//not paid
//		if(selectedIndexOfPuzzle>2){
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"If you like it, please upgrade to paid version.",@"If you like it, please upgrade to paid version.")
//																message:nil
//															   delegate:nil
//													  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
//													  otherButtonTitles:nil,nil];
//			alertView.opaque=YES;
//			[alertView show];
//			[alertView release];
//			return;
//		}
//	}
	
	
	if(selectedIndexOfPuzzle<[delegate.allPuzzles count]-1){
		delegate.selectedPuzzleId = [delegate.allPuzzles objectAtIndex:(selectedIndexOfPuzzle+1)];
		//refresh view
		[self refreshCurrentPuzzle];
		// Set up the animation
		CATransition *animation = [CATransition animation];
		[animation setDelegate:self];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromRight];
		
		[animation setDuration:0.75f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[[self.puzzleView layer] addAnimation:animation forKey:@"transitionViewAnimation"];
		
		
	}
	DebugLog(@"leaving ViewController.nextPuzzle");

}


-(IBAction)showHelp:(id)sender{
	NSMutableString *m = [[NSMutableString alloc] init];
	[m appendFormat:@"%@\n",NSLocalizedString(@"*To play: puzzle consists of tiles, spaces and stones. Tiles can only be moved to space. Puzzle is solved when all the words are unscrambled (one word per row)",@"")];
	[m appendFormat:@"%@\n",NSLocalizedString(@"*hint: randomly select one of the words to display",@"")];
	[m appendFormat:@"%@\n",NSLocalizedString(@"*show me: shows the system generated solution steps. For unsolved puzzles, can shows at most 50%; For solved puzzles, will show all the steps (can be changed on Setting screen)",@"")];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Instruction",@"Instruction")
														message:m
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
											  otherButtonTitles:nil,nil];
	alertView.opaque=NO;
	[alertView show];
	[alertView release];
	[m release];
}


-(IBAction)undo:(id)sender{
	[self.puzzleView undoStep];
	[self.view setNeedsDisplay];
}
-(IBAction)redo:(id)sender{

	[self.puzzleView redoStep];
	[self.view setNeedsDisplay];
}


-(IBAction)restart:(id)sender{
	//alert
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"restart the puzzle?",@"restart the puzzle")
														message:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No",@"no")
											  otherButtonTitles:NSLocalizedString(@"Yes",@"yes"),nil];
	alertView.opaque=YES;
	alertView.tag=alert_restart;
	[alertView show];
	[alertView release];

}
-(IBAction)hint:(id)sender{
	//allert view to display one of the complete rows
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(!delegate.configuration.allowHint){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hint feature is disabled",@"hint feature is disabled")
															message:nil
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		return;
	}
	if(delegate.currentPuzzle.completeData!=nil && [delegate.currentPuzzle.completeData count]>1){
	
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"One of the words is",@"One of the words is")
															message:[delegate.currentPuzzle.completeData objectAtIndex:rand()%([delegate.currentPuzzle.completeData count]-1)]
														   delegate:self
											      cancelButtonTitle:NSLocalizedString(@"Close",@"close")
											      otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
	}

}
-(IBAction)showMe:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(!delegate.configuration.allowShowMe){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ShowMe feature is disabled",@"showme feature is disabled")
															message:nil
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		return;
	}
	if(delegate.configuration.showShowMeWarning){
		NSString *s = nil;
		if(![self isPuzzleSolved:delegate.selectedPuzzleId]){
			//unsolved puzzle
			s = [[NSString alloc] initWithFormat:@"%@ %i%% %@",NSLocalizedString(@"restart puzzle and show","restart puzzle and show"), delegate.configuration.showMeValue,NSLocalizedString(@"of the solution steps?","of the solution steps?")];
		}else{
			//solved already
			if(delegate.configuration.showCompleteForSolvedPuzzle){
				s = [[NSString alloc] initWithFormat:NSLocalizedString(@"restart puzzle and show all of the solution steps?",@"restart puzzle and show all of the solution steps?")];
			}else{
				s = [[NSString alloc] initWithFormat:@"%@ %i%% %@", NSLocalizedString(@"restart puzzle and show",@"restart puzzle and show"), delegate.configuration.showMeValue, NSLocalizedString(@"of the solution steps?","of the solution steps?")];
			}
		}
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:s
														message:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No",@"no")
											  otherButtonTitles:NSLocalizedString(@"Yes",@"yes"),nil];
		alertView.opaque=YES;
		alertView.tag=alert_showme;
		[alertView show];
		[s release];
		[alertView release];
	}else{
		if(![self isPuzzleSolved:delegate.selectedPuzzleId]){
			//unsolved puzzle
			[self.puzzleView showMe:(int)(([delegate.currentPuzzle.solutionSteps count]*delegate.configuration.showMeValue)/100)];
		}else{
			//solved already
			if(delegate.configuration.showCompleteForSolvedPuzzle){
				[self.puzzleView showMe:[delegate.currentPuzzle.solutionSteps count]];
			}else{
				[self.puzzleView showMe:(int)(([delegate.currentPuzzle.solutionSteps count]*delegate.configuration.showMeValue)/100)];
			}
		}
	}

}

-(void)applicationWillTerminate:(NSNotification *)notification{

	[self.puzzleView savePuzzlePlayState];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;

//	self.view.backgroundColor = delegate.configuration.screenBackgroundColor;
	[self refreshCurrentPuzzle];
	//self.view.stepsTaken.text=[self.view.userSteps count];
	self.puzzleView.controller=self;
	UIApplication *app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];

}

- (void)viewWillAppear:(BOOL)animated{

	[super viewWillAppear:animated];
	//draw matrix background
	
}

-(BOOL)isPuzzleSolved:(NSString*)puzzleId{
	//check whether this puzzle is solved or not
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *filePath = [delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:delegate.configuration.scoreFileName];
	Boolean solved = NO;
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		
		NSArray *scores = [[NSArray alloc] initWithContentsOfFile:filePath];
		for(int i=0; i<[scores count];i++){
			NSDictionary *s = (NSDictionary*)[scores objectAtIndex:i];
			if([puzzleId caseInsensitiveCompare:[s objectForKey:@"name"]]==0){
				//found it
				solved = YES;
				break;
			}
		}
		[scores release];
	}
	if(!solved){
		return NO;
	}else{
		return YES;
	}
}

- (void)hideOrDisplayCheckImage{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	//check whether this puzzle is solved or not
	BOOL solved = [self isPuzzleSolved:delegate.selectedPuzzleId];
	if(!solved){
		self.checkImg.hidden = YES;
	}else{
		self.checkImg.hidden = NO;
	}
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(IBAction)information:(id)sender{
		//SettingViewController *s = [[SettingViewController alloc] initWithNibName:@"SettingView" bundle:nil];
	
	if(self.informationController==nil){
		PreferencesViewController *s = [[PreferencesViewController alloc] initWithStyle:UITableViewStyleGrouped];
		UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:s];
		self.informationController=n;
		[s release];
		[n release];
	}
	//animation??
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:YES];
	
	[self.view.superview addSubview:self.informationController.view];
	[UIView commitAnimations];

//	[self.view removeFromSuperview];
//	[s release];
}
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
	[informationController release];
	[puzzleView release];
	[previousPuzzleButton release];
	[nextPuzzleButton release];
	[message release];

	[puzzleName release];
	[checkImg release];
//	[currentPuzzleOfTotal release];
	[super dealloc];
}


@end
