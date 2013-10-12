//
//  NMSKGooglePlusHelper.h
//  NMKits
//
//  Created by Linh NGUYEN on 9/4/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NMSKGooglePlusHelperCompletionHandler)(BOOL,NSError*,NSDictionary*);


@interface NMSKGooglePlusHelper: NSObject

+ (NMSKGooglePlusHelper *)sharedManager;

// Add following class methods to AppDelegate's methods, each of which has same name
+ (void)applicationWillTerminate:(UIApplication *)application;
+ (void)applicationDidBecomeActive:(UIApplication *)application;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)logoutGooglePlusWithCompletionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler;
- (void)getProfileWithCompletionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler;
- (void)postStatus:(NSString*)status completionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler;
- (void)shareURL:(NSString*)url message:(NSString*)message completionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler;
- (void)postPhoto:(UIImage*)image message:(NSString*)message completionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler;

@end
