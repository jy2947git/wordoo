//
//  DesignWiardPage1ViewController.h
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@class DesignWizardHintViewController;


@interface DesignWiardPage1ViewController : UIViewController {


	NSString *currentPuzzleId;
	IBOutlet UITextField *name;
	IBOutlet UITextField *row0;
	IBOutlet UITextField *row1;
	IBOutlet UITextField *row2;
	IBOutlet UITextField *row3;
	IBOutlet UITextField *row4;
	IBOutlet UITextField *row5;

}

@property (nonatomic, retain) NSString *currentPuzzleId;
@property(nonatomic, retain) IBOutlet UITextField *name;
@property(nonatomic, retain) IBOutlet UITextField *row0;
@property(nonatomic, retain) IBOutlet UITextField *row1;
@property(nonatomic, retain) IBOutlet UITextField *row2;
@property(nonatomic, retain) IBOutlet UITextField *row3;
@property(nonatomic, retain) IBOutlet UITextField *row4;
@property(nonatomic, retain) IBOutlet UITextField *row5;
-(Boolean)validate;
-(NSMutableString*)validateRowSize;
-(Boolean)validateAll;
-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)nextPage:(id)sender;

@end
