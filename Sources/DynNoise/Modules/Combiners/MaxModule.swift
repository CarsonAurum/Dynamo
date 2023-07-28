//
//  MaxModule.swift
//
//
//  Carson Rau - 6/14/23
//

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

extension Module {
    /// Construct a module that determines the maximum between this module and another module.
    ///
    /// - Parameter lhs: The module to compare against.
    /// - Returns: A composite module that will compute the maximum value of the two child modules.
    public func max<T: Module>(_ lhs: T) -> some Module {
        MaxModule(first: self, second: lhs)
    }
}

extension Module {
    /// Construct a module that determines the maximum between this module and another module.
    ///
    /// - Parameter fn: A closure to evaluate when computing the second module in the max operation.
    /// - Returns: A composite module that will compute the maximum value of the two child modules.
    public func max<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.max(fn())
    }
}

extension Module {
    public func max(_ lhs: Double) -> some Module {
        self.max(ConstantModule(value: lhs))
    }
    public func max(_ lhs: Int) -> some Module {
        self.max(.init(lhs))
    }
}
