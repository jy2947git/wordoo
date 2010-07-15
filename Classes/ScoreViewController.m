//
//  Score.m
//  WizardView
//
//  Created by Junqiang You on 4/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScoreViewController.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"
#import "ScoreTableViewCell.h"
#import "MainMenuViewController.h"

@implementation ScoreViewController
@synthesize scores;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=NSLocalizedString(@"Score Board", @"score board");
//	CGRect newFrame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 30);
//	UILabel *headerView = [[UILabel alloc] init];
//	headerView.text=@"this is it";
//	headerView.backgroundColor = [UIColor clearColor];
//	headerView.frame = newFrame;
//	self.tableView.tableHeaderView =headerView;	// note this will override UITableView's 'sectionHeaderHeight' property
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	
//	UIBarButtonItem *d = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBack target:self action:@selector(menu)];
//	self.navigationItem.leftBarButtonItem = d;
//	[d release];
	
   
}

-(void)menu{

	[self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	[self.navigationController setNavigationBarHidden:NO];
	NSString *filePath = [delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:delegate.configuration.scoreFileName];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		if(self.scores==nil){
			NSMutableArray *s = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
			self.scores = s;
			[s release];
		}else{
			[self.scores removeAllObjects];
			NSArray *s = [[NSArray alloc] initWithContentsOfFile:filePath];
			[self.scores addObjectsFromArray:s];
			[s release];
			
		}
		[self.tableView reloadData];
	}else{
		//no score yet, place a picture
		
	}
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

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

#pragma mark Table view methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
		return NSLocalizedString(@"Puzzle                             Least Steps",@"puzzle least steps");

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.scores!=nil && [self.scores count]>0){
    return [self.scores count];
	}else{
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = nil;
    // Set up the cell...
	if(self.scores!=nil && [self.scores count]>0){
		static NSString *CellIdentifier = @"score";
		cell = (ScoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[ScoreTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		NSDictionary *score = (NSDictionary*)[self.scores objectAtIndex:indexPath.row];
		NSString *puzzleName = [score objectForKey:@"name"];
		NSString *bestScore = [score objectForKey:@"score"];
		NSString *par = [score objectForKey:@"par"];
		[cell setPuzzleName:puzzleName par:par bestScore:bestScore];
	}else{
		cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
		if(cell==nil){
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"emptyCell"] autorelease];
		}
		cell.text= NSLocalizedString(@"No Score Yet",@"No Score Yet");
	}
                                  
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


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

	[scores release];
    [super dealloc];
}


@end

