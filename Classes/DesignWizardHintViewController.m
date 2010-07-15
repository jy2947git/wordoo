//
//  DesignWizardHintViewController.m
//  WizardView
//
//  Created by Junqiang You on 3/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignWizardHintViewController.h"
#import "DesignWizardPage2ViewController.h"
#import "Puzzle.h"
#import "WizardViewAppDelegate.h"
#import "GlobalConfiguration.h"

@implementation DesignWizardHintViewController
@synthesize hint;


-(IBAction)nextPage:(id)sender{
	[hint resignFirstResponder];
	
	if([hint text]!=nil && [hint text]!=@""){
		NSString *hintstr = [[NSString alloc] initWithString:hint.text];
		WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
		
		delegate.currentPuzzle.hint=self.hint.text;
		[hintstr release];
	}
	//animate to next page

	DesignWizardPage2ViewController *viewPage = [[DesignWizardPage2ViewController alloc]initWithNibName:@"DesignWizardPage2" bundle:nil];
		
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
	self.title=NSLocalizedString(@"puzzle ending",@"puzzle ending");
	//UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextPage:)];
	UIBarButtonItem *sItem  = [[UIBarButtonItem alloc]
							   initWithTitle:NSLocalizedString(@"Next", @"Next")
							   style:UIBarButtonItemStyleBordered
							   target:self
							   action:@selector(nextPage:)];
	self.navigationItem.rightBarButtonItem = sItem;
    [sItem release];

}

- (void)viewWillAppear:(BOOL)animate{
	DebugLog(@"DesignWizardViewController.viewWillAppear:statrts");
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	DebugLog(@"current hint is %@", delegate.currentPuzzle.hint);
	if(delegate.currentPuzzle.hint!=nil){
		hint.text=delegate.currentPuzzle.hint;
	}

	
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
	[hint release];

    [super dealloc];
}


@end
