//
//  NMSKHelper.h
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import <Foundation/Foundation.h>

@interface NMSKHelper : NSObject

@property (nonatomic, strong) NSDictionary *appInfo;

+ (NMSKHelper *)sharedManager;
+ (BOOL)iOS_6_0;
+ (BOOL)checkSystemDependence;
+ (BOOL)checkFacebookDependence;
+ (BOOL)checkGooglePlusDependence;
+ (NSString*) trim:(NSString*)str;
+ (UIImage *)imageNamed:(NSString *)name;
void debug(NSString *format, ...);

@end
