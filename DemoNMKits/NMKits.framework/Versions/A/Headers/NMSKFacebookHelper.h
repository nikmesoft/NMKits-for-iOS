//
//  NMSKFacebookHelper.h
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import <Foundation/Foundation.h>

typedef void (^NMSKFacebookHelperCompletionHandler)(BOOL,NSError*,NSDictionary*);


@interface NMSKFacebookHelper : NSObject

+ (NMSKFacebookHelper *)sharedManager;

// Add following class methods to AppDelegate's methods, each of which has same name
+ (void)applicationWillTerminate:(UIApplication *)application;
+ (void)applicationDidBecomeActive:(UIApplication *)application;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)fbPostPhoto:(NSString*)message image:(UIImage*)image completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler;
- (void)fbPostStatusUpdate:(NSString*)shareContent completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler;
- (void)fbPublishStory:(NSString*)message link:(NSString*)link picture:(NSString*)picture
                  name:(NSString*)name caption:(NSString*)caption description:(NSString*)description completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler;

- (void)logoutFacebookWithCompletionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler;
- (void)getProfileWithPermissions:(NSArray*)permissions userFields:(NSArray*)fields completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler;

@end
