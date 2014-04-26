//
//  SamplesDetailPanelViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 3/28/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SamplesDetailPanelViewController.h"
#import "SamplesTableViewController.h"
#import "Sample.h"
#import "SampleImageUtils.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SamplesDetailPanelViewController ()
{
    enum comboBoxTags { rockTypeTag, lithologyTag, deposystemTag, ageMethodTag };
}
@end

@implementation SamplesDetailPanelViewController

@synthesize sample, googleMapsLink, dataStore, datePicker, dateCollected;

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
    
    NSArray *sampleImages = [SampleImageUtils imagesForSample:sample
                                                 inImageStore:[SampleImageUtils defaultImageStore]];
    if (sampleImages.count != 0)
        [self.imageCell setImage:[sampleImages firstObject]];
    
    [self setupGoogleMapsHyperlink];
}

- (void)setSample:(Sample *)newSample
{
    if (sample != nil)
        [self removeObserversFromSelectedSample];
    
    sample = newSample;
    [self.imageCell setImage:nil];
    
    if (sample == nil)
        [datePicker setEnabled:NO];
    else {
        [datePicker setEnabled:YES];
        [self setDateCollected:[NSDate dateWithNaturalLanguageString:[sample.attributes objectForKey:SMP_DATE_COLLECTED]]];
        
        NSArray *sampleImages = [SampleImageUtils imagesForSample:sample
                                                     inImageStore:[SampleImageUtils defaultImageStore]];
        if (sampleImages.count != 0)
            [self.imageCell setImage:[sampleImages firstObject]];
        
        [self addObserversToSelectedSample];
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
    
    [sample.attributes setObject:dateString
                          forKey:SMP_DATE_COLLECTED];
}

- (void)addObserversToSelectedSample
{
    NSArray *attributes = [SampleConstants attributeNames];
    for (NSString *attr in attributes) {
        [sample addObserver:self
                 forKeyPath:[NSString stringWithFormat:@"attributes.%@", attr]
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    }
}

- (void)removeObserversFromSelectedSample
{
    NSArray *attributes = [SampleConstants attributeNames];
    for (NSString *attr in attributes) {
        [sample removeObserver:self
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
    if ([attr isEqualToString:SMP_LATITUDE] || [attr isEqualToString:SMP_LONGITUDE])
        [self setupGoogleMapsHyperlink];
    else if ([attr isEqualToString:SMP_TYPE]) {
        NSString *rockType = [sample.attributes objectForKey:SMP_TYPE];
        if ([rockType isEqualToString:@"Siliciclastic"] || [rockType isEqualToString:@"Carbonate"] ||
                [rockType isEqualToString:@"Authigenic"] || [rockType isEqualToString:@"Volcanic"] ||
                [rockType isEqualToString:@"Fossil"])
            [sample.attributes setObject:@"" forKey:SMP_DEPOSYSTEM];
        else
            [sample.attributes setObject:@"N/A" forKey:SMP_DEPOSYSTEM];
            
        [sample.attributes setObject:@"" forKey:SMP_LITHOLOGY];
    }
    
    [dataStore updateLibraryObject:sample IntoTable:[SampleConstants tableName]];
}

- (void)updateDatePicker
{
    [datePicker setDateValue:[NSDate dateWithNaturalLanguageString:[sample.attributes objectForKey:SMP_DATE_COLLECTED]]];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox
{
    if (comboBox.tag == rockTypeTag)
        return [[SampleConstants rockTypes] count];
    else if (comboBox.tag == lithologyTag)
        return [[SampleConstants lithologiesForRockType:self.rockTypeComboBox.stringValue] count];
    else if (comboBox.tag == deposystemTag)
        return [[SampleConstants deposystemsForRockType:self.rockTypeComboBox.stringValue] count];
    else if (comboBox.tag == ageMethodTag)
        return [[SampleConstants ageMethods] count];
    else
        return 0;
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index
{
    if (comboBox.tag == rockTypeTag)
        return [[SampleConstants rockTypes] objectAtIndex:index];
    else if (comboBox.tag == lithologyTag)
        return [[SampleConstants lithologiesForRockType:self.rockTypeComboBox.stringValue] objectAtIndex:index];
    else if (comboBox.tag == deposystemTag)
        return [[SampleConstants deposystemsForRockType:self.rockTypeComboBox.stringValue] objectAtIndex:index];
    else if (comboBox.tag == ageMethodTag)
        return [[SampleConstants ageMethods] objectAtIndex:index];
    else
        return nil;
}

- (NSString *)comboBox:(NSComboBox *)comboBox completedString:(NSString *)enteredValue
{
    NSArray *prefilledValues;
    if (comboBox.tag == rockTypeTag)
        prefilledValues = [SampleConstants rockTypes];
    else if (comboBox.tag == lithologyTag)
        prefilledValues = [SampleConstants lithologiesForRockType:self.rockTypeComboBox.stringValue];
    else if (comboBox.tag == deposystemTag)
        prefilledValues = [SampleConstants deposystemsForRockType:self.rockTypeComboBox.stringValue];
    else if (comboBox.tag == ageMethodTag)
        prefilledValues = [SampleConstants ageMethods];
    
    // Check if entered value is prefix of one of the prefilled values
    for (NSString *value in prefilledValues) {
        if ([value.lowercaseString hasPrefix:enteredValue.lowercaseString])
            return value;
    }
    return nil;
}

- (void)setupGoogleMapsHyperlink
{
    NSString *latitude = [sample.attributes objectForKey:SMP_LATITUDE];
    NSString *longitude = [sample.attributes objectForKey:SMP_LONGITUDE];
    
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
