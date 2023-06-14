//
//  PassthroughView.swift
//
//  A wrapper view allowing seamless passthrough of its containing view.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI

/// A wrapper view to allow seamess passthrough of its containing view.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct PassthroughView<Content: View>: View {
    @usableFromInline internal let content: Content
    /// Construct a new view that wraps the given content.
    /// - Parameter content: The view contents to wrap within this new view.
    @inlinable
    public init(content: Content) {
        self.content = content
    }
    /// Construct a new view with the given content builder.
    /// - Parameter content: The result builder closure to use when creating content for this view.
    @inlinable
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    /// The content and behavior of this view.
    @inlinable public var body: some View {
        content
    }
}
#endif
