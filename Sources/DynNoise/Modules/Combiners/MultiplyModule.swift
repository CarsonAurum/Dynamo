//
//  MultiplyModule.swift
//
//
//  Carson Rau - 6/14/23
//

public struct MultiplyModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[x, y, z] * baseModule.1[x, y, z]
    }
}

extension Module {
    public func multiply<T: Module>(_ lhs: T) -> some Module {
        MultiplyModule(first: self, second: lhs)
    }
}

extension Module {
    public func multiply<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.multiply(fn())
    }
}

extension Module {
    public func multiply(_ lhs: Double) -> some Module {
        self.multiply(ConstantModule(value: lhs))
    }
    public func multiply(_ lhs: Int) -> some Module {
        self.multiply(.init(lhs))
    }
}
