//
//  NSFileManager+Utilities.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NSFileManager+NMUtilities.h"

@implementation NSFileManager (NMUtilities)

- (NSURL*)privateDirectory {
    return [[self URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*)publicDirectory {
    return [[self URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*)cacheDirectory {
    return [[self privateDirectory] URLByAppendingPathComponent:@"Caches"];
}


@end
