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
    
    /// An angle representing `Double.pi` in radians.
    @inlinable
    public static var pi: Self { .init(radians: Double.pi) }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Angle {
    
    /// Construct a new angle with the given `CGFloat` degree value.
    ///
    /// - Parameter degrees: The `CGFloat` degree value.
    @inlinable
    public init(degrees: CGFloat) {
        self.init(degrees: Double(degrees))
    }
    
    /// Construct a new angle with the given `Int` degree value.
    ///
    /// - Parameter degrees: The `Int` degree value.
    @inlinable
    public init(degrees: Int) {
        self.init(degrees: Double(degrees))
    }
    
    /// Construct a new angle with the given `CGFloat` radian value.
    ///
    /// - Parameter radians: The `CGFloat` radian value.
    @inlinable
    public init(radians: CGFloat) {
        self.init(radians: Double(radians))
    }
    
    /// Construct a new angle with the given `Int` radian value.
    ///
    /// - Parameter radians: The `Int` radian value.
    @inlinable
    public init(radians: Int) {
        self.init(radians: Double(radians))
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Angle {
    
    /// Construct a new angle by dividing this angle by the given angle (in radians).
    ///
    /// - Parameter other: The angle to divide this angle by.
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        .init(radians: self.radians.remainder(dividingBy: other.radians))
    }
    
    /// Construct a new angle with the given `CGFloat` degree value.
    ///
    /// - Parameter value: The degree value of this angle.
    @inlinable
    public static func degrees(_ value: CGFloat) -> Self {
        self.init(degrees: value)
    }
    
    /// Construct a new angle with the given `Int` degree value.
    ///
    /// - Parameter value: The degree value of this angle.
    @inlinable
    public static func degrees(_ value: Int) -> Self {
        self.init(degrees: value)
    }
    
    /// Construct a new angle with the given `CGFloat` radian value.
    ///
    /// - Parameter value: The radian value of this angle.
    @inlinable
    public static func radians(_ value: CGFloat) -> Self {
        self.init(radians: value)
    }
    
    /// Construct a new angle with the given `Int` radian value.
    ///
    /// - Parameter value: The radian value of this angle.
    @inlinable
    public static func radians(_ value: Int) -> Self {
        self.init(radians: value)
    }
}
#endif
