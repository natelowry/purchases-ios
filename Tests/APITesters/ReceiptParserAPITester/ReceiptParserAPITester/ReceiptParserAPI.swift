//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  PurchasesAPI.swift
//
//  Created by Nacho Soto on 12/05/22.

import Foundation
import ReceiptParser
import StoreKit

func checkReceiptParserAPI() {
    let parser1 = ReceiptParser()
    let parser2 = ReceiptParser.default

    do {
        let _: AppleReceipt = try parser2.parse(from: Data())
    } catch {}
}
