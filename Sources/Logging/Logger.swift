//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  Logger.swift
//
//  Created by Andrés Boedo on 11/13/20.
//

import Foundation

/// Enumeration of the different verbosity levels.
///
/// #### Related Symbols
/// - ``Purchases/logLevel``
@objc(RCLogLevel) public enum LogLevel: Int, CustomStringConvertible, CaseIterable, Sendable {

    // swiftlint:disable missing_docs

    case verbose = 4
    case debug = 0
    case info = 1
    case warn = 2
    case error = 3

    public var description: String {
        switch self {
        case .verbose: return "VERBOSE"
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warn: return "WARN"
        case .error: return "ERROR"
        }
    }

    // swiftlint:enable missing_docs
}

/// A function that can handle a log message including file and method information.
public typealias VerboseLogHandler = (_ level: LogLevel,
                                      _ message: String,
                                      _ file: String?,
                                      _ function: String?,
                                      _ line: UInt) -> Void

/// A function that can handle a log message.
public typealias LogHandler = (_ level: LogLevel,
                               _ message: String) -> Void

enum Logger {

    static var logLevel: LogLevel = Self.defaultLogLevel
    static var logHandler: VerboseLogHandler = Self.defaultLogHandler

    static let defaultLogHandler: VerboseLogHandler = { level, message, file, functionName, line in
        let fileContext: String
        if Logger.verbose, let file = file, let functionName = functionName {
            let fileName = (file as NSString)
                .lastPathComponent
                .replacingOccurrences(of: ".swift", with: "")
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            fileContext = "\t\(fileName).\(functionName):\(line)"
        } else {
            fileContext = ""
        }

        NSLog("%@", "[\(frameworkDescription)] - \(level.description)\(fileContext): \(message)")
    }

    static var verbose: Bool = false

    private static let defaultLogLevel: LogLevel = {
        #if DEBUG
        return .debug
        #else
        return .info
        #endif
    }()

    internal static let frameworkDescription = "Purchases"

    static func verbose(_ message: @autoclosure () -> CustomStringConvertible,
                        fileName: String? = #fileID,
                        functionName: String? = #function,
                        line: UInt = #line) {
        log(level: .verbose, intent: .verbose, message: message().description,
            fileName: fileName, functionName: functionName, line: line)
    }

    static func debug(_ message: @autoclosure () -> CustomStringConvertible,
                      fileName: String? = #fileID,
                      functionName: String? = #function,
                      line: UInt = #line) {
        log(level: .debug, intent: .info, message: message().description,
            fileName: fileName, functionName: functionName, line: line)
    }

    static func info(_ message: @autoclosure () -> CustomStringConvertible,
                     fileName: String? = #fileID,
                     functionName: String? = #function,
                     line: UInt = #line) {
        log(level: .info, intent: .info, message: message().description,
            fileName: fileName, functionName: functionName, line: line)
    }

    static func warn(_ message: @autoclosure () -> CustomStringConvertible,
                     fileName: String? = #fileID,
                     functionName: String? = #function,
                     line: UInt = #line) {
        log(level: .warn, intent: .warning, message: message().description,
            fileName: fileName, functionName: functionName, line: line)
    }

    static func error(_ message: @autoclosure () -> CustomStringConvertible,
                      fileName: String = #fileID,
                      functionName: String = #function,
                      line: UInt = #line) {
        log(level: .error, intent: .rcError, message: message().description,
            fileName: fileName, functionName: functionName, line: line)
    }

}

extension Logger {

    static func appleError(_ message: @autoclosure () -> CustomStringConvertible,
                           fileName: String = #fileID,
                           functionName: String = #function,
                           line: UInt = #line) {
        self.log(level: .error, intent: .appleError, message: message().description,
                 fileName: fileName, functionName: functionName, line: line)
    }

    static func appleWarning(_ message: @autoclosure () -> CustomStringConvertible,
                             fileName: String = #fileID,
                             functionName: String = #function,
                             line: UInt = #line) {
        self.log(level: .warn, intent: .appleError, message: message().description,
                 fileName: fileName, functionName: functionName, line: line)
    }

    static func purchase(_ message: @autoclosure () -> CustomStringConvertible,
                         fileName: String = #fileID,
                         functionName: String = #function,
                         line: UInt = #line) {
        self.log(level: .info, intent: .purchase, message: message().description,
                 fileName: fileName, functionName: functionName, line: line)
    }

    static func rcPurchaseSuccess(_ message: @autoclosure () -> CustomStringConvertible,
                                  fileName: String = #fileID,
                                  functionName: String = #function,
                                  line: UInt = #line) {
        self.log(level: .info, intent: .rcPurchaseSuccess, message: message().description,
                 fileName: fileName, functionName: functionName, line: line)
    }

    static func rcPurchaseError(_ message: @autoclosure () -> CustomStringConvertible,
                                fileName: String = #fileID,
                                functionName: String = #function,
                                line: UInt = #line) {
        self.log(level: .error, intent: .purchase, message: message().description,
                 fileName: fileName, functionName: functionName, line: line)
    }

    static func rcSuccess(_ message: @autoclosure () -> CustomStringConvertible,
                          fileName: String = #fileID,
                          functionName: String = #function,
                          line: UInt = #line) {
        self.log(level: .debug, intent: .rcSuccess, message: message().description,
                 fileName: fileName, functionName: functionName, line: line)
    }

    static func user(_ message: @autoclosure () -> CustomStringConvertible,
                     fileName: String? = #fileID,
                     functionName: String? = #function,
                     line: UInt = #line) {
        self.log(level: .debug, intent: .user, message: message().description,
                 fileName: fileName, functionName: functionName, line: line)
    }

    static func log(level: LogLevel,
                    intent: LogIntent,
                    message: @autoclosure () -> String,
                    fileName: String? = #fileID,
                    functionName: String? = #function,
                    line: UInt = #line) {
        Self.log(level: level,
                 message: [intent.prefix.notEmpty, message()]
                    .compactMap { $0 }
                    .joined(separator: " "),
                 fileName: fileName,
                 functionName: functionName,
                 line: line)
    }

}

private extension Logger {

    static func log(level: LogLevel,
                    message: @autoclosure () -> String,
                    fileName: String? = #fileID,
                    functionName: String? = #function,
                    line: UInt = #line) {
        guard self.logLevel <= level else { return }

        Self.logHandler(level, message(), fileName, functionName, line)
    }

}

// MARK: -

extension LogLevel: Comparable {

    // swiftlint:disable:next missing_docs
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        // Tests ensure that this can't happen
        guard let lhs = Self.order[lhs], let rhs = Self.order[rhs] else { return false }

        return lhs < rhs
    }

    private static let orderedLevels: [LogLevel] = [
        .verbose,
        .debug,
        .info,
        .warn,
        .error
    ]
    static let order: [LogLevel: Int] = Dictionary(uniqueKeysWithValues:
                                                    Self.orderedLevels
        .enumerated()
        .lazy
        .map { ($1, $0) }
    )

}
