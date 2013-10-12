//
//  NMShareKit.m
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import "NMShareKit.h"
#import "NMSKDevDefine.h"
#import "NMSKHelper.h"
#import "NMSKFacebookHelper.h"
#import "NMSKDefine.h"
#import "NMSKGooglePlusHelper.h"

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"


@interface NMShareKit () <MFMailComposeViewControllerDelegate>
{
    NMShareKitCompletionHandler _completionHandler;

}
@end

@implementation NMShareKit

+ (id)sharedManager {
    static NMShareKit *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        if ([NMSKHelper checkSystemDependence] == NO) {
            return nil;
        }
    }
    return self;
    
}

#pragma mark - Twitter
- (void)twShareWithText:(NSString*)text image:(UIImage*)image url:(NSString*)url completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    UIViewController *_rootViewController = [[NMSKDevDefine sharedManager] getRootViewController];
    if ([NMSKHelper iOS_6_0]) {
        // using Social framework in iOS SDK 6.0
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if(text != nil) {
            [vc setInitialText:text];
        }
        
        if(url != nil)
        {
            [vc addURL:[NSURL URLWithString:url]];
        }
    
        if(image != nil)
        {
            [vc addImage:image];
        }
        
        __block SLComposeViewController *_vc = vc;
        
        [vc setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    if(_completionHandler != nil)
                    {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
                        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
                        _completionHandler(FALSE,error,nil);
                    }
                    break;
                case SLComposeViewControllerResultDone:
                    if(_completionHandler != nil)
                    {
                        _completionHandler(TRUE,nil,nil);
                    }
                    break;
                    
                default:
                    break;
            }
            
            [_vc dismissModalViewControllerAnimated:YES];
        }];
        
        [_rootViewController presentViewController:vc animated:YES completion:nil];
        
        
    } else {
        // using Twitter framework in iOS SDK 5.0+
        TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
        [vc setInitialText:text];
        if(image != nil)
        {
            [vc addImage:image];
        }
        
        TWTweetComposeViewControllerCompletionHandler
        twcompletionHandler =
        ^(TWTweetComposeViewControllerResult result) {
            switch (result)
            {
                case SLComposeViewControllerResultCancelled:
                    if(_completionHandler != nil)
                    {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
                        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
                        _completionHandler(FALSE,error,nil);
                    }
                    break;
                case SLComposeViewControllerResultDone:
                    if(_completionHandler != nil)
                    {
                        _completionHandler(TRUE,nil,nil);
                    }
                    break;
                    
                default:
                    break;
            }
            [vc dismissModalViewControllerAnimated:YES];
        };
        
        [vc setCompletionHandler:twcompletionHandler];
    
        [_rootViewController presentModalViewController:vc animated:YES];
    }
}


- (void)twGetProfileWithCompletionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            if(accountsArray.count > 0)
            {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/account/verify_credentials.json"];
                TWRequest *req = [[TWRequest alloc] initWithURL:url
                                                     parameters:nil
                                                  requestMethod:TWRequestMethodGET];
                // Important: attach the user's Twitter ACAccount object to the request
                req.account = twitterAccount;
                
                [req performRequestWithHandler:^(NSData *responseData,
                                                 NSHTTPURLResponse *urlResponse,
                                                 NSError *error) {
                    // If there was an error making the request, display a message to the user                  
                    
                    if (urlResponse.statusCode == 200)
                    {
                        
                        NSError *jsonError = nil;
                        id resp = [NSJSONSerialization JSONObjectWithData:responseData
                                                                  options:0
                                                                    error:&jsonError];
                        
                        // If there was an error decoding the JSON, display a message to the user
                        if(jsonError != nil) {
                           
                            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_TW_CONFIG_MSG forKey:@"message"];
                            NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_TW_CONFIG_CODE userInfo:userInfo];
                            _completionHandler(FALSE,error,nil);
                            return;
                        }
                        
                        NSDictionary *dataDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:resp, nil] forKeys:[NSArray arrayWithObjects:@"json_data", nil]];
                        _completionHandler(TRUE,nil,dataDict);
                        
                    } else {

                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_TW_CONFIG_MSG forKey:@"message"];
                        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_TW_CONFIG_CODE userInfo:userInfo];
                        _completionHandler(FALSE,error,nil);
                        return;
                        
                    }
                    
                    
                }];
            }
            else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_TW_NO_ACCOUNT_MSG forKey:@"message"];
                NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_TW_NO_ACCOUNT_CODE userInfo:userInfo];
                _completionHandler(FALSE,error,nil);
                
            }
        } else {
           
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_TW_NO_ACCOUNT_MSG forKey:@"message"];
            NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_TW_NO_ACCOUNT_CODE userInfo:userInfo];
            _completionHandler(FALSE,error,nil);
            
        }
    }];
}



#pragma mark - Facebook
- (void)fbPostStatus:(NSString*)status completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    UIViewController *_rootViewController = [[NMSKDevDefine sharedManager] getRootViewController];
    if ([NMSKHelper iOS_6_0]) {
        // using Social framework in iOS SDK 6.0
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if(status != nil)
        {
            [vc setInitialText:status];
        }
        __block SLComposeViewController *_vc = vc;
        
        [vc setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    if(_completionHandler != nil)
                    {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
                        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
                        _completionHandler(FALSE,error,nil);
                    }
                    break;
                case SLComposeViewControllerResultDone:
                    if(_completionHandler != nil)
                    {
                        _completionHandler(TRUE,nil,nil);
                    }
                    break;
                    
                default:
                    break;
            }
            
            [_vc dismissModalViewControllerAnimated:YES];
        }];        
        [_rootViewController presentViewController:vc animated:YES completion:nil];
    } else {        
        [[NMSKFacebookHelper sharedManager] fbPostStatusUpdate:status completionHandler:^(BOOL successfully,NSError *error,NSDictionary *dataDict)
         {
             if(_completionHandler != nil)
             {
                 _completionHandler(successfully,error,dataDict);
             }
         }];
    }
}

- (void)fbShareURL:(NSString*)title url:(NSString*)url completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    UIViewController *_rootViewController = [[NMSKDevDefine sharedManager] getRootViewController];
    if ([NMSKHelper iOS_6_0]) {
        // using Social framework in iOS SDK 6.0
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if(title != nil)
        {
            [vc setInitialText:title];
        }
        if(url != nil)
        {
            [vc addURL:[NSURL URLWithString:url]];
        }
        __block SLComposeViewController *_vc = vc;
        
        [vc setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    if(_completionHandler != nil)
                    {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
                        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
                        _completionHandler(FALSE,error,nil);
                    }
                    break;
                case SLComposeViewControllerResultDone:
                    if(_completionHandler != nil)
                    {
                        _completionHandler(TRUE,nil,nil);
                    }
                    break;
                    
                default:
                    break;
            }
            
            [_vc dismissModalViewControllerAnimated:YES];
        }];
        [_rootViewController presentViewController:vc animated:YES completion:nil];
        
    } else {
       
        [[NMSKFacebookHelper sharedManager] fbPostStatusUpdate:[NSString stringWithFormat:@"%@ - %@",title,url] completionHandler:^(BOOL successfully,NSError *error, NSDictionary *dataDict)
         {
             if(_completionHandler != nil)
             {
                 _completionHandler(successfully,error,dataDict);
             }
         }];
    }
}

- (void)fbPostPhoto:(UIImage*)image message:(NSString*)message completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    UIViewController *_rootViewController = [[NMSKDevDefine sharedManager] getRootViewController];
    if ([NMSKHelper iOS_6_0]) {
        // using Social framework in iOS SDK 6.0
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if(message != nil)
        {
            [vc setInitialText:message];
        }
        if(image != nil)
        {
            [vc addImage:image];
        }
        __block SLComposeViewController *_vc = vc;
        
        [vc setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    if(_completionHandler != nil)
                    {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
                        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
                        _completionHandler(FALSE,error,nil);
                    }
                    break;
                case SLComposeViewControllerResultDone:
                    if(_completionHandler != nil)
                    {
                        _completionHandler(TRUE,nil,nil);
                    }
                    break;
                    
                default:
                    break;
            }
            
            [_vc dismissModalViewControllerAnimated:YES];
        }];
        
        [_rootViewController presentViewController:vc animated:YES completion:nil];
        
        
    } else {
       
        [[NMSKFacebookHelper sharedManager] fbPostPhoto:message image:image completionHandler:^(BOOL successfully,NSError *error, NSDictionary *dataDict)
         {
             if(_completionHandler != nil)
             {
                 _completionHandler(successfully,error,dataDict);
             }
         }];
    }
}

- (void)fbPublishStory:(NSString*)message link:(NSString*)link picture:(NSString*)picture
                  name:(NSString*)name caption:(NSString*)caption description:(NSString*)description completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    [[NMSKFacebookHelper sharedManager] fbPublishStory:message link:link picture:picture name:name caption:caption description:description completionHandler:^(BOOL successfully,NSError *error, NSDictionary *dataDict)
     {
         if(_completionHandler != nil)
         {
             _completionHandler(successfully,error,dataDict);
         }
     }];
}


- (void)fbGetProfileWithPermissions:(NSArray*)premissions userFields:(NSArray*)fields completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    [[NMSKFacebookHelper sharedManager] getProfileWithPermissions:premissions userFields:fields completionHandler:^(BOOL successfully,NSError *error, NSDictionary *dataDict)
    {
        if(_completionHandler != nil)
        {
            _completionHandler(successfully,error,dataDict);
        }
    }];
}


#pragma mark - Email

- (void)shareEmailWithSubject:(NSString*)subject body:(NSString*)body image:(UIImage*)image
                       isHTML:(BOOL)isHTML toRecipients:(NSArray*)toRecipients completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    vc.mailComposeDelegate = self;
    [vc setSubject:subject];
    [vc setMessageBody:body isHTML:isHTML];
    [vc setToRecipients:toRecipients];
    if(image != nil)
    {
        NSData *imageData = UIImagePNGRepresentation(image);
        [vc addAttachmentData:imageData mimeType:@"image/png" fileName:@"image.png"];

    }
    UIViewController *_rootViewController = [[NMSKDevDefine sharedManager] getRootViewController];
    if ([NMSKHelper iOS_6_0]) {
        [_rootViewController presentViewController:vc animated:YES completion:nil];
    } else {
        [_rootViewController presentModalViewController:vc animated:YES];
    }

}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent) {
        _completionHandler(TRUE,nil,nil);
    } else if(result == MFMailComposeResultCancelled)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_CANCELLED_MSG forKey:@"message"];
        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_CANCELLED_CODE userInfo:userInfo];
        _completionHandler(FALSE,error,nil);
        
    } else if(result == MFMailComposeResultFailed)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NMSK_ERROR_FAILED_MSG forKey:@"message"];
        NSError *error = [[NSError alloc] initWithDomain:NMSK_ERROR_DOMAIN code:NMSK_ERROR_FAILED_CODE userInfo:userInfo];
        _completionHandler(FALSE,error,nil);
    }
    
    if ([NMSKHelper iOS_6_0]) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    } else {
        [controller dismissModalViewControllerAnimated:YES];
    }
  
}

#pragma mark - Google Plus

- (void)gPlusPostStatus:(NSString*)status completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    [[NMSKGooglePlusHelper sharedManager] postStatus:status completionHandler:^(BOOL successfully,NSError *error, NSDictionary *dataDict)
    {
        if(_completionHandler != nil)
        {
            _completionHandler(successfully,error,dataDict);
        }
    }];;
}

- (void)gPlusShareURL:(NSString*)url message:(NSString*)message completionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    [[NMSKGooglePlusHelper sharedManager] shareURL:url message:message completionHandler:^(BOOL successfully,NSError *error, NSDictionary *dataDict)
    {
        if(_completionHandler != nil)
        {
            _completionHandler(successfully,error,dataDict);
        }
    }];;
    
}

- (void)gPlusGetProfileWithCompletionHandler:(NMShareKitCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    [[NMSKGooglePlusHelper sharedManager] getProfileWithCompletionHandler:^(BOOL successfully,NSError *error, NSDictionary *dataDict)
    {
        if(_completionHandler != nil)
        {
            _completionHandler(successfully,error,dataDict);
        }
    }];
}
@end
