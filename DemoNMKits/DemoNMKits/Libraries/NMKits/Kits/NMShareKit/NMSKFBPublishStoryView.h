//
//  NMSKFBPublishStoryView.h
//  NMKits
//
//  Created by Linh NGUYEN on 1/24/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMSKFBPublishStoryViewDelegate;

@interface NMSKFBPublishStoryView : UIView

@property(nonatomic, weak) id<NMSKFBPublishStoryViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame link:(NSString*)link picture:(NSString*)picture
               name:(NSString*)name caption:(NSString*)caption description:(NSString*)description;

@end
@protocol NMSKFBPublishStoryViewDelegate<NSObject>

- (void)publishStoryView:(NMSKFBPublishStoryView*)publishStoryView didPost:(NSString*)message;

@end