//
//  NMSKDevDefine.h
//  NMKits
//
//  Created by Linh NGUYEN on 1/15/13.
//

#import <Foundation/Foundation.h>

@interface NMSKDevDefine : NSObject

@property (nonatomic, weak) UIViewController *rootViewController;

+ (id)sharedManager;
- (UIViewController *)getRootViewController;

@end
