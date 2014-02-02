//
//  Sample.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"
#import "SampleConstants.h"

@implementation Sample

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues
{
    return [super initWithKey:key
            AndWithAttributes:[SampleConstants attributeNames]
                AndWithValues:attributeValues];
}

- (NSString *)sourceKey
{
    return [[self attributes] objectForKey:@"SourceKey"];
}

@end
