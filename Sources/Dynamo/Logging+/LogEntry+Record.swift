//
//  File.swift
//  
//
//  Created by Carson Rau on 6/26/23.
//

import Logging

public struct LogEntry {
    @usableFromInline
    internal var _store: _LogEntry
    public var parameters: LogParameters
    public init(
        label: String,
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata,
        source: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        parameters: LogParameters = .init()
    ) {
        self._store = .init(
            label: label,
            level: level,
            message: message,
            metadata: metadata,
            source: source,
            file: file,
            function: function,
            line: line
        )
        self.parameters = parameters
    }
}

extension LogEntry {
    @inlinable
    public var label: String { _store.label }
    @inlinable
    public var level: Logger.Level { _store.level }
    @inlinable
    public var message: Logger.Message { _store.message }
    @inlinable
    public var metadata: Logger.Metadata { _store.metadata }
    @inlinable
    public var source: String { _store.source }
    @inlinable
    public var file: String { _store.file }
    @inlinable
    public var function: String { _store.function }
    @inlinable
    public var line: UInt { _store.line }
}

extension LogEntry {
    @usableFromInline
    internal final class _LogEntry {
        @usableFromInline
        let label: String
        @usableFromInline
        let level: Logger.Level
        @usableFromInline
        let message: Logger.Message
        @usableFromInline
        let metadata: Logger.Metadata
        @usableFromInline
        let source: String
        @usableFromInline
        let file: String
        @usableFromInline
        let function: String
        @usableFromInline
        let line: UInt
        @usableFromInline
        init(
            label: String,
            level: Logger.Level,
            message: Logger.Message,
            metadata: Logger.Metadata,
            source: String,
            file: String = #file,
            function: String = #function,
            line: UInt = #line
        ) {
            self.label = label
            self.level = level
            self.message = message
            self.metadata = metadata
            self.source = source
            self.file = file
            self.function = function
            self.line = line
        }
    }
}

// MARK: LogRecord

public struct LogRecord<T> {
    public let entry: LogEntry
    public let output: T
    public init(_ entry: LogEntry, _ output: T) {
        self.entry = entry
        self.output = output
    }
}

// MARK: LogParameters

public struct LogParameters {
    private var dict: [AnyHashable: Any]
    public init() { dict = [:] }
    public subscript<T: LogParametersKey>(_ key: T.Type) -> T.Value? {
        get { -?>dict[key.key]  }
        set { dict[key.key] = newValue }
    }
    public subscript(_ key: AnyHashable) -> Any? {
        get { dict[key] }
        set { dict[key] = newValue }
    }
    public func snapshot() -> [AnyHashable: Any] { dict }
}

public protocol LogParametersKey {
    associatedtype Value
    static var key: AnyHashable { get }
}

extension LogParametersKey {
    static var key: AnyHashable { ObjectIdentifier(self) }
}
