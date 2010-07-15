//
//  GlobalConfiguration.m
//  WizardView
//
//  Created by Junqiang You on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GlobalConfiguration.h"
#import "GlobalHeader.h"

@implementation GlobalConfiguration
@synthesize styleNumber;
@synthesize imageBackground;
@synthesize matrixBackground;
@synthesize showMeValue;
@synthesize widthOfLetter;
@synthesize heightOfLetter;
@synthesize widthOfCell;
@synthesize heightOfCell;
@synthesize marginOfRow;
@synthesize marginOfCol;
@synthesize stoneImage;
@synthesize successSoundFile;
@synthesize soundId;
@synthesize playSound;
@synthesize releaseTypeOfApp;
@synthesize screenBackground;
@synthesize matrixBoundryColor;
@synthesize screenBackgroundColor;
@synthesize letterFont;
@synthesize matrixInternalColor;
@synthesize boundryWidth;
@synthesize showShowMeWarning;
@synthesize allowHint;
@synthesize allowShowMe;
@synthesize standardPuzzleDirectory;
@synthesize customPuzzleDirectory;
@synthesize scoreFileName;
@synthesize showCompleteForSolvedPuzzle;
@synthesize tilePicNames;
@synthesize alertWhenMemoryLow;
@synthesize userName;
@synthesize deviceId;
@synthesize osVersion;
- (id)init{
	if((self=[super init])!=nil){
		//check device os version
		self.osVersion = [[UIDevice currentDevice] systemVersion];
		self.deviceId = [[UIDevice currentDevice] uniqueIdentifier];
		
		alertWhenMemoryLow = YES;
		
		matrixBoundryColorRed[0] = 90.0f;
		matrixBoundryColorGreen[0] = 58.0f;
		matrixBoundryColorBlue[0] = 55.0f;
		matrixInterColorRed[0] = 220.0f;
		matrixInterColorGreen[0] = 200.0f;
		matrixInterColorBlue[0] = 198.0f;
		//
		matrixBoundryColorRed[1] = 130.0f;
		matrixBoundryColorGreen[1] = 30.0f;
		matrixBoundryColorBlue[1] = 22.0f;
		matrixInterColorRed[1] = 243.0f;
		matrixInterColorGreen[1] = 193.0f;
		matrixInterColorBlue[1] = 189.0f;
		//
		matrixBoundryColorRed[2] = 123.0f;
		matrixBoundryColorGreen[2] = 37.0f;
		matrixBoundryColorBlue[2] = 7.0f;
		matrixInterColorRed[2] = 212.0f;
		matrixInterColorGreen[2] = 179.0f;
		matrixInterColorBlue[2] = 73.0f;
		//
		matrixBoundryColorRed[3] = 122.0f;
		matrixBoundryColorGreen[3] = 105.0f;
		matrixBoundryColorBlue[3] = 22.0f;
		matrixInterColorRed[3] = 243.0f;
		matrixInterColorGreen[3] = 233.0f;
		matrixInterColorBlue[3] = 186.0f;
		//
		matrixBoundryColorRed[4] = 73.0f;
		matrixBoundryColorGreen[4] = 100.0f;
		matrixBoundryColorBlue[4] = 18.0f;
		matrixInterColorRed[4] = 224.0f;
		matrixInterColorGreen[4] = 243.0f;
		matrixInterColorBlue[4] = 186.0f;
		//
		matrixBoundryColorRed[5] = 18.0f;
		matrixBoundryColorGreen[5] = 99.0f;
		matrixBoundryColorBlue[5] = 35.0f;
		matrixInterColorRed[5] = 191.0f;
		matrixInterColorGreen[5] = 244.0f;
		matrixInterColorBlue[5] = 202.0f;
		//
		matrixBoundryColorRed[6] = 18.0f;
		matrixBoundryColorGreen[6] = 97.0f;
		matrixBoundryColorBlue[6] = 87.0f;
		matrixInterColorRed[6] = 194.0f;
		matrixInterColorGreen[6] = 244.0f;
		matrixInterColorBlue[6] = 238.0f;
		//
		matrixBoundryColorRed[7] = 16.0f;
		matrixBoundryColorGreen[7] = 58.0f;
		matrixBoundryColorBlue[7] = 88.0f;
		matrixInterColorRed[7] = 196.0f;
		matrixInterColorGreen[7] = 224.0f;
		matrixInterColorBlue[7] = 245.0f;
		//
		matrixBoundryColorRed[8] = 22.0f;
		matrixBoundryColorGreen[8] = 33.0f;
		matrixBoundryColorBlue[8] = 121.0f;
		matrixInterColorRed[8] = 193.0f;
		matrixInterColorGreen[8] = 199.0f;
		matrixInterColorBlue[8] = 244.0f;
		//
		matrixBoundryColorRed[9] = 69.0f;
		matrixBoundryColorGreen[9] = 21.0f;
		matrixBoundryColorBlue[9] = 119.0f;
		matrixInterColorRed[9] = 219.0f;
		matrixInterColorGreen[9] = 144.0f;
		matrixInterColorBlue[9] = 244.0f;
		//
		matrixBoundryColorRed[10] = 96.0f;
		matrixBoundryColorGreen[10] = 19.0f;
		matrixBoundryColorBlue[10] = 107.0f;
		matrixInterColorRed[10] = 238.0f;
		matrixInterColorGreen[10] = 194.0f;
		matrixInterColorBlue[10] = 244.0f;
		//
		matrixBoundryColorRed[11] = 124.0f;
		matrixBoundryColorGreen[11] = 22.0f;
		matrixBoundryColorBlue[11] = 75.0f;
		matrixInterColorRed[11] = 244.0f;
		matrixInterColorGreen[11] = 194.0f;
		matrixInterColorBlue[11] = 220.0f;
		//
		matrixBoundryColorRed[12] = 128.0f;
		matrixBoundryColorGreen[12] = 23.0f;
		matrixBoundryColorBlue[12] = 45.0f;
		matrixInterColorRed[12] = 245.0f;
		matrixInterColorGreen[12] = 194.0f;
		matrixInterColorBlue[12] = 204.0f;

		tilePicNames = [[NSArray alloc] initWithObjects:@"button-option1",@"button-option2",@"button-option3",@"button-option4",@"button-option5",@"button-option6",@"button-option7",@"button-option8",@"button-option9",@"button-option10",@"button-option11",@"button-option12",@"button-option13",nil];
		//
		//default value from global header
		self.releaseTypeOfApp=appRelease;
		

		//con
		UIColor *c = [[UIColor alloc] initWithRed:((float)205/255.0) green:(float)(230.0/255.0) blue:(float)(234/255.0) alpha:1];
		self.screenBackgroundColor = c;
		[c release];
		
		
		
//		self.matrixBackground  = [UIImage imageNamed:@"1153812_49172041.jpg"];
//		NSString* stoneImagePath = [[NSBundle mainBundle] pathForResource:@"block" ofType:@"png"]; 
//		self.stoneImage = [[UIImage alloc] initWithContentsOfFile:stoneImagePath];

//		self.screenBackground=[UIImage imageNamed:@"1153813_31120897.jpg"];
		self.widthOfCell = 46; //best to be even
		self.heightOfCell = 46;
		self.widthOfLetter = 26; //best to be even
		self.heightOfLetter = 26;
		self.marginOfCol = 2;
		self.marginOfRow = 2;
		self.boundryWidth = (320-self.widthOfCell*6 -7*marginOfCol)/2;
		self.letterFont = [UIFont fontWithName:@"Helvetica" size:widthOfLetter];
		self.successSoundFile=@"DingBellSound";
		NSString *soundPath = [[NSBundle mainBundle] pathForResource:self.successSoundFile ofType:@"aiff"];
		
		DebugLog(@"%@",soundPath);
		
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath], &soundId);
		//DebugLog(@"result of creating system sound %@", GetMacOSStatusErrorString(error));
		
		//load from setting file
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = [paths objectAtIndex:0];
		NSString *settingPath = [documentDirectory stringByAppendingPathComponent:@"WordMatrix.setting"];
		DebugLog(@"custom puzzles are in:%@",documentDirectory);
		self.playSound=YES;
		self.showMeValue=50;
		self.showShowMeWarning=YES;
		self.allowHint=YES;
		self.allowShowMe=YES;
		self.showCompleteForSolvedPuzzle=YES;
		self.styleNumber=2;
		self.userName = @"";
		if([[NSFileManager defaultManager] fileExistsAtPath:settingPath]){
			NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:settingPath];
			if([[dictionary allKeys] containsObject:@"play-sound"]){
				if([@"Y" compare:[dictionary objectForKey:@"play-sound"]]==0){
					self.playSound=YES;
				}else{
					self.playSound=NO;
				}
			}
			if([[dictionary allKeys] containsObject:@"show-me-value"]){
				self.showMeValue=[[dictionary objectForKey:@"show-me-value"] intValue];
			}
			if([[dictionary allKeys] containsObject:@"display-show-me-warning"]){
				if([@"Y" compare:[dictionary objectForKey:@"display-show-me-warning"]]==0){
					self.showShowMeWarning=YES;
				}else{
					self.showShowMeWarning=NO;
					
				}
			}
			if([[dictionary allKeys] containsObject:@"allow-hint"]){
				if([@"Y" compare:[dictionary objectForKey:@"allow-hint"]]==0){
					self.allowHint=YES;
				}else{
					self.allowHint=NO;
					
				}
			}
			if([[dictionary allKeys] containsObject:@"allow-show-me"]){
				if([@"Y" compare:[dictionary objectForKey:@"allow-show-me"]]==0){
					self.allowShowMe=YES;
				}else{
					self.allowShowMe=NO;
					
				}
			}
			if([[dictionary allKeys] containsObject:@"show-complete-for-solved"]){
				if([@"Y" compare:[dictionary objectForKey:@"show-complete-for-solved"]]==0){
					self.showCompleteForSolvedPuzzle=YES;
				}else{
					self.showCompleteForSolvedPuzzle=NO;
					
				}
			}
			if([[dictionary allKeys] containsObject:@"tile-style-number"]){
				if([@"" compare:[dictionary objectForKey:@"tile-style-number"]]==0){
					//no set yet
				}else{
					self.styleNumber=[[dictionary objectForKey:@"tile-style-number"] intValue];
					
				}
			}
			if([[dictionary allKeys] containsObject:@"user-name"]){
				if([@"" compare:[dictionary objectForKey:@"user-name"]]==0){
					//no set yet
				}else{
					self.userName=[dictionary objectForKey:@"user-name"];
					
				}
			}
			[dictionary release];
		}
		
	}
	[self setMatrixStyle:styleNumber];
	self.standardPuzzleDirectory = [[NSBundle mainBundle] resourcePath];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	self.customPuzzleDirectory = [paths objectAtIndex:0];
	self.scoreFileName = @"puzzle_score.plist";
	return self;
}
				
- (void)setMatrixStyle:(int)sn{
	UIColor *c2 = [[UIColor alloc] initWithRed:(float)(matrixBoundryColorRed[sn]/255.0) green:(float)(matrixBoundryColorGreen[sn]/255.0) blue:(float)matrixBoundryColorBlue[sn]/255.0 alpha:1];
	self.matrixBoundryColor = c2;
	[c2 release];
	
	UIColor *c3 = [[UIColor alloc] initWithRed:(float)(matrixInterColorRed[sn]/255.0) green:(float)(matrixInterColorGreen[sn]/255.0) blue:(float)(matrixInterColorBlue[sn]/255.0) alpha:1];
	self.matrixInternalColor = c3;
	[c3 release];
	NSString* tileImagePath = [[NSBundle mainBundle] pathForResource:[tilePicNames objectAtIndex:sn] ofType:@"png"]; 
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:tileImagePath];
	self.imageBackground = img;
	[img release];
}

-(BOOL)isOS3OrLater{
	return [self.osVersion hasPrefix:@"3."] || [self.osVersion hasPrefix:@"4."] || [self.osVersion hasPrefix:@"5."];
}

-(NSString*)encodeDeviceSpecificString:(NSString*)inputString{
	NSUInteger deviceNumber = [self.deviceId hash];
	NSString *s = [NSString stringWithFormat:@"%i%@",deviceNumber, inputString];
	DebugLog(@"input:%@ device-UID:%@ device-hash:%i final:%@",inputString, self.deviceId, deviceNumber, s);
	return s;
}


-(NSString*)decodeDeviceSpecificString:(NSString*)encodedString{
	NSUInteger deviceNumber = [self.deviceId hash];
	NSString *d = [[NSString alloc] initWithFormat:@"%i",deviceNumber];
	NSString *result;
	if([encodedString hasPrefix:d]){
		//yes
		result = [encodedString substringFromIndex:[d length]];
	}else{
		result = nil;
	}
	DebugLog(@"encoded:%@ device-UID:%@ device-id:%i decoded:%@",encodedString, self.deviceId, deviceNumber, result);
	[d release];
	return result;
}

- (void)dealloc {
	[matrixInternalColor release];
	[screenBackgroundColor release];
	[matrixBoundryColor release];
	[stoneImage release];
	[imageBackground release];
	[matrixBackground release];
	[successSoundFile release];
	[scoreFileName release];
	[screenBackground release];
	[letterFont release];
	[standardPuzzleDirectory release];
	[customPuzzleDirectory release];
	[tilePicNames release];
	[userName release];
	[super dealloc];
}
@end
