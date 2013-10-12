//
//  UIImage+Utilities.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "UIImage+NMUtilities.h"

@implementation UIImage (NMUtilities)

- (UIImage *)imageFromView:(UIView *)view
{
    CGSize screenShotSize = view.bounds.size;
    UIImage *img;
    UIGraphicsBeginImageContext(screenShotSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view drawLayer:view.layer inContext:ctx];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *) resizeToSize:(CGSize)toSize
{

    CGFloat actualHeight = [self size].height;
    CGFloat actualWidth = [self size].width;
    if(actualWidth <= toSize.width || actualHeight <= toSize.height)
    {
        return self;
    }
    else
    {
        if((actualWidth/actualHeight)<(toSize.width/toSize.height))
        {
            actualHeight=actualHeight*(toSize.width/actualWidth);
            actualWidth=toSize.width;
            
        }else
        {
            actualWidth=actualWidth*(toSize.height/actualHeight);
            actualHeight=toSize.height;
        }
    }
    CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return self;
}

@end
