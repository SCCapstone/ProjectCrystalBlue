//
//  DirtyKeySet.h
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/6/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A wrapper class for a set of dirty image keys. They are automatically loaded and written to a plaintext
 *  file on the local filesystem.
 */
@interface DirtyKeySet : NSObject {
    NSMutableSet *dirtyKeys;
    NSString *filePath;
}

/// You must provide a directory for the dirty key file to be stored.
-(id)initInDirectory:(NSString *)directory;

/// Add a key to the set of dirty keys.
-(void)add:(NSString *)key;

/// Add a set of keys to the set of dirty keys. Use this if you need to add multiple keys to save on file IO.
-(void)addAll:(NSSet *)keys;

/// Remove a key from the set of dirty keys. This should be performed after the image is successfully uploaded to S3.
-(void)remove:(NSString *)key;

/// Check if an image key is dirty.
-(BOOL)contains:(NSString *)key;

/// Return the set of all of the active keys.
-(NSSet *)allKeys;

/// The name of the dirtykeys file.
+(NSString *)fileName;

@end
