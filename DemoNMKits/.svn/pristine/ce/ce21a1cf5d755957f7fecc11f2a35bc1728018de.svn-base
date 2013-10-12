//
//  NMTableViewCell.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/15/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMTableViewCell.h"

@implementation NMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
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
