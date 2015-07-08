//
//  CatalogManager.h
//  Lightroom Catalog Cleaner
//
//  Created by Maxime Chaillou on 08/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogManager : NSObject

+ (int) getTotalFilesCountForCatalog: (NSString *) catalog;
+ (NSArray *) getNonPickedFiledForCatalog: (NSString *) catalog;

@end
