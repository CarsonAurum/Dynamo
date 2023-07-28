//
//  ExpModule.swift
//
//
//  Created by Carson Rau on 6/16/23.
//

import Dynamo

public struct ExpModule<T: Module, U: Module>: Combine2Module {
    public let baseModule: (T, U)
    public init(first: T, second: U) {
        self.baseModule = (first, second)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        let value = try baseModule.0[x, y, z]
        return try Double.pow(Swift.abs((value + 1.0) / 2.0), baseModule.1[x, y, z]) * 2.0 - 1.0
    }
}

extension Module {
    public func pow<T: Module>(_ module: T) -> some Module {
        ExpModule(first: self, second: module)
    }
}

extension Module {
    public func pow<T: Module>(_ builder: @escaping ModuleBuilder<T>) -> some Module {
        ExpModule(first: self, second: builder())
    }
}
