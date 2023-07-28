//
//  SubtractModule.swift
//
//
//  Carson Rau - 6/13/23
//

public struct SubtractModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[x, y, z] - baseModule.1[x, y, z]
    }
}

extension Module {
    public func subtract<T: Module>(_ lhs: T) -> some Module {
        SubtractModule(first: self, second: lhs)
    }
}

extension Module {
    public func subtract<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.subtract(fn())
    }
}

extension Module {
    public func subtract(_ lhs: Double) -> some Module {
        self.subtract(ConstantModule(value: lhs))
    }
    public func subtract(_ lhs: Int) -> some Module {
        self.subtract(.init(lhs))
    }
}
