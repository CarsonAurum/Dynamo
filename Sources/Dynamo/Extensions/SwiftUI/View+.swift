//
//  View+.swift
//
//  Extensions to the SwiftUI View type.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: View+Font

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    /// Modify the font of a view based on provided parameters.
    ///
    /// This method allows you to easily modify the font and its weight for any SwiftUI `View`.
    /// If a `Font.Weight` is provided, it applies the specified font with the given weight to the view.
    /// If the `Font.Weight` is `nil`, it applies the font without changing the weight of the current font.
    ///
    /// # Usage:
    /// ```swift
    /// Text("Hello, World!")
    ///     .font(.title, weight: .bold)
    /// ```
    /// This code snippet sets the font of the text to `title` and weight to `bold`.
    ///
    /// - Parameters:
    ///   - font: The desired `Font` to be applied to the `View`.
    ///   - weight: The desired `Font.Weight` to be applied to the `View`. This is an optional parameter.
    ///
    /// - Returns: The `View` with the modified font and potentially modified weight.
    ///
    /// - Note: If the `weight` parameter is `nil`, only the font will be changed.
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
    /// Allows to modify self directly inside a closure.
    ///
    /// - Parameter body: A closure that takes an inout self and returns Void.
    /// - Returns: Modified self.
    ///
    /// # Usage:
    /// ```swift
    /// Text("Hello, World!")
    ///     .then { $0.font(.largeTitle) }
    /// ```
    @inlinable
    public func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        body(&result)
        return result
    }
}

// MARK: View+Erase

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    /// Performs type-erasure on this view.
    /// - Returns: A type-erased copy of this view.
    ///
    /// # Usage:
    /// ```swift
    /// let typeErased: AnyView = Text("Hello, World!").eraseToAnyView()
    /// ```
    @inlinable
    public func eraseToAnyView() -> AnyView { .init(self) }
}

// MARK: View+Background

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    /// Applies a background to the View with a specified alignment.
    /// - Parameters:
    ///   - alignment: The alignment of the background view. Default is .center.
    ///   - background: A closure that returns the View to be used as the background.
    /// - Returns: A view with a custom background view aligned as specified.
    ///
    /// # Usage:
    /// ```swift
    /// Text("Hello, World!")
    ///     .background { Color.red }
    /// ```
    @_disfavoredOverload
    @inlinable
    public func background<Background: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ background: () -> Background
    ) -> some View {
        self.background(background(), alignment: alignment)
    }
    /// Applies a color as the background to the View.
    /// - Parameter color: The color to be used as the background.
    /// - Returns: A view with a color background.
    ///
    /// # Usage:
    /// ```swift
    /// Text("Hello, World!")
    ///     .background(Color.red)
    /// ```
    @_disfavoredOverload
    @inlinable
    public func background(_ color: Color) -> some View {
        self.background(PassthroughView { color })
    }
    /// Fills the entire View's background with a color, ignoring safe area.
    /// - Parameter color: The color to fill the background.
    /// - Returns: A view with a filled background color.
    ///
    /// # Usage:
    /// ```swift
    /// Text("Hello, World!")
    ///     .backgroundFill(Color.red)
    /// ```
    @inlinable
    public func backgroundFill(_ color: Color) -> some View {
        self.background(color.edgesIgnoringSafeArea(.all))
    }
    /// Fills the entire View's background with a custom view, ignoring safe area.
    /// - Parameters:
    ///   - fill: The view to be used to fill the background.
    ///   - alignment: The alignment of the fill view. Default is .center.
    /// - Returns: A view with a filled background view.
    ///
    /// # Usage:
    /// ```swift
    /// Text("Hello, World!")
    ///     .backgroundFill(CustomView())
    /// ```
    @inlinable
    public func backgroundFill<BackgroundFill: View>(
        _ fill: BackgroundFill,
        alignment: Alignment = .center
    ) -> some View {
        self.background(fill.edgesIgnoringSafeArea(.all), alignment: alignment)
    }
    /// Fills the entire View's background with a custom view from a ViewBuilder, ignoring safe area.
    /// - Parameters:
    ///   - alignment: The alignment of the fill view. Default is .center.
    ///   - fill: A closure returning the view to be used to fill the background.
    /// - Returns: A view with a filled background view from a ViewBuilder.
    ///
    /// # Usage:
    /// ```swift
    /// Text("Hello, World!")
    ///     .backgroundFill { CustomView() }
    /// ```
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
    /// Overlays a view on top of the current view with a specified alignment.
    ///
    /// The overlay is created by a closure that returns a `View`. The alignment of the overlay can also be specified.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the overlay view. Default is .center.
    ///   - overlay: A closure that returns the `View` to be used as the overlay.
    /// - Returns: A `View` with a custom overlay view aligned as specified.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .overlay {
    ///         Circle()
    ///             .fill(Color.red)
    ///             .frame(width: 10, height: 10)
    ///     }
    /// ```
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
    /// Conditionally hides the view based on a boolean value.
    ///
    /// When `isHidden` is true, the view is hidden. When `isHidden` is false, the view is visible.
    ///
    /// - Parameter isHidden: A Boolean value that determines whether the view should be hidden.
    /// - Returns: The original view, either hidden or visible based on the `isHidden` parameter.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .hidden(true)  // The text will not be visible
    /// ```
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
    /// Creates an inset (or outsets) equivalent to the specified point's coordinates.
    ///
    /// The horizontal and vertical offsets are set to the negative of the `x` and `y`
    /// values of the given point, respectively.
    ///
    /// - Parameter point: A point that specifies the amount to inset the view.
    /// - Returns: A view that is offset by the negative values of the point's coordinates.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .inset(CGPoint(x: 10, y: 20))  // The text will be offset by -10 horizontally and -20 vertically
    /// ```
    @inlinable
    public func inset(_ point: CGPoint) -> some View {
        self.offset(x: -point.x, y: -point.y)
    }
    /// Creates an inset (or outsets) equivalent to the specified length.
    ///
    /// The horizontal and vertical offsets are set to the negative of the given length.
    ///
    /// - Parameter length: A length that specifies the amount to inset the view.
    /// - Returns: A view that is offset by the negative value of the specified length.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .inset(10)  // The text will be offset by -10 both horizontally and vertically
    /// ```
    @inlinable
    public func inset(_ length: CGFloat) -> some View {
        self.offset(x: -length, y: -length)
    }
    /// Offsets a view by the given point's coordinates.
    ///
    /// - Parameter point: A point that specifies the amount to offset the view.
    /// - Returns: A view that is offset by the given point's coordinates.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .offset(CGPoint(x: 10, y: 20))  // The text will be offset by 10 horizontally and 20 vertically
    /// ```
    @inlinable
    public func offset(_ point: CGPoint) -> some View {
        self.offset(x: point.x, y: point.y)
    }
    /// Offsets a view by the specified length.
    ///
    /// The horizontal and vertical offsets are set to the given length.
    ///
    /// - Parameter length: A length that specifies the amount to offset the view.
    /// - Returns: A view that is offset by the specified length both horizontally and vertically.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .offset(10)  // The text will be offset by 10 both horizontally and vertically
    /// ```
    @inlinable
    public func offset(_ length: CGFloat) -> some View {
        self.offset(x: length, y: length)
    }
}

// MARK: View+Transtition

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    /// Applies a transition to the view.
    ///
    /// A transition determines how SwiftUI animates changes to a view’s visibility.
    ///
    /// - Parameter makeTransition: A closure that returns the transition to apply.
    /// - Returns: A view that applies the specified transition when it gets inserted or removed.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .transition { AnyTransition.slide }
    /// ```
    public func transition(_ makeTransition: () -> AnyTransition) -> some View {
        self.transition(makeTransition())
    }
    /// Applies asymmetric transitions to the view.
    ///
    /// An asymmetric transition uses one transition for insertion of the view and another for its removal.
    ///
    /// - Parameters:
    ///   - insertion: The transition to use when the view is inserted. Defaults to `.identity`.
    ///   - removal: The transition to use when the view is removed. Defaults to `.identity`.
    /// - Returns: A view that applies different transitions for insertion and removal.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .asymmetricTransition(insertion: .slide, removal: .opacity)
    /// ```
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
    /// Sets the view's horizontal alignment guide.
    ///
    /// This function sets the view's horizontal alignment guide to its current horizontal alignment.
    ///
    /// - Parameter guide: The horizontal alignment guide.
    /// - Returns: A view that has its horizontal alignment guide set to the current horizontal alignment.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .alignmentGuide(.leading) // The text's leading alignment guide is set to its current leading alignment.
    /// ```
    public func alignmentGuide(_ guide: HorizontalAlignment) -> some View {
        self.alignmentGuide(guide) { $0[guide] }
    }
    /// Sets the view's vertical alignment guide.
    ///
    /// This function sets the view's vertical alignment guide to its current vertical alignment.
    ///
    /// - Parameter guide: The vertical alignment guide.
    /// - Returns: A view that has its vertical alignment guide set to the current vertical alignment.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .alignmentGuide(.top) // The text's top alignment guide is set to its current top alignment.
    /// ```
    public func alignmentGuide(_ guide: VerticalAlignment) -> some View {
        self.alignmentGuide(guide) { $0[guide] }
    }
}

// MARK: View+Frame

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    /// Sets the explicit width of the view's frame.
    ///
    /// - Parameter width: The explicit width you want for the view's frame.
    /// - Returns: A view with a frame of the specified width.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .width(200) // Sets the width of the text frame to 200.
    /// ```
    @inlinable
    public func width(_ width: CGFloat?) -> some View {
        self.frame(width: width)
    }
    /// Sets the explicit height of the view's frame.
    ///
    /// - Parameter height: The explicit height you want for the view's frame.
    /// - Returns: A view with a frame of the specified height.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .height(50) // Sets the height of the text frame to 50.
    /// ```
    @inlinable
    public func height(_ height: CGFloat?) -> some View {
        self.frame(height: height)
    }
    /// Sets the minimum width of the view's frame.
    ///
    /// - Parameter width: The minimum width you want for the view's frame.
    /// - Returns: A view with a frame that will be at least the specified width.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .minWidth(100) // Sets the minimum width of the text frame to 100.
    /// ```
    @inlinable
    public func minWidth(_ width: CGFloat?) -> some View {
        self.frame(minWidth: width)
    }
    /// Sets the maximum width of the view's frame.
    ///
    /// - Parameter width: The maximum width you want for the view's frame.
    /// - Returns: A view with a frame that will be at most the specified width.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .maxWidth(300) // Sets the maximum width of the text frame to 300.
    /// ```
    @inlinable
    public func maxWidth(_ width: CGFloat?) -> some View {
        self.frame(maxWidth: width)
    }
    /// Sets the minimum height of the view's frame.
    ///
    /// - Parameter height: The minimum height you want for the view's frame.
    /// - Returns: A view with a frame that will be at least the specified height.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .minHeight(50) // Sets the minimum height of the text frame to 50.
    /// ```
    @inlinable
    public func minHeight(_ height: CGFloat?) -> some View {
        self.frame(minHeight: height)
    }
    /// Sets the maximum height of the view's frame.
    ///
    /// - Parameter height: The maximum height you want for the view's frame.
    /// - Returns: A view with a frame that will be at most the specified height.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .maxHeight(100) // Sets the maximum height of the text frame to 100.
    /// ```
    @inlinable
    public func maxHeight(_ height: CGFloat?) -> some View {
        self.frame(maxHeight: height)
    }
}

// MARK: View+Modify

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension View {
    /// Modifies a view using a transformation.
    ///
    /// - Parameter transform: The transformation to apply to the view.
    /// - Returns: A new view that is the result of the transformation.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .modify { $0.foregroundColor(.red) } // Changes the text color to red.
    /// ```
    @ViewBuilder
    public func modify<T: View>(
        @ViewBuilder transform: (Self) -> T
    ) -> some View {
        transform(self)
    }
    /// Modifies a view using a transformation, if a predicate is true.
    ///
    /// - Parameters:
    ///   - predicate: A Boolean value that determines whether the transformation should be applied.
    ///   - transform: The transformation to apply to the view.
    /// - Returns: A new view that is the result of the transformation if the predicate is true;
    /// otherwise, the original view.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .modify(if: true) { $0.foregroundColor(.red) } // Changes the text color to red.
    /// ```
    @ViewBuilder
    public func modify<T: View>(
        if predicate: Bool,
        @ViewBuilder transform: (Self) -> T
    ) -> some View {
        if predicate { transform(self) }
        else { self }
    }
    /// Modifies a view using a transformation if an environment value equals a specified value.
    ///
    /// - Parameters:
    ///   - keyPath: A key path to a specific value in the environment.
    ///   - comparate: The value to compare the environment value with.
    ///   - transform: The transformation to apply to the view.
    /// - Returns: A new view that is the result of the transformation if the environment value equals
    /// the specified value; otherwise, the original view.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .modify(if: \.isEnabled, equals: true) { $0.foregroundColor(.red) }
    ///     // Changes the text color to red if isEnabled is true.
    /// ```
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
    /// Modifies a view using a view modifier.
    ///
    /// - Parameter modifier: The view modifier to apply to the view.
    /// - Returns: A new view that is the result of applying the view modifier.
    ///
    /// # Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .modify { ForegroundColorModifier(.red) } // Changes the text color to red.
    /// ```
    public func modify<T: ViewModifier>(
        @ViewBuilder modifier: () -> T
    ) -> ModifiedContent<Self, T> {
        self.modifier(modifier())
    }
}

#endif
