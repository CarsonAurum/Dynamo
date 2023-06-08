//
//  GeometryReader+.swift
//
//  Extensions for the SwiftUI GeometryReader type.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension GeometryReader {
    @inlinable
    public init<T: View>(
        alignment: Alignment,
        @ViewBuilder content: @escaping (GeometryProxy) -> T
    ) where Content == XStack<T> {
        self.init { geometry in
            XStack(alignment: alignment) {
                content(geometry)
            }
        }
    }
}

#endif
