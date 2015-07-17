//
//  FileManager.m
//  Lightroom Catalog Cleaner
//
//  Created by Maxime Chaillou on 11/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import "FileObject.h"

@implementation FileObject: NSObject

- (long) getSize {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSDictionary *info = [fileManager attributesOfItemAtPath:self.path.path error:&error];
    
    NSLog(@"error : %@", error);
    NSLog(@"%@", [NSByteCountFormatter stringFromByteCount:[[info valueForKey:NSFileSize] longLongValue] countStyle:NSByteCountFormatterCountStyleFile]);
    
    return [[info valueForKey:NSFileSize] longValue];
}

- (BOOL) delete {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    return [fileManager removeItemAtPath:self.path.path error:&error];
}

@end
