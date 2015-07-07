//
//  ViewController.m
//  Lightroom Catalog Cleaner
//
//  Created by Maxime Chaillou on 07/07/2015.
//  Copyright (c) 2015 Maxime Chaillou. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.backgroundView setWantsLayer:YES];
    [self.backgroundView.layer setBackgroundColor:[[NSColor colorWithRed:59.0/255.0 green:59.0/255 blue:61.0/255.0 alpha:1.0] CGColor]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
