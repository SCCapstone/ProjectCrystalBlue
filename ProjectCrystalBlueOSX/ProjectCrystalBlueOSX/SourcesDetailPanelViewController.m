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
#import "SourceImageUtils.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SourcesDetailPanelViewController ()
{
    enum comboBoxTags { rockTypeTag, lithologyTag, deposystemTag, ageMethodTag };
}
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
    
    NSArray *sourceImages = [SourceImageUtils imagesForSource:source
                                                 inImageStore:[SourceImageUtils defaultImageStore]];
    if (sourceImages.count != 0)
        [self.imageCell setImage:[sourceImages firstObject]];
    
    [self setupGoogleMapsHyperlink];
}

- (void)setSource:(Source *)newSource
{
    if (source != nil)
        [self removeObserversFromSelectedSource];
    
    source = newSource;
    [self.imageCell setImage:nil];
    
    if (source == nil)
        [datePicker setEnabled:NO];
    else {
        [datePicker setEnabled:YES];
        [self setDateCollected:[NSDate dateWithNaturalLanguageString:[source.attributes objectForKey:SRC_DATE_COLLECTED]]];
        
        NSArray *sourceImages = [SourceImageUtils imagesForSource:source
                                                     inImageStore:[SourceImageUtils defaultImageStore]];
        if (sourceImages.count != 0)
            [self.imageCell setImage:[sourceImages firstObject]];
        
        [self addObserversToSelectedSource];
        [self setupGoogleMapsHyperlink];
    }
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
        [source addObserver:self
                 forKeyPath:[NSString stringWithFormat:@"attributes.%@", attr]
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    }
}

- (void)removeObserversFromSelectedSource
{
    NSArray *attributes = [SourceConstants attributeNames];
    for (NSString *attr in attributes) {
        [source removeObserver:self
                    forKeyPath:[NSString stringWithFormat:@"attributes.%@", attr]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSString *attr = [keyPath substringFromIndex:11];

    // Update link if latitude or longitude changes
    if ([attr isEqualToString:SRC_LATITUDE] || [attr isEqualToString:SRC_LONGITUDE])
        [self setupGoogleMapsHyperlink];
    else if ([attr isEqualToString:SRC_TYPE]) {
        NSString *rockType = [source.attributes objectForKey:SRC_TYPE];
        if ([rockType isEqualToString:@"Siliciclastic"] || [rockType isEqualToString:@"Carbonate"] ||
                [rockType isEqualToString:@"Authigenic"] || [rockType isEqualToString:@"Volcanic"] ||
                [rockType isEqualToString:@"Fossil"])
            [source.attributes setObject:@"" forKey:SRC_DEPOSYSTEM];
        else
            [source.attributes setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            
        [source.attributes setObject:@"" forKey:SRC_LITHOLOGY];
    }
    
    [dataStore updateLibraryObject:source IntoTable:[SourceConstants tableName]];
}

- (void)updateDatePicker
{
    [datePicker setDateValue:[NSDate dateWithNaturalLanguageString:[source.attributes objectForKey:SRC_DATE_COLLECTED]]];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox
{
    if (comboBox.tag == rockTypeTag)
        return [[SourceConstants rockTypes] count];
    else if (comboBox.tag == lithologyTag)
        return [[SourceConstants lithologiesForRockType:self.rockTypeComboBox.stringValue] count];
    else if (comboBox.tag == deposystemTag)
        return [[SourceConstants deposystemsForRockType:self.rockTypeComboBox.stringValue] count];
    else if (comboBox.tag == ageMethodTag)
        return [[SourceConstants ageMethods] count];
    else
        return 0;
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index
{
    if (comboBox.tag == rockTypeTag)
        return [[SourceConstants rockTypes] objectAtIndex:index];
    else if (comboBox.tag == lithologyTag)
        return [[SourceConstants lithologiesForRockType:self.rockTypeComboBox.stringValue] objectAtIndex:index];
    else if (comboBox.tag == deposystemTag)
        return [[SourceConstants deposystemsForRockType:self.rockTypeComboBox.stringValue] objectAtIndex:index];
    else if (comboBox.tag == ageMethodTag)
        return [[SourceConstants ageMethods] objectAtIndex:index];
    else
        return nil;
}

- (NSString *)comboBox:(NSComboBox *)comboBox completedString:(NSString *)enteredValue
{
    NSArray *prefilledValues;
    if (comboBox.tag == rockTypeTag)
        prefilledValues = [SourceConstants rockTypes];
    else if (comboBox.tag == lithologyTag)
        prefilledValues = [SourceConstants lithologiesForRockType:self.rockTypeComboBox.stringValue];
    else if (comboBox.tag == deposystemTag)
        prefilledValues = [SourceConstants deposystemsForRockType:self.rockTypeComboBox.stringValue];
    else if (comboBox.tag == ageMethodTag)
        prefilledValues = [SourceConstants ageMethods];
    
    // Check if entered value is prefix of one of the prefilled values
    for (NSString *value in prefilledValues) {
        if ([value.lowercaseString hasPrefix:enteredValue.lowercaseString])
            return value;
    }
    return nil;
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
        
        NSString *stringUrl = [NSString stringWithFormat:@"https://www.google.com/maps/preview/@%@,%@,8z", latitude, longitude];
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
