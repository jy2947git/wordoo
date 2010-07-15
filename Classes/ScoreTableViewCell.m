//
//  ScoreTableViewCell.m
//  WizardView
//
//  Created by Junqiang You on 4/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScoreTableViewCell.h"


@implementation ScoreTableViewCell
@synthesize titleLabel;
@synthesize parLabel;
@synthesize bestScoreLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		UIView *contentView = self.contentView;
		//puzzle name
		UILabel *newlabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:20.0 bold:NO]; 
		self.titleLabel = newlabel;
		self.titleLabel.textAlignment=UITextAlignmentLeft;
		[contentView addSubview:self.titleLabel];
		[newlabel release];
		//puzzle par
		UILabel *newparlabel = [self newLabelWithPrimaryColor:[UIColor lightGrayColor] selectedColor:[UIColor lightGrayColor] fontSize:16.0 bold:NO]; 
		self.parLabel = newparlabel;
		self.parLabel.textAlignment=UITextAlignmentRight;
		[contentView addSubview:self.parLabel];
		[newparlabel release];
		//best score
		UILabel *scorelabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:20.0 bold:NO]; 
		self.bestScoreLabel = scorelabel;
		self.bestScoreLabel.textAlignment=UITextAlignmentRight;
		[contentView addSubview:self.bestScoreLabel];
		[scorelabel release];
    }
    return self;
}

-(void)setPuzzleName:(NSString*)name par:(NSString*)par bestScore:(NSString*)bestScore{
	self.titleLabel.text=name;
	NSString *s = [[NSString alloc] initWithFormat:@"%@ %@",NSLocalizedString(@"Par",@"par"), par];
	self.parLabel.text=s;
	[s release];
	self.bestScoreLabel.text=bestScore;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	if(!self.editing){
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		frame = CGRectMake(boundsX+10, 4, 160, 18);
		self.titleLabel.frame=frame;
		frame=CGRectMake(boundsX+180, 24, 100, 18);
		self.parLabel.frame=frame;
		frame=CGRectMake(boundsX+240, 4, 40, 18);
		self.bestScoreLabel.frame=frame;
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)newLabelWithPrimaryColor:(UIColor*)primaryColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize bold:(Boolean)bold{
//	UIFont *font;
//	if(bold){
//		font = [UIFont boldSystemFontOfSize:fontSize];
//	}else{
//		font = [UIFont systemFontOfSize:fontSize];
//	}
	UILabel *newlabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newlabel.backgroundColor=[UIColor whiteColor];
	newlabel.opaque=YES;
//	newlabel.textColor=primaryColor;
//	newlabel.highlightedTextColor=selectedColor;
//	newlabel.font = font;
	return newlabel;
}

- (void)dealloc {
	[titleLabel release];
	[parLabel release];
	[bestScoreLabel release];
    [super dealloc];
}


@end
