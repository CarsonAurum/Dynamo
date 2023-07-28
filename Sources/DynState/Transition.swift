//
//  Transition.swift
//
//
//  Created by Carson Rau on 7/17/23.
//

import Dynamo

// MARK: - Transition
/// A movement from one state to another. Represented as `.state1 => .state2`
public struct Transition<S: StateProtocol>: Hashable, CustomStringConvertible {
    /// The wrapped initial state for the transition.
    public let from: State<S>
    /// The wrapped final state for the transition.
    public let to: State<S>
    /// A string description for this transition: `.state1 => .state2`
    public var description: String {
        "\(self.from) => \(self.to) (\(self.hashValue))"
    }
    // MARK: Init
    /// Create a transition from two wrapped states.
    ///
    /// - Parameters:
    ///   - from: The initial state of the transition.
    ///   - to: The final state of the transition.
    public init(from: State<S>, to: State<S>) {
        self.from = from
        self.to = to
    }
    /// Create a transition from an unwrapped initial state and a wrapped final state.
    ///
    /// - Parameters:
    ///   - from: The unwrapped initial state of the transition.
    ///   - to: The wrapped final state of the transition.
    public init(from: S, to: State<S>) {
        self.from = .some(from)
        self.to = to
    }
    /// Create a transition from a wrapped intiial state and an unwrapped final state.
    ///
    /// - Parameters:
    ///   - from: The wrapped initial state of the transition.
    ///   - to: The unwrapped final state of the transition.
    public init(from: State<S>, to: S) {
        self.from = from
        self.to = .some(to)
    }
    /// Create a transition from two unwrapped states.
    ///
    /// - Parameters:
    ///   - from: The initial state of the transition.
    ///   - to: The final state of the transition.
    public init(from: S, to: S) {
        self.from = .some(from)
        self.to = .some(to)
    }
    /// Hash this transition's states.
    /// - Parameter hasher: The hasher in which to place the data.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(from.hashValue)
        hasher.combine(to.hashValue)
    }
    // MARK: Operators
    /// Check if two transitions are equal.
    ///
    /// - Parameters:
    ///   - lhs: The first transition to compare.
    ///   - rhs: The second transition to compare.
    /// - Returns: `true` if both pairs of states within the given transitions are equal. `false` otherwise.
    public static func == (lhs: Transition<S>, rhs: Transition<S>) -> Bool {
        lhs.from == rhs.from && lhs.to == rhs.to
    }
    /// Construct a new transition chain between the given transition and another following state.
    ///
    /// - Parameters:
    ///   - lhs: The transition to place at the beginning of the chain.
    ///   - rhs: The final state for the transition chain.
    /// - Returns: The new transition chain: `lhs.from => lhs.to => rhs`
    public static func => (lhs: Transition<S>, rhs: State<S>) -> TransitionChain<S> {
        .init(states: [lhs.from, lhs.to]) => rhs
    }
    /// Construct a new transition chain between the given transition and another following unwrapped state.
    ///
    /// - Parameters:
    ///   - lhs: The transition to place at the beginning of the chain.
    ///   - rhs: The unwrapped final state for the transition chain.
    /// - Returns: The new transition chain: `lhs.from => lhs.to => rhs`
    public static func => (lhs: Transition<S>, rhs: S) -> TransitionChain<S> {
        lhs => .some(rhs)
    }
    /// Construct a new transition chain between the given state and another following transition.
    ///
    /// - Parameters:
    ///   - lhs: The intiial state for the transition chain.
    ///   - rhs: The transition to place at the end of the chain.
    /// - Returns: The new transition chain: `lhs => rhs.from => rhs.to`
    public static func => (lhs: State<S>, rhs: Transition<S>) -> TransitionChain<S> {
        lhs => .init(states: [rhs.from, rhs.to])
    }
    /// Construct a new transition chain between the given unwrapped state and another following transition.
    ///
    /// - Parameters:
    ///   - lhs: The initial unwrapped state for the transition chain.
    ///   - rhs: The transition to place at the end of the chain.
    /// - Returns: The new transition chain: `lhs => rhs.from => rhs.to`
    public static func => (lhs: S, rhs: Transition<S>) -> TransitionChain<S> {
        .some(lhs) => rhs
    }
}
/// Construct a new transition between two unwrapped states.
///
/// - Parameters:
///   - lhs: The initial state for the transition.
///   - rhs: The final state for the transition.
/// - Returns: The newly constructed transition.
public func => <S>(lhs: S, rhs: S) -> Transition<S> {
    .init(from: .some(lhs), to: .some(rhs))
}

// MARK: - TransitionChain

/// A group of continuous ``Transition``s: `.state1 => .state2 => .state3`
public struct TransitionChain<S: StateProtocol> {
    /// The collection of states associated with this transition chain.
    public private(set) var states: [State<S>]
    /// Access the states in ``Transition`` pairs.
    public var transitions: [Transition<S>] {
        var result: [Transition<S>] = []
        for i in 0 ..< states.count - 1 {
            result += states[i] => states[i + 1]
        }
        return result
    }
    /// Construct a new transition chain with the array of ``State``s.
    /// - Parameter states: The array of states to store in this transition chain.
    public init(states: [State<S>]) {
        self.states = states
    }
    /// Construct a new transition chain with a ``Transition``.
    /// - Parameter transition: The transition whose states will be stored within the newly constructed transition chain.
    public init(transition: Transition<S>) {
        self.init(states: [transition.from, transition.to])
    }
    /// Construct a new transition chain between another ``TransitionChain`` and a new final state.
    ///
    /// - Parameters:
    ///   - lhs: The transition chain to place at the beginning of the newly constructed transition chain.
    ///   - rhs: The state to place at the end of the transition chain.
    /// - Returns: The new transition chain.
    public static func => (lhs: TransitionChain<S>, rhs: State<S>) -> TransitionChain<S> {
        .init(states: lhs.states + rhs)
    }
    /// Construct a new transition chain between another ``TransitionChain`` and a new unwrapped final state.
    ///
    /// - Parameters:
    ///   - lhs: The transition chain to place at the beginning of the newly constructed transition chain.
    ///   - rhs: The unwrapped state to place at the end of the transition chain.
    /// - Returns: The new transition chain.
    public static func => (lhs: TransitionChain<S>, rhs: S) -> TransitionChain<S> {
        lhs => .some(rhs)
    }
    /// Construct a new transition chain between a new initial state and another ``TransitionChain``.
    ///
    /// - Parameters:
    ///   - lhs: The state to place at the beginning of the newly constructed transition chain.
    ///   - rhs: The transition chain to place at the end of the newly constructed transition chain.
    /// - Returns: The new transition chain.
    public static func => (lhs: State<S>, rhs: TransitionChain<S>) -> TransitionChain<S> {
        .init(states: lhs + rhs.states)
    }
    /// Construct a new transition chain between a new unwrapped initial state and another ``TransitionChain``.
    ///
    /// - Parameters:
    ///   - lhs: The unwrapped state to place at the beginning of the newly constructed transition chain.
    ///   - rhs: The transition chain to place at the end of the newly constructed transition chain.
    /// - Returns: The new transition chain.
    public static func => (lhs: S, rhs: TransitionChain<S>) -> TransitionChain<S> {
        .some(lhs) => rhs
    }
}
