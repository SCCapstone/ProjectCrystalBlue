//
//  SourcesDetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesDetailPanelViewController.h"
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SourcesDetailPanelViewController ()


@end

@implementation SourcesDetailPanelViewController

@synthesize source, googleMapsLink, dataStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (Source *)source
{
    return source;
}

- (void)setSource:(Source *)newSource
{
    if (source != nil)
        [self removeObserversFromSelectedSource];
    
    source = newSource;
    [self addObserversToSelectedSource];
    [self setupGoogleMapsHyperlink];
}

- (void)addObserversToSelectedSource
{
    NSArray *attributes = [SourceConstants attributeNames];
    for (NSString *attr in attributes) {
        [source addObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.%@", attr] options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserversFromSelectedSource
{
    NSArray *attributes = [SourceConstants attributeNames];
    for (NSString *attr in attributes) {
        [source removeObserver:self forKeyPath:[NSString stringWithFormat:@"attributes.%@", attr]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSString *attr = [keyPath substringFromIndex:11];
    
    [dataStore updateLibraryObject:source IntoTable:[SourceConstants tableName]];
    
    // Update link if latitude, longitude, or source changes
    if ([attr isEqualToString:SRC_LATITUDE] || [attr isEqualToString:SRC_LONGITUDE])
        [self setupGoogleMapsHyperlink];
}

- (void)setupGoogleMapsHyperlink
{
    NSString *latitude = [source.attributes objectForKey:SRC_LATITUDE];
    NSString *longitude = [source.attributes objectForKey:SRC_LONGITUDE];
    
    if ([latitude isEqualToString:SRC_DEF_VAL_LATITUDE] || [longitude isEqualToString:SRC_DEF_VAL_LONGITUDE]) {
        [self.googleMapsLink setStringValue:@"No Google Maps link available."];
    }
    else {
        [googleMapsLink setAllowsEditingTextAttributes:YES];
        [googleMapsLink setSelectable:YES];
        
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
        
        [googleMapsLink setAttributedStringValue:attributedString];
    }
}

@end
