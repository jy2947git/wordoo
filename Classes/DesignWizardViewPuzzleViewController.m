//
//  DesignWizardViewPuzzle.m
//  WizardView
//
//  Created by Junqiang You on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignWizardViewPuzzleViewController.h"
#import "DesignPuzzleView.h"
#import "WordWizardPuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "Puzzle.h"
#import "WizardViewAppDelegate.h"
#import "DesignWizardCustomPuzzleListViewController.h"
#import "WordWizardPuzzleViewController.h"
#import "PuzzleView.h"
#import "Puzzle.h"
#import "MainMenuViewController.h"
#import "GlobalConfiguration.h"
#import "DesignWizardCustomPuzzleListViewController.h"
//#import "NSData+CocoaDevUsersAdditions.h"
#import "Reachability.h"
#import "WizardViewAppDelegate.h"
#import "GlobalHeader.h"

@implementation DesignWizardViewPuzzleViewController

@synthesize puzzleView;
@synthesize ratingButton;
@synthesize uploadButton;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {  
	if(RESTART_TO_SAVED_STATE==alertView.tag){
		if (buttonIndex == 0) {
			return;
		}
		[self restartDesignPuzzleToSavedState];
		[self.puzzleView setNeedsDisplay];
	}else if(RESTART_TO_INITIAL_STATE == alertView.tag){
		if (buttonIndex == 0) {
			return;
		}
		[self restartDesignPuzzleToInitialState];
		[self.puzzleView setNeedsDisplay];
	}else if(DELETE_PUZZLE==alertView.tag){
		if (buttonIndex == 0) {
			return;
		}
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		NSArray *allViewControllersInStack = [self.navigationController viewControllers];
		if([allViewControllersInStack count]>=2){
			DesignWizardCustomPuzzleListViewController *listController = [allViewControllersInStack objectAtIndex:1];
			[listController deletePuzzle:delegate.selectedPuzzleId];
		}
		
		//back to root
		[self.navigationController popViewControllerAnimated:YES];
	}else if(UPLOAD_PUZZLE==alertView.tag){
		if (buttonIndex == 0) {
			return;
		}
		[self uploadPuzzleToServer];

	}
}

-(void)restartDesignPuzzleToSavedState{
	[self.puzzleView refreshPuzzle];
	//load solution steps to user steps
	[self.puzzleView loadSolutionStepsToUserSteps];
	NSString *s = [[NSString alloc] initWithFormat:@"%i",[self.puzzleView.userSteps count]];
	self.puzzleView.stepsTaken.text=s;
	[s release];
}

-(void)restartDesignPuzzleToInitialState{
	DebugLog(@"start to rollback matrix to inital state");
	//empty solution steps, rollback data matrix from complete data matrix
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	Puzzle *currentPuzzle = delegate.currentPuzzle;
	if(currentPuzzle.solutionSteps!=nil){
		[currentPuzzle.solutionSteps removeAllObjects];
	}
	


	[self.puzzleView.userSteps removeAllObjects];
	
	//refresh data matrix from complete data
	for(int i=0;i<delegate.currentPuzzle.matrixRows;i++){
		NSMutableArray* keys = [delegate.currentPuzzle.dataMatrix objectAtIndex:i];
		[keys removeAllObjects];
		for(int j=0;j<delegate.currentPuzzle.matrixCols;j++){
			NSMutableString *s = [[NSMutableString alloc] initWithFormat:@""];
			switch (i){
				case 0:
					[s appendFormat:@"a%i",j];
					[keys addObject:s];
					[s release];
					break;
				case 1:
					[s appendFormat:@"b%i",j];
					[keys addObject:s];
					[s release];
					break;
				case 2:
					[s appendFormat:@"c%i",j];
					[keys addObject:s];
					[s release];
					break;
				case 3:
					[s appendFormat:@"d%i",j];
					[keys addObject:s];
					[s release];
					break;
				case 4:
					[s appendFormat:@"e%i",j];
					[keys addObject:s];
					[s release];
					break;
				case 5:
					[s appendFormat:@"f%i",j];
					[keys addObject:s];
					[s release];
					break;
				default:
					DebugLog(@"unexpected error - matrix rows beyond limit of 6");
					break;
			}
		}
		
		
	}
	NSString *s = [[NSString alloc] initWithFormat:@"%i",[self.puzzleView.userSteps count]];
	self.puzzleView.stepsTaken.text=s;
	[s release];
	DebugLog(@"end to rollback matrix to inital state");

	//[viewHelper printPuzzle:delegate.currentPuzzle];
	
}



- (IBAction)savePuzzle:(id)sender{
	//populate solution steps

	NSMutableArray *userSteps = [self.puzzleView userSteps];
	[WordWizardPuzzleHelper savePuzzle:userSteps];
	//back to custom list page
	[self.navigationController popViewControllerAnimated:YES];
	
}



- (IBAction)restartDesignPuzzle:(id)sender{
	
	//alert
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"restart the design matrix to the last saved state?",@"restart the design matrix to the last saved state?")
														message:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No",@"no")
											  otherButtonTitles:NSLocalizedString(@"Yes",@"yes"),nil];
	alertView.opaque=YES;
	alertView.tag=RESTART_TO_SAVED_STATE;
	[alertView show];
	[alertView release];
	

}

- (IBAction)reInitiateDesignPuzzle:(id)sender{
	//clear all solutionsteps, rollback data matrix to complete data
	//alert
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"restart the design matrix from the initial state?",@"restart the design matrix from the initial state?")
														message:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No",@"No")
											  otherButtonTitles:NSLocalizedString(@"Yes",@"Yes"),nil];
	alertView.opaque=YES;
	alertView.tag=RESTART_TO_INITIAL_STATE;
	[alertView show];
	[alertView release];
}

- (IBAction)deletePuzzle:(id)sender{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete the puzzle permanently?",@"delete the puzzle permanently?")
														message:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No",@"No")
											  otherButtonTitles:NSLocalizedString(@"Yes",@"Yes"),nil];
	alertView.opaque=YES;
	alertView.tag=DELETE_PUZZLE;
	[alertView show];
	[alertView release];
}
-(IBAction)undo:(id)sender{
	[(PuzzleView*)self.view undoStep];
	
}
-(IBAction)redo:(id)sender{

	[(PuzzleView*)self.view redoStep];
	
}

-(IBAction)emailPuzzle:(id)sender{
	NSString *subjString = NSLocalizedString(@"check out this puzzle",@"check out this puzzle");
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	//read the puzzle file
	
	NSString *fileName = [[NSString alloc] initWithFormat:@"%@.pz",delegate.selectedPuzzleId];
	NSString *filePath = [delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:fileName];
	DebugLog(@"will email puzzle %@", filePath);
	NSError *error=nil;
	NSString *puzzle = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	if(error){
		DebugLog(@"error=%@",[error localizedDescription]);
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"failed to read file",@"failed to read file")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		return;
	}
	DebugLog(@"puzzle=[%@]",puzzle);
	NSString *s = [puzzle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *messageString = [[NSString alloc] initWithFormat:@"<a href='wordoo://?puzzleName=%@&puzzleData=%@'>%@</a>%@",delegate.selectedPuzzleId, s, NSLocalizedString(@"click here to download to Wordoo",@"click here to download to Wordoo"), NSLocalizedString(@"(make sure you have Wordoo installed on your phone - both free and paid version are available at App Store)",@"(make sure you have Wordoo installed on your phone - both free and paid version are available at App Store)")];
	DebugLog(@"messageString[%@]",messageString);
    NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"), kCFStringEncodingUTF8);
	
	NSString *urlString = [[NSString alloc] initWithFormat: @"mailto:?subject=%@&body=%@" , 
						   [subjString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						   encodedMessageString];
	DebugLog(@"urlString[%@]",urlString);
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[[UIApplication sharedApplication] openURL:url];
	[url release];
	[fileName release];
	[puzzle release];
	[messageString release];
	[urlString release];
}

-(NSData *)compress:(NSString *)inputString{
	 return [[inputString dataUsingEncoding:NSUTF8StringEncoding] zlibDeflate];
}

-(NSData *)decompress:(NSData*)inputData{
	return [inputData zlibInflate];
}



- (void)uploadPuzzleToServer{
	//read the puzzle file
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *fileName = [[NSString alloc] initWithFormat:@"%@.pz",delegate.selectedPuzzleId];
	NSString *filePath = [delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:fileName];
	
	NSError *error=nil;
	NSString *puzzle = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	if(error){
		DebugLog(@"error=%@",[error localizedDescription]);
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"failed to read file",@"failed to read file")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		return;
	}
	DebugLog(@"puzzle:%@", puzzle);
	NSString *s = [puzzle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *messageString = [[NSString alloc] initWithFormat:@"command=upload&token=%@&puzzleAuthor=%@&puzzleName=%@&puzzleData=%@",requestToken,delegate.configuration.userName,delegate.selectedPuzzleId, s];
	DebugLog(@"upload puzzle:%@", messageString);
    NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"),  kCFStringEncodingUTF8);
	
	
	//	NSString *post = [NSString stringWithFormat:@"logn=%@&Pword=%@&Latitude=%@&Longitude=%@", 
	//					  [self urlEncodeValue:[[NSUserDefaults standardUserDefaults] stringForKey:kUsernameKey]], 
	//					  [self urlEncodeValue:[[NSUserDefaults standardUserDefaults] stringForKey:kPasswordKey]],
	//					  [self urlEncodeValue:latitude],					  
	//					  [self urlEncodeValue:longitude]
	//					  ];
	NSData *postData = [encodedMessageString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [encodedMessageString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/wordee/puzzle?",serverHost]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	[request setHTTPBody:postData];
	
	// send it
	NSURLResponse *response;

	NSData *serverReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	[request release];
	[fileName release];
	[messageString release];
	[puzzle release];
	if(error){
		NSString *msg = [[NSString alloc] initWithFormat:@"%@", NSLocalizedString(@"Could not establish internet connection to Wordoo community server",@"Could not establish internet connection to Wordoo community server"),
						 [error localizedDescription]]; 
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:msg
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		[msg release];
		return;
	}
	
	// Need to check return data and return status
	
	NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSUTF8StringEncoding];
	DebugLog(@"NSURLConnection response = %@\nreply = [%@]", [[response URL] absoluteString], replyString);
	
	if([replyString rangeOfString:@"SUCCESS"].location==0){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"Puzzle Uploaded",@"Puzzle Uploaded")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
	}else{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"Failed",@"Failed")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
	}
	[replyString release];
}

-(IBAction)uploadPuzzle:(id)sender{
	//check user name
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if([delegate.configuration.userName caseInsensitiveCompare:@""]==0){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"Please set up the puzzle author name on the Settings screen (one time only)",@"Please set up your name in the Setting screen")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		return;
		
	}
//	[[Reachability sharedReachability] setHostName:serverHost];
//	NetworkStatus hostStatus = [[Reachability sharedReachability] remoteHostStatus];
//	NetworkStatus internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
//	NetworkStatus localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
//	DebugLog(@"%i %i %i",hostStatus,internetConnectionStatus,localWiFiConnectionStatus);
//	if(internetConnectionStatus!=ReachableViaCarrierDataNetwork && localWiFiConnectionStatus!=ReachableViaWiFiNetwork){
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//															message:NSLocalizedString(@"Host is not reachable",@"Host is not reachable")
//														   delegate:self
//												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
//												  otherButtonTitles:nil,nil];
//		alertView.opaque=YES;
//		
//		[alertView show];
//		[alertView release];
//		return;
//	}
	//right
//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//														message:NSLocalizedString(@"Do you agree to make the puzzle public and share with all wordoo users?",@"Do you agree to share the puzzle with all wordoo users?")
//													   delegate:self
//											  cancelButtonTitle:NSLocalizedString(@"No",@"No")
//											  otherButtonTitles:NSLocalizedString(@"I agree",@"I agree"),nil];
//	alertView.opaque=YES;
//	alertView.tag=UPLOAD_PUZZLE;
//	[alertView show];
//	[alertView release];
//	return;
	
	UIActionSheet *styleAlert =
	[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Do you agree to make the puzzle public and share with all wordoo users?",@"Do you agree to share the puzzle with all wordoo users?")
								delegate:self cancelButtonTitle:NSLocalizedString(@"No",@"No") destructiveButtonTitle:nil
					   otherButtonTitles:NSLocalizedString(@"I agree",@"I agree"), nil, nil];
	
	// use the same style as the nav bar
	styleAlert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
	styleAlert.tag=UPLOAD_PUZZLE;
	[styleAlert showInView:self.view];
	[styleAlert release];
	
}

-(IBAction)playPuzzle:(id)sender{
	//switch to the play tab and load the selected puzzle id
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	UITabBarController *tabController = delegate.controllerTabBar;
	//load current puzzle
	UINavigationController *playPageNavController = [[tabController viewControllers] objectAtIndex:0];
	WordWizardPuzzleViewController *playPage = (WordWizardPuzzleViewController*)[playPageNavController topViewController];
	[playPage refreshCurrentPuzzle];
	tabController.selectedIndex=0;
}

-(IBAction)ratePuzzle:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *puzzleFileName = delegate.selectedPuzzleId;
	NSArray* components = [puzzleFileName componentsSeparatedByString:@"~"];
	if([components count]>=2){
		//downloaded puzzle, the first component is system id, the second is puzzle name
	
		UIActionSheet *styleAlert =
		[[UIActionSheet alloc] initWithTitle:@"Rate this puzzle:"
								delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
					   otherButtonTitles:@"Poor", @"Ok", @"Good", @"Awesome", @"Speechless", nil, nil];
	
		// use the same style as the nav bar
		styleAlert.actionSheetStyle = UIBarStyleDefault;
		styleAlert.tag=RATE_PUZZLE;
		[styleAlert showInView:self.view];
		[styleAlert release];
	}
}

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	DebugLog(@"clicked button index %i", buttonIndex);
	
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(RATE_PUZZLE==modalView.tag){
		if (buttonIndex == 5) {
			//cancel button
			return;
		}
		NSString *puzzleFileName = delegate.selectedPuzzleId;
		NSArray* components = [puzzleFileName componentsSeparatedByString:@"~"];
		[self uploadRating:buttonIndex+1 OfPuzzle:[components objectAtIndex:0]];
	}else if(UPLOAD_PUZZLE==modalView.tag){
		if (buttonIndex == 1) {
			//cancel button
			return;
		}
		[self uploadPuzzleToServer];
	}
}

-(void)uploadRating:(int)rating OfPuzzle:(NSString*)systemId{
	DebugLog(@"uploading rating %i for puzzle %@", rating, systemId);

	NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/wordee/puzzle?command=rate&id=%@&rating=%i&token=%@",serverHost,systemId,rating, requestToken];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	NSError *error = nil;
	NSString *response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	[url release];
	if(error){
	}else{
		DebugLog(@"%@", response);
		[response release];
	}
	
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//WizardViewAppDelegate* appdelegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
//		self.title=NSLocalizedString(@"Design Matrix",@"Design Matrix");
		DesignPuzzleView *view = (DesignPuzzleView*)self.puzzleView;


		[view setAllowTouch:NO];

		DebugLog(@"ViewController.initWithNibName:setting allow touch NO");
    }
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
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	self.view.backgroundColor = delegate.configuration.screenBackgroundColor;
//	UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePuzzle:)];
//	
//    self.navigationItem.rightBarButtonItem = saveItem;
//    [saveItem release];
	
	NSString *puzzleFileName = delegate.selectedPuzzleId;
	NSArray* components = [puzzleFileName componentsSeparatedByString:@"~"];
	if([components count]<2){
		//not downloaded puzzle, no rating function
		self.ratingButton.enabled=NO;
		self.uploadButton.enabled=YES;
		self.navigationItem.title=[components objectAtIndex:0];
	}else{
		self.ratingButton.enabled=YES;
		self.uploadButton.enabled=NO;
		self.navigationItem.title=[components objectAtIndex:1];
	}
}

- (void)viewWillAppear:(BOOL)animate{
	//reload puzzle, and especially load solutionsteps to usersteps
	[self restartDesignPuzzleToSavedState];
	
	DesignPuzzleView *view = (DesignPuzzleView*)self.puzzleView;
	NSString *s = [[NSString alloc] initWithFormat:@"%i",[view.userSteps count]];
	view.stepsTaken.text=s;
	[s release];
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
	[ratingButton release];
	[puzzleView release];
	[uploadButton release];
    [super dealloc];
}


@end
