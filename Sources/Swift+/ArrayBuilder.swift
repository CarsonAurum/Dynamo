//
//  ArrayBuilder.swift
//
//  Introduces a result builder for constructing arrays of an arbitrary element type.
//
//  Carson Rau - 6/22/22
//

/// `ArrayBuilder` is a result builder that helps in the construction of arrays.
/// 
/// This result builder uses generic methods that accept a variety of inputs to construct arrays in a
/// declarative manner.
@resultBuilder
public enum ArrayBuilder {
    // swiftlint:disable missing_docs
    public static func buildExpression<Element>(_ element: Element) -> [Element] { [element] }
    public static func buildExpression<Element>(_ elements: [Element]) -> [Element] { elements }
    public static func buildExpression<Element>(_ element: Void) -> [Element] { [] }
    public static func buildExpression<Element>(_ element: Never) -> [Element] { }
    public static func buildPartialBlock<Element>(first: Element) -> [Element] { [first] }
    public static func buildPartialBlock<Element>(first: [Element]) -> [Element] { first }
    public static func buildPartialBlock<Element>(
        accumulated: [Element],
        next: Element
    ) -> [Element] { accumulated + [next] }
    public static func buildPartialBlock<Element>(
        accumulated: [Element],
        next: [Element]
    ) -> [Element] { accumulated + next }
    public static func buildPartialBlock<Element>(first: Void) -> [Element] { [] }
    public static func buildPartialBlock<Element>(first: Never) -> [Element] { }
    public static func buildBlock<Element>() -> [Element] { [] }
    public static func buildBlock<Element>(_ element: Element) -> [Element] { [element] }
    public static func buildBlock<Element>(_ elements: Element...) -> [Element] { elements }
    public static func buildBlock<Element>(_ elements: [Element]) -> [Element] { elements }
    public static func buildIf<Element>(_ element: Element?) -> [Element] {
        if let element { return [element] }
        else { return [] }
    }
    public static func buildIf<Element>(_ element: [Element]?) -> [Element] { element ?? [] }
    public static func buildOptional<Element>(_ component: Element?) -> [Element] {
        if let component { return [component] }
        else { return [] }
    }
    public static func buildOptional<Element>(_ component: [Element]?) -> [Element] { component ?? [] }
    public static func buildEither<Element>(first: Element) -> [Element] { [first] }
    public static func buildEither<Element>(second: Element) -> [Element] { [second] }
    public static func buildEither<Element>(first component: [Element]) -> [Element] { component }
    public static func buildEither<Element>(second component: [Element]) -> [Element] { component }
    public static func buildArray<Element>(_ elements: [Element]) -> [Element] { elements }
    public static func buildArray<Element>(_ elements: [[Element]]) -> [Element] {
        elements.flatMap { $0 }
    }
    // swiftlint:enable missing_docs
}

extension Array {
    /// Initializes an Array instance by using a result builder closure.
    /// - Parameter builder: The closure that will build the array.
    public init(@ArrayBuilder _ builder: () -> [Element]) {
        self.init(builder())
    }
}
