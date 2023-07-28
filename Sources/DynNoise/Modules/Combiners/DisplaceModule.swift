//
//  DisplaceModule.swift
//
//
//  Carson Rau - 6/14/23
//


public struct DisplaceModule<T: Module, A: Module, B: Module, C: Module>: Combine4Module {
    public enum Axis { case x, y, z }
    public let baseModule: (T, A, B, C)
    public init(first: T, second: A, third: B, fourth: C) {
        self.baseModule = (first, second, third, fourth)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try baseModule.0[baseModule.1[x, y, z], baseModule.2[x, y, z], baseModule.3[x, y, z]]
    }
}
