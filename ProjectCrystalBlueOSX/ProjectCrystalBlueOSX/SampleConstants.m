//
//  SampleConstants.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleConstants.h"
#import "PCBLogWrapper.h"

/* Sample table name
 */
#ifdef DEBUG
static NSString *const SAMPLE_TABLE_NAME = @"test_sample_table";
#else
static NSString *const SAMPLE_TABLE_NAME = @"prod_sample_table";
#endif

@implementation SampleConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          SMP_KEY,
                          SMP_REGION,
                          SMP_CONTINENT,
                          SMP_TYPE,
                          SMP_LITHOLOGY,
                          SMP_LOCALITY,
                          SMP_LATITUDE,
                          SMP_LONGITUDE,
                          SMP_DATE_COLLECTED,
                          SMP_COLLECTED_BY,
                          SMP_AGE,
                          SMP_AGE_METHOD,
                          SMP_AGE_DATATYPE,
                          SMP_GROUP,
                          SMP_FORMATION,
                          SMP_MEMBER,
                          SMP_DEPOSYSTEM,
                          SMP_SECTION,
                          SMP_METER,
                          SMP_NOTES,
                          SMP_HYPERLINKS,
                          SMP_NUM_SPLITS,
                          SMP_IMAGES, nil];
    }
    
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  SMP_DEF_VAL_KEY,
                                  SMP_DEF_VAL_REGION,
                                  SMP_DEF_VAL_CONTINENT,
                                  SMP_DEF_VAL_TYPE,
                                  SMP_DEF_VAL_LITHOLOGY,
                                  SMP_DEF_VAL_LOCALITY,
                                  SMP_DEF_VAL_LATITUDE,
                                  SMP_DEF_VAL_LONGITUDE,
                                  SMP_DEF_VAL_DATE_COLLECTED,
                                  SMP_DEF_VAL_COLLECTED_BY,
                                  SMP_DEF_VAL_AGE,
                                  SMP_DEF_VAL_AGE_METHOD,
                                  SMP_DEF_VAL_AGE_DATATYPE,
                                  SMP_DEF_VAL_GROUP,
                                  SMP_DEF_VAL_FORMATION,
                                  SMP_DEF_VAL_MEMBER,
                                  SMP_DEF_VAL_DEPOSYSTEM,
                                  SMP_DEF_VAL_SECTION,
                                  SMP_DEF_VAL_METER,
                                  SMP_DEF_VAL_NOTES,
                                  SMP_DEF_VAL_HYPERLINKS,
                                  SMP_DEF_VAL_NUM_SPLITS,
                                  SMP_DEF_VAL_IMAGES, nil];
    }
    return attributeDefaultValues;
}

+ (NSArray *)humanReadableLabels
{
    static NSArray *attributeLabelValues = nil;
    if (!attributeLabelValues)
    {
        attributeLabelValues = [NSArray arrayWithObjects:
                                SMP_DISPLAY_KEY,
                                SMP_DISPLAY_REGION,
                                SMP_DISPLAY_CONTINENT,
                                SMP_DISPLAY_TYPE,
                                SMP_DISPLAY_LITHOLOGY,
                                SMP_DISPLAY_LOCALITY,
                                SMP_DISPLAY_LATITUDE,
                                SMP_DISPLAY_LONGITUDE,
                                SMP_DISPLAY_DATE_COLLECTED,
                                SMP_DISPLAY_COLLECTED_BY,
                                SMP_DISPLAY_AGE,
                                SMP_DISPLAY_AGE_METHOD,
                                SMP_DISPLAY_AGE_DATATYPE,
                                SMP_DISPLAY_GROUP,
                                SMP_DISPLAY_FORMATION,
                                SMP_DISPLAY_MEMBER,
                                SMP_DISPLAY_DEPOSYSTEM,
                                SMP_DISPLAY_SECTION,
                                SMP_DISPLAY_METER,
                                SMP_DISPLAY_NOTES,
                                SMP_DISPLAY_HYPERLINKS,
                                SMP_DISPLAY_NUM_SPLITS,
                                SMP_DISPLAY_IMAGES, nil];
    }
    return attributeLabelValues;
}

+ (NSString *)humanReadableLabelForAttribute:(NSString *)attributeName
{
    NSUInteger index = [[self.class attributeNames] indexOfObject:attributeName];
    if (index == NSNotFound) {
        DDLogWarn(@"%@: %@ attribute is unknown.", NSStringFromClass(self.class), attributeName);
        return attributeName;
    }

    return [[self.class humanReadableLabels] objectAtIndex:index];
}

+ (NSString *)attributeNameForHumanReadableLabel:(NSString *)label
{
    NSUInteger index = [[self.class humanReadableLabels] indexOfObject:label];
    if (index == NSNotFound) {
        DDLogWarn(@"%@: %@ attribute is unknown.", NSStringFromClass(self.class), label);
        return label;
    }
    
    return [[self.class attributeNames] objectAtIndex:index];
}

+ (NSString *)tableName
{
    return SAMPLE_TABLE_NAME;
}

+ (NSString *)tableSchema
{
    static NSString *schema = nil;
    if (!schema)
    {
        NSMutableArray *attrNames = [[self attributeNames] mutableCopy];
        
        // Append column info to each attribute name
        for (int i=0; i<[attrNames count];  i++)
        {
            NSString *attr = [attrNames objectAtIndex:i];
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ TEXT%@",
                                                          attr, [attr isEqualToString:SMP_KEY] ? @" PRIMARY KEY" : @""]];
        }
        schema = [attrNames componentsJoinedByString:@","];
    }
    return schema;
}

+ (NSString *)tableColumns
{
    static NSString *columns = nil;
    if (!columns)
    {
        columns = [[self attributeNames] componentsJoinedByString:@","];
    }
    return columns;
}

+ (NSString *)tableValueKeys
{
    static NSString *valueKeys = nil;
    if (!valueKeys)
    {
        NSMutableArray *attrNames = [[self attributeNames] mutableCopy];
        
        // Prepend ':' to each attribute name
        for (int i=0; i<[attrNames count];  i++)
        {
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@":%@", [attrNames objectAtIndex:i]]];
        }
        valueKeys = [attrNames componentsJoinedByString:@","];
    }
    return valueKeys;
}

+ (NSArray *)rockTypes
{
    return [NSArray arrayWithObjects: @"siliciclastic", @"carbonate", @"authigenic", @"other sedimentary", @"plutonic",
            @"volcanic", @"other igneous", @"metasedimentary", @"metaigneous", @"other metamorphic", @"fossil", @"unknown", nil];
}

+ (NSArray *)lithologiesForRockType:(NSString *)rockType
{
    rockType = [rockType lowercaseString];
    
    if ([rockType isEqualToString:@"siliciclastic"]) {
        return [NSArray arrayWithObjects: @"conglomerate", @"breccia", @"sandstone", @"mudstone", @"gravel",
                @"sand", @"mud", @"other", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"carbonate"]) {
        return [NSArray arrayWithObjects: @"marl", @"micrite", @"wackestone", @"packstone", @"grainstone",
                @"boundstone", @"other", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"authigenic"]) {
        return [NSArray arrayWithObjects: @"glauconite", @"other", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"plutonic"]) {
        return [NSArray arrayWithObjects: @"granitoid", @"granite", @"granodiorite", @"gonalite", @"diorite",
                @"gabbro", @"monzonite", @"syenite", @"other", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"volcanic"]) {
        return [NSArray arrayWithObjects: @"ash", @"rhyolite", @"dacite", @"andesite", @"basalt", @"trachyte", @"other", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"metasedimentary"]) {
        return [NSArray arrayWithObjects: @"slate", @"phyllite", @"schist", @"gneiss", @"quartzite", @"marble", @"other", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"metaigneous"]) {
        return [NSArray arrayWithObjects: @"felsic orthoschist", @"felsic orthogneiss", @"intermediate orthoschist",
                @"intermediate orthogneiss", @"amphibolite", @"other", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"fossil"]) {
        return [NSArray arrayWithObjects:@"conglomerate", @"sandstone", @"mudstone", @"marl", @"micrite", @"wackestone",
                @"packstone", @"grainstone", @"other", @"unknown", nil];
    }
    else {
        return nil;
    }
}

+ (NSArray *)deposystemsForRockType:(NSString *)rockType
{
    rockType = [rockType lowercaseString];
    
    if ([rockType isEqualToString:@"siliciclastic"]) {
        return [NSArray arrayWithObjects: @"alluvial fan", @"fluvial megafan", @"meandering fluvial", @"alpine glacial", @"ice sheet",
                @"lacustrine", @"eolian", @"deltaic", @"estuarine", @"shallow marine", @"shelf", @"pelagic", @"submarine fan", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"carbonate"]) {
        return [NSArray arrayWithObjects: @"carbonate platform", @"carbonate reef", @"pelagic", @"eolian", @"unknown", nil];
    }
    else if ([rockType isEqualToString:@"fossil"]) {
        return [NSArray arrayWithObjects: @"alluvial fan", @"fluvial megafan", @"meandering fluvial", @"alpine glacial", @"ice sheet",
                @"lacustrine", @"eolian", @"deltaic", @"estuarine", @"shallow marine", @"shelf", @"pelagic", @"submarine fan",
                @"carbonate platform", @"carbonate reef", @"pelagic", @"eolian", @"unknown", nil];
    }
    else {
        return nil;
    }
}

+ (NSArray *)ageMethods
{
    return [NSArray arrayWithObjects: @"biostratigraphy", @"magnetostratigraphy", @"chemostratigraphy", @"geochronology",
            @"thermochronology", @"other", @"none", nil];
}

@end
