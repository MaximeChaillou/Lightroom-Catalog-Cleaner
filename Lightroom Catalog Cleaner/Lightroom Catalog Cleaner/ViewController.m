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
CatalogManager *catalog;

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
                              
                              catalog = [[CatalogManager alloc] initDatabaseWithPath:path];
                              
                              files = [catalog getNonPickedFiles];
                              
                              [self updateViewAfterCatalog];
                          }
                          
                      }];
}

- (void) updateViewAfterCatalog {
    [self displayTotalCanSave];
    
    self.totalFiles.hidden = NO;
    self.totalFiles.stringValue = [NSString stringWithFormat:@"%lu files found on %d files in your catalog", (unsigned long)files.count, [catalog getTotalFilesCount]];
    
    if ( files.count > 0 ) {
        self.deleteButton.hidden = NO;
    }
    
}

- (void) displayTotalCanSave {
    long total = 0;
    for ( FileObject *file in files ) {
        total += file.size;
    }
    self.totalSize.stringValue = [NSString stringWithFormat:@"You can save : %@", [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile]];
    self.totalSize.hidden = NO;
}

- (IBAction)clickOnDelete:(id)sender {
    NSLog(@"Click on delete");
    
    // Alert user that all files will be deleted permanently
    NSAlert *alertDelete = [[NSAlert alloc] init];
    
    [alertDelete addButtonWithTitle:@"Yes, I'm sure"];
    [alertDelete addButtonWithTitle:@"No, I'm not sure"];
    
    [alertDelete setMessageText:@"Are you sure you want to permanently delete all these files ?"];
    
    [alertDelete setAlertStyle:NSCriticalAlertStyle];
    
    // If OK, start to delete
    if ([alertDelete runModal] == NSAlertFirstButtonReturn) {
        NSLog(@"Delete files permanently");
        self.loadingIndicator.hidden = NO;
        
        for (FileObject *file in files) {
            if (![file delete]) {
                NSLog(@"Error when deleting %@", file.path.path);
            }
        }
    }
    
    [self initView];
    
    // Information for the user after delete
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Files deleted"];
    [alert setInformativeText:@"All your files have been deleted.\nNow relaunch your catalog in LightRoom and re-synchronised your directory(ies)."];
    
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert runModal];
    
}

- (void) initView {
    self.totalFiles.hidden = YES;
    self.deleteButton.hidden = YES;
    self.totalSize.hidden = YES;
    self.loadingIndicator.hidden = YES;

}

@end
