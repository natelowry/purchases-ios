//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  RCPurchasesErrorCodeAPI.m
//
//  Created by Madeline Beyl on 9/7/21.

#import "RCPurchasesErrorCodeAPI.h"
@import Purchases;

@implementation RCPurchasesErrorCodeAPI

+ (void)checkEnums {
    RCPurchasesErrorCode errCode = RCUnknownError;
    switch(errCode) {
        case RCUnknownError:
        case RCPurchaseCancelledError:
        case RCStoreProblemError:
        case RCPurchaseNotAllowedError:
        case RCPurchaseInvalidError:
        case RCProductNotAvailableForPurchaseError:
        case RCProductAlreadyPurchasedError:
        case RCReceiptAlreadyInUseError:
        case RCInvalidReceiptError:
        case RCMissingReceiptFileError:
        case RCNetworkError:
        case RCInvalidCredentialsError:
        case RCUnexpectedBackendResponseError:
        case RCReceiptInUseByOtherSubscriberError:
        case RCInvalidAppUserIdError:
        case RCOperationAlreadyInProgressError:
        case RCUnknownBackendError:
        case RCInvalidAppleSubscriptionKeyError:
        case RCIneligibleError:
        case RCInsufficientPermissionsError:
        case RCPaymentPendingError:
        case RCInvalidSubscriberAttributesError:
        case RCLogOutAnonymousUserError:
        case RCConfigurationError:
            NSLog(@"%ld", (long)errCode);
    }
}

@end
