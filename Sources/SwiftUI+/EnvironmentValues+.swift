//
//  EnvironmentValues+.swift
//
//  Extensions to the functionality of the SwiftUI EnvironmentValues capability.
//
//  Carson Rau - 6/8/23
//

#if canImport(SwiftUI)
import SwiftUI


@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct EnvironmentValueAccessView<Value, Content: View>: View {
    private let keyPath: KeyPath<EnvironmentValues, Value>
    private let content: (Value) -> Content
    @usableFromInline @Environment var value: Value
    public init(
        _ keyPath: KeyPath<EnvironmentValues, Value>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.keyPath = keyPath
        self.content = content
        self._value = .init(keyPath)
    }
    public var body: some View {
        content(value)
    }
}

#endif
