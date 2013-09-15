//
//  NMSKHelper.m
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import "NMSKHelper.h"
#import "NMSKDefine.h"

static float __version = -1.0f;
@implementation NMSKHelper

+ (id)sharedManager {
    static NMSKHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.appInfo = [[NSBundle mainBundle] infoDictionary];
    }
    return self;
}

// get device system version
+ (BOOL)iOS_6_0
{
    if (__version < 0) {
        UIDevice *device = [UIDevice currentDevice];
        NSString *systemVersion = [device systemVersion];
        __version = [systemVersion floatValue];
    }
    return __version >= 6;
}

// check system version
+ (BOOL)checkSystemDependence
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *systemVersion = [device systemVersion];
    __version = [systemVersion floatValue];
    if (__version < 5.0f) {
        NSAssert(__version, NMSK_SUPPORT);
        return NO;
    }
    return YES;
}

// check Facebook config
+ (BOOL)checkFacebookDependence
{    
    // Facebook App ID
    NSDictionary *appInfo = [[self sharedManager] appInfo];
    NSString *fbAppID = [appInfo objectForKey:@"FacebookAppID"];
    
    if (fbAppID == nil) {
        NSAssert(fbAppID, NMSK_FACEBOOK_APP_ID);
        return NO;
    }
    
    // Facebook URL Schemes
    BOOL pass = NO;
    NSArray *urlTypes = [appInfo objectForKey:@"CFBundleURLTypes"];
    if (urlTypes != nil && [urlTypes count] > 0) {
        NSDictionary *item = urlTypes[0];
        if (item) {
            NSArray *urlSchemes = [item objectForKey:@"CFBundleURLSchemes"];
            if (urlSchemes && [urlSchemes count] > 0) {
                NSString *item_ = urlSchemes[0];
                if (item_ && [item_ hasPrefix:@"fb"]) {
                    pass = YES;
                }
            }
        }
    }
    if (pass == NO) {
        NSAssert(pass, NMSK_FACEBOOK_URL_SCHEMES);
        return NO;
    }
    
    return YES;
}

// check GooglePlus config
+ (BOOL)checkGooglePlusDependence
{
    // Facebook App ID
    NSDictionary *appInfo = [[self sharedManager] appInfo];
    NSString *gPlusClientID = [appInfo objectForKey:@"GooglePlusCLientID"];
    
    if (gPlusClientID == nil) {
        NSAssert(gPlusClientID, NMSK_GOOGLE_PLUS_CLIENT_ID);
        return NO;
    }
    
    return YES;
}

// get images from bundle
+ (UIImage *)imageNamed:(NSString *)name
{
    // get an image in bundle by name
    NSString *path = [NSString stringWithFormat:@"NMShareKit.bundle/%@", name];
    return [UIImage imageNamed:path];
}

// trim a string
+ (NSString*) trim:(NSString*)str
{
    return [str stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
