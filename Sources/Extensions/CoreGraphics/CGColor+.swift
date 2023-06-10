//
//  CGColor+.swift
//
//  Extensions to the CoreGraphics CGColor type.
//
//  Carson Rau - 6/8/23
//

#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

extension CGColor {
    #if canImport(UIKit)
    /// Convert this color into a `UIColor` type.
    public var uiColor: UIColor? { .init(cgColor: self) }
    #endif
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    /// Convert this color into a `NSColor` type.
    public var nsColor: NSColor? { .init(cgColor: self) }
    #endif
}
#endif
