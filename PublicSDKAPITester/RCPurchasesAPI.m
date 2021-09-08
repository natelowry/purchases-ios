//
//  RevenueCatAPI.m
//  MigrateTester
//
//  Created by Joshua Liebowitz on 6/18/21.
//

@import Purchases;
@import StoreKit;

#import "RCPurchasesAPI.h"

@implementation RCPurchasesAPI

bool canI;
NSString *version;

BOOL automaticAppleSearchAdsAttributionCollection;
BOOL debugLogsEnabled;
RCLogLevel logLevel;
NSURL *proxyURL;
BOOL forceUniversalAppStore;
BOOL simulatesAskToBuyInSandbox;
RCPurchases *sharedPurchases;
BOOL isConfigured;
BOOL allowSharingAppStoreAccount;
BOOL finishTransactions;
id<RCPurchasesDelegate> delegate;
NSString *appUserID;
BOOL isAnonymous;

+ (void)checkAPI {
    // TODO: iOS ONLY, TEST FOR THIS API BY LOOKING UP SELECTOR
    // [p presentCodeRedemptionSheet];
    RCPurchases *p = [RCPurchases configureWithAPIKey:@""];
    [RCPurchases configureWithAPIKey:@"" appUserID:@""];
    [RCPurchases configureWithAPIKey:@"" appUserID:@"" observerMode:false];
    [RCPurchases configureWithAPIKey:@"" appUserID:@"" observerMode:false userDefaults:nil];
    
    [RCPurchases setLogHandler:^(RCLogLevel l, NSString *i) {}];
    canI = [RCPurchases canMakePayments];
    version = [RCPurchases frameworkVersion];
    [RCPurchases addAttributionData:@{} fromNetwork:RCAttributionNetworkBranch];
    [RCPurchases addAttributionData:@{} fromNetwork:RCAttributionNetworkBranch forNetworkUserId:@""];
        
    automaticAppleSearchAdsAttributionCollection = [RCPurchases automaticAppleSearchAdsAttributionCollection];
    debugLogsEnabled = [RCPurchases debugLogsEnabled];
    logLevel = [RCPurchases logLevel];
    proxyURL = [RCPurchases proxyURL];
    forceUniversalAppStore = [RCPurchases forceUniversalAppStore];
    simulatesAskToBuyInSandbox = [RCPurchases simulatesAskToBuyInSandbox];
    sharedPurchases = [RCPurchases sharedPurchases];
    isConfigured = [RCPurchases isConfigured];
    allowSharingAppStoreAccount = [p allowSharingAppStoreAccount];
    finishTransactions = [p finishTransactions];
    delegate = [p delegate];
    appUserID = [p appUserID];
    isAnonymous = [p isAnonymous];
    
    RCPurchaserInfo *pi = nil;
    SKProduct *skp = [[SKProduct alloc] init];
    SKProductDiscount *skpd = [[SKProductDiscount alloc] init];
    SKPaymentDiscount *skmd = [[SKPaymentDiscount alloc] init];
    
    RCPackage *pack;

    [p invalidatePurchaserInfoCache];

    NSDictionary<NSString *, NSString *> *attributes = nil;
    [p setAttributes: attributes];
    [p setEmail: @""];
    [p setPhoneNumber: @""];
    [p setDisplayName: @""];
    [p setPushToken: [@"" dataUsingEncoding: NSUTF8StringEncoding]];
    [p setAdjustID: @""];
    [p setAppsflyerID: @""];
    [p setFBAnonymousID: @""];
    [p setMparticleID: @""];
    [p setOnesignalID: @""];
    [p setMediaSource: @""];
    [p setCampaign: @""];
    [p setAdGroup: @""];
    [p setAd: @""];
    [p setKeyword: @""];
    [p setCreative: @""];
    [p collectDeviceIdentifiers];
    
    [p purchaserInfoWithCompletionBlock:^(RCPurchaserInfo *info, NSError *error) {}];
    [p offeringsWithCompletionBlock:^(RCOfferings *info, NSError *error) {}];
    [p productsWithIdentifiers:@[@""] completionBlock:^(NSArray<SKProduct *> *products) { }];
    [p purchaseProduct:skp withCompletionBlock:^(SKPaymentTransaction *t, RCPurchaserInfo *i, NSError *error, BOOL userCancelled) { }];
    [p purchasePackage:pack withCompletionBlock:^(SKPaymentTransaction *t, RCPurchaserInfo *i, NSError *e, BOOL userCancelled) { }];
    [p restoreTransactionsWithCompletionBlock:^(RCPurchaserInfo *i, NSError *e) {}];
    [p syncPurchasesWithCompletionBlock:^(RCPurchaserInfo *i, NSError *e) {}];
    [p checkTrialOrIntroductoryPriceEligibility:@[@""] completionBlock:^(NSDictionary<NSString *,RCIntroEligibility *> *d) { }];
    [p paymentDiscountForProductDiscount:skpd product:skp completion:^(SKPaymentDiscount *d, NSError *e) { }];
    [p purchaseProduct:skp withDiscount:skmd completionBlock:^(SKPaymentTransaction *t, RCPurchaserInfo *i, NSError *e, BOOL userCancelled) { }];
    [p purchasePackage:pack withDiscount:skmd completionBlock:^(SKPaymentTransaction *t, RCPurchaserInfo *i, NSError *e, BOOL userCancelled) { }];
    
    [p createAlias:@"" completionBlock:^(RCPurchaserInfo *i, NSError *e) { }];
    [p identify:@"" completionBlock:^(RCPurchaserInfo *i, NSError *e) { }];
    [p resetWithCompletionBlock:^(RCPurchaserInfo *i, NSError *e) { }];

    [p logIn:@"" completionBlock:^(RCPurchaserInfo *i, BOOL created, NSError *e) { }];
    [p logOutWithCompletionBlock:^(RCPurchaserInfo *i, NSError *e) { }];

    [p.delegate purchases:p didReceiveUpdatedPurchaserInfo:pi];
    [p.delegate purchases:p
shouldPurchasePromoProduct:skp
           defermentBlock:^(void (^ _Nonnull completion)(SKPaymentTransaction * _Nullable transaction,
                                                         RCPurchaserInfo * _Nullable info,
                                                         NSError * _Nullable error,
                                                         BOOL cancelled)) {}];
}

+ (void)checkEnums {
    RCPeriodType t = RCNormal;
    switch(t) {
        case RCNormal:
        case RCIntro:
        case RCTrial:
            NSLog(@"%ld", (long)t);
    }

    RCPurchaseOwnershipType o = RCPurchaseOwnershipTypePurchased;
    switch(o) {
        case RCPurchaseOwnershipTypePurchased:
        case RCPurchaseOwnershipTypeFamilyShared:
        case RCPurchaseOwnershipTypeUnknown:
            NSLog(@"%ld", (long)o);
    }

    RCLogLevel l = RCLogLevelInfo;
    switch(l) {
        case RCLogLevelInfo:
        case RCLogLevelWarn:
        case RCLogLevelDebug:
        case RCLogLevelError:
            NSLog(@"%ld", (long)o);
    }
}

+ (void)checkConstants {
    NSErrorDomain bed = RCBackendErrorDomain;
    NSErrorDomain ped = RCPurchasesErrorDomain;
    NSErrorUserInfoKey fk = RCFinishableKey;
    NSErrorUserInfoKey eck = RCReadableErrorCodeKey;

    NSLog(bed, ped, fk, eck);
}

@end
