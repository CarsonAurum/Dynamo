//
//  AlignedSpacers.swift
//
//  A collection of spacers aligned to different axes within the containing view.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI

/// A spacer that is automatically aligned in both the vertical and horizontal directions.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct XSpacer: View {
    @inlinable
    public init() { }
    @inlinable
    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
            }
        }
    }
}

/// A spacer that is automatically aligned in the horizontal direction.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct HSpacer: View {
    @inlinable
    public init() { }
    @inlinable
    public var body: some View {
        HStack { Spacer() }
    }
}

/// A spacer that is automatically aligned in the vertical direction.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct VSpacer: View {
    @inlinable
    public init() { }
    @inlinable
    public var body: some View {
        VStack { Spacer() }
    }
}

#endif
