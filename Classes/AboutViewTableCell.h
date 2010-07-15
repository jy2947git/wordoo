//
//  AboutViewTableCell.h
//  WizardView
//
//  Created by Junqiang You on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
enum VIEW_TAGS {
	VIEW_DESC=999630,
	VIEW_FEATURE=999631,
	VIEW_SUPPORT=99632
};

@interface AboutViewTableCell : UITableViewCell {
	UITextView *displayText;
}
@property(nonatomic, retain) UITextView *displayText;

- (void)setTextContent:(NSString*)text;
-(UITextView *)newLabelWithFrame:(CGRect)rect PrimaryColor:(UIColor*)primaryColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize bold:(Boolean)bold;
@end
