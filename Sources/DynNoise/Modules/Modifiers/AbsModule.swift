//
//  AbsModule.swift
//
//  A module that computes the absolute value of its base value.
//
//  Carson Rau - 6/13/23
//

import Dynamo

public struct AbsModule<T: Module>: ModifierModule {
    public let baseModule: T
    public init(_ baseModule: T) {
        self.baseModule = baseModule
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try Swift.abs(baseModule[x, y, z])
    }
}

extension Module {
    public func abs() -> some Module {
        AbsModule(self)
    }
    public func absoluteValue() -> some Module {
        self.abs()
    }
}
