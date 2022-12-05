//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  ReceiptParser.swift
//
//  Created by Andrés Boedo on 7/22/20.
//

import Foundation

// TODO: add to APITesters

// TODO: document

// TODO: different name for module and type

// TODO: short URL for this?
/// A type that can parse Apple receipts from a device.
/// This implements parsing based on Apple's documentation: https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html
public class ReceiptParser: NSObject {

    private let logger: LoggerType
    private let containerBuilder: ASN1ContainerBuilder
    private let receiptBuilder: AppleReceiptBuilder

    // TODO: extract to a separate file for ReceiptParser only and add to APITester

//    convenience override init() {
//        self.init(logger: ReceiptParserLogger())
//    }

    internal init(logger: LoggerType,
                  containerBuilder: ASN1ContainerBuilder = ASN1ContainerBuilder(),
                  receiptBuilder: AppleReceiptBuilder = AppleReceiptBuilder()) {
        self.logger = logger
        self.containerBuilder = containerBuilder
        self.receiptBuilder = receiptBuilder
    }

    /// Returns the result of parsing the receipt from `receiptData`, or throws `ReceiptParser.Error`.
    public func parse(from receiptData: Data) throws -> AppleReceipt {
        self.logger.info(ReceiptStrings.parsing_receipt)

        let intData = [UInt8](receiptData)

        let asn1Container = try self.containerBuilder.build(fromPayload: ArraySlice(intData))
        guard let receiptASN1Container = try self.findASN1Container(withObjectId: ASN1ObjectIdentifier.data,
                                                                    inContainer: asn1Container) else {
            self.logger.error(ReceiptStrings.data_object_identifer_not_found_receipt)
            throw Error.dataObjectIdentifierMissing
        }

        let receipt = try self.receiptBuilder.build(fromContainer: receiptASN1Container)
        self.logger.info(ReceiptStrings.parsing_receipt_success)
        return receipt
    }

}

// @unchecked because:
// - Class is not `final` (it's mocked). This implicitly makes subclasses `Sendable` even if they're not thread-safe.
extension ReceiptParser: @unchecked Sendable {}

// MARK: - Internal

extension ReceiptParser {

    @objc
    func receiptHasTransactions(receiptData: Data) -> Bool {
        if let receipt = try? self.parse(from: receiptData) {
            return !receipt.inAppPurchases.isEmpty
        }

        self.logger.warn(ReceiptStrings.parsing_receipt_failed(fileName: #fileID, functionName: #function))
        return true
    }

}

// MARK: - Private

private extension ReceiptParser {

    func findASN1Container(withObjectId objectId: ASN1ObjectIdentifier,
                           inContainer container: ASN1Container) throws -> ASN1Container? {
        if container.encodingType == .constructed {
            for (index, internalContainer) in container.internalContainers.enumerated() {
                if internalContainer.containerIdentifier == .objectIdentifier {
                    let objectIdentifier = try ASN1ObjectIdentifierBuilder.build(
                        fromPayload: internalContainer.internalPayload)
                    if objectIdentifier == objectId && index < container.internalContainers.count - 1 {
                        // the container that holds the data comes right after the one with the object identifier
                        return container.internalContainers[index + 1]
                    }
                } else {
                    let receipt = try self.findASN1Container(withObjectId: objectId, inContainer: internalContainer)
                    if receipt != nil {
                        return receipt
                    }
                }
            }
        }
        return nil
    }

}
