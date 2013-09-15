//
//  NMShareKit.h
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import <Foundation/Foundation.h>

typedef void (^NMShareKitCompletionHandler)(BOOL,NSError*,NSDictionary*);

@interface NMShareKit : NSObject

+ (id)sharedManager;

// twitter
- (void)twShareWithText:(NSString*)text image:(UIImage*)image url:(NSString*)url
      completionHandler:(NMShareKitCompletionHandler)completionHandler;
- (void)twGetProfileWithCompletionHandler:(NMShareKitCompletionHandler)completionHandler;


// facebook
- (void)fbPostStatus:(NSString*)status completionHandler:(NMShareKitCompletionHandler)completionHandler;
- (void)fbShareURL:(NSString*)title url:(NSString*)url completionHandler:(NMShareKitCompletionHandler)completionHandler;
- (void)fbPostPhoto:(UIImage*)image message:(NSString*)message completionHandler:(NMShareKitCompletionHandler)completionHandler;
- (void)fbPublishStory:(NSString*)message link:(NSString*)link picture:(NSString*)picture
                  name:(NSString*)name caption:(NSString*)caption description:(NSString*)description
     completionHandler:(NMShareKitCompletionHandler)completionHandler;

- (void)fbGetProfileWithPermissions:(NSArray*)premissions userFields:(NSArray*)fields
                  completionHandler:(NMShareKitCompletionHandler)completionHandler;


// email
- (void)shareEmailWithSubject:(NSString*)subject body:(NSString*)body image:(UIImage*)image
                       isHTML:(BOOL)isHTML toRecipients:(NSArray*)toRecipients completionHandler:(NMShareKitCompletionHandler)completionHandler;

// google plus
- (void)gPlusPostStatus:(NSString*)status completionHandler:(NMShareKitCompletionHandler)completionHandler;
- (void)gPlusShareURL:(NSString*)url message:(NSString*)message completionHandler:(NMShareKitCompletionHandler)completionHandler;
- (void)gPlusGetProfileWithCompletionHandler:(NMShareKitCompletionHandler)completionHandler;

@end
