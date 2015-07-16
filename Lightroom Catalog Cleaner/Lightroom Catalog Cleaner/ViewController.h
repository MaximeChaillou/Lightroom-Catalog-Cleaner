//
//  ViewController.h
//  Lightroom Catalog Cleaner
//
//  Created by Maxime Chaillou on 07/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface ViewController : NSViewController

@property (strong) IBOutlet NSView *backgroundView;
@property (strong) NSURL *fileURL;
@property (strong) NSPasteboard *pboard;
@property (weak) IBOutlet NSButton *openFileButton;
@property (weak) IBOutlet NSTextField *totalSize;
@property (weak) IBOutlet NSTextField *totalFiles;

@end

