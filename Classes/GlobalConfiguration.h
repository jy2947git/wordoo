//
//  GlobalConfiguration.h
//  WizardView
//
//  Created by Junqiang You on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>



@interface GlobalConfiguration : NSObject {
	UIImage *imageBackground;
	UIImage *matrixBackground;
	UIImage *stoneImage;
	UIColor *matrixBoundryColor;
	int boundryWidth;
	UIColor *screenBackgroundColor;
	UIColor *matrixInternalColor;
	UIFont *letterFont;
	int widthOfLetter;
	int heightOfLetter;
	int widthOfCell;
	int heightOfCell;
	int marginOfRow;
	int marginOfCol;
	NSString *successSoundFile;
	SystemSoundID soundId;
	Boolean playSound;
	
	int releaseTypeOfApp;
	UIImage *screenBackground;
	
	int showMeValue;
	Boolean showShowMeWarning;
	Boolean allowHint;
	Boolean allowShowMe;
	Boolean showCompleteForSolvedPuzzle;
	
	NSString *standardPuzzleDirectory;
	NSString *customPuzzleDirectory;
	
	NSString *scoreFileName;
	float matrixBoundryColorRed[13];
	float matrixBoundryColorGreen[13];
	float matrixBoundryColorBlue[13];
	float matrixInterColorRed[13];
	float matrixInterColorGreen[13];
	float matrixInterColorBlue[13];
	NSArray *tilePicNames;
	int styleNumber;
	Boolean alertWhenMemoryLow;
	NSString *userName;
	
	NSString *osVersion;
	NSString *deviceId;
}
@property(nonatomic, retain) NSString *osVersion;
@property(nonatomic, retain) NSString *deviceId;
@property Boolean alertWhenMemoryLow;
@property int styleNumber;
@property (nonatomic, retain) NSArray *tilePicNames;
@property Boolean showCompleteForSolvedPuzzle;
@property (nonatomic, retain) NSString *scoreFileName;
@property (nonatomic, retain) NSString *standardPuzzleDirectory;
@property (nonatomic, retain) NSString *customPuzzleDirectory;
@property Boolean allowHint;
@property Boolean allowShowMe;
@property int boundryWidth;
@property Boolean showShowMeWarning;
@property (nonatomic, retain) UIColor *matrixInternalColor;
@property (nonatomic, retain) UIFont *letterFont;
@property (nonatomic, retain) UIColor *screenBackgroundColor;
@property (nonatomic, retain) UIColor *matrixBoundryColor;
@property int showMeValue;
@property Boolean playSound;
@property (nonatomic, retain) UIImage *imageBackground;
@property (nonatomic, retain) UIImage *matrixBackground;
@property (nonatomic, retain) UIImage *stoneImage;
@property (nonatomic, retain) NSString *successSoundFile;
@property int releaseTypeOfApp;
@property (nonatomic, retain) UIImage *screenBackground;
@property SystemSoundID soundId;

@property int widthOfLetter;
@property int heightOfLetter;
@property int widthOfCell;
@property int heightOfCell;
@property int marginOfRow;
@property int marginOfCol;
@property (nonatomic, copy) NSString *userName;
-(BOOL)isOS3OrLater;
-(NSString*)decodeDeviceSpecificString:(NSString*)encodedString;
-(NSString*)encodeDeviceSpecificString:(NSString*)inputString;
- (void)setMatrixStyle:(int)styleNumber;
@end
