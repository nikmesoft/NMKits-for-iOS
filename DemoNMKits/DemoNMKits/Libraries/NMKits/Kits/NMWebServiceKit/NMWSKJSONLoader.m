//
//  NMWSKJSONLoader.m
//  NMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMWSKJSONLoader.h"

@implementation NMWSKJSONLoader

- (void)parserData:(NSMutableData *)data forKey:(NSString *)key
{
    NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (JSONDict != nil) {
        [super parserData:JSONDict forKey:key];
    } else {
        [super parserData:data forKey:key];
    }
}

@end
