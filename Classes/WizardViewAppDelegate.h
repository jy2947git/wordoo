//
//  WizardViewAppDelegate.h
//  WizardView
//
//  Created by Junqiang You on 2/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WordWizardPuzzleViewController;
@class Puzzle;
@class GlobalConfiguration;
@class MainMenuViewController;
@class RootTabBarController;
@interface WizardViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet WordWizardPuzzleViewController *wordWizardPuzzleViewController;

	//to pass values from designer 1 to designer 2 page
//	NSMutableArray *rows;
	//hold for play-puzzle
	NSMutableArray *allPuzzles;
	//current working puzzle
	Puzzle *currentPuzzle;
	NSString *selectedPuzzleId;
	

	//global configuration constants
	GlobalConfiguration *configuration;
	//to pass the last-puzzle-state to puzzle screen
	NSString *lastPuzzleId;
	NSMutableArray *lastTakenSteps;

	
	//
	UINavigationController *navControllerMainmenu;
	
	RootTabBarController *controllerTabBar;
	
}
@property (nonatomic, retain) RootTabBarController *controllerTabBar;
@property (nonatomic, retain) UINavigationController *navControllerMainmenu;


@property (nonatomic, retain) Puzzle *currentPuzzle;
@property (nonatomic, retain) NSString *selectedPuzzleId;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WordWizardPuzzleViewController *wordWizardPuzzleViewController;
//@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableArray *allPuzzles;
@property (nonatomic, retain) GlobalConfiguration *configuration;
@property (nonatomic, retain) NSString *lastPuzzleId;
@property (nonatomic, retain) NSMutableArray *lastTakenSteps;
- (void)startup;
- (void)startedWithNormal;
-(void)startTabView;

@end

