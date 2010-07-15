//
//  FileUtility.h
//  WizardView
//
//  Created by Junqiang You on 4/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileUtility : NSObject {

}
+(BOOL)savePlist:(id)plit toDocumentDirectoryFile:(NSString *)fileName;
+ (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;
+ (id)readPlistFromFile:(NSString *)fileName;
+ (NSData *)applicationDataFromFile:(NSString *)fileName;
@end
