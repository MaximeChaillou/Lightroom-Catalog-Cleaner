//
//  CatalogManager.h
//  Lightroom Catalog Cleaner
//
//  Created by Maxime Chaillou on 08/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface CatalogManager : NSObject

- (id)initDatabaseWithPath: (NSString *) path;

- (int) getTotalFilesCount;
- (NSArray *) getNonPickedFiles;

@end
