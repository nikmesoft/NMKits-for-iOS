//
//  NMSKFBPostStatusUpdateView.h
//  NMKits
//
//  Created by Linh NGUYEN on 1/24/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMSKFBPostStatusUpdateViewDelegate;

@interface NMSKFBPostStatusUpdateView : UIView

@property(nonatomic, weak) id<NMSKFBPostStatusUpdateViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame shareContent:(NSString*)shareContent;

- (void) setText:(NSString*)text;

@end
@protocol NMSKFBPostStatusUpdateViewDelegate<NSObject>

- (void)postStatusUpdateView:(NMSKFBPostStatusUpdateView*)postStatusUpdateView didPost:(BOOL)successfully withText:(NSString*)shareContent;

@end

