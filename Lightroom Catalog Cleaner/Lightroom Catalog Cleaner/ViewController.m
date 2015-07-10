//
//  ViewController.m
//  Lightroom Catalog Cleaner/Users/maximechaillou/Pictures/Cabanes - Salagnac/salagnac
//
//  Created by Maxime Chaillou on 07/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.backgroundView setWantsLayer:YES];
    [self.backgroundView.layer setBackgroundColor:[[NSColor colorWithRed:59.0/255.0 green:59.0/255 blue:61.0/255.0 alpha:1.0] CGColor]];
    [[self.openFileButton cell] setBackgroundColor:[NSColor redColor]];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (IBAction)openFinder:(id)sender {
    NSLog(@"Open Finder");
    
    NSWindow *currentWindow = [NSApp keyWindow];
    
    //this gives you a copy of an open file dialogue
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    //set the title of the dialogue window
    openPanel.title = @"Choose a .lrcat file";
    
    //shoud the user be able to resize the window?
    openPanel.showsResizeIndicator = YES;
    
    //should the user see hidden files (for user apps - usually no)
    openPanel.showsHiddenFiles = NO;
    
    //can the user select a directory?
    openPanel.canChooseDirectories = NO;
    
    //can the user create directories while using the dialogue?
    openPanel.canCreateDirectories = YES;
    
    //should the user be able to select multiple files?
    openPanel.allowsMultipleSelection = NO;
    
    //an array of file extensions to filter the file list
    openPanel.allowedFileTypes = @[@"lrcat"];
    
    //this launches the dialogue
    [openPanel beginSheetModalForWindow:currentWindow
                      completionHandler:^(NSInteger result) {
                          
                          //if the result is NSOKButton
                          //the user selected a file
                          if (result == NSModalResponseOK) {
                              
                              //get the selected file URLs
                              NSURL *selection = openPanel.URLs[0];
                              
                              //finally store the selected file path as a string
                              NSString* path = [[selection path] stringByResolvingSymlinksInPath];
                              
                              //here add your own code to open the file
                              NSLog(@"%@", path);
                              
                              FMDatabase *db = [FMDatabase databaseWithPath:path];
                              NSFileManager *fileManager = [NSFileManager defaultManager];
                              
                              long total = 0;
                              
                              if ( [db open] ) {
                                  NSLog(@"Database opened");
                                  FMResultSet *s = [db executeQuery:@"SELECT Adobe_images.rootFile, AgLibraryFile.baseName, AgLibraryFolder.pathFromRoot, AgLibraryRootFolder.absolutePath FROM Adobe_images INNER JOIN AgLibraryFile ON Adobe_images.rootFile = AgLibraryFile.id_local INNER JOIN AgLibraryFolder ON AgLibraryFile.folder = AgLibraryFolder.id_local INNER JOIN AgLibraryRootFolder ON AgLibraryFolder.rootFolder = AgLibraryRootFolder.id_local WHERE Adobe_images.pick != 1 AND fileFormat = 'RAW'"];
                                  while ([s next]) {
                                      //retrieve values for each record
                                      NSLog(@"%d", [s intForColumnIndex:0]);
                                      NSLog(@"%@", [s stringForColumnIndex:1]);
                                      
                                      NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@%@.CR2", [s stringForColumnIndex:3], [s stringForColumnIndex:2], [s stringForColumnIndex:1]]];
                                      NSLog(@"URL = %@", url);
                                      if ([url isFileURL]) {
                                          NSError *error = nil;
                                          NSDictionary *info = [fileManager attributesOfItemAtPath:url.path error:&error];
                                          
                                          total += [[info valueForKey:NSFileSize] longValue];
                                          
                                          NSLog(@"error : %@", error);
                                          NSLog(@"%@", [NSByteCountFormatter stringFromByteCount:[[info valueForKey:NSFileSize] longLongValue] countStyle:NSByteCountFormatterCountStyleFile]);
                                      }
                                      else {
                                          NSLog(@"Can't open file");
                                      }
                                      
                                  }
                                  
                                  self.totalSize.stringValue = [NSString stringWithFormat:@"You can save : %@", [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile]];
                                  self.totalSize.hidden = NO;
                              }
                              
                          }
                          
                      }];
}

@end
