//
//  NMView.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/15/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMView.h"

@implementation NMView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (id)initWithXibName:(NSString*)xibName
{
    self = [super init];
    if(self)
    {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
        if([arrayOfViews count] < 1) {
            return nil;
        }
        self = [arrayOfViews lastObject];
        [self initVariables];
    }
    
    return self;
}

- (void)initVariables
{
    
}

@end
