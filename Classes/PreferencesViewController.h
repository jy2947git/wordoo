//
//  PreferencesViewController.h
//  WizardView
//
//  Created by Junqiang You on 4/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PreferencesViewController : UITableViewController {
	
}

-(void)menu;
-(IBAction)soundSwitchValueChanged:(id)sender;
-(IBAction)showMeValueChanged:(id)sender;
-(void)saveSetting;
-(IBAction)showMeWarningSwitchValueChanged:(id)sender;
-(IBAction)disableHintSwitchValueChanged:(id)sender;
-(IBAction)disableShowMeSwitchValueChanged:(id)sender;
-(IBAction)showMeCompleteSwitchValueChanged:(id)sender;
-(IBAction)userNameValueChanged:(id)sender;
@end
