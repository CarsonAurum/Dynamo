//
//  Angle+.swift
//
//  Extensions to the SwiftUI Angle type.
//
//  Carson Rau - 6/7/23
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Angle {
    
    @inlinable
    public static var pi: Self { .init(radians: Double.pi) }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Angle {
    
    @inlinable
    public init(degrees: CGFloat) {
        self.init(degrees: Double(degrees))
    }
    
    @inlinable
    public init(degrees: Int) {
        self.init(degrees: Double(degrees))
    }
    
    @inlinable
    public init(radians: CGFloat) {
        self.init(radians: Double(radians))
    }
    
    @inlinable
    public init(radians: Int) {
        self.init(radians: Double(radians))
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Angle {
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        .init(radians: self.radians.remainder(dividingBy: other.radians))
    }
    
    @inlinable
    public static func degrees(_ value: CGFloat) -> Self {
        self.init(degrees: value)
    }
    
    @inlinable
    public static func degrees(_ value: Int) -> Self {
        self.init(degrees: value)
    }
    
    @inlinable
    public static func radians(_ value: CGFloat) -> Self {
        self.init(radians: value)
    }
    
    @inlinable
    public static func radians(_ value: Int) -> Self {
        self.init(radians: value)
    }
}
#endif
