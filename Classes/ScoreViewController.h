//
//  Score.h
//  WizardView
//
//  Created by Junqiang You on 4/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoreViewController : UITableViewController {
	NSMutableArray *scores;

}
@property(nonatomic, retain) NSMutableArray *scores;

-(void)menu;
@end
