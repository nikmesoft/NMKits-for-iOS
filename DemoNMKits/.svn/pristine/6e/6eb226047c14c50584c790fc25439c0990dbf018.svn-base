//
//  NMSKDevDefine.m
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import "NMSKDevDefine.h"
#import "NMSKDefine.h"
#import "NMSKHelper.h"

@interface NMSKDevDefine()

@end

@implementation NMSKDevDefine


#pragma mark Singleton Methods

+ (id)sharedManager {
    static NMSKDevDefine *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (UIViewController *)getRootViewController
{
    
    UIViewController *result;
    // If developer provieded a root view controler, use it
    if (self.rootViewController) 
    {        
        return self.rootViewController;
    }
    
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"NMShareKit: Could not find a root view controller.  You can assign one manually by calling [[NMSKDevDefine sharedManager] setRootViewController:YOURROOTVIEWCONTROLLER].");
    return result;
}

@end
