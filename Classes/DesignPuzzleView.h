//
//  DesignPuzzleView.h
//  WizardView
//
//  Created by Junqiang You on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleView.h"

@interface DesignPuzzleView : PuzzleView {

}
- (void)singleTap:(UITouch *)touch;
- (void)doubleTap:(UITouch*)touch;
- (void)onDoubleTouchBegin:(CGPoint) touchedPoint;
@end
