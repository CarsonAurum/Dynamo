//
//  MinModule.swift
//
//
//  Carson Rau - 6/14/23
//

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

extension Module {
    /// Construct a module that determines the minimum between this module and another module.
    ///
    /// - Parameter lhs: The module to compare against.
    /// - Returns: A composite module that will compute the minimum value of the two child modules.
    public func min<T: Module>(_ lhs: T) -> some Module {
        MinModule(first: self, second: lhs)
    }
}

extension Module {
    /// Construct a module that determines the minimum between this module and another module.
    ///
    /// - Parameter fn: A closure to evaluate when computing the second module in the min operation.
    /// - Returns: A composite module that will compute the minimum value of the two child modules.
    public func min<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.min(fn())
    }
}

extension Module {
    public func min(_ lhs: Double) -> some Module {
        self.min(ConstantModule(value: lhs))
    }
    public func min(_ lhs: Int) -> some Module {
        self.min(.init(lhs))
    }
}
