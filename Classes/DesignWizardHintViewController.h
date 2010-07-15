//
//  DesignWizardHintViewController.h
//  WizardView
//
//  Created by Junqiang You on 3/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DesignWizardPage2ViewController;

@interface DesignWizardHintViewController : UIViewController <UITextViewDelegate>{
	IBOutlet UITextView *hint;

}
@property(nonatomic, retain) IBOutlet UITextView *hint;


-(IBAction)nextPage:(id)sender;
@end
