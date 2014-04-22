//
//  LoadingSheet.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 4/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LoadingSheet.h"

@interface LoadingSheet ()

@end

@implementation LoadingSheet
@synthesize progressIndicator;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)activateSheetWithParentWindow:(NSWindow *)parentWindow
                              AndText:(NSString *)loadingText
{
    if (!self.sheet) {
        if ([[NSBundle mainBundle] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)])
            // We're running on Mountain Lion or higher
            [[NSBundle mainBundle] loadNibNamed:@"LoadingSheet"
                                          owner:self
                                topLevelObjects:nil];
        else
            // We're running on Lion or lower
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [NSBundle loadNibNamed:@"LoadingSheet"
                             owner:self];
#pragma clang diagnostic pop
    }
    
    [self.loadingText setStringValue:loadingText];
    
    [NSApp beginSheet:self.sheet
       modalForWindow:parentWindow
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:nil];
    
    [self.progressIndicator startAnimation:nil];
}

- (void)closeSheet
{
    [NSApp endSheet:self.sheet];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
}



@end
