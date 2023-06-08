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

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct XStack<Content: View>: View {
    public let alignment: Alignment
    public let content: Content
    
    public init(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.content = content()
    }
    
    @inlinable
    public var body: some View {
        ZStack(alignment: alignment) {
            XSpacer()
            content
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension XStack where Content == EmptyView {
    public init() {
        self.init { EmptyView() }
    }
}

#endif
