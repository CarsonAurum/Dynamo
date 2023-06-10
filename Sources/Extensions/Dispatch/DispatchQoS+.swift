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
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.qosClass < rhs.qosClass
    }
}

#endif
