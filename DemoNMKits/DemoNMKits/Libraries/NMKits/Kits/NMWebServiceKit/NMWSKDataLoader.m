//
//  NMWSKDataLoader.m
//  NMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMWSKDataLoader.h"

@interface NMWSKDataLoader ()
{
    NSURLConnection *_connection;
    NSMutableData *_data;
    NSString *_key;
}

@end

@implementation NMWSKDataLoader

- (void)cancelDownload
{
    self.delegate = nil;
    [_connection cancel];
}

- (void)loadDataWithStringURL:(NSString *)strURL delegate:(id<DataLoaderDelegate>)theDelegate forKey:(NSString *)key
{
    self.delegate = theDelegate;
    _key = key;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *URL = [NSURL URLWithString:strURL];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    _connection = theConnection;
}

- (void)loadDataWithURLRequest:(NSURLRequest *)request delegate:(id<DataLoaderDelegate>)theDelegate forKey:(NSString *)key
{
    self.delegate = theDelegate;
    _key = key;
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    _connection = theConnection;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DBGS;
    NSMutableData *theData = [[NSMutableData alloc] initWithLength:0];
    _data = theData;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DBGS;
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DBG(@"%@",error.userInfo);
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoader:connectionFailed:forKey:)]) {
        [self.delegate dataLoader:self connectionFailed:error forKey:_key];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DBGS;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoader:didFinishLoadData:forKey:)]) {
        [self.delegate dataLoader:self didFinishLoadData:_data forKey:_key];
    }
}

@end
