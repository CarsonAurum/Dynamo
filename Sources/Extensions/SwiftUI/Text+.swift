//
//  Text+.swift
//
//  Extensions for the SwiftUI Text type.
//
//  Created by Carson Rau on 6/8/23.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Text {
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
