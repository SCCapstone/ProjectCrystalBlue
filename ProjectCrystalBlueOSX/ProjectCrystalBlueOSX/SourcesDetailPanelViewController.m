//
//  SourcesDetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourcesDetailPanelViewController.h"
#import "SourcesTableViewController.h"
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SourcesDetailPanelViewController ()

@end

@implementation SourcesDetailPanelViewController

@synthesize source, googleMapsLink, dataStore, datePicker, dateCollected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        dateCollected = [NSDate date];
    }
    return self;
}

- (void)awakeFromNib
{
    // Embed custom view in scroll view
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:[self.view frame]];
    [scrollView setBorderType:NSNoBorder];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setDocumentView:self.view];
    [self setView:scrollView];
    
    [self.rockTypeComboBox addItemsWithObjectValues:[SourceConstants rockTypes]];
    [self.ageMethodComboBox addItemsWithObjectValues:[SourceConstants ageMethods]];
    [self updateComboBoxesAndShouldClearValue:NO];
    [self setupGoogleMapsHyperlink];
}

- (void)setSource:(Source *)newSource
{
    if (source != nil)
        [self removeObserversFromSelectedSource];
    
    source = newSource;
    [self setDateCollected:[NSDate dateWithNaturalLanguageString:[source.attributes objectForKey:SRC_DATE_COLLECTED]]];
    [self addObserversToSelectedSource];
    [self setupGoogleMapsHyperlink];
}

- (void)setDateCollected:(NSDate *)newDateCollected
{
    dateCollected = newDateCollected;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:dateCollected];
    
    [source.attributes setObject:dateString
                          forKey:SRC_DATE_COLLECTED];
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

    // Update link if latitude, longitude, or source changes
    if ([attr isEqualToString:SRC_LATITUDE] || [attr isEqualToString:SRC_LONGITUDE])
        [self setupGoogleMapsHyperlink];
    // Update combo boxes when rock type changes
    else if ([attr isEqualToString:SRC_TYPE]) {
        [self updateComboBoxesAndShouldClearValue:YES];
        [dataStore updateLibraryObject:source IntoTable:[SourceConstants tableName]];
    }
    else
        [dataStore updateLibraryObject:source IntoTable:[SourceConstants tableName]];
}

- (void)updateDatePicker
{
    [datePicker setDateValue:[NSDate dateWithNaturalLanguageString:[source.attributes objectForKey:SRC_DATE_COLLECTED]]];
}

- (void)updateComboBoxesAndShouldClearValue:(BOOL)shouldClearValue
{
    NSString *rockType = self.rockTypeComboBox.stringValue;
    
    // Setup lithology dropdown when type changes
    [self.lithologyComboBox removeAllItems];
    if (shouldClearValue)
        [source.attributes setObject:@"" forKey:SRC_LITHOLOGY];
    NSArray *lithologyValues = [SourceConstants lithologiesForRockType:rockType];
    if (lithologyValues)
        [self.lithologyComboBox addItemsWithObjectValues:lithologyValues];
    
    // Setup deposystem dropdown when type changes
    [self.deposystemComboBox removeAllItems];
    if (shouldClearValue)
        [source.attributes setObject:@"" forKey:SRC_DEPOSYSTEM];
    NSArray *deposystemValues = [SourceConstants deposystemsForRockType:rockType];
    if (deposystemValues)
        [self.deposystemComboBox addItemsWithObjectValues:deposystemValues];
    
    // Hacky way of updating table view combo boxes
    [self.tableViewController updateComboBoxesWithRockType:rockType];
}

- (void)setupGoogleMapsHyperlink
{
    NSString *latitude = [source.attributes objectForKey:SRC_LATITUDE];
    NSString *longitude = [source.attributes objectForKey:SRC_LONGITUDE];
    
    if ([latitude isEqualToString:@""] || [longitude isEqualToString:@""]) {
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
