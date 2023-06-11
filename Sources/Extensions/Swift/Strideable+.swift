//
//  Strideable+.swift
//
//  Extensions to the Swift Strideable type.
//
//  Carson Rau - 3/2/22
//

extension Strideable {
    @inlinable
    public mutating func advance(by distance: Stride) {
        self = self.advanced(by: distance)
    }
    @inlinable
    public mutating func advance() {
        self.advance(by: 1)
    }
    @inlinable
    public func predecessor() -> Self {
        self.advanced(by: -1)
    }
    @inlinable
    public func successor() -> Self {
        self.advanced(by: 1)
    }
}
