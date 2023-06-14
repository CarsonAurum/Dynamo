//
//  Utils.swift
//
//
//  Created by Carson Rau on 6/13/23.
//

// swiftlint:disable identifier_name

internal func linearInterp(_ n0: Double, _ n1: Double, _ a: Double) -> Double {
    (1.0 - a) * n0 + (a * n1)
}

// swiftlint:enable identifier_name
