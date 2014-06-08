//
//  DDIAPHelper.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 5/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDIAPHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface DDIAPHelper () <SKProductsRequestDelegate>
@end

@implementation DDIAPHelper

SKProductsRequest * _productsRequest;
RequestProductsCompletionHandler _completionHandler;
NSSet * _productIdentifiers;
NSMutableSet * _purchasedProductIdentifiers;

- (id)initWithProductIdentifiers:(NSSet *)prodIdentifiers {
    
    if ((self = [super init]))
    {
        // Store product identifiers
        _productIdentifiers = prodIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productId in _productIdentifiers)
        {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productId];
            
            if (productPurchased)
            {
                [_purchasedProductIdentifiers addObject:productId];
//                NSLog(@"Previously purchased: %@", productId);
            }
            else
            {
//                NSLog(@"Not purchased: %@", productId);
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    if ([SKPaymentQueue canMakePayments])
    {
        _completionHandler = [completionHandler copy];
    
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }
    else
    {
        NSLog(@"Please enable In App Purchase in Settings");
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    
    if (skProducts.count == 0)
    {
        NSLog(@"Product not found: %@", skProducts);
    }
    
    for (SKProduct * skProduct in skProducts)
    {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    NSLog(@"Error - %@", error.description);
    
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
