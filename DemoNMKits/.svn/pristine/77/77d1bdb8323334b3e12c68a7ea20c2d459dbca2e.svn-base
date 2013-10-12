//
//  NMSKGooglePlusHelper.m
//  NMKits
//
//  Created by Linh NGUYEN on 9/4/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import "NMSKGooglePlusHelper.h"
#import "NMSKHelper.h"
#import "NMSKDefine.h"
#import "NMSKDevDefine.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "NMConversionHelper.h"

@interface NMSKGooglePlusHelper()<GPPSignInDelegate,GPPShareDelegate>
{
    @protected
    NMSKGooglePlusHelperCompletionHandler _completionHandler;
}
@end

@implementation NMSKGooglePlusHelper

+ (id)sharedManager {
    static NMSKGooglePlusHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    if (self) {
        // check google plus config
        if ([NMSKHelper checkGooglePlusDependence] == NO) {
            return nil;
        }
        
        NSDictionary *appInfo = [[NMSKHelper sharedManager] appInfo];
        NSString *gPlusClientID = [appInfo objectForKey:@"GooglePlusCLientID"];
        [GPPSignIn sharedInstance].clientID = gPlusClientID;
        
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
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [GPPURLHandler handleURL:url
           sourceApplication:sourceApplication
                  annotation:annotation];
}


#pragma mark - Functions

- (void)postStatus:(NSString*)status completionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    [GPPShare sharedInstance].delegate = self; 
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    [shareBuilder setPrefillText:status];
    
    if (![shareBuilder open]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_GPLUS_CLIENT_MSG forKey:@"message"];
        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_GPLUS_CLIENT_CODE userInfo:userInfo];
        _completionHandler(FALSE,error,nil);
    }
}

- (void)shareURL:(NSString*)url message:(NSString*)message completionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    [GPPShare sharedInstance].delegate = self;
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    NSURL *urlToShare = [url length] ? [NSURL URLWithString:url] : nil;
    if (urlToShare) {
        [shareBuilder setURLToShare:urlToShare];
    }

    [shareBuilder setPrefillText:message];
    
    if (![shareBuilder open]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_GPLUS_CLIENT_MSG forKey:@"message"];
        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_GPLUS_CLIENT_CODE userInfo:userInfo];
        _completionHandler(FALSE,error,nil);
    }
}


- (void)logoutGooglePlusWithCompletionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler
{
    [[GPPSignIn sharedInstance] signOut];
    completionHandler(TRUE,nil,nil);
}

- (void)getProfileWithCompletionHandler:(NMSKGooglePlusHelperCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    if ([GPPSignIn sharedInstance].authentication) {
        [self getProfile];
        
    } else {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        
        signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,
                         kGTLAuthScopePlusMe,
                         nil];
        
        signIn.delegate = self;
        signIn.shouldFetchGoogleUserID = TRUE;
        signIn.shouldFetchGoogleUserEmail =TRUE;
        signIn.actions = [NSArray arrayWithObjects:
                          @"http://schemas.google.com/AddActivity",
                          @"http://schemas.google.com/BuyActivity",
                          @"http://schemas.google.com/CheckInActivity",
                          @"http://schemas.google.com/CommentActivity",
                          @"http://schemas.google.com/CreateActivity",
                          @"http://schemas.google.com/ListenActivity",
                          @"http://schemas.google.com/ReserveActivity",
                          @"http://schemas.google.com/ReviewActivity",
                          nil];
        
        [signIn trySilentAuthentication];
        [signIn authenticate];
    }    
    
}

- (void)getProfile
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    NSString *openId = signIn.userID;
    NSString *email =  signIn.userEmail;
    
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = NO;
    [plusService setAuthorizer:signIn.authentication];
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    _completionHandler(FALSE,error,nil);
                    return;
                } else {
                   
                    if(ticket != nil && ticket.statusCode == 200)
                    {
                        if(openId != nil && email != nil)
                        {
                            NSDictionary *dataDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:openId,email,[NMConversionHelper dictionaryWithPropertiesOfObject:person] , nil] forKeys:[NSArray arrayWithObjects:@"openid",@"email",@"person", nil]];
                            _completionHandler(TRUE,nil,dataDict);
                            return;
                        }
                    }
                    
                }
            }];
}
#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    if (error!= nil) {
        _completionHandler(FALSE,error,nil);
        return;
    }
    if ([GPPSignIn sharedInstance].authentication) {
        [self getProfile];        
        
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
        _completionHandler(FALSE,error,nil);
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    _completionHandler(FALSE,error,nil);
}

#pragma mark - GPPShareDelegate
- (void)finishedSharing:(BOOL)shared
{
    if(!shared)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
        _completionHandler(FALSE,error,nil);
    } else {
        _completionHandler(TRUE,nil,nil);
    }
}
@end
