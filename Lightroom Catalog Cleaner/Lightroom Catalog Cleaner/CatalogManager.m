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
        
        FMResultSet *s = [db executeQuery:@"SELECT Adobe_images.rootFile, AgLibraryFile.baseName, AgLibraryFolder.pathFromRoot, AgLibraryRootFolder.absolutePath, AgLibraryFile.extension FROM Adobe_images INNER JOIN AgLibraryFile ON Adobe_images.rootFile = AgLibraryFile.id_local INNER JOIN AgLibraryFolder ON AgLibraryFile.folder = AgLibraryFolder.id_local INNER JOIN AgLibraryRootFolder ON AgLibraryFolder.rootFolder = AgLibraryRootFolder.id_local WHERE Adobe_images.pick != 1 AND fileFormat = 'RAW'"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        while ([s next]) {
            //retrieve values for each record
            
            NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@%@.%@", [s stringForColumnIndex:3], [s stringForColumnIndex:2], [s stringForColumnIndex:1], [s stringForColumnIndex:4]]];

            if ([url isFileURL]) {
                if ([fileManager fileExistsAtPath:url.path]) {
                    
                    FileObject* file = [FileObject new];
                    file.path = url;
                    file.size = [file getSize];
                    
                    [result addObject:file];
                }
                else {
                    NSLog(@"File doesn't exist");
                }
            }
            else {
                NSLog(@"Bad path");
            }
            
        }
    }
    
    return result;
}

@end
