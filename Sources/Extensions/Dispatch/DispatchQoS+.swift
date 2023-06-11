//
//  DispatchQoS+.swift
//
//  Extensions to the Dispatch DispatchQoS type.
//
//  Created by Carson Rau on 6/10/23.
//

#if canImport(Dispatch)
import Dispatch

extension DispatchQoS: Comparable {
    /// Compare two qualities of service via their underlying raw values.
    /// - Parameters:
    ///   - lhs: The first QpS to compare.
    ///   - rhs: The second QoS to compare.
    /// - Returns: The result of comparison between the two given instances.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.qosClass < rhs.qosClass
    }
}

#endif
