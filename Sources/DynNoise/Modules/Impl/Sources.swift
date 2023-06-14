//
//  Sources.swift
//  
//
//  Carson Rau - 6/13/23
//

public struct ConstantModule: SourceModule {
    public let value: Double
    public func getValue(x: Double, y: Double, z: Double) throws -> Double { value }
}

extension ConstantModule: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self.value = .init(value)
    }
    public init(floatLiteral value: Double) {
        self.value = value
    }
}
