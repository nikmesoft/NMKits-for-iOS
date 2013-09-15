//
//  NSDictionary+Utilities.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NSString+NMUtilities.h"

@implementation NSString (NMUtilities)

// trim a nsstring
- (NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// encode NSString for URL
- (NSString*)encodeForURL
{
    NSString * encodedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedString;
}


@end
