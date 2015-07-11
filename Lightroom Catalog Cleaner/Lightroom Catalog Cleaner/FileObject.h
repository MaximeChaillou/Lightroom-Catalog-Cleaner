//
//  FileManager.h
//  Lightroom Catalog Cleaner
//
//  Created by Maxime Chaillou on 11/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileObject : NSObject

@property NSURL *path;
@property long size;

@end
