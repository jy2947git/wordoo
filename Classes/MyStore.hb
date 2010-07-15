//
//  MyStore.h
//  WizardView
//
//  Created by Junqiang You on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKProductsRequest.h>
enum ALERT_TAGS {
	PURCHASE_UNLOCK=99935
};

@interface MyStore : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver>{

}

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void)recordTransaction: (SKPaymentTransaction *)transaction;
- (void)provideContent:(NSString*)productIdentifier;
-(void)startPurchase:(NSString*)productIdentifier;
-(void)registerTransactionObserver;
@end
