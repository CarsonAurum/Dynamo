//
//  Combiners.swift
//
//
//  Created by Carson Rau on 6/13/23.
//

// MARK: Add

public struct AddModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[x, y, z] + baseModule.1[x, y, z]
    }
}

// MARK: Blend

public struct BlendModule<Control: Module, T: Module, U: Module>: Combine3Module {
    public let baseModule: (Control, T, U)
    public init(first: Control, second: T, third: U) {
        self.baseModule = (first, second, third)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try linearInterp(
            baseModule.1[x, y, z],
            baseModule.2[x, y, z],
            (baseModule.0[x, y, z] - 1.0) / 2.0
        )
    }
}

// MARK: Clamped

public struct ClampedModule<T: Module, U: Module, V: Module>: Combine3Module {
    public let baseModule: (T, U, V)
    public init(first: T, second: U, third: V) {
        self.baseModule = (first, second, third)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[x, y, z].clamped(to: baseModule.1[x, y, z]...baseModule.2[x, y, z])
    }
}

// MARK: Max

public struct MaxModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        self.baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try Swift.max(
            baseModule.0[x, y, z],
            baseModule.1[x, y, z]
        )
    }
}

// MARK: Min

public struct MinModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        self.baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try Swift.min(
            baseModule.0[x, y, z],
            baseModule.1[x, y, z]
        )
    }
}

// MARK: Multiply

public struct MultiplyModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[x, y, z] * baseModule.1[x, y, z]
    }
}

// MARK: Subtract

public struct SubtractModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[x, y, z] - baseModule.1[x, y, z]
    }
}
