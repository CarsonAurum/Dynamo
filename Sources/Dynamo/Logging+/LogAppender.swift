//
//  File.swift
//
//
//  Created by Carson Rau on 6/27/23.
//

#if canImport(Darwin)
import Darwin
#elseif os(Windows)
import MSVCRT
#elseif os(Linux)
import Glibc
#endif
#if canImport(Foundation)
import Foundation
#endif

public protocol LogAppender {
    associatedtype Output
    func append(_ record: LogRecord<Output>) throws
}

// MARK: - ConsoleAppender
#if canImport(Foundation)
public struct ConsoleLogAppender: LogAppender {
    public let stream: TextOutputStream
    public init(_ stream: TextOutputStream) { self.stream = stream }
    public func append(_ record: LogRecord<String>) throws {
        var stream = self.stream
        stream.write(record.output)
    }
    public static let stdout = Self(_OutputStream.out)
    public static let stderr = Self(_OutputStream.err)
}

extension ConsoleLogAppender {
    internal struct _OutputStream: TextOutputStream {
        internal static let out: Self = .init(file: _out)
        internal static let err: Self = .init(file: _err)
        private let file: UnsafeMutablePointer<FILE>
        internal func write(_ string: String) {
            #if canImport(Darwin) || os(Linux)
            flockfile(file)
            #elseif os(Windows)
            _lock_file(file)
            #endif
            defer {
                #if canImport(Darwin) || os(Linux)
                funlockfile(file)
                #elseif os(Windows)
                _unlock_file(file)
                #endif
            }
            string.withCString {
                _ = fputs($0, file)
                _ = fflush(file)
            }
        }
        private static var _out: UnsafeMutablePointer<FILE> {
            #if os(Windows)
            MSVCRT.stdout
            #elseif os(Linux)
            Glibc.stdout.forceUnwrap()
            #elseif canImport(Darwin)
            Darwin.stdout
            #endif
        }
        private static var _err: UnsafeMutablePointer<FILE> {
            #if os(Windows)
            MSVCRT.stderr
            #elseif os(Linux)
            Glibc.stderr.forceUnwrap()
            #elseif canImport(Darwin)
            Darwin.stderr
            #endif
        }
    }
}
#endif

// MARK:
