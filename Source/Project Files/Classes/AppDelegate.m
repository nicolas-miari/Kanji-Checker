//
//  AppDelegate.m
//  KanjiChecker
//
//  Created by Nicolás Miari on 12/22/13.
//  Copyright (c) 2013 Nicolas Miari. All rights reserved.
//

#import "AppDelegate.h"

#import "MainWindowController.h"


// .............................................................................

@implementation AppDelegate
{
    MainWindowController* _mainWindowController;
}

// .............................................................................

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    // Insert code here to initialize your application
    
    _mainWindowController = [MainWindowController new];
    
    [_mainWindowController showWindow:self];
}

// .............................................................................

@end
