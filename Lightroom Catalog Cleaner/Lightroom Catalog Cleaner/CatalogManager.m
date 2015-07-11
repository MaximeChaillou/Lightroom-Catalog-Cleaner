//
//  CatalogManager.m
//  Lightroom Catalog Cleaner
//
//  Created by Maxime Chaillou on 08/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import "CatalogManager.h"
#import "FileObject.h"

FMDatabase *db = nil;

@implementation CatalogManager

- (id)init {
    return [self initDatabaseWithPath:nil];
}

- (id)initDatabaseWithPath: (NSString *) path {
    if (self = [super init]) {
        /* perform your post-initialization logic here */
        assert(path != nil);
        db = [FMDatabase databaseWithPath:path];
    }
    return self;
}



- (void) getTotalFilesCount {
    if ( [db open] ) {
        NSLog(@"ok");
    }
}


- (NSArray *) getNonPickedFiles {
    
    NSMutableArray* result = [NSMutableArray new];
    
    if ( [db open] ) {
        
        FMResultSet *s = [db executeQuery:@"SELECT Adobe_images.rootFile, AgLibraryFile.baseName, AgLibraryFolder.pathFromRoot, AgLibraryRootFolder.absolutePath FROM Adobe_images INNER JOIN AgLibraryFile ON Adobe_images.rootFile = AgLibraryFile.id_local INNER JOIN AgLibraryFolder ON AgLibraryFile.folder = AgLibraryFolder.id_local INNER JOIN AgLibraryRootFolder ON AgLibraryFolder.rootFolder = AgLibraryRootFolder.id_local WHERE Adobe_images.pick != 1 AND fileFormat = 'RAW'"];
        
        while ([s next]) {
            //retrieve values for each record
            
            NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@%@.CR2", [s stringForColumnIndex:3], [s stringForColumnIndex:2], [s stringForColumnIndex:1]]];

            if ([url isFileURL]) {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error = nil;
                
                NSDictionary *info = [fileManager attributesOfItemAtPath:url.path error:&error];
                
                FileObject* file = [FileObject new];
                file.path = url;
                file.size = [[info valueForKey:NSFileSize] longValue];
                
                [result addObject:file];
                
                //total += [[info valueForKey:NSFileSize] longValue];
                
                NSLog(@"error : %@", error);
                NSLog(@"%@", [NSByteCountFormatter stringFromByteCount:[[info valueForKey:NSFileSize] longLongValue] countStyle:NSByteCountFormatterCountStyleFile]);
            }
            else {
                NSLog(@"Can't open file");
            }
            
        }
    }
    
    return result;
}

@end
