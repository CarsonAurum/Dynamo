//
//  ClampedModule.swift
//
//
//  Carson Rau - 6/14/23
//

public struct ClampedModule<T: Module, U: Module, V: Module>: Combine3Module {
    public let baseModule: (T, U, V)
    public init(first: T, second: U, third: V) {
        self.baseModule = (first, second, third)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[x, y, z].clamped(to: baseModule.1[x, y, z]...baseModule.2[x, y, z])
    }
}

extension Module {
    public func clamp<T: Module, U: Module>(lower: T, upper: U) -> some Module {
        ClampedModule(first: self, second: lower, third: upper)
    }
    public func clamp<Value: Module, T: Module>(value: Value, lower: T) -> some Module {
        ClampedModule(first: value, second: lower, third: self)
    }
    public func clamp<Value: Module, T: Module>(value: Value, upper: T) -> some Module {
        ClampedModule(first: value, second: self, third: upper)
    }
}

extension Module {
    public func clamp<T: Module, U: Module>(
        lower: @escaping ModuleBuilder<T>,
        upper: @escaping ModuleBuilder<U>
    ) -> some Module {
        self.clamp(lower: lower(), upper: upper())
    }
    public func clamp<Value: Module, T: Module>(
        value: @escaping ModuleBuilder<Value>,
        lower: @escaping ModuleBuilder<T>
    ) -> some Module {
        self.clamp(value: value(), lower: lower())
    }
    public func clamp<Value: Module, T: Module>(
        value: @escaping ModuleBuilder<Value>,
        upper: @escaping ModuleBuilder<T>
    ) -> some Module {
        self.clamp(value: value(), upper: upper())
    }
}

extension Module {
    public func clamp(lower: Double, upper: Double) -> some Module {
        self.clamp(lower: ConstantModule(value: lower), upper: ConstantModule(value: upper))
    }
    public func clamp(lower: Int, upper: Int) -> some Module {
        self.clamp(lower: .init(lower), upper: .init(upper))
    }
    public func clamp(_ range: ClosedRange<Double>) -> some Module {
        self.clamp(lower: range.lowerBound, upper: range.upperBound)
    }
    public func clamp(_ range: ClosedRange<Int>) -> some Module {
        self.clamp(lower: range.lowerBound, upper: range.upperBound)
    }
}
