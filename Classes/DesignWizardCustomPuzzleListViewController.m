//
//  DesignWizardCustomPuzzleListViewController.m
//  WizardView
//
//  Created by Junqiang You on 3/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignWizardCustomPuzzleListViewController.h"
#import "WordWizardPuzzleHelper.h"
#import "DesignWiardPage1ViewController.h"
#import "WizardViewAppDelegate.h"
#import "Puzzle.h"
#import "GlobalConfiguration.h"
#import "DesignWizardViewPuzzleViewController.h"
#import "DesignPuzzleView.h"
#import "MainMenuViewController.h"
#import "GlobalHeader.h"
@implementation DesignWizardCustomPuzzleListViewController
@synthesize customPuzzles;
@synthesize solvedImg;
@synthesize unsolvedImg;



- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }

    return self;
}


- (void)addButtonWasPressed{
	DebugLog(@"add button clicked");
	//check version type
	
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
//	if(delegate.configuration.releaseTypeOfApp<3){
//		if([self.customPuzzles count]>1){
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"If you like it, please upgrade to paid version.",@"If you like it, please upgrade to paid version.")
//															message:nil
//														   delegate:nil
//												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
//												  otherButtonTitles:nil,nil];
//			alertView.opaque=YES;
//			[alertView show];
//			[alertView release];
//			return;
//		}
//	}
	//clear the selected puzzle id
	delegate.selectedPuzzleId=nil;
	if(delegate.currentPuzzle!=nil){
		[delegate.currentPuzzle clear];
	}
	//clear session

	DesignWiardPage1ViewController *d = [[DesignWiardPage1ViewController alloc]initWithNibName:@"DesignWizardPage1" bundle:nil];

	//FIXME remove the list page to delegate....
	d.currentPuzzleId=nil;
	d.name.text=@"";
	d.row0.text=@"";
	d.row1.text=@"";
	d.row2.text=@"";
	d.row3.text=@"";
	d.row4.text=@"";
	d.row5.text=@"";

	[self.navigationController pushViewController:d animated:YES];
	[d release];
	
}

- (void)addCustomPuzzle:(NSString *)puzzleId{
	DebugLog(@"adding puzzle to table view");

	[self.customPuzzles addObject:puzzleId];

}



- (void)viewDidLoad {
	
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	 self.title=NSLocalizedString(@"custom puzzles",@"custom puzzles");
	//get all the custom puzzles
	if(self.customPuzzles==nil){
		NSMutableArray *c = [[NSMutableArray alloc] init];
		self.customPuzzles = c;
		[c release];
	}
	[WordWizardPuzzleHelper addAllCustomizedPuzzles:customPuzzles];
	DebugLog(@"find %i custom puzzles", [customPuzzles count]);

	NSString *imagePathSolved = [[NSBundle mainBundle] pathForResource:@"check-1-small"
																ofType:@"png"];
    self.solvedImg = [UIImage imageWithContentsOfFile:imagePathSolved];
	NSString *imagePathUnsolved = [[NSBundle mainBundle] pathForResource:@"unsolved-small"
																  ofType:@"png"];
    self.unsolvedImg = [UIImage imageWithContentsOfFile:imagePathUnsolved];
	
	UIBarButtonItem *a  = [[UIBarButtonItem alloc]
						   initWithTitle:NSLocalizedString(@"Design", @"Design")
						   style:UIBarButtonItemStyleBordered
						   target:self
						   action:@selector(addButtonWasPressed)];
	
	self.navigationItem.rightBarButtonItem = a;
	[a release];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
}

-(void)applicationWillTerminate:(NSNotification *)notification{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delegate.configuration.releaseTypeOfApp<STANDARD_APP){
		//delete all customized puzzles
		[PuzzleHelper deleteAllCustomPuzzles];
	}
}
-(void)menu{

	[self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self customPuzzles] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Set up the cell...
	NSString *puzzleFileName = [[self customPuzzles] objectAtIndex:[indexPath row]];
	NSArray* components = [puzzleFileName componentsSeparatedByString:@"~"];
	if([components count]>=2){
		//downloaded puzzle, the first component is system id, the second is puzzle name
		cell.text = [components objectAtIndex:1];
	}else{
		cell.text = [components objectAtIndex:0];
	}
	cell.font=[UIFont systemFontOfSize:14];
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *filePath = [delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:delegate.configuration.scoreFileName];
	Boolean solved = NO;
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		
		NSArray *scores = [[NSArray alloc] initWithContentsOfFile:filePath];
		for(int i=0; i<[scores count];i++){
			NSDictionary *s = (NSDictionary*)[scores objectAtIndex:i];
			if([cell.text caseInsensitiveCompare:[s objectForKey:@"name"]]==0){
				//found it
				solved = YES;
				break;
			}
		}
		[scores release];
	}
	if(solved){
		cell.image=self.solvedImg;
	}else{
		cell.image=self.unsolvedImg;
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	DebugLog(@"selected to edit custom puzzle");

	
	//update current puzzle
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	delegate.selectedPuzzleId = [self.customPuzzles objectAtIndex:[indexPath row]];
	[WordWizardPuzzleHelper loadPuzzleToMemory:delegate.selectedPuzzleId];
	DebugLog(@"user selected %i %@", [indexPath row], delegate.selectedPuzzleId);

	DesignWizardViewPuzzleViewController *v =  [[DesignWizardViewPuzzleViewController alloc]initWithNibName:@"DesignWizardViewPuzzle" bundle:nil];

	[self.navigationController pushViewController:v animated:YES];
	[v release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


- (void)deletePuzzle:(NSString*)puzzleId{
	//delete files
	[WordWizardPuzzleHelper deleteCustomPuzzle:puzzleId];
	//delete from the all-puzzles
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	[delegate.allPuzzles removeObject:puzzleId];
	[self.customPuzzles removeObject:puzzleId];

	

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *selectedPuzzleId = [self.customPuzzles objectAtIndex:[indexPath row]];
		[self deletePuzzle:selectedPuzzleId];
		[tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		
		//reload custom puzzles
		[customPuzzles removeAllObjects];
		[WordWizardPuzzleHelper addAllCustomizedPuzzles:customPuzzles];
    }   
	[tableView endUpdates];
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[customPuzzles release];

	[solvedImg release];
	[unsolvedImg release];
	
    [super dealloc];
}


@end

