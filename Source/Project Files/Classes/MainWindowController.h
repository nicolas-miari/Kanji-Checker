//
//  MainWindowController.h
//  KanjiChecker
//
//  Created by Nicolás Miari on 12/22/13.
//  Copyright (c) 2013 Nicolas Miari. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSWindowController <NSWindowDelegate, NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (weak) IBOutlet NSPopUpButton *audiencePopupButton;
@property (weak) IBOutlet NSMenu *audienceMenu;

@property (weak) IBOutlet NSButton *checkButton;

    
- (IBAction)check:(id)sender;

- (IBAction)audienceChanged:(id)sender;

@end
