//
//  NSFileManager+Utilities.h
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (NMUtilities)

- (NSURL*)privateDirectory;
- (NSURL*)publicDirectory;
- (NSURL*)cacheDirectory;

@end
