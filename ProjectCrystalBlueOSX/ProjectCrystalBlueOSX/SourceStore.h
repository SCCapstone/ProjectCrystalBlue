//
//  SourceStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Source.h"
#import <Zumero.h>

@interface SourceStore : NSObject <ZumeroDBDelegate>

- (void)setupZumero;
- (void)synchronize;
- (void)createTable;
- (void)insertObject;
- (NSArray *)getObjects;

@end
