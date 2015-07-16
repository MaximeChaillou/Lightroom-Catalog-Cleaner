//
//  ViewController.m
//  Lightroom Catalog Cleaner/Users/maximechaillou/Pictures/Cabanes - Salagnac/salagnac
//
//  Created by Maxime Chaillou on 07/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import "ViewController.h"
#import "CatalogManager.h"
#import "FileObject.h"

@implementation ViewController

NSArray *files;


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
                              
                              CatalogManager *catalog = [[CatalogManager alloc] initDatabaseWithPath:path];
                              
                              files = [catalog getNonPickedFiles];
                              
                              [self displayTotalCanSave];
                              
                              self.totalFiles.hidden = NO;
                              self.totalFiles.stringValue = [NSString stringWithFormat:@"%lu files found", (unsigned long)files.count];
                              
                          }
                          
                      }];
}


- (void) displayTotalCanSave {
    long total = 0;
    for ( FileObject *file in files ) {
        total += file.size;
    }
    self.totalSize.stringValue = [NSString stringWithFormat:@"You can save : %@", [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile]];
    self.totalSize.hidden = NO;
}

@end
