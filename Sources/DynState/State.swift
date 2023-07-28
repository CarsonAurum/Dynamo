//
//  State.swift
//  
//
//  Created by Carson Rau on 7/17/23.
//

/// A protocol representing any type that can be used as a state.
public protocol StateProtocol: Hashable { }

// MARK: State
/// A ``StateProtocol`` wrapper that supports the `any` state.
public enum State<S: StateProtocol>: Hashable, RawRepresentable {
    /// A specific state value.
    case some(S)
    /// Any state value.
    case any
    // MARK: Vars
    /// The hash value for this state.
    public var hashValue: Int {
        switch self {
        case let .some(x):
            return x.hashValue
        case .any:
            return Int.min / 2
        }
    }
    /// The raw value for this state, unwrapped from this type.
    public var rawValue: S? {
        switch self {
        case let .some(x):
            return x
        default:
            return nil
        }
    }
    // MARK: Inits
    /// Create a new wrapper around the given raw value. If no value is provided, `any` will be the value of `self`.
    /// - Parameter rawValue: The raw value to wrap within this type.
    public init(rawValue: S?) {
        if let rawValue = rawValue {
            self = .some(rawValue)
        } else {
            self = .any
        }
    }
    // MARK: Operators
    /// The equality operator for comparing two state values.
    ///
    /// - Parameters:
    ///   - lhs: The first state value.
    ///   - rhs: The second state value.
    /// - Returns: `true` if the wrapped values are the same, or they are both empty. `false` otherwise.
    public static func == (lhs: State<S>, rhs: State<S>) -> Bool {
        switch (lhs, rhs) {
        case let (.some(x1), .some(x2)) where x1 == x2:
            return true
        case (.any, .any):
            return true
        default:
            return false
        }
    }
    /// The equality operator for comparing a state value with a value of the wrapped type.
    ///
    /// - Parameters:
    ///   - lhs: The state value.
    ///   - rhs: The value to compare against the state's wrapped value.
    /// - Returns: `true` if the wrapped value is equivalent to the given value. `false` otherwise.
    public static func == (lhs: State<S>, rhs: S) -> Bool {
        switch lhs {
        case let .some(x):
            return x == rhs
        case .any:
            return false
        }
    }
    /// The equality operator for comparing a state value with a value of the wrapped type.
    ///
    /// - Parameters:
    ///   - lhs: The value to compare against the state's wrapped value.
    ///   - rhs: The state value.
    /// - Returns: `true` if the wrapped value is equivalent to the given value. `false` otherwise.
    public static func == (lhs: S, rhs: State<S>) -> Bool {
        switch rhs {
        case let .some(x):
            return x == lhs
        case .any:
            return false
        }
    }
    /// A transition operator to create a new transition from `lhs` to `rhs`.
    ///
    /// - Parameters:
    ///   - lhs: The `from` state.
    ///   - rhs: The `to` state.
    /// - Returns: A transition between the two given states.
    public static func => (lhs: State<S>, rhs: State<S>) -> Transition<S> {
        .init(from: lhs, to: rhs)
    }
    /// A transition operator to create a new transition from `lhs` to `rhs`.
    ///
    /// - Parameters:
    ///   - lhs: The `from` state's wrapped value.
    ///   - rhs: The `to` state.
    /// - Returns: A transition between the two given states.
    public static func => (lhs: S, rhs: State<S>) -> Transition<S> {
        .init(from: .some(lhs), to: rhs)
    }
    /// A transition operator to create a new transition from `lhs` to `rhs`.
    ///
    /// - Parameters:
    ///   - lhs: The `from` state.
    ///   - rhs: The `to` state's wrapped value.
    /// - Returns: A transition between the two given states.
    public static func => (lhs: State<S>, rhs: S) -> Transition<S> {
        .init(from: lhs, to: .some(rhs))
    }
    /// A route operator to create a new route from any of the states in `lhs` to `rhs`.
    ///
    /// - Parameters:
    ///   - lhs: An array of `from` states that are acceptable to transition to `rhs`.
    ///   - rhs: The state to transition to within the route.
    /// - Returns: The newly constructed route between the `lhs` states and `rhs`.
    public static func => <E>(lhs: [S], rhs: State<S>) -> Route<S, E> {
        .init(transition: .any => rhs) { lhs.contains($0.from) }
    }
    /// A route operator to create a new route from `lhs` to any of the states in `rhs`.
    ///
    /// Ex: event0 => [event1, event2]  === event0 => event1, event0 => event2
    ///
    /// - Parameters:
    ///   - lhs: The state from which the route is triggered.
    ///   - rhs: The array of `to` states that are acceptable transitions within this route.
    /// - Returns: The newly constructed route between `lhs` and the `rhs` states.
    public static func => <E>(lhs: State<S>, rhs: [S]) -> Route<S, E> {
        .init(transition: lhs => .any) { rhs.contains($0.to) }
    }
}
