//
//  CGVector+.swift
//
//  Extensions to the CoreGraphics Vector type.
//
//  Carson Rau - 6/8/23
//

#if canImport(CoreGraphics)
import CoreGraphics

extension CGVector {
    
    /// Get the angle from this vector.
    @inlinable
    public var angle: CGFloat { atan2(dy, dx) }
    
    /// Get the magnitude from this vector.
    @inlinable
    public var magnitude: CGFloat { sqrt(dx * dx + dy * dy) }
    
    /// Construct a new vector from a given angle and magnitude.
    ///
    /// - Parameters:
    ///   - angle: The angle of the desired vector.
    ///   - magnitude: The magnitude of the desired vector.
    @inlinable
    public init(angle: CGFloat, magnitude: CGFloat) {
        self = .init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

extension CGVector {
    
    /// Scale a vector by a given constant.
    ///
    /// - Parameters:
    ///   - lhs: The vector to scale.
    ///   - rhs: The value by which to scale the given vector.
    /// - Returns: The scaled vector.
    public static func *(lhs: Self, rhs: CGFloat) -> Self {
        .init(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    /// Scale a vector by a given constant.
    ///
    /// - Parameters:
    ///   - lhs: The value by which to scale the given vector.
    ///   - rhs: The vector to scale.
    /// - Returns: The scaled vector.
    public static func *(lhs: CGFloat, rhs: Self) -> Self {
        .init(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }
    
    /// In-place scaling operator.
    ///
    /// - Parameters:
    ///   - lhs: The vector to scale.
    ///   - rhs: The value by which to scale the given vector.
    public static func *=(lhs: inout Self, rhs: CGFloat) {
        lhs.dy *= rhs
        lhs.dx *= rhs
    }
    
    /// Invert the sign of the given vector.
    ///
    /// - Parameter lhs: The vector to invert.
    /// - Returns: The inverted vector.
    public static prefix func -(lhs: Self) -> Self {
        .init(dx: -lhs.dx, dy: -lhs.dy)
    }
}
#endif
