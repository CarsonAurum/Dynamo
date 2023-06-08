//
//  View+.swift
//
//
//  Created by Carson Rau on 6/8/23.
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: View+Font

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    @inlinable
    @ViewBuilder
    public func font(_ font: Font, weight: Font.Weight?) -> some View {
        if let weight {
            self.font(font.weight(weight))
        } else {
            self.font(font)
        }
    }
}

// MARK: View+Then

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    @inlinable
    public func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        body(&result)
        return result
    }
}

// MARK:  View+Erase

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    @inlinable
    public func eraseToAnyView() -> AnyView { .init(self) }
}

// MARK: View+Background

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    @_disfavoredOverload
    @inlinable
    public func background<Background: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ background: () -> Background
    ) -> some View {
        self.background(background(), alignment: alignment)
    }
    
    @_disfavoredOverload
    @inlinable
    public func background(_ color: Color) -> some View {
        self.background(PassthroughView(content: { color }))
    }
    
    @inlinable
    public func backgroundFill(_ color: Color) -> some View {
        self.background(color.edgesIgnoringSafeArea(.all))
    }
    
    @inlinable
    public func backgroundFill<BackgroundFill: View>(
        _ fill: BackgroundFill,
        alignment: Alignment = .center
    ) -> some View {
        self.background(fill.edgesIgnoringSafeArea(.all), alignment: alignment)
    }
    
    @inlinable
    public func backgroundFill<BackgroundFill: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ fill: () -> BackgroundFill
    ) -> some View {
        self.backgroundFill(fill())
    }
}

// MARK: View+Overlay

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    @_disfavoredOverload
    @inlinable
    public func overlay<Overlay: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ overlay: () -> Overlay
    ) -> some View {
        self.overlay(overlay(), alignment: alignment)
    }
}

// MARK: View+Hidden

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    @_disfavoredOverload
    @inlinable
    public func hidden(_ isHidden: Bool) -> some View {
        PassthroughView {
            if isHidden { hidden() }
            else { self }
        }
    }
}

// MARK: View+Hidden

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    
    @inlinable
    public func inset(_ point: CGPoint) -> some View {
        self.offset(x: -point.x, y: -point.y)
    }
    
    @inlinable
    public func inset(_ length: CGFloat) -> some View {
        self.offset(x: -length, y: -length)
    }
    
    @inlinable
    public func offset(_ point: CGPoint) -> some View {
        self.offset(x: point.x, y: point.y)
    }
    
    @inlinable
    public func offset(_ length: CGFloat) -> some View {
        self.offset(x: length, y: length)
    }
}

// MARK: View+Transtition

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    
    public func transition(_ makeTransition: () -> AnyTransition) -> some View {
        self.transition(makeTransition())
    }
    
    public func asymmetricTransition(
        insertion: AnyTransition = .identity,
        removal: AnyTransition = .identity
    ) -> some View {
        self.transition(.asymmetric(insertion: insertion, removal: removal))
    }
}

// MARK: View+AlignmentGuide

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    
    public func alignmentGuide(_ g: HorizontalAlignment) -> some View {
        self.alignmentGuide(g) { $0[g] }
    }
    
    public func alignmentGuide(_ g: VerticalAlignment) -> some View {
        self.alignmentGuide(g) { $0[g] }
    }
}

// MARK: View+Frame

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    
    @inlinable
    public func width(_ width: CGFloat?) -> some View {
        self.frame(width: width)
    }
    
    @inlinable
    public func height(_ height: CGFloat?) -> some View {
        self.frame(height: height)
    }
    
    @inlinable
    public func minWidth(_ width: CGFloat?) -> some View {
        self.frame(minWidth: width)
    }
    
    @inlinable
    public func maxWidth(_ width: CGFloat?) -> some View {
        self.frame(maxWidth: width)
    }
    
    @inlinable
    public func minHeight(_ height: CGFloat?) -> some View {
        self.frame(minHeight: height)
    }
    
    @inlinable
    public func maxHeight(_ height: CGFloat?) -> some View {
        self.frame(maxHeight: height)
    }
}

// MARK: View+Modify

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    
    @ViewBuilder
    public func modify<T: View>(
        @ViewBuilder transform: (Self) -> T
    ) -> some View {
        transform(self)
    }
    
    @ViewBuilder
    public func modify<T: View>(
        if predicate: Bool,
        @ViewBuilder transform: (Self) -> T
    ) -> some View {
        if predicate { transform(self) }
        else { self }
    }
    
    @ViewBuilder
    public func modify<T: View, U: Equatable>(
        if keyPath: KeyPath<EnvironmentValues, U>,
        equals comparate: U,
        @ViewBuilder transform: @escaping (Self) -> T
    ) -> some View {
        EnvironmentValueAccessView(keyPath) { value in
            if value == comparate {
                transform(self)
            } else {
                self
            }
        }
    }
    
    public func modify<T: ViewModifier>(
        @ViewBuilder modifier: () -> T
    ) -> ModifiedContent<Self, T> {
        self.modifier(modifier())
    }
}

#endif
