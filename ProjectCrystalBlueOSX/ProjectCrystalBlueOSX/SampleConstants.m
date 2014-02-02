//
//  SampleConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleConstants.h"

/* Attribute names
 */
NSString *const SOURCE_KEY = @"SourceKey";
NSString *const CURRENT_LOCATION = @"CurrentLocation";
NSString *const BULK_ROCK = @"Bulk_Rock";
NSString *const RAINY_DAY = @"Rainy_Day";
NSString *const HAND_SAMPLE = @"Hand_Sample";
NSString *const DEEP_STORAGE = @"Deep_Storage";
NSString *const ROCK_SAW = @"Rock_Saw";
NSString *const JAW_CRUSHER = @"Jaw_Crusher";
NSString *const PULVERIZER = @"Pulverizer";
NSString *const SIEVES = @"Sieves";
NSString *const GEMENI = @"Gemeni";
NSString *const GOLD_PAN = @"Gold_Pan";
NSString *const HEAVY_LIQUID = @"Heavy_Liquid";
NSString *const MAGNETIC_SEPERATOR = @"Magnetic_Seperator";
NSString *const TAGS = @"Tags";

/* Attribute default values
 */
NSString *const DEF_VAL_SOURCE_KEY = @"";
NSString *const DEF_VAL_CURRENT_LOCATION = @"USC";
NSString *const DEF_VAL_BULK_ROCK = @"Is Bulk_Rock";
NSString *const DEF_VAL_RAINY_DAY = @"Not Rainy_Day";
NSString *const DEF_VAL_HAND_SAMPLE = @"Not Hand_Sample";
NSString *const DEF_VAL_DEEP_STORAGE = @"Not Deep_Storage";
NSString *const DEF_VAL_ROCK_SAW = @"Not Rock_Saw";
NSString *const DEF_VAL_JAW_CRUSHER = @"Not Jaw_Crusher";
NSString *const DEF_VAL_PULVERIZER = @"Not Pulverizer";
NSString *const DEF_VAL_SIEVES = @"Not Sieves";
NSString *const DEF_VAL_GEMENI = @"Not Gemeni";
NSString *const DEF_VAL_GOLD_PAN = @"Not Gold_Pan";
NSString *const DEF_VAL_HEAVY_LIQUID = @"Not Heavy_Liquid";
NSString *const DEF_VAL_MAGNETIC_SEPERATOR = @"Not Magnetic_Seperator";
NSString *const DEF_VAL_TAGS = @"";

/* Sample table name
 */
NSString *const SAMPLE_TABLE_NAME = @"test_sample_table";

@implementation SampleConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          SOURCE_KEY, CURRENT_LOCATION, BULK_ROCK, RAINY_DAY, HAND_SAMPLE, DEEP_STORAGE, ROCK_SAW, JAW_CRUSHER, PULVERIZER, SIEVES, GEMENI, GOLD_PAN, HEAVY_LIQUID, MAGNETIC_SEPERATOR, TAGS, nil];
    }
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  DEF_VAL_SOURCE_KEY, DEF_VAL_CURRENT_LOCATION, DEF_VAL_BULK_ROCK, DEF_VAL_RAINY_DAY, DEF_VAL_HAND_SAMPLE, DEF_VAL_DEEP_STORAGE, DEF_VAL_ROCK_SAW, DEF_VAL_JAW_CRUSHER, DEF_VAL_PULVERIZER, DEF_VAL_SIEVES, DEF_VAL_GEMENI, DEF_VAL_GOLD_PAN, DEF_VAL_HEAVY_LIQUID, DEF_VAL_MAGNETIC_SEPERATOR, DEF_VAL_TAGS,
                                  nil];
    }
    return attributeDefaultValues;
}

+ (NSString *)sampleTableName
{
    return SAMPLE_TABLE_NAME;
}

@end
