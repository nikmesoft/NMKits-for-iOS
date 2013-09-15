//
//  NMUIHelper.h
//  NMKits
//
//  Created by Linh NGUYEN on 9/14/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMUIHelper : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
         cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
