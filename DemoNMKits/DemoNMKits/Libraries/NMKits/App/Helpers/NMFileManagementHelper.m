//
//  NMFileManagementHelper.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMFileManagementHelper.h"
#import "NSFileManager+NMUtilities.h"
#import "NMConversionHelper.h"

@implementation NMFileManagementHelper

+ (NSURL*)cacheURL:(NSString*)urlString cacheName:(NSString*)cacheName
{
    NSString *ext = [urlString pathExtension];
    if(cacheName == nil)
    {
        cacheName = [NMConversionHelper getMD5FromString:urlString];
    }
    
    NSURL* url = [[NSFileManager defaultManager] cacheDirectory];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",cacheName,ext]];
    return url;
}

+ (NSURL*)cacheURL:(NSString*)urlString cacheName:(NSString*)cacheName cacheExt:(NSString*)ext
{
    if(ext == nil)
    {
        ext = [urlString pathExtension];
    }
    if(cacheName == nil)
    {
        cacheName = [NMConversionHelper getMD5FromString:urlString];
    }
    NSURL* url = [[NSFileManager defaultManager] cacheDirectory];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",cacheName,ext]];
    return url;
}

+ (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *fileError;
    NSURL *literatureURL = [fileManager cacheDirectory];
    BOOL isDirectory = FALSE;
    BOOL isExist = [fileManager fileExistsAtPath:literatureURL.path isDirectory:&isDirectory];
    if(isExist && isDirectory)
    {
        // remove cache if need
        
    } else {
        
        [fileManager createDirectoryAtURL:literatureURL withIntermediateDirectories:YES attributes:nil error:&fileError];
        if(!fileError)
        {
            DBG(@"Created cache directory");
        } else {
            DBG(@"%@",fileError.userInfo);
        }
    }
    
}

+ (unsigned long long)getFileSizeAtPath:(NSString*)path
{
    unsigned long long fileSize = [[[NSFileManager defaultManager]
                                    attributesOfItemAtPath:path error:nil] fileSize];
    return fileSize;
}

+ (unsigned long long)getCacheSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *literatureURL = [fileManager cacheDirectory];
    BOOL isDirectory = FALSE;
    BOOL isExist = [fileManager fileExistsAtPath:literatureURL.path isDirectory:&isDirectory];
    NSError *error = nil;
    
    unsigned long long cacheSize = 0;
    
    if(isExist && isDirectory)
    {
        
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:literatureURL.path error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [literatureURL.path stringByAppendingPathComponent:path];
                cacheSize += [self getFileSizeAtPath:fullPath];
            }
        } else {
            cacheSize += [self getFileSizeAtPath:literatureURL.path];
        }
    }
    return cacheSize;
}

+ (BOOL)isCached:(NSString*)urlString cacheExt:(NSString*)cacheExt
{
    NSURL *localURL = [NMFileManagementHelper cacheURL:urlString cacheName:nil cacheExt:cacheExt];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localURL.path])
    {
        return TRUE;
    }
    return FALSE;
    
}

+ (void)removeCache:(NSString*)urlString cacheExt:(NSString*)cacheExt
{
    NSURL *localURL = [NMFileManagementHelper cacheURL:urlString cacheName:nil cacheExt:cacheExt];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localURL.path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:localURL.path error:nil];
    }
    
}

@end
