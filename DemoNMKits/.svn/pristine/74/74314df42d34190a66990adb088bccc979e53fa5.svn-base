//
//  NMSKFBPublishStoryView.m
//  NMKits
//
//  Created by Linh NGUYEN on 1/24/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import "NMSKFBPublishStoryView.h"
#import "NMSKHelper.h"
#import <QuartzCore/QuartzCore.h>

#define MARGIN 20
#define WIDTH 320
#define HEIGHT 216

#define BUTTON_CANCEL_WIDTH 56
#define BUTTON_CANCEL_HEIGHT 29

#define BUTTON_POST_WIDTH 49
#define BUTTON_POST_HEIGHT 29

#define BUTTON_MARGIN_TOP 16
#define BUTTON_MARGIN_LEFT 10
#define BUTTON_MARGIN_RIGHT 12

#define SCROLLVIEW_MARGIN 5
#define SCROLLVIEW_HEIGHT 100

#define TEXTVIEW_MARGIN 2

@interface NMSKFBPublishStoryView()<UITextViewDelegate>
{
    __weak UIView *_textViewParent;
    __weak UIView *_bgView;
    __weak UITextView *_textView;
    __weak UIButton *_btnCancel;
    __weak UIButton *_btnPost;
    __weak UIImageView *_imageView;
}
@end

@implementation NMSKFBPublishStoryView

- (id)initWithFrame:(CGRect)frame link:(NSString*)link picture:(NSString*)picture
               name:(NSString*)name caption:(NSString*)caption description:(NSString*)description
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // add bgView
        UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.0;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [bgView addGestureRecognizer:singleTap];
        [self addSubview:bgView];
        _bgView = bgView;
        
        // animation for bgView
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews
                         animations:^{
                             bgView.alpha = 0.7;
                         }
                         completion:nil];
        
        
        // add mainView
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - HEIGHT, WIDTH,HEIGHT)];
        v.backgroundColor = [UIColor colorWithPatternImage:[NMSKHelper imageNamed:@"bg.png"]];
        
        // cancel button
        UIButton *btnCancel = [UIButton buttonWithType: UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(BUTTON_MARGIN_LEFT, BUTTON_MARGIN_TOP, BUTTON_CANCEL_WIDTH, BUTTON_CANCEL_HEIGHT);
        [btnCancel setBackgroundImage:[NMSKHelper imageNamed:@"ic_bt_cancel.png"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel:) forControlEvents: UIControlEventTouchUpInside];
        [v addSubview:btnCancel];
        _btnCancel = btnCancel;
        
        // post button
        UIButton *btnPost = [UIButton buttonWithType: UIButtonTypeCustom];
        btnPost.frame = CGRectMake(WIDTH - BUTTON_MARGIN_LEFT - BUTTON_POST_WIDTH, BUTTON_MARGIN_TOP, BUTTON_POST_WIDTH, BUTTON_POST_HEIGHT);
        [btnPost setBackgroundImage:[NMSKHelper imageNamed:@"ic_bt_post.png"] forState:UIControlStateNormal];
        btnPost.enabled = NO;
        [v addSubview:btnPost];
        _btnPost = btnPost;
        
        int SCROLLVIEW_MARGIN_TOP = BUTTON_MARGIN_TOP + 35;
        
        // Scrollview
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(SCROLLVIEW_MARGIN, SCROLLVIEW_MARGIN_TOP + SCROLLVIEW_MARGIN, WIDTH - SCROLLVIEW_MARGIN * 2 - 2, SCROLLVIEW_HEIGHT);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.alwaysBounceVertical = YES;
        
        // textview
        UITextView *textView = [[UITextView alloc]init];
        textView.delegate = self;
        textView.frame = CGRectMake(TEXTVIEW_MARGIN, TEXTVIEW_MARGIN, scrollView.frame.size.width - TEXTVIEW_MARGIN * 2, scrollView.frame.size.height - TEXTVIEW_MARGIN * 2);
        textView.font = [UIFont fontWithName:@"Helvetica" size:20];
        textView.backgroundColor = [UIColor clearColor];
        [textView becomeFirstResponder];
        [scrollView addSubview: textView];
        _textView = textView;
        
        [v addSubview:scrollView];
        
        [self addSubview:v];
        _textViewParent = v;
        
        // animation v;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop
                         animations:^{
                             CGRect frame = v.frame;
                             frame.origin.y = MARGIN;
                             v.frame = frame;
                         }
                         completion:^ (BOOL finished){
                             
                         }];
        
        
    }
    return self;
}

#pragma mark - TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    //[self cancel:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    if ([NMSKHelper trim:textView.text].length == 0 && _imageView == nil)
    {
        [_btnPost setBackgroundImage:[NMSKHelper imageNamed:@"ic_bt_post_off.png"] forState:UIControlStateNormal];
        [_btnPost setEnabled:NO];
    }
    else
    {
        [_btnPost setEnabled:YES];
        [_btnPost setBackgroundImage:[NMSKHelper imageNamed:@"ic_bt_post.png"] forState:UIControlStateNormal];
        [_btnPost addTarget:self action:@selector(post:) forControlEvents: UIControlEventTouchUpInside];
    }
    
}

#pragma mark - Actions
- (void)cancel:(id)sender
{
    [_textView resignFirstResponder];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         CGRect frame = _textViewParent.frame;
                         frame.origin.y -= (HEIGHT + 20);
                         _textViewParent.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         _bgView.alpha = 0.0;
                     }
                     completion:^ (BOOL finished){
                         [self removeFromSuperview];
                     }];
}

- (void)post:(id)sender
{
    [self cancel:nil];
    [self.delegate publishStoryView:self didPost:_textView.text];
}



@end
