//
//  NMWSKDataLoader.h
//  NMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataLoaderDelegate;

@interface NMWSKDataLoader : NSObject

@property (nonatomic, weak) id<DataLoaderDelegate> delegate;

- (void)loadDataWithStringURL:(NSString *)strURL delegate:(id<DataLoaderDelegate>)theDelegate forKey:(NSString *)key;
- (void)loadDataWithURLRequest:(NSURLRequest *)request delegate:(id<DataLoaderDelegate>)theDelegate forKey:(NSString *)key;

@end

@protocol DataLoaderDelegate <NSObject>

@required
- (void)dataLoader:(NMWSKDataLoader *)dataLoader didFinishLoadData:(NSMutableData*)data forKey:(NSString *)key;
- (void)dataLoader:(NMWSKDataLoader *)dataLoader connectionFailed:(NSError *)error forKey:(NSString *)key;

@end
