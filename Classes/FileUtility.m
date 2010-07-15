//
//  FileUtility.m
//  WizardView
//
//  Created by Junqiang You on 4/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileUtility.h"


@implementation FileUtility
+(BOOL)savePlist:(id)plist toDocumentDirectoryFile:(NSString *)fileName{
    NSString *error; 
    NSData *pData = [NSPropertyListSerialization dataFromPropertyList:plist 
															   format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error]; 
    if (!pData) { 
        NSLog(@"%@", error); 
        return NO; 
    } 
    return ([self writeApplicationData:pData toFile:(NSString *)fileName]); 
} 


+ (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName { 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!"); 
        return NO; 
    } 
    NSString *appFile = [documentsDirectory 
						 stringByAppendingPathComponent:fileName]; 
    return ([data writeToFile:appFile atomically:YES]); 
} 


+ (id)readPlistFromFile:(NSString *)fileName { 
    NSData *retData; 
    NSString *error; 
    id retPlist; 
    NSPropertyListFormat format; 
    retData = [self applicationDataFromFile:fileName]; 
    if (!retData) { 
        NSLog(@"Data file not returned."); 
        return nil; 
    } 
    retPlist = [NSPropertyListSerialization propertyListFromData:retData  
												mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error]; 
    if (!retPlist){ 
        NSLog(@"Plist not returned, error: %@", error); 
    } 
    return retPlist; 
} 

+ (NSData *)applicationDataFromFile:(NSString *)fileName { 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *appFile = [documentsDirectory 
						 stringByAppendingPathComponent:fileName]; 
    NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] 
					  autorelease]; 
    return myData; 
} 

@end
