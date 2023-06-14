//
//  Text+.swift
//
//  Extensions for the SwiftUI Text type.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Text {
    /// A custom modifier to support fonts of varying weights in the same call.
    /// - Parameters:
    ///   - font: The font to apply to this text instance.
    ///   - weight: An optional weight to use when applying the given font to this text instance.
    /// - Returns: This instance after modification.
    @inlinable
    public func font(_ font: Font, weight: Font.Weight?) -> Self {
        if let weight {
            return self.font(font.weight(weight))
        } else {
            return self.font(font)
        }
    }
}
#endif
