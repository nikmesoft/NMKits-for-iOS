//
//  NMInAppPurchaseKit.m
//  NMKits
//
//  Created by Nikmesoft on 9/10/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "NMInAppPurchaseKit.h"
#import "NMIAPKDefine.h"

@interface NMInAppPurchaseKit() <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation NMInAppPurchaseKit {
    
    RequestProductsCompletionHandler _requestCompletionHandler;
    RestoreProductsCompletionHandler _restoreCompletionHandler;
    PurchaseProductCompletionHandler _purchaseCompletionHandler;
    
    SKProduct *_purchasingProduct;
    NSSet *_productIdentifierList;
    NSMutableArray *_productList;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        _productIdentifierList = [[NSSet alloc] init];
        _productList = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NMInAppPurchaseKit *)sharedInstance
{
    static NMInAppPurchaseKit *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark -
#pragma mark - Public methods

- (void)requestProductsIdentifiers:(NSSet *)productIdentifiers completionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _requestCompletionHandler = [completionHandler copy];
    
    if(_productIdentifierList != nil)
    {
        _productIdentifierList = nil;
    }
    _productIdentifierList = [productIdentifiers copy];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifierList];
    request.delegate = self;
    [request start];
}

- (void)requestProductsIdentifiersFromPath:(NSString *)productIdentifiersPath completionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _requestCompletionHandler = [completionHandler copy];
    
    if(_productIdentifierList != nil)
    {
        _productIdentifierList = nil;
    }
    _productIdentifierList = [NSSet set];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:productIdentifiersPath];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    for (int i = 0; i < [plistData count]; i++) {
        _productIdentifierList = [_productIdentifierList setByAddingObject:[plistData valueForKey:[NSString stringWithFormat:@"%@%.6f",NMIAPK_PRODUCT_PREFIX_KEY,i/1000000.0]]];
    }
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifierList];
    request.delegate = self;
    [request start];
}

- (void)purchaseProduct:(SKProduct *)product compleHandler:(PurchaseProductCompletionHandler)completionHandler
{
    if (product) {
        _purchaseCompletionHandler = completionHandler;
        _purchasingProduct = product;
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)restoreCompletedTransactionsWithCompletionHandler:(RestoreProductsCompletionHandler)completionHandler
{
     _restoreCompletionHandler = [completionHandler copy];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (BOOL)isProductPurchased:(NSString *)productIdentifier
{
    return [_productIdentifierList containsObject:productIdentifier];
}

+ (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (SKProduct *)getSKProductbySKProductIdentifier:(NSString *)productIdentifier
{
    if (_productList == nil || _productList.count == 0 || productIdentifier == nil) {
        return nil;
    } else {
        for (SKProduct *product in _productList) {
            if (product != nil && [[product productIdentifier] isEqualToString:productIdentifier]) {
                return product;
            }
        }
    }
    return nil;
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    DBGS;

    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    
    DBGS;
    if(_purchaseCompletionHandler != nil)
    {
        _purchaseCompletionHandler(FALSE,transaction.error,_purchasingProduct);
        _purchaseCompletionHandler = nil;
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    DBGS;
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    DBGS;
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:transaction.transactionIdentifier ];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)provideContent:(NSString *)productIdentifier
{
    DBGS;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(_purchaseCompletionHandler != nil)
    {
        _purchaseCompletionHandler(TRUE,nil,_purchasingProduct);
        _purchaseCompletionHandler = nil;
    }
}

#pragma mark -
#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    DBGS;
    if (_productList) {
        [_productList removeAllObjects];
    } else {
        _productList = [NSMutableArray array];
    }
    
    NSMutableArray *skProducts = [NSMutableArray arrayWithArray:response.products];
    [_productList addObjectsFromArray:response.products];
    for (SKProduct *skProduct in skProducts) {
        DBG(@"Found product : %@ - %@ - %0.2f",skProduct.productIdentifier,skProduct.localizedDescription,skProduct.price.floatValue);
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    DBGS;    
    if(_requestCompletionHandler != nil)
    {
        _requestCompletionHandler(FALSE,error,nil);
        _requestCompletionHandler = nil;
    }
}

- (void)requestDidFinish:(SKRequest *)request
{
    DBGS;
    if(_requestCompletionHandler != nil)
    {
        _requestCompletionHandler(TRUE,nil,_productList);
        _requestCompletionHandler = nil;
    }
}
#pragma mark -
#pragma mark - SKPaymentQueueRestoreHandler

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    DBGS;
    NSMutableArray* purchasedProducts  = [[NSMutableArray alloc] init];
    
    DBG(@"Received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        if([_productIdentifierList containsObject:productID])
        {
            DBG(@"Restored %@ - %i",productID,transaction.transactionState);
            [purchasedProducts addObject:transaction.payment];
        }
    }
    
    if(_restoreCompletionHandler != nil)
    {
        _restoreCompletionHandler(TRUE,nil,_productList);
        _restoreCompletionHandler = nil;
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    DBGS;
    if(_restoreCompletionHandler != nil)
    {
        _restoreCompletionHandler(FALSE,error,nil);
        _restoreCompletionHandler = nil;
    }
}

@end
