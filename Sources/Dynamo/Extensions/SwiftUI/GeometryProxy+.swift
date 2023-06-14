//
//  GeometryProxy+.swift
//
//  Extensions to the SwiftUI GeometryProxy type.
//
//  Carson Rau - 6/7/23
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension GeometryProxy {
    /// Calculate the true size of this proxy by removing the safe area on all bounds.
    public var insetSize: CGSize {
        .init(
            width: self.size.width - (self.safeAreaInsets.leading + self.safeAreaInsets.trailing),
            height: self.size.height - (self.safeAreaInsets.top + self.safeAreaInsets.bottom)
        )
    }
}
#endif
