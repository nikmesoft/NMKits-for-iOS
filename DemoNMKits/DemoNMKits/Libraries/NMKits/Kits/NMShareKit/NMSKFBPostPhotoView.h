//
//  NMSKFBPostPhotoView.h
//  NMKits
//
//  Created by Linh NGUYEN on 1/24/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMSKFBPostPhotoViewDelegate;

@interface NMSKFBPostPhotoView : UIView

@property(nonatomic, weak) id<NMSKFBPostPhotoViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame message:(NSString*)message image:(UIImage*)image;

- (void) setText:(NSString*)text;
- (void) setImage:(UIImage*)image;

@end
@protocol NMSKFBPostPhotoViewDelegate<NSObject>

- (void)postPhotoView:(NMSKFBPostPhotoView*)postStatusUpdateView didPost:(NSString*)message image:(UIImage*)image;

@end