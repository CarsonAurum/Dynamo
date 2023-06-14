//
//  Double++.swift
//
//
//  Carson Rau - 3/19/22
//

#if canImport(Darwin)
import Darwin
#endif
#if canImport(Foundation)
import Foundation
#endif

extension Double {
#if !os(Linux)
    /// Generates a random double value between 0 and 1.
    ///
    /// Example:
    /// ```swift
    /// let randomValue = Double.random
    /// print(randomValue)  // Output: A random number between 0 and 1
    /// ```
    public static var random: Double {
        Double.random(in: 0...1)
    }
#endif
}
// MARK: - Time Extensions
#if canImport(Foundation)
extension Double {
    /// Converts the receiver into milliseconds (1/1000 of a second).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.millisecond)  // Output: 0.002
    /// ```
    public var millisecond: TimeInterval { self / 1_000 }
    /// Converts the receiver into milliseconds (1/1000 of a second).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.milliseconds)  // Output: 0.002
    /// ```
    public var milliseconds: TimeInterval { millisecond }
    /// Converts the receiver into milliseconds (1/1000 of a second), aliased as 'ms'.
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.ms)  // Output: 0.002
    /// ```
    public var ms: TimeInterval { millisecond }
    /// Represents the receiver value as seconds.
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.second)  // Output: 2.0
    /// ```
    public var second: TimeInterval { self }
    /// Represents the receiver value as seconds.
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.seconds)  // Output: 2.0
    /// ```
    public var seconds: TimeInterval { second }
    /// Converts the receiver value into minutes (each minute is 60 seconds).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.minute)  // Output: 120.0
    /// ```
    public var minute: TimeInterval { self * 60 }
    /// Converts the receiver value into minutes (each minute is 60 seconds).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.minutes)  // Output: 120.0
    /// ```
    public var minutes: TimeInterval { minute }
    /// Converts the receiver value into hours (each hour is 3600 seconds).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.hour)  // Output: 7200.0
    /// ```
    public var hour: TimeInterval { self * 3_600 }
    /// Converts the receiver value into hours (each hour is 3600 seconds).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.hours)  // Output: 7200.0
    /// ```
    public var hours: TimeInterval { hour }
    /// Converts the receiver value into days (each day is 86,400 seconds).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.day)  // Output: 172800.0
    /// ```
    public var day: TimeInterval { self * 3_600 * 24 }
    /// Converts the receiver value into days (each day is 86,400 seconds).
    ///
    /// Example:
    /// ```swift
    /// let time = 2.0
    /// print(time.days)  // Output: 172800.0
    /// ```
    public var days: TimeInterval { day }
}
#endif
