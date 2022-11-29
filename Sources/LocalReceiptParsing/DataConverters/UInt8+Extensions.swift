//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  UInt8+Extensions.swift
//
//  Created by Andrés Boedo on 7/24/20.
//

import Foundation

// swiftlint:disable identifier_name
enum BitShiftError: Error {

    case invalidIndex(_ index: UInt8)
    case rangeFlipped(from: UInt8, to: UInt8)
    case rangeLargerThanByte
    case unhandledRange

}

extension BitShiftError: CustomStringConvertible {

    var description: String {
        switch self {
        case .invalidIndex(let index):
            return "invalid index: \(index)"
        case .rangeFlipped(let from, let to):
            return "from: \(from) can't be greater than to: \(to)"
        case .rangeLargerThanByte:
            return "range must be between 1 and 8"
        case .unhandledRange:
            return "unhandled range"
        }
    }

}

extension UInt8 {

    /// - Throws: `BitShiftError`
    func bitAtIndex(_ index: UInt8) throws -> UInt8 {
        guard index <= 7 else { throw BitShiftError.invalidIndex(index) }
        let shifted = self >> (7 - index)
        return shifted & 0b1
    }

    /// - Throws: `BitShiftError`
    func valueInRange(from: UInt8, to: UInt8) throws -> UInt8 {
        guard to <= 7 else { throw BitShiftError.invalidIndex(to) }
        guard from <= to else { throw BitShiftError.rangeFlipped(from: from, to: to) }

        let range: UInt8 = to - from + 1
        let shifted = self >> (7 - to)
        let mask = try self.maskForRange(range)
        return shifted & mask
    }

}

private extension UInt8 {

    /// - Throws: `BitShiftError`
    func maskForRange(_ range: UInt8) throws -> UInt8 {
        guard 0 <= range && range <= 8 else { throw BitShiftError.rangeLargerThanByte }
        switch range {
        case 1: return 0b1
        case 2: return 0b11
        case 3: return 0b111
        case 4: return 0b1111
        case 5: return 0b11111
        case 6: return 0b111111
        case 7: return 0b1111111
        case 8: return 0b11111111
        default:
            throw BitShiftError.unhandledRange
        }
    }

}
