//
//  NMWSKLoader.h
//  NMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMWSKLoader : NSObject

typedef void (^NMWSKLoaderCompletionHandler)(BOOL successfully,NSError *error,NSObject *data,NSString *key);

@property (nonatomic, strong) NSMutableDictionary *responseDict;

- (void)callURL:(NSString *)strURL forKey:(NSString *)key completionHandler:(NMWSKLoaderCompletionHandler)completionHandler;
- (void)callRequest:(NSMutableURLRequest *)request forKey:(NSString *)key completionHandler:(NMWSKLoaderCompletionHandler)completionHandler;

- (void)processData:(NSObject *)data error:(NSError**)error;

- (void)parserData:(NSObject *)data forKey:(NSString *)key;

@end
