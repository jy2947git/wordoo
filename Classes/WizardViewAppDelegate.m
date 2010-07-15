//
//  WizardViewAppDelegate.m
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "WizardViewAppDelegate.h"
#import "WordWizardPuzzleViewController.h"
#import "WordWizardPuzzleHelper.h"
#import "Puzzle.h"
#import "PuzzleHelper.h"
#import "GlobalConfiguration.h"
#import "RootTabBarController.h"
#import "MainMenuViewController.h"
#import "DesignWizardCustomPuzzleListViewController.h"
#import "BrowseCommunityViewController.h"
#import "ScoreViewController.h"
#import "PreferencesViewController.h"
#import "GlobalHeader.h"

@implementation WizardViewAppDelegate
@synthesize configuration;
@synthesize currentPuzzle;
@synthesize window;
@synthesize wordWizardPuzzleViewController;

@synthesize allPuzzles;
@synthesize selectedPuzzleId;

@synthesize lastPuzzleId;
@synthesize lastTakenSteps;
@synthesize navControllerMainmenu;
@synthesize controllerTabBar;

- (void)applicationDidFinishLaunching:(UIApplication *)application {   
	
	NSMutableArray *a =  [[NSMutableArray alloc] init];
	self.allPuzzles = a;
	[a release];
	
	GlobalConfiguration *g = [[GlobalConfiguration alloc]init];
	self.configuration = g;
	[g release];
	
	[self startup];

	
}


- (void)startup{
	//NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];

	[WordWizardPuzzleHelper addAllStandardPuzzles:self.allPuzzles];
	
	[WordWizardPuzzleHelper addAllCustomizedPuzzles:self.allPuzzles];
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *dictionary = [bundle infoDictionary];
	if([dictionary objectForKey:@"SignerIdentity"]!=nil){
		//cracked version!
		self.configuration.releaseTypeOfApp =FREE_APP;

		UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"cracked version",@"cracked version") message:NSLocalizedString(@"sorry, will run in free version mode",@"sorry, will run in free version mode") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"ok") otherButtonTitles:nil];
		[openURLAlert show];
		[openURLAlert release];
	}
	
    // Override point for customization after application launch
    lastPuzzleId = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *stateFilePath = [documentDirectory stringByAppendingPathComponent:@"puzzle-play-state.dat"];
	if([fm isReadableFileAtPath:stateFilePath]){
		//recover from last time play state
		NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:stateFilePath];
		self.lastPuzzleId = [dic objectForKey:@"puzzle-id"];
		self.lastTakenSteps = [dic objectForKey:@"user-steps"];
		//clear the file
		[fm removeItemAtPath:stateFilePath error:nil];
		[dic release];
	}
	//no alert, always start from last time
	if(self.selectedPuzzleId==nil && self.lastPuzzleId!=nil){
		self.selectedPuzzleId = self.lastPuzzleId;
	}
	[self performSelector:@selector(startTabView) withObject:nil afterDelay:0.0];

	
	
}

-(void)startTabView{
	if(self.selectedPuzzleId==nil && [self.allPuzzles count]>0){
		self.selectedPuzzleId = [self.allPuzzles objectAtIndex:0];
	}
	WordWizardPuzzleViewController *w = [[WordWizardPuzzleViewController alloc]initWithNibName:@"WordWizardPuzzleView" bundle:nil];
	UINavigationController *nw = [[UINavigationController alloc] initWithRootViewController:w];
	UITabBarItem *wt=[[UITabBarItem alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play-wordoo-icon.png"] tag:1];
	nw.tabBarItem=wt;
	
	DesignWizardCustomPuzzleListViewController *d = [[DesignWizardCustomPuzzleListViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:d];
	UITabBarItem *dt=[[UITabBarItem alloc] initWithTitle:@"Puzzles" image:[UIImage imageNamed:@"my-puzzles-icon.png"] tag:2];
	n.tabBarItem=dt;
	
	BrowseCommunityViewController *b = [[BrowseCommunityViewController alloc] initWithStyle:UITableViewStylePlain];
	UITabBarItem *bt=[[UITabBarItem alloc] initWithTitle:@"Community" image:[UIImage imageNamed:@"group-icon.png"] tag:3];
	b.tabBarItem=bt;
//	ScoreViewController *s = [[ScoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	UITabBarItem *st=[[UITabBarItem alloc] initWithTitle:@"scores" image:nil tag:4];
//	s.tabBarItem=st;
	PreferencesViewController *p = [[PreferencesViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UITabBarItem *pt=[[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"settings-icon.png"] tag:5];
	p.tabBarItem=pt;


	RootTabBarController *t = [[RootTabBarController alloc] init];
	self.controllerTabBar=t;
	self.controllerTabBar.delegate=t;
	[t release];
	NSArray *tabs = nil;
	if(self.configuration.releaseTypeOfApp<STANDARD_APP){
		tabs = [[NSArray alloc] initWithObjects:nw,p,nil];
	}else{
		tabs = [[NSArray alloc] initWithObjects:nw,n,b,p,nil];
	}
	self.controllerTabBar.viewControllers=tabs;
//	self.controllerTabBar.selectedViewController=nw;
	self.controllerTabBar.selectedIndex=0;
	[window addSubview:self.controllerTabBar.view];
	[w release];
	[nw release];
	[wt release];
	[d release];
	[dt release];
	[n release];
	[b release];
	[bt release];
//	[s release];
//	[st release];
	[p release];
	[pt release];
	[tabs release];
	[window makeKeyAndVisible];

	
}
- (void)startedWithNormal{
	DebugLog(@"starting normally");
	if(self.selectedPuzzleId==nil && [self.allPuzzles count]>0){
		self.selectedPuzzleId = [self.allPuzzles objectAtIndex:0];
	}
	
	//load main menu and puzzle view controllers
//	if(self.mainMenuViewController==nil){
//		MainMenuViewController *m = [[MainMenuViewController alloc]initWithNibName:@"MainMenuView" bundle:nil];
//		self.mainMenuViewController =  m;
//		[m release];
//	}
//	if(self.wordWizardPuzzleViewController==nil){
		WordWizardPuzzleViewController *w = [[WordWizardPuzzleViewController alloc]initWithNibName:@"WordWizardPuzzleView" bundle:nil];
		self.wordWizardPuzzleViewController = w;
		[w release];
//	}
	
	MainMenuViewController *m = [[MainMenuViewController alloc]initWithNibName:@"MainMenuView" bundle:nil];

	UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:m];
	self.navControllerMainmenu = n;
	//[self.navControllerMainmenu setNavigationBarHidden:YES];
	[n release];
	[m release];
	
	if(self.selectedPuzzleId!=nil){
		DebugLog(@"go directly to puzzle view");
		
		[window addSubview:self.wordWizardPuzzleViewController.view];
	}else{
		DebugLog(@"go to menu");
		
		[window addSubview:self.navControllerMainmenu.view];
	}
	[window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{   
	
    // You should be extremely careful when handling URL requests.
    // You must take steps to validate the URL before handling it.
    
    if (!url) {
        // The URL is nil. There's nothing more to do.
        return NO;
    }
    
    NSString *URLString = [url absoluteString];
    //url string is like "wordoo:?puzzleName=1234&puzzleData=compressedString"   
    if (!URLString) {
        // The URL's absoluteString is nil. There's nothing more to do.
        return NO;
    }
    
	
	NSString* decodedURL = [URLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	DebugLog(@"decodedURL=[%@]",decodedURL);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *customPuzzleDirectory = [paths objectAtIndex:0];

	//parse the url to get puzzle name between "puzzleName=xxx&puzzleData=xxx"
	NSString *parameterString = [decodedURL substringFromIndex:[decodedURL rangeOfString:@"puzzleName="].location];
	if(parameterString!=nil){	
		NSArray *parameters = [parameterString componentsSeparatedByString:@"&"];
		if(parameters!=nil && [parameters count]>=2){
			NSString *puzzleName = [(NSString*)[parameters objectAtIndex:0] substringFromIndex:11];
			NSString *puzzleData = [(NSString*)[parameters objectAtIndex:1] substringFromIndex:11];
			DebugLog(@"puzzleName=[%@]",puzzleName);
			DebugLog(@"puzzleData=[%@]",puzzleData);
			NSString *savedName = [[NSString alloc] initWithString:puzzleName];
			//NSString *message = [NSString stringWithFormat:@"starting the passed custom puzzle size %i.....%@", parameterString.length, parameterString];
			int count = 1;
			while([self.allPuzzles containsObject:savedName]){
				//same name already exists
				count++;
				[savedName release];
				savedName = [[NSString alloc] initWithFormat:@"%@ (%i)",puzzleName, count];
			}

			NSString *message = [[NSString alloc] initWithFormat:@"%@ %@",NSLocalizedString(@"downloaded a puzzle",@"downloaded a puzzle"), savedName];

			UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"you got puzzle!",@"you got puzzle") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"ok") otherButtonTitles:nil];
			[openURLAlert show];
			[openURLAlert release];
			[message release];
			NSString *filePath = [[NSString alloc] initWithFormat:@"%@.pz",savedName];
			[puzzleData  writeToFile:[customPuzzleDirectory stringByAppendingPathComponent:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
			[self.allPuzzles addObject:savedName];
			[filePath release];
			[savedName release];
			self.selectedPuzzleId = savedName;
		}else{
			return NO;
		}
	}else{

		return NO;
	}
	
    return YES;
}


- (void)dealloc {
	[navControllerMainmenu release];
	[self.currentPuzzle release];
	[self.configuration release];

	[self.allPuzzles release];
    [self.window release];
	
	[self.wordWizardPuzzleViewController release];
	
	[self.controllerTabBar release];

	
	[self.selectedPuzzleId release];
	[self.lastPuzzleId release];
	[self.lastTakenSteps release];

    [super dealloc];
}


@end
