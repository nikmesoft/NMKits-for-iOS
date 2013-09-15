//
//  NMSKFacebookHelper.m
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import "NMSKFacebookHelper.h"
#import "NMSKHelper.h"
#import "NMSKDefine.h"
#import "NMSKDevDefine.h"
#import "NMSKFBPostPhotoView.h"
#import "NMSKFBPostStatusUpdateView.h"
#import "NMSKFBPublishStoryView.h"

#import <FacebookSDK/FacebookSDK.h>

typedef enum PendingActionTypes {
    NONE = 1,
    GET_USER_INFO = 2,
    POST_STATUS_UPDATE = 3,
    POST_PHOTO = 4,
    PUBLISH_STORY = 5,
    GET_PROFILE = 6
} PendingAction;


@interface NMSKFacebookHelper() <NMSKFBPostStatusUpdateViewDelegate, NMSKFBPostPhotoViewDelegate, NMSKFBPublishStoryViewDelegate>
{
    __strong NSString *_shareStatus;
    __strong NSString *_shareMessage;
    __strong UIImage *_shareImage;
    __strong NSString *_shareLink;
    __strong NSString *_sharePicture;
    __strong NSString *_shareCaption;
    __strong NSString *_shareName;
    __strong NSString *_shareDescription;
    PendingAction pendingAction;
    PendingAction chooseAction;
    
    @protected
    NMSKFacebookHelperCompletionHandler _completionHandler;
}

@end


@implementation NMSKFacebookHelper

+ (id)sharedManager {
    static NMSKFacebookHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    if (self) {
        // check facebook config
        if ([NMSKHelper checkFacebookDependence] == NO) {
            return nil;
        }
        pendingAction = NONE;
    }
    return self;
}

#pragma mark - AppDelegate Handle

+ (void)applicationWillTerminate:(UIApplication *)application
{
    [[self sharedManager] applicationWillTerminate:application];
}

+ (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[self sharedManager] applicationDidBecomeActive:application];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[self sharedManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - facebook handle

- (BOOL)hasPublishPermission
{
    return !([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound);
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(PendingAction)action
{
    pendingAction = action;
    if([self hasPublishPermission])
    {
        [self handlePendingAction];
    } else
    {
        [FBSession.activeSession requestNewPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         [self sessionStateChanged:session state:session.state error:error];
                                                     }
                                                 }];
    }
    
}

- (void)postStatusUpdate:(NSString*)content
{
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    // if it is available to us, we will post using the native dialog
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = [application keyWindow];
    UIViewController *vc = [window rootViewController];
    BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:vc initialText:content image:nil url:nil handler:nil];
    if (!displayedNativeDialog) {
        if([self hasPublishPermission])
        {
            [FBRequestConnection startForPostStatusUpdate:content completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    if(_completionHandler != nil)
                    {
                        _completionHandler(FALSE,error,nil);
                    }
                } else {
                    
                    if(_completionHandler != nil)
                    {
                        _completionHandler(TRUE,nil,nil);
                    }
                }
            }];
            
        } else
        {
            pendingAction = POST_STATUS_UPDATE;
        }
    }
}

- (void)postPhoto:(UIImage*)image message:(NSString*)message
{
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    // if it is available to us, we will post using the native dialog
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = [application keyWindow];
    UIViewController *vc = [window rootViewController];
    BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:vc initialText:message image:image url:nil handler:nil];
    if (!displayedNativeDialog) {
        if([self hasPublishPermission])
        {
            // init postparams
            NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
            [postParams setObject:image forKey:@"picture"];
            [postParams setObject:message forKey:@"message"];
            [FBRequestConnection
             startWithGraphPath:@"me/photos"
             parameters:postParams
             HTTPMethod:@"POST"
             completionHandler:^(FBRequestConnection *connection,
                                 id result,
                                 NSError *error) {
                 if (error) {
                     if(_completionHandler != nil)
                     {
                         _completionHandler(FALSE,error,nil);
                     }
                 } else {
                     
                     if(_completionHandler != nil)
                     {
                         _completionHandler(TRUE,nil,nil);
                     }
                 }
             }];
            
        } else
        {
            pendingAction = POST_PHOTO;
        }
    }
}

- (void)publishStory:(NSString*)message link:(NSString*)link picture:(NSString*)picture
                name:(NSString*)name caption:(NSString*)caption description:(NSString*)description
{
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    // if it is available to us, we will post using the native dialog
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = [application keyWindow];
    UIViewController *vc = [window rootViewController];
    BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:vc initialText:message image:nil url:nil handler:nil];
    if (!displayedNativeDialog) {
        if([self hasPublishPermission])
        {
            // init postparams
            NSMutableDictionary *postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               link, @"link",
                                               picture, @"picture",
                                               name, @"name",
                                               caption, @"caption",
                                               description, @"description",
                                               message, @"message",
                                               nil];
            
            [FBRequestConnection
             startWithGraphPath:@"me/feed"
             parameters:postParams
             HTTPMethod:@"POST"
             completionHandler:^(FBRequestConnection *connection,
                                 id result,
                                 NSError *error) {
                 if (error) {
                     if(_completionHandler != nil)
                     {
                         _completionHandler(FALSE,error,nil);
                     }
                 } else {
                     
                     if(_completionHandler != nil)
                     {
                         _completionHandler(TRUE,nil,nil);
                     }
                 }
             }];
            
        } else
        {
            pendingAction = PUBLISH_STORY;
        }
    }
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            [self handlePendingAction];
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    if (error) {
        pendingAction = NONE;
        if(_completionHandler)
        {
            _completionHandler(FALSE,error,nil);
        }
    }
}


- (void)fetchUserInfo {
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
         {
             if (!error)
             {
                 switch (chooseAction) {
                     case POST_PHOTO:
                         [self showPostPhotoView:_shareMessage image:_shareImage];
                         break;
                     case POST_STATUS_UPDATE:
                         [self showPostStatusUpdateView:_shareStatus];
                         break;
                     case PUBLISH_STORY:
                         [self showPublishStoryView:_shareMessage link:_shareLink picture:_sharePicture
                                               name:_shareName caption:_shareCaption description:_shareDescription];
                         break;
                     default:
                         break;
                 }
             }
         }];
    }
}


- (void)handlePendingAction
{
    PendingAction previouslyPendingAction = pendingAction;
    pendingAction = NONE;
    switch (previouslyPendingAction) {
        case POST_STATUS_UPDATE:
            [self postStatusUpdate:_shareStatus];
            break;
        case POST_PHOTO:
            [self postPhoto:_shareImage message:_shareMessage];
            break;
        case PUBLISH_STORY:
            [self publishStory:_shareMessage link:_shareLink picture:_sharePicture name:_shareName caption:_shareCaption description:_shareDescription];
            break;
        case GET_USER_INFO:
            [self fetchUserInfo];
            break;
        default:
            break;
    }
}

#pragma mark - public functions
- (void)fbPostPhoto:(NSString*)message image:(UIImage*)image completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler
{
    _shareMessage = message;
    _shareImage = image;
    chooseAction = POST_PHOTO;
    _completionHandler = [completionHandler copy];
    if(FBSession.activeSession.isOpen) {
        [self performPublishAction:GET_USER_INFO];
        
    } else {
        pendingAction = GET_USER_INFO;
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:(FBSessionDefaultAudienceEveryone) allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
    }
}

- (void)fbPostStatusUpdate:(NSString*)shareContent completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler
{
    _shareStatus = shareContent;
    chooseAction = POST_STATUS_UPDATE;
    _completionHandler = [completionHandler copy];
    
    if(FBSession.activeSession.isOpen) {
        [self performPublishAction:GET_USER_INFO];
        
    } else {
        pendingAction = GET_USER_INFO;
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:(FBSessionDefaultAudienceEveryone) allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
    }
}

- (void)fbPublishStory:(NSString*)message link:(NSString*)link picture:(NSString*)picture
                  name:(NSString*)name caption:(NSString*)caption description:(NSString*)description completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler
{
    _shareMessage = message;
    _shareLink = link;
    _sharePicture = picture;
    _shareName = name;
    _shareCaption = caption;
    _shareDescription = description;
    
    chooseAction = PUBLISH_STORY;    
    
    _completionHandler = [completionHandler copy];
    
    if(FBSession.activeSession.isOpen) {
        [self performPublishAction:GET_USER_INFO];
        
    } else {
        pendingAction = GET_USER_INFO;
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:(FBSessionDefaultAudienceEveryone) allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
    }
}


- (void)logoutFacebookWithCompletionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    if(_completionHandler != nil)
    {
        _completionHandler(TRUE,nil,nil);
    }
}

- (void)getProfileWithPermissions:(NSArray*)permissions userFields:(NSArray*)fields
                completionHandler:(NMSKFacebookHelperCompletionHandler)completionHandler
{
    chooseAction = GET_PROFILE;
    _completionHandler = [completionHandler copy];
    
    if(FBSession.activeSession.isOpen) {
        [self queryUserWithUserFields:fields];
        
    } else {        
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            switch (state) {
                case FBSessionStateOpen:
                    [self queryUserWithUserFields:fields];
                    break;
                case FBSessionStateClosed:
                case FBSessionStateClosedLoginFailed:
                    [FBSession.activeSession closeAndClearTokenInformation];
                    break;
                default:
                    break;
            }
            if (_completionHandler) {
                _completionHandler(FALSE,error,nil);
            }
        }];
        
    }

}

#pragma mark - showUI

- (void)showPostPhotoView:(NSString*)message image:(UIImage*)image
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    NMSKFBPostPhotoView *shareView = [[NMSKFBPostPhotoView alloc] initWithFrame:window.frame message:message image:image];
    shareView.delegate = self;
    UIViewController *viewController = [[NMSKDevDefine sharedManager] getRootViewController];
    [viewController.view addSubview:shareView];
}

- (void)showPostStatusUpdateView:(NSString*)content
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    NMSKFBPostStatusUpdateView *shareView = [[NMSKFBPostStatusUpdateView alloc] initWithFrame:window.frame shareContent:content];
    shareView.delegate = self;
    UIViewController *viewController = [[NMSKDevDefine sharedManager] getRootViewController];
    [viewController.view addSubview:shareView];
}

- (void)showPublishStoryView:(NSString*)message link:(NSString*)link picture:(NSString*)picture
                        name:(NSString*)name caption:(NSString*)caption description:(NSString*)description
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    NMSKFBPublishStoryView *shareView = [[NMSKFBPublishStoryView alloc]
                                         initWithFrame:window.frame link:link picture:picture
                                         name:name caption:caption description:description];
    shareView.delegate = self;
    UIViewController *viewController = [[NMSKDevDefine sharedManager] getRootViewController];
    [viewController.view addSubview:shareView];
}

#pragma mark - NMSKFBPostStatusUpdateViewDelegate
- (void)postStatusUpdateView:(NMSKFBPostStatusUpdateView*)postStatusUpdateView didPost:(BOOL)successfully withText:(NSString*)shareContent
{
    if(successfully)
    {
        [self postStatusUpdate:shareContent];
    } else {
        if(_completionHandler)
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
            NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
            _completionHandler(FALSE,error,nil);
        }
    }
}

#pragma mark - NMSKFBPostPhotoViewDelegate
- (void)postPhotoView:(NMSKFBPostPhotoView*)postStatusUpdateView didPost:(NSString*)message image:(UIImage*)image
{
    [self postPhoto:image message:message];
}

#pragma mark - NMSKFBPublishStoryViewDelegate
- (void)publishStoryView:(NMSKFBPublishStoryView*)publishStoryView didPost:(NSString*)message
{
    [self publishStory:message link:_shareLink picture:_sharePicture name:_shareName caption:_shareCaption description:_shareDescription];
}




#pragma mark - Query with FQL
- (void)queryUserWithUserFields:(NSArray*)fields
{
    NSString *willquery = @"";
    if(fields != nil)
    {
        int i = 0;
        for (NSString *field in fields) {
            if(i == 0)
            {
                willquery = [willquery stringByAppendingFormat:@"%@",field];
            } else {
                willquery = [willquery stringByAppendingFormat:@",%@",field];
            }
            i++;
        }
    } else {
        willquery = @"uid, name, pic_square, pic_big,email,birthday_date,sex,current_location";
    }
    NSString *fqlQuery = [NSString stringWithFormat:@"SELECT %@ FROM user WHERE uid = me()",willquery];
    
    DBG(@"%@",fqlQuery);
    
    [self queryFql:fqlQuery];
}

- (void) queryFql:(NSString *)fql
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:fql forKey:@"q"];
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:params
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  _completionHandler(FALSE,error,nil);
                              } else {
                                  NSDictionary *data = nil;
                                  if(result != nil && [result valueForKey:@"data"] != nil)
                                  {
                                      NSArray *resultArray = [result objectForKey:@"data"];
                                      if(resultArray != nil && [resultArray count] > 0)
                                      {
                                          data = [resultArray objectAtIndex:0];
                                      }
                                  }
                                  
                                  if (data != nil) {
                                      _completionHandler(TRUE,nil,data);
                                  } else {
                                      NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_GET_PROFILE_MSG forKey:@"message"];
                                      NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_GET_PROFILE_CODE userInfo:userInfo];
                                      _completionHandler(FALSE,error,nil);
                                  }
                                  
                                  
                              }
                          }];
    
}

@end