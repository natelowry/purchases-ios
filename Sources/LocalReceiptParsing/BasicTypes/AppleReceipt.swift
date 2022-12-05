//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  AppleReceipt.swift
//
//  Created by Andrés Boedo on 7/22/20.
//

import Foundation

// TODO: document

/// The contents of a parsed IAP receipt.
public struct AppleReceipt: Equatable {

    public let bundleId: String
    public let applicationVersion: String
    public let originalApplicationVersion: String?
    public let opaqueValue: Data
    public let sha1Hash: Data
    public let creationDate: Date
    public let expirationDate: Date?
    public let inAppPurchases: [InAppPurchase]

}

// MARK: - Extensions

extension AppleReceipt {

    func purchasedIntroOfferOrFreeTrialProductIdentifiers() -> Set<String> {
        let productIdentifiers = self.inAppPurchases
            .filter { $0.isInIntroOfferPeriod == true || $0.isInTrialPeriod == true }
            .map { $0.productId }
        return Set(productIdentifiers)
    }

    func containsActivePurchase(forProductIdentifier identifier: String) -> Bool {
        return (
            self.inAppPurchases.contains { $0.isActiveSubscription } ||
            self.inAppPurchases.contains { !$0.isSubscription && $0.productId == identifier }
        )
    }

}

// MARK: - Conformances

extension AppleReceipt: Codable {}

extension AppleReceipt: CustomDebugStringConvertible {

    /// swiftlint:disable:next missing_docs
    public var debugDescription: String {
        return (try? self.prettyPrintedJSON) ?? "<null>"
    }

}
