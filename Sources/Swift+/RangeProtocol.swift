//
//  RangeProtocol.swift
//
//  Use protocol-based programming to upgrade the functionality of ranges.
//
//  Carson Rau - 3/2/22
//

/// A protocol representing a range with upper and lower bounds.
///
/// The conforming types can be used where a range is needed.
public protocol RangeProtocol: RangeExpression {
    /// The lower bound of the range.
    var lowerBound: Bound { get }
    /// The upper bound of the range.
    var upperBound: Bound { get }
    /// Determines if a range includes a given other range.
    ///
    /// - Parameter other: The range to check for containment within the current range.
    /// - Returns: `true` if the other range is within the current range, otherwise `false`.
    func contains(_ other: Self) -> Bool
}

/// A protocol representing a range that excludes the upper bound.
///
/// Conforms to the `RangeProtocol`.
public protocol HalfOpenRangeProtocol: RangeProtocol { }

/// A protocol representing a range that includes both the upper and lower bounds.
///
/// Conforms to the `RangeProtocol`.
public protocol ClosedRangeProtocol: RangeProtocol { }

/// A protocol representing a range with specified upper and lower bounds.
///
/// Conforms to the `RangeProtocol`.
public protocol BoundedRangeProtocol: RangeProtocol {
    /// Creates a new range with the provided bounds. This initializer does not check
    /// whether the lower bound is less than or equal to the upper bound.
    ///
    /// - Parameter uncheckedBounds: A tuple containing the lower and upper bounds of the range.
    init(uncheckedBounds: (lower: Bound, upper: Bound))
    /// Creates a new range with the provided bounds. The initializer checks that the lower bound is less than
    /// or equal to the upper bound and traps in case of violation.
    ///
    /// - Parameter bounds: A tuple containing the lower and upper bounds of the range.
    init(bounds: (lower: Bound, upper: Bound))
}

extension HalfOpenRangeProtocol {
    /// Determines if a range includes a given other half-open range.
    ///
    /// - Parameter other: The half-open range to check for containment within the current range.
    /// - Returns: `true` if the other half-open range is within the current range, otherwise `false`.
    public func contains(_ other: Self) -> Bool {
        (other.lowerBound >= self.lowerBound) && (other.lowerBound < self.upperBound)
        && (other.upperBound <= self.upperBound) && (other.upperBound > self.lowerBound)
    }
    /// Creates a new instance of a `HalfOpenRangeProtocol` with the given bound and its successor.
    ///
    /// - Parameter bound: The lower bound of the half-open range.
    @inlinable
    public init(_ bound: Bound) where Self: BoundedRangeProtocol, Bound: Strideable {
        self.init(bounds: (lower: bound, upper: bound.successor()))
    }
    /// Determines if a range overlaps with a given other half-open range.
    ///
    /// - Parameter other: The half-open range to check for overlap with the current range.
    /// - Returns: `true` if the other half-open range overlaps with the current range, otherwise `false`.
    public func overlaps(with other: Self) -> Bool {
        ((other.lowerBound >= self.lowerBound) && (other.lowerBound < self.upperBound))
        || ((other.upperBound <= self.upperBound) && (other.upperBound > self.lowerBound))
    }
}

extension ClosedRange: BoundedRangeProtocol, ClosedRangeProtocol {
    /// Creates a new `ClosedRange` instance with the specified bounds.
    ///
    /// - Parameter bounds: A tuple containing the lower and upper bounds of the range.
    public init(bounds: (lower: Bound, upper: Bound)) {
        self = bounds.lower...bounds.upper
    }
    /// Determines if a closed range includes a given other closed range.
    ///
    /// - Parameter other: The closed range to check for containment within the current range.
    /// - Returns: `true` if the other closed range is within the current range, otherwise `false`.
    public func contains(_ other: ClosedRange) -> Bool {
        other.lowerBound >= self.lowerBound && other.upperBound <= self.upperBound
    }
}


extension Range: BoundedRangeProtocol, HalfOpenRangeProtocol {
    /// Creates a new `Range` instance with the specified bounds.
    ///
    /// This range includes the lower bound and excludes the upper bound.
    /// - Parameter bounds: A tuple containing the lower and upper bounds of the range.
    public init(bounds: (lower: Bound, upper: Bound)) {
        self = bounds.lower..<bounds.upper
    }
}
