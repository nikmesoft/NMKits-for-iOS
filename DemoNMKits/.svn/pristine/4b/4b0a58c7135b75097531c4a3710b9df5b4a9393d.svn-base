//
//  Webservice.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "Webservice.h"

#define WS_METHOD @"http://nikmesoft.com/steven/vietfooding/foods/getfooddetails.json?food_id=%@&user_id=%@"
#define TIME_OUT 30
#define API_KEY @"a30e38ce87e30dd2a6f7e858ce68dcc3"

@interface Webservice()
{
    NMWSKLoaderCompletionHandler _completionHandler;
}

@end

@implementation Webservice

- (void)getFoodDetailwithFoodID:(NSString *)food_id withUserID:(NSString *)user_id
                        withKey:(NSString *)key completionHandler:(NMWSKLoaderCompletionHandler)completionHandler
{
    NSString *strURL = [NSString stringWithFormat:WS_METHOD,food_id,user_id];
    DBG(@"%@",strURL);
    
    _completionHandler = [completionHandler copy];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    NSURL* URL = [NSURL URLWithString:strURL];
	[request setURL:URL];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setTimeoutInterval:TIME_OUT];
    [request setHTTPMethod:@"GET"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:API_KEY forHTTPHeaderField:@"api_key"];
    NSString *postParams = @"";
    
    [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self callRequest:request forKey:key completionHandler:^(BOOL successfully, NSError *error, NSObject *data, NSString *key) {
        if(_completionHandler)
        {
            _completionHandler(successfully,error,data,key);
            _completionHandler = nil;
        }
    }];
}

- (void)processData:(NSObject*)data error:(NSError**)error
{
    DBG(@"Data = %@",data);
    
    if([data isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *returnDict = (NSDictionary*)data;
        NSDictionary *responseDict = [returnDict objectForKey:@"response"];
        NSDictionary *data = [responseDict objectForKey:@"data"];
        NSDictionary *errorObj = [responseDict valueForKey:@"result"];
        NSNumber *success = [errorObj valueForKey:@"success"];
        
        
        if([success boolValue])
        {
            // Get food detail
            NSDictionary *food = [data objectForKey:@"Food"];
            
            [self.responseDict setObject:food forKey:@"Result"];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[errorObj objectForKey:@"error"] forKey:@"message"];
            *error = [[NSError alloc] initWithDomain:@"Webservice" code:0 userInfo:userInfo];
        }
        
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Response is invalid." forKey:@"message"];
        *error = [[NSError alloc] initWithDomain:@"Webservice" code:0 userInfo:userInfo];
        
    }
}

@end
