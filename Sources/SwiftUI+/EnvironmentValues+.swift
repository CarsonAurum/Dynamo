//
//  EnvironmentValues+.swift
//
//  Extensions to the functionality of the SwiftUI EnvironmentValues capability.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI


/// A SwiftUI `View` that provides access to a specific value from the `EnvironmentValues`.
/// This struct helps to wrap environment values and pass them to the specified content.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct EnvironmentValueAccessView<Value, Content: View>: View {
    /// The `KeyPath` to the specific value in `EnvironmentValues`.
    private let keyPath: KeyPath<EnvironmentValues, Value>
    /// The content that should be displayed. This is a closure that takes the environment value as a parameter.
    private let content: (Value) -> Content
    /// The environment value extracted using the provided key path.
    @usableFromInline @Environment internal var value: Value
    /// Initializes an `EnvironmentValueAccessView`.
    ///
    /// - Parameters:
    ///   - keyPath: A `KeyPath` pointing to the desired value in the `EnvironmentValues`.
    ///   - content: A closure that takes the desired environment value and returns a `View`.
    ///   The returned `View` is what will be displayed.
    public init(
        _ keyPath: KeyPath<EnvironmentValues, Value>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.keyPath = keyPath
        self.content = content
        self._value = .init(keyPath)
    }
    /// Defines the content of the `View` using the value from the environment and the provided content closure.
    public var body: some View {
        content(value)
    }
}


#endif
