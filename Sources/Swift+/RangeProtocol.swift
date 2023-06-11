//
//  RangeProtocol.swift
//
//  Use protocol-based programming to upgrade the functionality of ranges.
//
//  Carson Rau - 3/2/22
//

public protocol RangeProtocol: RangeExpression {
    var lowerBound: Bound { get }
    var upperBound: Bound { get }
    func contains(_ other: Self) -> Bool
}

public protocol HalfOpenRangeProtocol: RangeProtocol { }

public protocol ClosedRangeProtocol: RangeProtocol { }

public protocol BoundedRangeProtocol: RangeProtocol {
    init(uncheckedBounds: (lower: Bound, upper: Bound))
    init(bounds: (lower: Bound, upper: Bound))
}

extension HalfOpenRangeProtocol {
    public func contains(_ other: Self) -> Bool {
        (other.lowerBound >= self.lowerBound) && (other.lowerBound <= self.upperBound)
        && (other.upperBound <= self.upperBound) && (other.upperBound >= self.lowerBound)
    }
    @inlinable
    public init(_ bound: Bound) where Self: BoundedRangeProtocol, Bound: Strideable {
        self.init(bounds: (lower: bound, upper: bound.successor()))
    }
    public func overlaps(with other: Self) -> Bool {
        ((other.lowerBound >= self.lowerBound) && (other.lowerBound <= self.upperBound))
        || ((other.upperBound <= self.upperBound) && (other.upperBound >= self.lowerBound))
    }
}

extension ClosedRange: BoundedRangeProtocol, ClosedRangeProtocol {
    public init(bounds: (lower: Bound, upper: Bound)) {
        self = bounds.lower...bounds.upper
    }
    public func contains(_ other: ClosedRange) -> Bool {
        other.lowerBound >= self.lowerBound && other.upperBound <= self.upperBound
    }
}

extension Range: BoundedRangeProtocol, HalfOpenRangeProtocol {
    public init(bounds: (lower: Bound, upper: Bound)) {
        self = bounds.lower..<bounds.upper
    }
}
