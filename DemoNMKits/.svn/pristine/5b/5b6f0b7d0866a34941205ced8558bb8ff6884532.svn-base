//
//  NMInAppPurchaseKit.h
//  NMKits
//
//  Created by Nikmesoft on 9/10/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const InAppHelperProductPurchaseNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL successfully, NSError* errror, NSMutableArray* products);
typedef void (^RestoreProductsCompletionHandler)(BOOL successfully, NSError* errror, NSMutableArray* products);
typedef void (^PurchaseProductCompletionHandler)(BOOL successfully, NSError* errror, SKProduct* product);

@interface NMInAppPurchaseKit : NSObject

+ (NMInAppPurchaseKit *)sharedInstance;

- (void)requestProductsIdentifiers:(NSSet *)productIdentifiers completionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)requestProductsIdentifiersFromPath:(NSString *)productIdentifiersPath completionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)purchaseProduct:(SKProduct *)product compleHandler:(PurchaseProductCompletionHandler)completionHandler;

- (void)restoreCompletedTransactionsWithCompletionHandler:(RestoreProductsCompletionHandler)completionHandler;

- (BOOL)isProductPurchased:(NSString *)productIdentifier;
+ (BOOL)canMakePurchases;
- (SKProduct *)getSKProductbySKProductIdentifier:(NSString *)productIdentifier;

@end
