/*
    MainWindowController.m
    Kanji Checker

    Created by Nicolás Miari on 2013-12-22.
    Copyright (c) 2014 Nicolas Miari. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
 */

#import "MainWindowController.h"

#import "CustomTextView.h"


// .............................................................................

//#define RedColor [NSColor color]


// .............................................................................

@implementation MainWindowController
{
    NSUInteger  _audienceGrade;
    
    NSArray*    _gradeStrings;
    
    NSFont*     _textViewFont;
}

// .............................................................................

- (instancetype) init
{
    if ((self = [super initWithWindowNibName:@"MainWindow" owner:self])){
        
        NSString* tablePath = [[NSBundle mainBundle] pathForResource:@"Table"
                                                              ofType:@"csv"];
        
        NSString* table = [NSString stringWithContentsOfFile:tablePath
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
    
    NSColor* blackColor = [NSColor colorWithDeviceRed:0.00f
                                                green:0.00f
                                                 blue:0.00f
                                                alpha:1.00f];
    
    NSColor* greenColor = [NSColor colorWithDeviceRed:0.00f
                                                green:0.66f
                                                 blue:0.00f
                                                alpha:1.00f];
    
    NSColor* redColor   = [NSColor colorWithDeviceRed:1.00f
                                                green:0.00f
                                                 blue:0.00f
                                                alpha:1.00f];
    
    // . .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
    // Check text and highlight
    
    NSString* inputText = [_textView string];
    
    for (NSUInteger i = 0; i < [inputText length]; i++) {
        
        unichar character = [inputText characterAtIndex:i];
        
        if (character >= 0x4e00 && character <= 0x9faf) {
            // Kanji
        
            NSString* characterString = [NSString stringWithFormat:@"%C", character];
            
            
            // Search character in tables within range
            
            BOOL found = NO;
            
            for(NSUInteger i = 0; i < _audienceGrade; i++){
                
                NSString* gradeString = [_gradeStrings objectAtIndex:i];
            
                if ([gradeString rangeOfString:characterString].location != NSNotFound) {
                    found = YES;
                    break;
                }
            }
            
            if (found) {
                // . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
                // [ A ] FOUND; paint it GREEN
                
                [_textView setTextColor:greenColor range:NSMakeRange(i, 1)];
            }
            else{
                // . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
                // [ B ] NOT FOUND; paint it RED
                
                [_textView setTextColor:redColor range:NSMakeRange(i, 1)];
            }
        }
        else{
            // Not Kanji; paint it BLACK
            
            [_textView setTextColor:blackColor range:NSMakeRange(i, 1)];
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

- (BOOL)        textView:(NSTextView*) textView
 shouldChangeTextInRange:(NSRange) affectedCharRange
       replacementString:(NSString*) replacementString
// (These are the method names that suck in cocoa)
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


