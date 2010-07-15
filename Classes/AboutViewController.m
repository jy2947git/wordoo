//
//  AboutViewController.m
//  WizardView
//
//  Created by Junqiang You on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "WizardViewAppDelegate.h"
#import "AboutViewTableCell.h"

@implementation AboutViewController
#define ROW_HEIGHT 160
#define ROW_WIDTH 300
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
	//	self.tableView.rowHeight = ROW_HEIGHT;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=NSLocalizedString(@"About Wordoo",@"About Wordoo");
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	[self.navigationController setNavigationBarHidden:NO];
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
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
//		case 0:
//            title = NSLocalizedString(@"Description", @"Description");
//			break;
        case 0:
            title = NSLocalizedString(@"Features", @"Features");
            break;
		case 1:
            title = NSLocalizedString(@"Support", @"Support");
            break;
        default:
            break;
    }
   return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
//	if(indexPath.section==0){
//		return 250;
//	}else 
	if(indexPath.section==0){
		return 250;
	}if(indexPath.section==1){
		return 100;
	}
	return ROW_HEIGHT;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
	//
	
//	tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	UITableViewCell *cell = nil;
    // Set up the cell...
//	if(indexPath.section==0){
//		cell = [tableView dequeueReusableCellWithIdentifier:@"desc"];
//		if (cell == nil) {
//			cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ROW_WIDTH, 200-10) reuseIdentifier:@"desc"] autorelease];
//		
//			UITextView *tv  = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, ROW_WIDTH-20, 200-20)];
//			tv.tag=VIEW_DESC;
//			tv.text = @"Wordoo is a word puzzle where users try to assemble all the words.\naa\nddd\n\n\neee";
//
//			tv.editable=NO;
//			tv.scrollEnabled=NO;
//			tv.font = [UIFont fontWithName:@"Helvetica" size:16];
//			[cell.contentView addSubview:tv];
//			[tv release];
//		}
//		
//	}else 
		if(indexPath.section==0){
		cell = [tableView dequeueReusableCellWithIdentifier:@"feature"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ROW_WIDTH, 250) reuseIdentifier:@"feature"] autorelease];
		
			UITextView *tv  = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, ROW_WIDTH-20, 250-20)];
			tv.tag=VIEW_FEATURE;
			tv.text=@"1, Built in standard puzzles (paid version has 100, free version has 10\n2,Show-Me feature:utomatically show part or all of system generated solution moves \n\nPaid version only:\n3, Design custom puzzles puzzles \n4, Share custom puzzles with friends through email \n5, Share custom puzzles (upload and download) with Wordoo community";

			tv.editable=NO;
			tv.scrollEnabled=NO;
			tv.font = [UIFont systemFontOfSize:14];
			[cell.contentView addSubview:tv];
			[tv release];
		}
		
	}else if(indexPath.section==1){
		cell = [tableView dequeueReusableCellWithIdentifier:@"support"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ROW_WIDTH, 100-10) reuseIdentifier:@"support"] autorelease];
		
			UITextView *tv  = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, ROW_WIDTH-20, 100-20)];		
			tv.tag=VIEW_SUPPORT;
			tv.text = @"Please email to support@focaplo.com";

			tv.editable=NO;
			tv.scrollEnabled=NO;
			tv.font = [UIFont systemFontOfSize:14];
			[cell.contentView addSubview:tv];
			[tv release];
			
		}
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
    [super dealloc];
}


@end

