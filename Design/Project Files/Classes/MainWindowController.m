//
//  MainWindowController.m
//  KanjiChecker
//
//  Created by Nicolás Miari on 12/22/13.
//  Copyright (c) 2013 Nicolas Miari. All rights reserved.
//

#import "MainWindowController.h"


// .............................................................................

#define RedColor [NSColor color]
// .............................................................................

@implementation MainWindowController
{
    NSUInteger  _audienceGrade;
    
    NSArray* _gradeStrings;
    
    NSFont*     _textViewFont;
}

// .............................................................................

- (id)init
{
    if ((self = [super initWithWindowNibName:@"MainWindow" owner:self]))
    {
        // Initialization code here.
        
        NSString* table = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Table"
                                                                                             ofType:@"csv"]
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
        
        _gradeStrings = [table componentsSeparatedByString:@"\n"];
    }
    
    return self;
}

// .............................................................................

- (void) windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // Center window on screen
    
    NSWindow* window = [self window];
    
    NSArray* screenArray = [NSScreen screens];
    
    for (NSScreen* screen in screenArray){
        
        if (screen == [[self window] screen]) {
            
            NSRect screenRect = [screen visibleFrame];
            NSSize screenSize = screenRect.size;
            
            NSRect windowRect = [window frame];
            NSSize windowSize = windowRect.size;
            
            windowRect.origin.x = roundf((screenSize.width  - windowSize.width ) /2.0);
            windowRect.origin.y = roundf((screenSize.height - windowSize.height) /2.0);
            
            [window setFrame:windowRect display:YES];
        }
    }
    
    [_textView setDelegate:self];
    [_textView setRichText:YES];
    [_textView setAutomaticSpellingCorrectionEnabled:NO];
    
    _audienceGrade = 2;
    [_audiencePopupButton selectItemAtIndex:1];
    
}

// .............................................................................

- (IBAction) check:(id) sender
{
    // . .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
    // Disable command button until text changes again:
    
    [_checkButton setEnabled:NO];
    

    [_textView setRichText:YES];
    
    // . .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
    // Check text and highlight
    
    NSString* inputText = [_textView string];
    
    for (NSUInteger i=0; i < [inputText length]; i++) {
        
        unichar character = [inputText characterAtIndex:i];
        
        if (character >= 0x4e00 && character <= 0x9faf) {
            // Kanji
        
            NSString* characterString = [NSString stringWithFormat:@"%C", character];
            
            //NSLog(@"Searching %@", characterString);
            
            
            // Search character in tables within range
            
            BOOL found = NO;
            
            for(NSUInteger i=0; i < _audienceGrade; i++){
                
                NSString* gradeString = [_gradeStrings objectAtIndex:i];
            
                if ([gradeString rangeOfString:characterString].location != NSNotFound) {
                    found = YES;
                    break;
                }
            }
            
            if (found) {
                NSColor* color = [NSColor colorWithDeviceRed:0.0
                                                       green:0.66
                                                        blue:0.0
                                                       alpha:1.0];
                
                [_textView setTextColor:color
                                  range:NSMakeRange(i, 1)];
            }
            else{

                NSColor* color = [NSColor colorWithDeviceRed:1.0
                                                       green:0.0
                                                        blue:0.0
                                                       alpha:1.0];
                
                [_textView setTextColor:color
                                  range:NSMakeRange(i, 1)];
            }
        }
        else{
            //
        }
    }
}

// .............................................................................

- (IBAction) audienceChanged:(id)sender
{
    NSUInteger selectedIndex = [_audiencePopupButton indexOfSelectedItem];
    
    if ((selectedIndex + 1) != _audienceGrade) {
        
        _audienceGrade = selectedIndex + 1;
        
        [_checkButton setEnabled:YES];
    }
}

// .............................................................................

- (BOOL) textView:(NSTextView*) textView shouldChangeTextInRange:(NSRange) affectedCharRange
replacementString:(NSString*) replacementString
{
    if (affectedCharRange.length || [replacementString length]) {
    
        [_checkButton setEnabled:YES];
    
        [_textView setRichText:NO];
        
        [_textView setTextColor:[NSColor blackColor]];
    }
    
    return YES;
}
// .............................................................................

- (void) textViewDidChangeSelection:(NSNotification *)notification
{
    if (_textViewFont){
    
        [_textView setFont:_textViewFont];
    }
}

// .............................................................................

@end


