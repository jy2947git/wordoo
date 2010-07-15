//
//  ScoreTableViewCell.h
//  WizardView
//
//  Created by Junqiang You on 4/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoreTableViewCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *parLabel;
	UILabel *bestScoreLabel;
}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *parLabel;
@property (nonatomic, retain) UILabel *bestScoreLabel;
-(UILabel *)newLabelWithPrimaryColor:(UIColor*)primaryColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize bold:(Boolean)bold;
-(void)setPuzzleName:(NSString*)name par:(NSString*)par bestScore:(NSString*)bestScore;
@end
