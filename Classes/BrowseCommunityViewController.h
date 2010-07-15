//
//  BrowseCommunityViewController.h
//  WizardView
//
//  Created by Junqiang You on 5/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ALERT_TAGS {
	DOWNLOAD_PUZZLE=999930,
	LEFT_LABEL1=999931,
	RIGHT_LABEL1=99932,
	RIGHT_LABEL2=99933,
	RIGHT_MASK=99934
};

@interface BrowseCommunityViewController : UITableViewController <UIActionSheetDelegate>{
//	NSMutableData *receivedData;
	NSMutableArray *puzzles;
	UIActivityIndicatorView *spinner;
	int currentPage;
	UIImage *fiveStarImg;
}
//@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) UIActivityIndicatorView *spinner;
@property(nonatomic, retain) UIImage *fiveStarImg;
@property(nonatomic, retain) NSMutableArray *puzzles;
@property int currentPage;
-(void)downloadPuzzleList:(int)page;
-(void)downloadSelectedPuzzle;
-(void)downloadPuzzleListInBackground;
@end
