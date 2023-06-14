//
//  XStack.swift
//
//  A custom SwiftUI layout container that aligns objects in both axes.
//  This layout structure assumes as much of the enclosing coordinate space as possible.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI

///  A custom SwiftUI layout container that aligns objects in both axes.
///  
///  This layout structure assumes as much of the enclosing coordinate space as possible.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct XStack<Content: View>: View {
    /// The alignment guide which the stack will use to align the views it contains.
    ///
    /// This guide indicates where SwiftUI should position this child view within its parent.
    public let alignment: Alignment
    /// The content of this stack.
    ///
    /// The type of view to present.
    public let content: Content
    /// Creates an instance with the given `alignment` and view-building closure.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews within this stack. Default is `.center`.
    ///   - content: A closure returning the content of this stack.
    public init(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.content = content()
    }
    /// The content and behavior of the view.
    @inlinable public var body: some View {
        ZStack(alignment: alignment) {
            XSpacer()
            content
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension XStack where Content == EmptyView {
    /// Creates an instance of `XStack` with an `EmptyView`.
    public init() {
        self.init { EmptyView() }
    }
}

#endif
