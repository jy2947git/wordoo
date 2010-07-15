//
//  BrowseCommunityViewController.m
//  WizardView
//
//  Created by Junqiang You on 5/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowseCommunityViewController.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"
#import "Reachability.h"
#import "GlobalHeader.h"



@implementation BrowseCommunityViewController
//@synthesize receivedData;
@synthesize puzzles;
@synthesize currentPage;
@synthesize fiveStarImg;
@synthesize spinner;
//make sure to match App Engine setting
int pageSize=25;


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		self.puzzles = [[NSMutableArray alloc] init];
		self.tableView.rowHeight = 55;
		NSString *imagePathSolved = [[NSBundle mainBundle] pathForResource:@"five-star"
																	ofType:@"png"];
		self.fiveStarImg = [UIImage imageWithContentsOfFile:imagePathSolved];
		

    }
    return self;
}

		-(void)startSpinner{
			if(self.spinner==nil){
				DebugLog(@"creagting spinner...");
				UIActivityIndicatorView *c = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
				c.frame=CGRectMake(150, 200, 30, 30);
				
				self.spinner =c;
				[c release];
				[self.view addSubview:self.spinner];
			}
			if(![self.spinner isAnimating]){
				DebugLog(@"spinning...");
				[self.spinner startAnimating];
			}
		}
		
		-(void)stopSpinner{
			if(self.spinner!=nil && [self.spinner isAnimating]){
				DebugLog(@"stoping spinning...");
				[self.spinner stopAnimating];
			}
		}

//-(void)downloadPuzzleList:(int)page{
//	// create the request 
//	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL 
//														   URLWithString:@"http://127.0.0.1:8080/wordee/puzzle?command=browse&start=0&end=26&token=2983032043nksfd0-1fda-1hf"] 
//											  cachePolicy:NSURLRequestUseProtocolCachePolicy 
//										  timeoutInterval:60.0]; 
//	// create the connection with the request 
//	// and start loading the data 
//	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest 
//																   delegate:self]; 
//	if (theConnection) { 
//		// Create the NSMutableData that will hold 
//		// the received data 
//		// receivedData is declared as a method instance elsewhere 
//		receivedData=[[NSMutableData data] retain]; 
//	} else { 
//		// inform the user that the download could not be made 
//	} 
//	
//	
//}

-(void)downloadPuzzleList:(int)page{

//	[[Reachability sharedReachability] setHostName:serverHost];
//	NetworkStatus hostStatus = [[Reachability sharedReachability] remoteHostStatus];
//	NetworkStatus internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
//	NetworkStatus localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
//	DebugLog(@"%i %i %i %i %i",hostStatus,internetConnectionStatus,localWiFiConnectionStatus,ReachableViaCarrierDataNetwork,ReachableViaWiFiNetwork);
//	if(internetConnectionStatus!=ReachableViaCarrierDataNetwork && localWiFiConnectionStatus!=ReachableViaWiFiNetwork){
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//															message:NSLocalizedString(@"Host is not reachable",@"Host is not reachable")
//														   delegate:self
//												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
//												  otherButtonTitles:nil,nil];
//		alertView.opaque=YES;
//		[alertView show];
//		[alertView release];
//		return;
//	}
	int start=pageSize*page;
	int end=start+pageSize+1;
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/wordee/puzzle?command=browse&start=%i&end=%i&token=%@",serverHost,start,end,requestToken];
	DebugLog(@"request:%@", urlString);
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
	NSError *error = nil;
	NSString *list = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	[url release];
	
	if(error){
		[list release];
		NSString *msg = [[NSString alloc] initWithFormat:@"%@", NSLocalizedString(@"Could not establish internet connection to Wordoo community server",@"Could not establish internet connection to Wordoo community server")]; 
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:msg
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		[msg release];
	}else{
		DebugLog(@"result:%@",list);
		if(list==nil || ![list hasPrefix:@"SUCCESS"]){
			return;
		}
		//test2^ying ma^05/02/2009|test2^ying ma|05/02/2009|test2^ying ma|05/02/2009
		[self.puzzles removeAllObjects];

		//by default, every request will fetch pageSize+1 records, thus to know whether to display "browse next 25 puzzles"
		if(page>0){
			[self.puzzles addObject:@"PREVIOUS"];
		}else{
			
		}
		NSMutableArray *downloadedData = [[NSMutableArray alloc] init];
		[downloadedData addObjectsFromArray:[list componentsSeparatedByString:@"|"]];
		[downloadedData removeObjectAtIndex:0];
		[self.puzzles addObjectsFromArray:downloadedData];
		if([downloadedData count]==pageSize+1){
			//
			[self.puzzles removeLastObject];
			[self.puzzles addObject:@"NEXT"];
			
		}
		[self.puzzles addObject:@"HIDE"];
		[list release];
		[downloadedData release];
	}
	
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title=NSLocalizedString(@"Wordoo Community",@"Wordoo Community");
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
	self.currentPage=0;
	[self startSpinner];
	[NSThread detachNewThreadSelector:@selector(downloadPuzzleListInBackground) toTarget:self withObject:nil];
//	[self.puzzles addObject:@"1^testafdasf fdafadsf afrdsfadsf 321rfrasdf23r523r43fdsafasadsfgad2^ying ma^05/02/2009"];
//	[self.puzzles addObject:@"2^test2^ying ma^05/02/2009"];
//	[self.puzzles addObject:@"3^test2^ying ma^05/02/2009"];
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


-(void)downloadPuzzleListInBackground{
	NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	
	[self downloadPuzzleList:self.currentPage];
	[self.tableView reloadData];
	[self stopSpinner];
	[p release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	DebugLog(@"right now there are %i records", [self.puzzles count]);
	if(puzzles==nil){
		return 0;
	}
    return [puzzles count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	DebugLog(@"right now there are %i records", [self.puzzles count]);
	if([[self.puzzles objectAtIndex:indexPath.row] caseInsensitiveCompare:@"PREVIOUS"] ==0){
		//previous button
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"previousButton"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"previousButton"] autorelease];
			cell.textAlignment=UITextAlignmentCenter;
			cell.textColor=[UIColor grayColor];
			cell.font = [UIFont boldSystemFontOfSize:14];
			NSString *s=[[NSString alloc] initWithFormat:@"                %@ %i %@ ...",NSLocalizedString(@"Browse previous",@"Browse previous"),pageSize,NSLocalizedString(@"puzzles",@"puzzles")];
			cell.text=s;
			[s release];
		}
		return cell;
	}
	if([[self.puzzles objectAtIndex:indexPath.row] caseInsensitiveCompare:@"NEXT"] ==0){
		//next page button
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nextButton"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"nextButton"] autorelease];
			cell.font = [UIFont boldSystemFontOfSize:14];
			
			cell.textColor=[UIColor grayColor];
			cell.textAlignment=UITextAlignmentCenter;
			NSString *s=[[NSString alloc] initWithFormat:@"               %@ %i %@ ...",NSLocalizedString(@"Browse next",@"Browse next"),pageSize,NSLocalizedString(@"puzzles",@"puzzles")];
			cell.text=s;
			[s release];
		}
		return cell;
	}
	if([[self.puzzles objectAtIndex:indexPath.row] caseInsensitiveCompare:@"HIDE"] ==0){
		//previous button
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hide"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"hide"] autorelease];
		}
		return cell;
	}
    static NSString *CellIdentifier = @"pd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];

		UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 40)];
		
		leftLabel.tag=LEFT_LABEL1;
		leftLabel.textAlignment=UITextAlignmentLeft;
		leftLabel.font = [UIFont systemFontOfSize:14];
		[cell.contentView addSubview:leftLabel];
		[leftLabel release];
		
		//
		
		UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 115, 25)];
		
		rightLabel.tag=RIGHT_LABEL1;
		rightLabel.textAlignment=UITextAlignmentRight;
		rightLabel.font = [UIFont systemFontOfSize:14];
		[cell.contentView addSubview:rightLabel];
		[rightLabel release];
		
		


		
	
			
	}
	//clear first
	if([cell.contentView viewWithTag:RIGHT_LABEL2]!=nil){
		[[cell.contentView viewWithTag:RIGHT_LABEL2] removeFromSuperview];
	}
	if([cell.contentView viewWithTag:RIGHT_MASK]!=nil){
		[[cell.contentView viewWithTag:RIGHT_MASK] removeFromSuperview];
	}
	// Set up the cell...
	NSString *ps = [puzzles objectAtIndex:indexPath.row];
	NSArray *psdata = [ps componentsSeparatedByString:@"^"];
	((UILabel*)[cell viewWithTag:LEFT_LABEL1]).text=[psdata objectAtIndex:1]; //name
    ((UILabel*)[cell viewWithTag:RIGHT_LABEL1]).text = [psdata objectAtIndex:2]; //author

	NSString *rating = [psdata objectAtIndex:5];//rating
	if([rating doubleValue]>0){
		
		DebugLog(@"rating %@", rating);
		UIImageView *rightLabel2 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 30, 70, 20)];
		rightLabel2.tag = RIGHT_LABEL2;
		
		rightLabel2.image=self.fiveStarImg;
		
		[cell.contentView addSubview:rightLabel2];
		[rightLabel2 release];
		
		UIImageView *starView = ((UIImageView*)[cell viewWithTag:RIGHT_LABEL2]);
		double displayWidth = starView.bounds.size.width*[rating doubleValue]/5-5;
		if(displayWidth>0){
			UILabel *maskLabel = [[UILabel alloc] initWithFrame:CGRectMake(displayWidth, 0,starView.bounds.size.width-displayWidth, 20)];
			maskLabel.tag=RIGHT_MASK;
			//maskLabel.text=[NSString stringWithFormat:@"%@",rating];
			[((UIImageView*)[cell viewWithTag:RIGHT_LABEL2]) addSubview:maskLabel];
			[maskLabel release];
		}
	}
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	if([[self.puzzles objectAtIndex:indexPath.row] caseInsensitiveCompare:@"HIDE"] ==0){
		[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
		return;
	}
	if([[self.puzzles objectAtIndex:indexPath.row] caseInsensitiveCompare:@"PREVIOUS"] ==0){
		//click previous button
		[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
		self.currentPage--;
		[self downloadPuzzleList:self.currentPage];
		//reload
		[self.tableView reloadData];
		return;
	}else if([[self.puzzles objectAtIndex:indexPath.row] caseInsensitiveCompare:@"NEXT"] ==0){
		//click next button
		[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
		self.currentPage++;
		[self downloadPuzzleList:self.currentPage];
		//
		[self.tableView reloadData];
		return;
	}else{
		//check whether user is allowed to download - free version not
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		if(delegate.configuration.releaseTypeOfApp<STANDARD_APP){
			//plain warning
			NSString *msg = [[NSString alloc] initWithFormat:@"%@",NSLocalizedString(@"This version has limited access to Wordoo host. To download free puzzles, please purchase the Wordoo(Unlock) version",@"This version has limited access to Wordoo host. To download free puzzles, please purchase the Wordoo(Unlock) version")];
			UIActionSheet *styleAlert =
			[[UIActionSheet alloc] initWithTitle:msg
										delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
							   otherButtonTitles:nil, nil, nil];
			//styleAlert.tag=PURCHASE_UNLOCK;
			// use the same style as the nav bar
			styleAlert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
			
			[styleAlert showInView:self.view];
			[styleAlert release];
			[msg release];

		}else{
			NSString *ps = [puzzles objectAtIndex:indexPath.row];
			NSArray *psdata = [ps componentsSeparatedByString:@"^"];
			NSString *msg = [[NSString alloc] initWithFormat:@"%@?",NSLocalizedString(@"Download Puzzle",@"Download Puzzle")];
			UIActionSheet *styleAlert =
			[[UIActionSheet alloc] initWithTitle:nil
										delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
							   otherButtonTitles:msg, nil, nil];
			styleAlert.tag=DOWNLOAD_PUZZLE;
			// use the same style as the nav bar
			styleAlert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
			
			[styleAlert showInView:self.view];
			[styleAlert release];
			[msg release];
		}

	}
}



- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	DebugLog(@"selected button %i", buttonIndex);
	if(modalView.tag==DOWNLOAD_PUZZLE){
		if (buttonIndex == 1) {
			
		}else{
			[self downloadSelectedPuzzle];
		}
		
	}//else if(modalView.tag==PURCHASE_UNLOCK){
//		if (buttonIndex == 1) {
//			
//		}else{
//			//purchase
////			[self startPurchase:kMyFeatureIdentifier];
//
//		}
//	}
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {  
	if(DOWNLOAD_PUZZLE==alertView.tag){
		if (buttonIndex == 0) {
			
		}else{
			[self downloadSelectedPuzzle];
		}
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	}
	
}

-(void)downloadSelectedPuzzle{
	NSString *ps = [[NSString alloc] initWithString:[puzzles objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
		
		
//		[[Reachability sharedReachability] setHostName:serverHost];
//		NetworkStatus hostStatus = [[Reachability sharedReachability] remoteHostStatus];
//		NetworkStatus internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
//		NetworkStatus localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
//		DebugLog(@"%i %i %i",hostStatus,internetConnectionStatus,localWiFiConnectionStatus);
//		if(internetConnectionStatus!=ReachableViaCarrierDataNetwork && localWiFiConnectionStatus!=ReachableViaWiFiNetwork){
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//																message:NSLocalizedString(@"Host is not reachable",@"Host is not reachable")
//															   delegate:self
//													  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
//													  otherButtonTitles:nil,nil];
//			alertView.opaque=YES;
//			[alertView show];
//			[alertView release];
//			return;
//		}
		

		
		DebugLog(@"downloading %@", ps);
		NSArray *psdata = [ps componentsSeparatedByString:@"^"];
		NSString *pid = [psdata objectAtIndex:0]; //system id
		DebugLog(@"puzzle id=%@",pid);
		NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/wordee/puzzle?command=download&id=%@&token=%@",serverHost,pid,requestToken];
		DebugLog(@"request:%@",urlString);
		NSURL *url = [[NSURL alloc] initWithString:urlString];
		NSError *error = nil;
		NSString *pdata = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
		DebugLog(@"pdata=[%@]",pdata);
		if(error){
			[pdata release];
			[urlString release];
			[url release];
			NSString *msg = [[NSString alloc] initWithFormat:@"%@", NSLocalizedString(@"Could not connect to server",@"Could not connect to server")]; 
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																message:msg
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
													  otherButtonTitles:nil,nil];
			alertView.opaque=YES;
			[alertView show];
			[alertView release];
			[msg release];
			
		}else{

			[urlString release];
			[url release];
			if(![pdata hasPrefix:@"<?xml"]){
				//somethig wrong, server maybe too busy
				NSString *msg = [[NSString alloc] initWithFormat:@"%@", NSLocalizedString(@"Server was too busy",@"Server was too busy")]; 
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																	message:msg
																   delegate:self
														  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
														  otherButtonTitles:nil,nil];
				alertView.opaque=YES;
				[alertView show];
				[alertView release];
				[msg release];
				
			}else{
				//save
				NSString *pname = [psdata objectAtIndex:1]; //puzzle name
				NSString *savedName = [[NSString alloc] initWithFormat:@"%@~%@",pid, pname]; //downloaded puzzle file name will be like "1234~my stuff.pz"
				int count = 1;
				WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
				while([delegate.allPuzzles containsObject:savedName]){
					//same name already exists
					count++;
					[savedName release];
					savedName = [[NSString alloc] initWithFormat:@"%@~%@ (%i)",pid, pname, count];
				}
				//
				NSString *filePath = [[NSString alloc] initWithFormat:@"%@.pz",savedName];
				[pdata  writeToFile:[delegate.configuration.customPuzzleDirectory stringByAppendingPathComponent:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
				[delegate.allPuzzles addObject:savedName];
				[filePath release];

				[pdata release];
			
				NSArray* components = [savedName componentsSeparatedByString:@"~"];
			
				NSString *msg = [[NSString alloc] initWithFormat:@"%@ %@", NSLocalizedString(@"Downloaded puzzle",@"Downloaded puzzle"),[components objectAtIndex:1]];
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:msg
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
				alertView.opaque=YES;
				[alertView show];
				[alertView release];
				[msg release];
		
				[savedName release];
			}
		}
	[ps release];
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
//	[receivedData release];
	[spinner release];
	[puzzles release];
	[fiveStarImg release];
    [super dealloc];
}


//---------------------------
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse 
//																	 *)response 
//{ 
//    // this method is called when the server has determined that it 
//    // has enough information to create the NSURLResponse 
//    // it can be called multiple times, for example in the case of a 
//    // redirect, so each time we reset the data. 
//    // receivedData is declared as a method instance elsewhere 
//    [receivedData setLength:0]; 
//} 
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
//{ 
//    // append the new data to the receivedData 
//    // receivedData is declared as a method instance elsewhere 
//    [receivedData appendData:data]; 
//} 
//- (void)connection:(NSURLConnection *)connection 
//  didFailWithError:(NSError *)error 
//{ 
//    // release the connection, and the data
//	[connection release]; 
//    // receivedData is declared as a method instance elsewhere 
//    [receivedData release]; 
//    // inform the user 
//    DebugLog(@"Connection failed! Error - %@ %@", 
//          [error localizedDescription], 
//          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]); 
//} 
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
//{ 
//    // do something with the data 
//    // receivedData is declared as a method instance elsewhere 
//    DebugLog(@"Succeeded! Received %d bytes of data %@",[receivedData length], receivedData); 
//    // release the connection, and the data object 
//    [connection release]; 
//    [receivedData release]; 
//} 




@end