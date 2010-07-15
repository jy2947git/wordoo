//
//  PreferencesViewController.m
//  WizardView
//
//  Created by Junqiang You on 4/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesViewController.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"
#import "PreferenceTilesViewController.h"

@implementation PreferencesViewController

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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.title=NSLocalizedString(@"Settings",@"Settings");
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	

	
   
}

-(void)menu{
	[self saveSetting];
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:1.25];
//	[UIView setAnimationDelegate:self];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view.superview cache:YES];
	
	[self.navigationController popViewControllerAnimated:YES];
//	[self.navigationController.view removeFromSuperview];
//	[UIView commitAnimations];
	

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	UIBarButtonItem *d = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(menu)];
	self.navigationItem.rightBarButtonItem =d;
	[d release];
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

-(IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==0){
		return 1;
	}else if(section==1){
		return 1;
	}else if(section==2){
		return 1;
	}else if(section==3){
		return 4;
	}else if(section==4){
		return 1;
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	
	if(indexPath.section==0){
		//user name
		if(indexPath.row==0){
			UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(10,10,150,30)];
			userName.tag=10;
		
			userName.borderStyle=UITextBorderStyleRoundedRect;
			userName.text = delegate.configuration.userName;
			[userName addTarget:self action:@selector(userNameValueChanged:) forControlEvents:UIControlEventEditingDidEndOnExit];
			[userName addTarget:self action:@selector(userNameValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
			cell.accessoryView=userName;
			cell.target=self;
			cell.userInteractionEnabled=YES;
			cell.text=NSLocalizedString(@"Puzzle Author",@"Puzzle Author");
			[userName release];
		}
	}else if(indexPath.section==1){
		if(indexPath.row == 0){
			//sound
			UISwitch *v = [[UISwitch alloc] init];
			v.on=delegate.configuration.playSound;
			v.tag=1;
			[v addTarget:self action:@selector(soundSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = v;
			cell.target=self;
			cell.userInteractionEnabled=YES;
			[v release];
			cell.text = NSLocalizedString(@"Sound",@"sound");
		}
	}else if(indexPath.section==2){
		if(indexPath.row == 0){
			//hint
			cell.text = NSLocalizedString(@"Hint",@"hint");
			UISwitch *v = [[UISwitch alloc] init];
			v.tag=2;
			v.on=delegate.configuration.allowHint;
			[v addTarget:self action:@selector(disableHintSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = v;
			cell.target=self;
			[v release];
		}
	}else if(indexPath.section==3){
		//show-me
		if(indexPath.row == 0){
			//show-me switch
			cell.text = NSLocalizedString(@"Show-Me",@"show-me");
			UISwitch *v = [[UISwitch alloc] init];
			v.tag=3;
			v.on=delegate.configuration.allowShowMe;
			[v addTarget:self action:@selector(disableShowMeSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = v;
			cell.target=self;
			[v release];
		}else if(indexPath.row == 1){
			//show-me warning
			cell.text = NSLocalizedString(@"Display warning",@"display warning");
			UISwitch *v = [[UISwitch alloc] init];
			v.tag=4;
			v.on=delegate.configuration.showShowMeWarning;
			[v addTarget:self action:@selector(showMeWarningSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = v;
			cell.target=self;
			[v release];
		}else if(indexPath.row == 2){
			//show-me steps
			NSString *s = [[NSString alloc] initWithFormat:@"%@ %i%% (%@)",NSLocalizedString(@"Show",@"show"),delegate.configuration.showMeValue, NSLocalizedString(@"unsolved",@"unsolved")];
			cell.text =s;
			[s release];
			
			UISlider *v = [[UISlider alloc] init];
			v.tag=5;
			v.minimumValue=0;
			v.maximumValue=50;
			v.value=delegate.configuration.showMeValue;
			[v addTarget:self action:@selector(showMeValueChanged:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = v;
			cell.target=self;
			[v release];
		}else if(indexPath.row == 3){
			//show-me all for solved puzzles
			cell.text = NSLocalizedString(@"Show all (solved)", @"show all (unsolved)");
			UISwitch *v = [[UISwitch alloc] init];
			v.tag=5;
			v.on=delegate.configuration.showCompleteForSolvedPuzzle;
			[v addTarget:self action:@selector(showMeCompleteSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = v;
			cell.target=self;
			[v release];
		}else{
		}
	}if(indexPath.section==4){
		if(indexPath.row == 0){
			cell.text = NSLocalizedString(@"Tile style",@"Tile style");
		}else{
		}
	}else{
	}
    // Set up the cell...
	
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    NSString *title = nil;
//    switch (section) {
//        case 0:
//            title = NSLocalizedString(@"test", @"test");
//            break;
//        case 1:
//            title = NSLocalizedString(@"Show-Me", @"Show-Me");
//            break;
//        default:
//            break;
//    }
//    return title;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	if(indexPath.section==4){
		if(indexPath.row == 0){
			PreferenceTilesViewController *anotherViewController = [[PreferenceTilesViewController alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:anotherViewController animated:NO];
			[anotherViewController release];
		}
	}
	
}

-(UITableViewCellAccessoryType)tableView:(UITableView*)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath{
	if(indexPath.section==4){
		if(indexPath.row == 0){
			return UITableViewCellAccessoryDisclosureIndicator;
		}
	}
	return UITableViewCellAccessoryNone;
}

-(IBAction)userNameValueChanged:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	UITextField *s = (UITextField*)sender;
	delegate.configuration.userName = s.text;
	[sender resignFirstResponder];
	[self saveSetting];
}
-(IBAction)soundSwitchValueChanged:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	UISwitch *s = (UISwitch*)sender;
	if(s.on){
		delegate.configuration.playSound=YES;
	}else{
		delegate.configuration.playSound=NO;
	}
	[self saveSetting];	
}
-(IBAction)showMeWarningSwitchValueChanged:(id)sender{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	UISwitch *s = (UISwitch*)sender;
	if(s.on){
		delegate.configuration.showShowMeWarning=YES;
	}else{
		delegate.configuration.showShowMeWarning=NO;
	}
	[self saveSetting];
}
-(IBAction)showMeValueChanged:(id)sender{
		UISlider *slider = (UISlider*)sender;
		DebugLog(@"show me %i", (int)slider.value);
		UITableViewCell *cell = (UITableViewCell*)slider.superview;
		
		NSString *s = [[NSString alloc] initWithFormat:@"%@ %i%% (%@)",NSLocalizedString(@"Show",@"show"), (int)slider.value, NSLocalizedString(@"unsolved",@"unsolved")];
		cell.text =s;
		[s release];
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		delegate.configuration.showMeValue=(int)slider.value;
	
	[self saveSetting];
}
	
-(IBAction)disableHintSwitchValueChanged:(id)sender{
		UISwitch *s = (UISwitch*)sender;
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		if(s.on){
			delegate.configuration.allowHint=YES;
		}else{
			delegate.configuration.allowHint=NO;
		}
	[self saveSetting];
}
-(IBAction)disableShowMeSwitchValueChanged:(id)sender{
		UISwitch *s = (UISwitch*)sender;
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		if(s.on){
			delegate.configuration.allowShowMe=YES;
		}else{
			delegate.configuration.allowShowMe=NO;
		}
	}
-(IBAction)showMeCompleteSwitchValueChanged:(id)sender{
	UISwitch *s = (UISwitch*)sender;
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	if(s.on){
		delegate.configuration.showCompleteForSolvedPuzzle=YES;
	}else{
		delegate.configuration.showCompleteForSolvedPuzzle=NO;
	}
	[self saveSetting];
}
	-(void)saveSetting{
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		NSMutableArray *keys = [[NSMutableArray alloc] init];
		NSMutableArray *objects = [[NSMutableArray alloc]init];
		[keys addObject:@"play-sound"];
		if(delegate.configuration.playSound){
			[objects addObject:@"Y"];
		}else{
			[objects addObject:@"N"];
		}
		
		[keys addObject:@"show-me-value"];
		NSString *s = [[NSString alloc] initWithFormat:@"%i",delegate.configuration.showMeValue];
		[objects addObject:s];
		[s release];
		
		[keys addObject:@"display-show-me-warning"];
		if(delegate.configuration.showShowMeWarning){
			[objects addObject:@"Y"];
		}else{
			[objects addObject:@"N"];
		}
		
		[keys addObject:@"allow-hint"];
		if(delegate.configuration.allowHint){
			[objects addObject:@"Y"];
		}else{
			[objects addObject:@"N"];
		}
		
		[keys addObject:@"allow-show-me"];
		if(delegate.configuration.allowShowMe){
			[objects addObject:@"Y"];
		}else{
			[objects addObject:@"N"];
		}
		
		[keys addObject:@"show-complete-for-solved"];
		if(delegate.configuration.showCompleteForSolvedPuzzle){
			[objects addObject:@"Y"];
		}else{
			[objects addObject:@"N"];
		}
		
		if([delegate.configuration.userName compare:@""]!=0){
			[keys addObject:@"user-name"];
			[objects addObject:delegate.configuration.userName];
		}
		
		[keys addObject:@"tile-style-number"];
		NSString *styleNumberString = [[NSString alloc] initWithFormat:@"%i", delegate.configuration.styleNumber];
		[objects addObject:styleNumberString];
		[styleNumberString release];
		
		NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = [paths objectAtIndex:0];
		[dictionary writeToFile:[documentDirectory stringByAppendingPathComponent:@"WordMatrix.setting"] atomically:YES];
		[objects release];
		[keys release];
		[dictionary release];
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

