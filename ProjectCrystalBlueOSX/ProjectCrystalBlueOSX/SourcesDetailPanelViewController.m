//
//  SourcesDetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesDetailPanelViewController.h"
#import "Source.h"

@interface SourcesDetailPanelViewController ()

@end

@implementation SourcesDetailPanelViewController

@synthesize source, googleMapsLink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupGoogleMapsHyperlink];
    
    // Watch latitude, longitude, and source for changes (to update google maps link)
    [source addObserver:self forKeyPath:@"attributes.LATITUDE" options:NSKeyValueObservingOptionNew context:nil];
    [source addObserver:self forKeyPath:@"attributes.LONGITUDE" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"source" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // Update link if latitude, longitude, or source changes
    [self setupGoogleMapsHyperlink];
}

- (void)setupGoogleMapsHyperlink
{
    NSString *latitude = [self.source.attributes objectForKey:SRC_LATITUDE];
    NSString *longitude = [self.source.attributes objectForKey:SRC_LONGITUDE];
    
    if ([latitude isEqualToString:SRC_DEF_VAL_LATITUDE] || [longitude isEqualToString:SRC_DEF_VAL_LONGITUDE]) {
        [self.googleMapsLink setStringValue:@"No Google Maps link available."];
    }
    else {
        [self.googleMapsLink setAllowsEditingTextAttributes:YES];
        [self.googleMapsLink setSelectable:YES];
        
        NSString *stringUrl = [NSString stringWithFormat:@"www.maps.google.com/?ll=%@,%@", latitude, longitude];
        NSURL *url = [NSURL URLWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *label = @"Google Maps Link";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Google Maps Link"];
        NSRange range = NSMakeRange(0, label.length);
        
        [attributedString beginEditing];
        [attributedString addAttribute:NSLinkAttributeName value:url.absoluteString range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
        [attributedString addAttribute:@"NSFont" value:[NSFont systemFontOfSize:13.0] range:range];
        [attributedString endEditing];
        
        [self.googleMapsLink setAttributedStringValue:attributedString];
    }
}

@end
