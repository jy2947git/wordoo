//
//  AboutViewTableCell.m
//  WizardView
//
//  Created by Junqiang You on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutViewTableCell.h"


@implementation AboutViewTableCell
@synthesize displayText;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		UIView *contentView = self.contentView;
		//puzzle name
		CGRect tzvFrame = CGRectMake(0.0, 0.0,frame.size.width, frame.size.height);
		
		
		UITextView *newlabel = [self newLabelWithFrame:tzvFrame PrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]; 
		newlabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		self.displayText = newlabel;
		self.displayText.textAlignment=UITextAlignmentLeft;
	
		[contentView addSubview:self.displayText];
		[newlabel release];
    }
    return self;
}

- (void)setTextContent:(NSString*)text{
	self.displayText.text=text;
}
//-(void)layoutSubviews{
//	[super layoutSubviews];
//	CGRect contentRect = self.contentView.bounds;
//	if(!self.editing){
//		CGFloat boundsX = contentRect.origin.x;
//		CGRect frame;
//		frame = CGRectMake(boundsX+10, 4, 300, 200);
//		self.displayText.frame=frame;
//		
//	}
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UITextView *)newLabelWithFrame:(CGRect)rect PrimaryColor:(UIColor*)primaryColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize bold:(Boolean)bold{
	//	UIFont *font;
	//	if(bold){
	//		font = [UIFont boldSystemFontOfSize:fontSize];
	//	}else{
	//		font = [UIFont systemFontOfSize:fontSize];
	//	}
	UITextView *newlabel = [[UITextView alloc] initWithFrame:rect];
	newlabel.backgroundColor=[UIColor whiteColor];
	newlabel.opaque=YES;
	newlabel.editable=YES;
	newlabel.scrollEnabled=YES;
	//	newlabel.textColor=primaryColor;
	//	newlabel.highlightedTextColor=selectedColor;
	//	newlabel.font = font;
	return newlabel;
}
- (void)dealloc {
	[displayText release];
    [super dealloc];
}


@end
