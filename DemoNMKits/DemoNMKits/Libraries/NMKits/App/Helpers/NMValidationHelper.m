//
//  NMValidationHelper.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMValidationHelper.h"

@implementation NMValidationHelper

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

@end
