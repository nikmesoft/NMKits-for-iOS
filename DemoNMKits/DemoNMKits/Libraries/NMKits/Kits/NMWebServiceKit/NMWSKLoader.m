//
//  WSLoader.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMWSKLoader.h"
#import "NMWSKDataLoader.h"


@interface NMWSKLoader() <DataLoaderDelegate>
{
    NMWSKDataLoader *_dataLoader;
    NMWSKLoaderCompletionHandler _completionHandler;
}

@end

@implementation NMWSKLoader

- (id)init
{
    if ((self = [super init])) {
        _responseDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)callURL:(NSString *)strURL forKey:(NSString *)key completionHandler:(NMWSKLoaderCompletionHandler)completionHandler
{
    _dataLoader = [[NMWSKDataLoader alloc] init];
    _completionHandler = [completionHandler copy];
    [_dataLoader loadDataWithStringURL:strURL delegate:self forKey:key];
}

- (void)callRequest:(NSMutableURLRequest *)request forKey:(NSString *)key completionHandler:(NMWSKLoaderCompletionHandler)completionHandler
{
    _dataLoader = [[NMWSKDataLoader alloc] init];
    _completionHandler = [completionHandler copy];
    [_dataLoader loadDataWithURLRequest:request delegate:self forKey:key];
}

- (void)processData:(NSObject *)data error:(NSError**)error;
{
    DBGS;
}

- (void)parserData:(NSObject *)data forKey:(NSString *)key
{
    DBGS;
    NSError *error = nil;
    [self processData:data error:&error];
    if (error == nil) {
        if(_completionHandler)
        {
            _completionHandler(YES,nil,_responseDict,key);
            _completionHandler = nil;
        }
    } else {
        if(_completionHandler)
        {
            _completionHandler(NO,error,nil,key);
            _completionHandler = nil;
        }
    }
}

#pragma mark - DataLoaderDelegate

- (void)dataLoader:(NMWSKDataLoader *)dataLoader didFinishLoadData:(NSMutableData *)data forKey:(NSString *)key
{
    DBGS;
    @try {
        [self parserData:data forKey:key];
    }
    @catch (NSException *exception) {
        DBG(@"%@",exception);
    }
}

- (void)dataLoader:(NMWSKDataLoader *)dataLoader connectionFailed:(NSError *)error forKey:(NSString *)key
{
    if(_completionHandler)
    {
        _completionHandler(NO,error,nil,key);
        _completionHandler = nil;
    }
}

@end
