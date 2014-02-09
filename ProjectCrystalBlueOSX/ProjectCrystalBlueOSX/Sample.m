//
//  Sample.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation Sample

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues
{
    return [super initWithKey:key
            AndWithAttributes:[SampleConstants attributeNames]
                    AndValues:attributeValues];
}

- (NSString *)sourceKey
{
    return [[self attributes] objectForKey:@"sourceKey"];
}

@end
