//
//  NMView.h
//  NMKits
//
//  Created by Linh NGUYEN on 9/15/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMView : UIView

- (id)initWithXibName:(NSString*)xibName;
- (void)initVariables;
- (BOOL)showInView:(UIView *)view;
- (void)hide;

@end
