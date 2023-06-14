//
//  DispatchQoS.QoSClass+.swift
//
//  Extensions to the Dispatch DispatchQoS.QoSClass type.
//
//  Carson Rau - 6/9/23
//

#if canImport(Dispatch)
import Dispatch

#if canImport(Foundation)
import Foundation
#endif

extension DispatchQoS.QoSClass {
    /// Determine the QosClass for the currently executing thread.
    public static var current: Self {
        Self(rawValue: qos_class_self()) ?? .unspecified
    }
    #if canImport(Foundation)
    /// A bridge initializer to support integration of Foundation's `QualityOfService` type with `QoSClass` types.
    /// - Parameter qos: The quality of the desired `QosClass`.
    public init(qos: QualityOfService) {
        switch qos {
        case .userInteractive:
            self = .userInteractive
        case .userInitiated:
            self = .userInitiated
        case .utility:
            self = .utility
        case .background:
            self = .background
        case .default:
            self = .default
        @unknown default:
            self = .default
        }
    }
    #endif
}

extension DispatchQoS.QoSClass: CaseIterable {
    /// Support for case iteration over this type.
    ///
    /// Ordered from highest to lowest priority.
    public static var allCases: [DispatchQoS.QoSClass] = [
        .userInteractive,
        .userInitiated,
        .default,
        .utility,
        .background,
        .unspecified
    ]
}

extension DispatchQoS.QoSClass: Comparable {
    /// Compare two qualities of service via their underlying raw values.
    /// - Parameters:
    ///   - lhs: The first class to compare.
    ///   - rhs: The second class to compare.
    /// - Returns: The result of comparison between the two given instances.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue.rawValue < rhs.rawValue.rawValue
    }
}
#endif
