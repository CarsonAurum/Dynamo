//
//  File.swift
//  
//
//  Created by Carson Rau on 7/17/23.
//

import Dynamo

/// A ``Transition`` with an associated ``Machine/Condition``.
public struct Route<S: StateProtocol, E: EventProtocol> {
    /// The transition to associated with a condition.
    public let transition: Transition<S>
    /// The machine state condition closure to evaluate for this transition.
    public let condition: Machine<S, E>.Condition?
    /// Construct a new route with the given transition and condition.
    ///
    /// - Parameters:
    ///   - transition: The transition to save within the newly constructed route.
    ///   - condition: The condition to save within the newly constructed route.
    public init(transition: Transition<S>, condition: Machine<S, E>.Condition?) {
        self.transition = transition
        self.condition = condition
    }
}
/// Construct a new route allowing transitions from multiple `from` states to the given unwrapped `to` state.
///
/// `[.state0, .state1] => .state2` allows `[.state0 => .state2, .state1 => .state2]`
///
/// - Parameters:
///   - lhs: The array of `from` states for this route.
///   - rhs: The `to` state for the route.
/// - Returns: The newly constructed route.
public func => <S, E>(lhs: [S], rhs: S) -> Route<S, E> {
    lhs => .some(rhs)
}
/// Construct a new route allowing transitions from one `from` state to many `to` states.
///
/// `.state0 => [.state1, .state2]` allows `[.state0 => .state1, .state0 => .state2]`
///
/// - Parameters:
///   - lhs: The `from` state for the route.
///   - rhs: The array of `to` states for the route.
/// - Returns: The newly constructed route.
public func => <S, E>(lhs: S, rhs: [S]) -> Route<S, E> {
    .some(lhs) => rhs
}
/// Construct a new route allowing transitions from many `from` states to many `to` states.
///
/// `[.state0, .state1] => [.state2, .state3]` allows
/// `[.state0 => .state2, .state0 => .state3, .state1 => .state2, .state1 => .state3]`
public func => <S, E>(lhs: [S], rhs: [S]) -> Route<S, E> {
    .init(transition: .any => .any) { lhs.contains($0.from) && rhs.contains($0.to) }
}



// MARK: - RouteChain

/// A group of continuous ``Route``s.
public struct RouteChain<S: StateProtocol, E: EventProtocol> {
    /// The array of routes stored within this chain.
    public private(set) var routes: [Route<S, E>]
    /// Construct a new RouteChain with the given array of routes.
    /// - Parameter routes: The array of routes within the newly constructed chain.
    public init(routes: [Route<S, E>]) {
        self.routes = routes
    }
    /// Construct a new route chain from the transitions within a transition chain and the given condition.
    ///
    /// - Parameters:
    ///   - transitions: The transition chain whose transitions will be stored within the route chain.
    ///   - condition: The condition to associate with each transition within the route chain.
    public init(transitions chain: TransitionChain<S>, condition: Machine<S, E>.Condition? = nil) {
        var rs: [Route<S, E>] = []
        for transition in chain.transitions {
            rs += .init(transition: transition, condition: condition)
        }
        self.init(routes: rs)
    }
}
