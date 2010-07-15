//
//  DesignWiardPage1ViewController.m
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignWiardPage1ViewController.h"
#import "DesignWizardHintViewController.h"
#import "DesignWizardCustomPuzzleListViewController.h"
#import "PuzzleHelper.h"
#import "WizardViewAppDelegate.h"
#import "Puzzle.h"
#import "GlobalConfiguration.h"

@implementation DesignWiardPage1ViewController


@synthesize name;
@synthesize row0;
@synthesize row1;
@synthesize row2;
@synthesize row3;
@synthesize row4;
@synthesize row5;
@synthesize currentPuzzleId;


-(IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
	[self validate];
}

-(Boolean)validate{
	NSMutableString *message = [self validateRowSize];
	if([message compare:@""]!=0){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"error")
															message:message
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		[message release];
		return NO;
	}
	[message release];
	return YES;
}

-(NSMutableString*)validatePuzzleName:(NSString*)puzzleName{
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	NSMutableString *message = [[NSMutableString alloc] initWithString:@""];
	if([delegate.allPuzzles containsObject:puzzleName]){
		[message appendFormat:NSLocalizedString(@"same puzzle name already exists!", @"same puzzle name already exists!")];
	}
	return message;
}
-(NSMutableString*)validateRowSize{
	NSMutableString *message = [[NSMutableString alloc] initWithString:@""];
	if([row0 text]!=nil && [row0 text]!=@"" && row0.text.length>6){
		[message appendFormat:@"%@\n",NSLocalizedString(@"Please keep the first row size at most 6 characters",@"Please keep the first row size at most 6 characters")];
	}
	if([row1 text]!=nil && [row1 text]!=@"" && row1.text.length>6){
		[message appendFormat:@"%@\n",NSLocalizedString(@"Please keep the second row size at most 6 characters",@"Please keep the second row size at most 6 characters")];
	}
	if([row2 text]!=nil && [row2 text]!=@"" && row2.text.length>6){
			[message appendFormat:@"%@\n",NSLocalizedString(@"Please keep the third row size at most 6 characters",@"Please keep the third row size at most 6 characters")];
	}
	if([row3 text]!=nil && [row3 text]!=@"" && row3.text.length>6){
		[message appendFormat:@"%@\n",NSLocalizedString(@"Please keep the fourth row size at most 6 characters",@"Please keep the fourth row size at most 6 characters")];
	}
	if([row4 text]!=nil && [row4 text]!=@"" && row4.text.length>6){
		[message appendFormat:@"%@\n",NSLocalizedString(@"Please keep the fifth row size at most 6 characters",@"Please keep the fifth row size at most 6 characters")];
	}
	if([row5 text]!=nil && [row5 text]!=@"" && row5.text.length>6){
		[message appendFormat:@"%@\n",NSLocalizedString(@"Please keep the sixth row size at most 6 characters",@"Please keep the sixth row size at most 6 characters")];
	}
	return message;
}

-(Boolean)validateAll{
	NSMutableString *message = [[NSMutableString alloc] initWithString:@""];
	NSString *validateName = nil;
	if(name.text!=nil && [[name text] compare:@""]==0){
		[message appendFormat:@"%@\n",NSLocalizedString(@"Puzzle name is required and must be unique",@"Puzzle name is required and must be unique")];
	}else{
		validateName = [self validatePuzzleName:[name text]];
		if([validateName compare:@""]!=0){
			[message appendFormat:@"%@\n", validateName];
		}
		
	}
	if(row0.text!=nil && [row0.text compare:@""]==0 && 
		row1.text!=nil && [row1.text compare:@""]==0 && 
		row2.text!=nil && [row2.text compare:@""]==0 && 
		row3.text!=nil && [row3.text compare:@""]==0 && 
		row4.text!=nil && [row4.text compare:@""]==0 && 
	   row5.text!=nil && [row5.text compare:@""]==0){
		[message appendFormat:@"%@\n",NSLocalizedString(@"At least one row should not be empty",@"At least one row should not be empty")];
	}
	NSString *validateRowSize = [self validateRowSize];
	if([validateRowSize compare:@""]!=0){
		[message appendFormat:@"%@",validateRowSize];
	}
	
	if([message compare:@""]!=0){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"error")
															message:message
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
												  otherButtonTitles:nil,nil];
		alertView.opaque=YES;
		[alertView show];
		[alertView release];
		if(validateName!=nil){
			[validateName release];
		}
		[validateRowSize release];
		[message release];
		return NO;
		
	}
	if(validateName!=nil){
		[validateName release];
	}
	[validateRowSize release];
	[message release];
	return YES;
}
-(IBAction)nextPage:(id)sender{
	if(![self validateAll]){
		return;
	}
	//pass the rows to next page through delegate
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	//clear the current puzzle in memory
	if(delegate.currentPuzzle!=nil){
		[delegate.currentPuzzle clear];
	}
	else{
		Puzzle *p = [[Puzzle alloc]init];
		delegate.currentPuzzle = p;
		[p release];
	}
	//complete strategy by default is compare-display
	delegate.currentPuzzle.completeStrategy = @"DISPLAY";
	

	NSMutableArray *rows = [[NSMutableArray alloc] init];
	if(delegate.currentPuzzle.completeData!=nil){
		[delegate.currentPuzzle.completeData removeAllObjects];
	}else{
		NSMutableArray *c =  [[NSMutableArray alloc] init];
		delegate.currentPuzzle.completeData = c;
		[c release];
	}
	//////// populdate puzzle name
	if([name text]!=nil && [name text]!=@""){
		NSString *inputName = [[NSString alloc] initWithString:name.text];
		delegate.currentPuzzle.name=inputName;
		[inputName release];
	}
	
	////////populate puzzle hint
//	NSMutableString *hint = [NSMutableString stringWithFormat:@""];
	int maxRows=0;
	int maxcols=0;
	if(row0.text!=nil && [row0.text compare:@""]!=0){
		maxRows++;
		if([row0.text length]>maxcols){
			maxcols=[row0.text length];
		}
		[delegate.currentPuzzle.completeData addObject:row0.text];
		NSString *inputRow0 = [[NSString alloc] initWithString:row0.text];
		[rows addObject:inputRow0];
//		[hint appendFormat:@"%@\n",inputRow0];
		[inputRow0 release];
	}
	
	if(row1.text!=nil && [row1.text compare:@""]!=0){
		maxRows++;
		if([row1.text length]>maxcols){
			maxcols=[row1.text length];
		}
		[delegate.currentPuzzle.completeData addObject:row1.text];
		NSString *inputRow1 = [[NSString alloc] initWithString:row1.text];
		[rows addObject:inputRow1];
//		[hint appendFormat:@"%@\n",row1.text];
		[inputRow1 release];
	}
	if(row2.text!=nil && [row2.text compare:@""]!=0){
		maxRows++;
		if([row2.text length]>maxcols){
			maxcols=[row2.text length];
		}
		[delegate.currentPuzzle.completeData addObject:row2.text];
		NSString *inputRow2 = [[NSString alloc] initWithString:row2.text];
		[rows addObject:inputRow2];
//		[hint appendFormat:@"%@\n",row2.text];
		[inputRow2 release];
	}
	if(row3.text!=nil && [row3.text compare:@""]!=0){
		maxRows++;
		if([row3.text length]>maxcols){
			maxcols=[row3.text length];
		}
		[delegate.currentPuzzle.completeData addObject:row3.text];
		NSString *inputRow3 = [[NSString alloc] initWithString:row3.text];
		[rows addObject:inputRow3];
//		[hint appendFormat:@"%@\n",row3.text];
		[inputRow3 release];
	}
	if(row4.text!=nil && [row4.text compare:@""]!=0){
		maxRows++;
		if([row4.text length]>maxcols){
			maxcols=[row4.text length];
		}
		[delegate.currentPuzzle.completeData addObject:row4.text];
		NSString *inputRow4 = [[NSString alloc] initWithString:row4.text];
		[rows addObject:inputRow4];
//		[hint appendFormat:@"%@\n",row4.text];
		[inputRow4 release];
	}
	if(row5.text!=nil && [row5.text compare:@""]!=0){
		maxRows++;
		if([row5.text length]>maxcols){
			maxcols=[row5.text length];
		}
		[delegate.currentPuzzle.completeData addObject:row5.text];
		NSString *inputRow5 = [[NSString alloc] initWithString:row5.text];
		[rows addObject:inputRow5];
//		[hint appendFormat:@"%@\n",row5.text];
		[inputRow5 release];
	}

//	delegate.currentPuzzle.hint = [[NSString stringWithString:hint] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	delegate.currentPuzzle.matrixRows = maxRows;
	delegate.currentPuzzle.matrixCols = maxcols;
	////////// populdate solution steps
	if(delegate.currentPuzzle.solutionSteps!=nil){
		[delegate.currentPuzzle.solutionSteps removeAllObjects];
	}else{
		NSMutableArray *s = [[NSMutableArray alloc]init];
		delegate.currentPuzzle.solutionSteps = s;
		[s release];
	}
	

	///////// populdate data matrix
	if(delegate.currentPuzzle.dataMatrix!=nil){
		[delegate.currentPuzzle.dataMatrix removeAllObjects];
	}else{
		NSMutableArray *d = [[NSMutableArray alloc]init];
		delegate.currentPuzzle.dataMatrix = d;
		[d release];
	}
	NSMutableArray* displayKeys = [[NSMutableArray alloc] init];
	NSMutableArray* displayObjects = [[NSMutableArray alloc] init];
	for(int i=0;i<delegate.currentPuzzle.matrixRows;i++){
		NSString *s = [rows objectAtIndex:i];
		NSMutableArray* dataRow = [[NSMutableArray alloc] init];
		
		for(int j=0;j<delegate.currentPuzzle.matrixCols;j++){
			NSMutableString *key = nil;
			switch (i){
				case 0:
					key = [[NSString alloc] initWithFormat:@"a%i",j];
					break;
				case 1:
					key = [[NSString alloc] initWithFormat:@"b%i",j];
					break;
				case 2:
					key = [[NSString alloc] initWithFormat:@"c%i",j];
					break;
				case 3:
					key = [[NSString alloc] initWithFormat:@"d%i",j];
					break;
				case 4:
					key =[[NSString alloc] initWithFormat:@"e%i",j];
					break;
				case 5:
					key = [[NSString alloc] initWithFormat:@"f%i",j];
					break;
				default:
					DebugLog(@"unexpected error - matrix rows beyond limit of 6");
					break;
			}
			
			
			[dataRow addObject:key];
			[displayKeys addObject: key];
			[key release];

			if(j<[s length]){
				NSString *letter = [s substringWithRange:NSMakeRange(j, 1)];
				[displayObjects addObject:letter];
			}else{
				//default stone
				[displayObjects addObject:@"^"];
			}
			
		}
		
		[delegate.currentPuzzle.dataMatrix addObject:dataRow];
		[dataRow release];
		
	}	
	[displayKeys addObject:@"#"];
	[displayObjects addObject:@"#"];
	[displayKeys addObject:@"^"];
	[displayObjects addObject:@"^"];
	NSMutableDictionary *dm =  [[NSMutableDictionary alloc] initWithObjects:displayObjects forKeys:displayKeys];
	delegate.currentPuzzle.displayMap = dm;
	[dm release];
	[displayKeys release];
	[displayObjects release];
	///////////// end
	
	[rows release];
	//
	[PuzzleHelper printPuzzle:delegate.currentPuzzle];
	//animate to next page

	DesignWizardHintViewController *viewPage = [[DesignWizardHintViewController alloc]initWithNibName:@"DesignWizardHintPage" bundle:nil];
	[self.navigationController pushViewController:viewPage animated:YES];
	[viewPage release];
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
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
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	self.title=NSLocalizedString(@"Words",@"Words");

	//UIBarButtonItem *sItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextPage:)];
	UIBarButtonItem *sItem  = [[UIBarButtonItem alloc]
						   initWithTitle:NSLocalizedString(@"Next", @"Next")
						   style:UIBarButtonItemStyleBordered
						   target:self
						   action:@selector(nextPage:)];
	self.navigationItem.rightBarButtonItem = sItem;
	[sItem release];
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

	[name release];
	[row0 release];
	[row1 release];
	[row2 release];
	[row3 release];
	[row4 release];
	[row5 release];
	[currentPuzzleId release];
    [super dealloc];
}


@end
