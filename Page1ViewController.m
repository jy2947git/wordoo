//
//  Page1ViewController.m
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Page1ViewController.h"
//#import "Page2ViewController.h"
#import "DesignWizardCustomPuzzleListViewController.h"
#import "WizardViewAppDelegate.h"

@implementation Page1ViewController
//@synthesize viewControllerPage2;

@synthesize viewControllerCustomPuzzleList;
@synthesize navControllerDesignPuzzleList;
- (IBAction)startDesign:(id)sender{
	//clear session
	WizardViewAppDelegate* delegate = (WizardViewAppDelegate*)[UIApplication sharedApplication].delegate;
	delegate.selectedPuzzleId=nil;
//	if(self.viewControllerCustomPuzzleList==nil){
//		DesignWizardCustomPuzzleListViewController *viewPage = [[DesignWizardCustomPuzzleListViewController alloc]initWithNibName:@"DesignWizardCustomPuzzleList" bundle:nil];
//		//[viewPage setFirstPage:self];
//		//DesignWizardCustomPuzzleListViewController *viewPage = [[DesignWizardCustomPuzzleListViewController alloc] init];
//
//		self.viewControllerCustomPuzzleList = viewPage;
//		[viewPage release];
//	}
	
	if(self.navControllerDesignPuzzleList==nil){
		 
		DesignWizardCustomPuzzleListViewController *viewPage = [[DesignWizardCustomPuzzleListViewController alloc]initWithNibName:@"DesignWizardCustomPuzzleList" bundle:nil];
		//[viewPage setFirstPage:self];
		//DesignWizardCustomPuzzleListViewController *viewPage = [[DesignWizardCustomPuzzleListViewController alloc] init];
		
		//self.viewControllerCustomPuzzleList = viewPage;
		self.navControllerDesignPuzzleList = [[UINavigationController alloc] initWithRootViewController:viewPage];
		[viewPage release];
	}
	//animation begin
	[UIView beginAnimations:@"view flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.superview cache:YES];
	[self.navControllerDesignPuzzleList viewWillAppear:YES];
	[self viewWillDisappear:YES];
	//add and remove view
	[self.view.superview addSubview:navControllerDesignPuzzleList.view];
	[self.view removeFromSuperview];
	//animation end
	[self.navControllerDesignPuzzleList viewDidAppear:YES];
	[self viewDidDisappear:YES];
	[UIView commitAnimations];
	
	
}
//-(IBAction)nextView:(id)sender{
//	
//	if(self.viewControllerPage2==nil){	
//		Page2ViewController *viewPage2 = [[Page2ViewController alloc]initWithNibName:@"Page2View" bundle:nil];
//		[viewPage2 setFirstPage:self];
//		self.viewControllerPage2 = viewPage2;
//		[viewPage2 release];
//
//	}
//	//animation begin
//	[UIView beginAnimations:@"view flip" context:nil];
//	[UIView setAnimationDuration:1.25];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.superview cache:YES];
//	[self.viewControllerPage2 viewWillAppear:YES];
//	[self viewWillDisappear:YES];
//	//add and remove view
//	[self.view.superview addSubview:viewControllerPage2.view];
//	[self.view removeFromSuperview];
//	//animation end
//	[self.viewControllerPage2 viewDidAppear:YES];
//	[self viewDidDisappear:YES];
//	[UIView commitAnimations];
//	
//	}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
	
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//	UIApplication *app = [UIApplication sharedApplication];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];
	
	[super viewDidLoad];
}

-(void)applicationWillTerminate:(NSNotification *)notification{

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
	//[viewControllerPage2 release];
	[navControllerDesignPuzzleList release];

	[viewControllerCustomPuzzleList release];
    [super dealloc];
}


@end
