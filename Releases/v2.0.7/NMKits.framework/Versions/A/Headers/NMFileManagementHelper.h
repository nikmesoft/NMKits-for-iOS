//
//  NMFileManagementHelper.h
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMFileManagementHelper : NSObject

+ (NSURL*)cacheURL:(NSString*)urlString cacheName:(NSString*)cacheName;
+ (NSURL*)cacheURL:(NSString*)urlString cacheName:(NSString*)cacheName cacheExt:(NSString*)ext;
+ (void)createCacheDirectory;
+ (unsigned long long)getFileSizeAtPath:(NSString*)path;
+ (unsigned long long)getCacheSize;
+ (BOOL)isCached:(NSString*)urlString cacheExt:(NSString*)cacheExt;
+ (void)removeCache:(NSString*)urlString cacheExt:(NSString*)cacheExt;

@end
