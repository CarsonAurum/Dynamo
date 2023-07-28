//
//  Machine.swift
//  
//
//  Created by Carson Rau on 7/17/23.
//

import Dynamo
#if canImport(Combine)
import Combine
#endif

#if canImport(Combine)
extension Machine: ObservableObject { }
#endif

/// A simplified state machine that can be driven by events.
public class Machine<S: StateProtocol, E: EventProtocol> {
    /// The closure argument passed to ``Condition`` and ``Handler`` as an argument.
    public struct Context {
        /// The event calling the state change in this machine.
        public let event: E?
        /// The previous state of the machine.
        public let from: S
        /// The new state of the machine.
        public let to: S
        /// Any additional information, typically a dictionary, associated with the change in state and/or event.
        public let userInfo: Any?
    }
    /// A closure for validating a transition.
    /// If this condition returns `false`, the transition will fail and the associated handlers will not be called.
    public typealias Condition = (Context) -> Bool
    /// Transition callback invoked when the state changes successfully.
    public typealias Handler = (Context) -> ()
    /// Closure-based route, mainly for `tryEvent()`
    /// - Returns: The preferred destination state.
    public typealias RouteMapping = (_ event: E?, _ from: S, _ userInfo: Any?) -> S?
    /// The current state of the machine.
    #if canImport(Combine)
    /// The state storage.
    @Published public internal(set) var state: S
    #else
    /// The state storage.
    public internal(set) var state: S
    #endif
    
    // MARK: - Init
    /// Create a new machine with the given initial state.
    ///
    /// - Parameters:
    ///   - state: The initial state for the newly constructed machine.
    ///   - closure: An optional closure to add routes and handlers initially.
    public init(state: S, _ closure: ((Machine) -> Void)? = nil) {
        self.state = state
        closure?(self)
    }
    /// Provide a new closure to add new routes and handlers.
    /// - Parameter closure: The closure to modify this machine.
    public func configure(_ closure: (Machine) -> Void) {
        closure(self)
    }
    // MARK: - Has Route
    /// Check for added routes and route mappings.
    ///
    /// - Parameters:
    ///   - event: The event which triggered this state change request.
    ///   - transition: The transition to check for.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: `true` if this route exists, either in closure or in route. `false` otherwise.
    public func hasRoute(event: E, transition: Transition<S>, userInfo: Any? = nil) -> Bool {
        guard let from = transition.from.rawValue, let to = transition.to.rawValue else {
            return false
        }
        return self.hasRoute(event: event, from: from, to: to, userInfo: userInfo)
    }
    /// Check for added routes and route mappings.
    ///
    /// - Parameters:
    ///   - event: The event which triggered this state change request.
    ///   - from: The `from` state associated with the desired route.
    ///   - to: The `to` state associated with the desired route.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: `true` if this route exists, either in closure or in route. `false` otherwise.
    public func hasRoute(event: E, from: S, to: S, userInfo: Any? = nil) -> Bool {
        self._hasRoute(event: event, from: from, to: to, userInfo: userInfo)
    }
    
    // MARK: Try Events
    /// Determine if an event can successfully trigger a state change.
    ///
    /// - Parameters:
    ///   - event: The event triggering a state change.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: The preferred `to` state.
    public func canTryEvent(_ event: E, userInfo: Any? = nil) -> S? {
        for case let route? in [self._routes[.some(event)], self._routes[.any]] {
            for (transition, keyDict) in route {
                if transition.from == .some(state) || transition.from == .any {
                    for (_, condition) in keyDict {
                        let to = transition.to .rawValue ?? self.state
                        if _canPassCondition(
                            condition,
                            for: event,
                            from: state,
                            to: to,
                            userInfo: userInfo
                        ) {
                            return to
                        }
                    }
                }
            }
        }
        if let toState = _hasRouteMappingInDict(
            event: event,
            from: state,
            to: nil,
            userInfo: userInfo
        ) {
            return toState
        }
        return nil
    }
    /// Trigger a state change with an event.
    ///
    /// - Parameters:
    ///   - event: The current event.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: `true` if the state change occured successfully, `false` otherwise.
    @discardableResult
    public func tryEvent(_ event: E, userInfo: Any? = nil) -> Bool {
        let fromState = self.state
        if let toState = self.canTryEvent(event, userInfo: userInfo) {
            self.state = toState
            for handlerInfo in _validHandlerInfos(event: event, from: fromState, to: toState)  {
                handlerInfo.handler(.init(
                    event: event,
                    from: fromState,
                    to: toState,
                    userInfo: userInfo
                ))
            }
            return true
        } else {
            for handlerInfo in self._errorHandlers {
                let toState = self.state
                handlerInfo.handler(.init(
                    event: event,
                    from: fromState,
                    to: toState,
                    userInfo: userInfo
                ))
            }
            return false
        }
    }
    // MARK: Add Routes
    /// Add an array of routes based on an event. These route will be constructed automatically given the transition and condition.
    ///
    /// - Parameters:
    ///   - event: The event to trigger the routes.
    ///   - transitions: The array of transitions to associate with the event in the route.
    ///   - condition: The condition to check when validating the route.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(
        event: E,
        transitions: [Transition<S>],
        condition: Machine.Condition? = nil
    ) -> Disposable {
        self.addRoutes(event: .some(event), transitions: transitions, condition: condition)
    }
    /// Add an array of routes based on a wrapped event. These routes will be constructed automatically given the transition and
    /// condition.
    ///
    /// - Parameters:
    ///   - event: The wrapped event to trigger the routes.
    ///   - transitions: The array of transitions to associate with the event in the route.
    ///   - condition: The condition to check when validating the route.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(
        event: Event<E>,
        transitions: [Transition<S>],
        condition: Machine.Condition? = nil
    ) -> Disposable {
        let routes: [Route] = transitions.map { .init(transition: $0, condition: condition) }
        return self.addRoutes(event: event, routes: routes)
    }
    /// Add an array of routes based on an event.
    ///
    /// - Parameters:
    ///   - event: The event to trigger the routes.
    ///   - routes: The array of routes to add in association with this event.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(event: E, routes: [Route<S, E>]) -> Disposable {
        self.addRoutes(event: .some(event), routes: routes)
    }
    /// Add an array of routes based on a wrapped event.
    ///
    /// - Parameters:
    ///   - event: The event to trigger the routes.
    ///   - routes: The array of routes to add in association with this event.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(event: Event<E>, routes: [Route<S, E>]) -> Disposable {
        let disposables = routes.map { _addRoute(event: event, route: $0) }
        return ActionDisposable {
            disposables.forEach { $0.dispose() }
        }
    }
    /// Add routes based on an event with an associated handler. The routes will be constructed automatically.
    ///
    /// - Parameters:
    ///   - event: The event to associate with the routes.
    ///   - transitions: The array of transitions to construct in routes.
    ///   - condition: The condition to associate with the route.
    ///   - handler: The handler to associate with the newly created routes.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(
        event: E,
        transitions: [Transition<S>],
        condition: Condition? = nil,
        handler: @escaping Handler
    ) -> Disposable {
        self.addRoutes(
            event: .some(event),
            transitions: transitions,
            condition: condition,
            handler: handler
        )
    }
    /// Add routes based on a wrapped event with an associated handler. The routes will be constructed automatically.
    ///
    /// - Parameters:
    ///   - event: The wrapped event to associate with the routes.
    ///   - transitions: The array of transitions to construct in routes.
    ///   - condition: The condition to associate with the route.
    ///   - handler: The handler to associate with the newly created routes.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(
        event: Event<E>,
        transitions: [Transition<S>],
        condition: Condition? = nil,
        handler: @escaping Handler
    ) -> Disposable {
        let routes: [Route] = transitions.map { .init(transition: $0, condition: condition) }
        return self.addRoutes(event: event, routes: routes, handler: handler)
    }
    /// Add an array of routes based on an event with an associated handler.
    ///
    /// - Parameters:
    ///   - event: The event to associate with the routes.
    ///   - routes: The array of routes to associate with the event.
    ///   - handler: The handler to associate with the routes.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(
        event: E,
        routes: [Route<S, E>],
        handler: @escaping Handler
    ) -> Disposable {
        self.addRoutes(event: .some(event), routes: routes, handler: handler)
    }
    /// Add an array of routes based on a wrapped event with an associated handler.
    ///
    /// - Parameters:
    ///   - event: The wrapped event to associate with the routes.
    ///   - routes: The array of routes to associate with the event.
    ///   - handler: The handler to associate with the routes.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRoutes(
        event: Event<E>,
        routes: [Route<S, E>],
        handler: @escaping Handler
    ) -> Disposable {
        let routeDisposables = self.addRoutes(event: event, routes: routes)
        let handlerDisposables = self.addHandler(event: event, handler: handler)
        return ActionDisposable {
            routeDisposables.dispose()
            handlerDisposables.dispose()
        }
    }
    // MARK: - AddRouteMapping
    /// Add a closure-based route to this machine.
    ///
    /// - Parameter mapping: The closure to treat as a route within this machine.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRouteMapping(_ mapping: @escaping RouteMapping) -> Disposable {
        let key = _createUniqueString()
        self._routeMappings[key] = mapping
        let id = _RouteMappingID(key: key)
        return ActionDisposable { [weak self] in
            self?._removeRouteMapping(id)
        }
    }
    /// Add a closure-based route to this machine with an associated handler.
    /// - Parameters:
    ///   - mapping: The closure to treat as a route within this machine.
    ///   - order: The handler order to assign to this closure.
    ///   - handler: The handler to associate with the given mapping.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addRouteMapping(
        _ mapping: @escaping RouteMapping,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        let routeDisposable = self.addRouteMapping(mapping)
        let handlerDisposable = self._addHandler(event: .any, order: order) {
            guard let prefState =
                    mapping($0.event, $0.from, $0.userInfo), prefState == $0.to else {
                return
            }
            handler($0)
        }
        return ActionDisposable {
            routeDisposable.dispose()
            handlerDisposable.dispose()
        }
    }
    // MARK: - Handler
    /// Add an event handler to this machine.
    ///
    /// - Parameters:
    ///   - event: The event to associate with the new handler.
    ///   - order: The handler order to associate with the closure.
    ///   - handler: The event handler.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addHandler(
        event: E,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        self.addHandler(event: .some(event), order: order, handler: handler)
    }
    /// Add a wrapped event handler to this machine.
    ///
    /// - Parameters:
    ///   - event: The wrapped event to associate with the new handler.
    ///   - order: The handler order to associate with the closure.
    ///   - handler: The event handler.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addHandler(
        event: Event<E>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        return self._addHandler(event: event, order: order) {
            guard let triggeredEvent = $0.event else { return }
            if triggeredEvent == event.rawValue || event == .any {
                handler($0)
            }
        }
    }
    // MARK: - Error Handler
    /// Add an error handler to this machine.
    ///
    /// - Parameters:
    ///   - order: The handler order to associate with the closure.
    ///   - handler: The error handler.
    /// - Returns: A reference to the runtime disposable data that will be freed when this state machine is no longer in use.
    @discardableResult
    public func addErrorHandler(
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        let key = _createUniqueString()
        let newInfo = _HandlerInfo(order: order, key: key, handler: handler)
        _insertHandlerInArray(&_errorHandlers, info: newInfo)
        let id = _HandlerID<S, E>(event: nil, transition: nil, key: key)
        return ActionDisposable { [weak self] in
            self?._removeHandler(id)
        }
    }
    // MARK: - Operators
    /// An operator to trigger state changes by event.
    ///
    /// - Parameters:
    ///   - machine: The machine on which to perform the event.
    ///   - event: The event to send to the machine.
    /// - Returns: The machine after the event has been executed.
    @discardableResult
    public static func <-!(machine: Machine<S, E>, event: E) -> Machine<S, E> {
        machine.tryEvent(event)
        return machine
    }
    /// An operator to trigger changes by event, with optional data associated.
    ///
    /// - Parameters:
    ///   - machine: The machine on which to perform the event.
    ///   - tuple: The tuple of event and associated data to send to the machine.
    /// - Returns: The machine after the event has been executed.
    @discardableResult
    public static func <-!(machine: Machine<S, E>, tuple: (E, Any?)) -> Machine<S, E> {
        machine.tryEvent(tuple.0, userInfo: tuple.1)
        return machine
    }
    
    // MARK: - Internal State
    /// A typealias denoting the dictionary of information stored within each route's dictionary entry.
    ///
    /// The transition is the transition assigned to the route.
    /// The string is the key (internal identifier) for the route.
    /// The condition is the closure required to validate the transition.
    internal typealias _RouteDictionary = [Transition<S> : [String: Condition?]]
    /// A collection of all routes that can be triggered by a given event.
    private lazy var _routes: [Event<E>: _RouteDictionary] = [:]
    /// A collection of all custom routes that can be called on this machine.
    ///
    /// The string is the key (internal identifier) for the custom mapping.
    private lazy var _routeMappings: [String: RouteMapping] = [:]
    /// A collection of handlers assigned to each event.
    ///
    /// These handlers will be called after the state is changed internally successfully.
    private lazy var _handlers: [Event<E>: [_HandlerInfo<S, E>]] = [:]
    /// A collection of handlers assigned to catch errors.
    ///
    /// These handlers will be called after the failed state change of **any** state.
    internal lazy var _errorHandlers: [_HandlerInfo<S, E>] = []
}

// MARK: - Helpers
extension Machine {
    internal func _hasRoute(event: E?, from: S, to: S, userInfo: Any? = nil) -> Bool {
        if _hasRouteInDict(event: event, from: from, to: to, userInfo: userInfo) {
            return true
        }
        if _hasRouteMappingInDict(event: event, from: from, to: to, userInfo: userInfo) != nil {
            return true
        }
        return false
    }
    private func _hasRouteInDict(event: E?, from: S, to: S, userInfo: Any? = nil) -> Bool {
        let validTransitions = _validTransition(from: from, to: to)
        for validTransition in validTransitions {
            var dicts: [_RouteDictionary] = []
            if let event = event {
                for (ev, route) in self._routes {
                    if ev.rawValue == event || ev == .any {
                        dicts += [route]
                    }
                }
            } else {
                dicts.append(contentsOf: self._routes.values)
            }
            for dict in dicts {
                if let keyDict = dict[validTransition] {
                    for (_, condition) in keyDict {
                        if _canPassCondition(
                            condition,
                            for: event,
                            from: from,
                            to: to,
                            userInfo: userInfo
                        ) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    private func _hasRouteMappingInDict(event: E?, from: S, to: S?, userInfo: Any? = nil) -> S? {
        for mapping in self._routeMappings.values {
            if let preferredTo = mapping(event, from, userInfo), preferredTo == to || to == nil {
                return preferredTo
            }
        }
        return nil
    }
    private func _validHandlerInfos(event: E, from: S, to: S) -> [_HandlerInfo<S, E>] {
        let result = [self._handlers[.some(event)], self._handlers[.any]]
            .filter { $0 != nil }
            .map { $0! }
            .joined()
        return result.sorted { $0.order < $1.order }
    }
    private func _addRoute(event: Event<E> = .any, route: Route<S, E>) -> Disposable {
        let key = _createUniqueString()
        if self._routes[event] == nil {
            self._routes[event] = [:]
        }
        var routeDict = self._routes[event]!
        if routeDict[route.transition] == nil {
            routeDict[route.transition] = [:]
        }
        var keyConditionDict = routeDict[route.transition]!
        keyConditionDict[key] = route.condition
        routeDict[route.transition] = keyConditionDict
        self._routes[event] = routeDict
        let _routeID = _RouteID(event: event, transition: route.transition, key: key)
        return ActionDisposable { [weak self] in
            self?._removeRoute(_routeID)
        }
    }
    @discardableResult
    private func _removeRoute(_ id: _RouteID<S, E>) -> Bool {
        guard let event = id.event else { return false }
        if let routeDict_ = self._routes[event] {
            var routeDict = routeDict_
            if let keyConditionDict_ = routeDict[id.transition] {
                var keyConditionDict = keyConditionDict_
                keyConditionDict[id.key] = nil
                if !keyConditionDict.isEmpty {
                    routeDict[id.transition] = keyConditionDict
                } else {
                    routeDict[id.transition] = nil
                }
            }
            if !routeDict.isEmpty {
                self._routes[event] = routeDict
            } else {
                self._routes[event] = nil
            }
            return true
        }
        return false
    }
    @discardableResult
    private func _removeRouteMapping(_ id: _RouteMappingID) -> Bool {
        if self._routeMappings[id.key] != nil {
            self._routeMappings[id.key] = nil
            return true
        } else {
            return false
        }
    }
    @discardableResult
    private func _addHandler(
        event: Event<E>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        if self._handlers[event] == nil {
            self._handlers[event] = []
        }
        let key = _createUniqueString()
        var infos = self._handlers[event]!
        let newInfo = _HandlerInfo(order: order, key: key, handler: handler)
        _insertHandlerInArray(&infos, info: newInfo)
        self._handlers[event] = infos
        let id = _HandlerID<S, E>(event: event, transition: .any => .any, key: key)
        return ActionDisposable { [weak self] in
            self?._removeHandler(id)
        }
    }
    @discardableResult
    private func _removeHandler(_ id: _HandlerID<S, E>) -> Bool {
        if let event = id.event {
            if let infos_ = self._handlers[event] {
                var infos = infos_
                if _removeHandlerFromArray(&infos, id: id) {
                    self._handlers[event] = infos
                    return true
                }
            }
        } else if id.transition == nil {
            if _removeHandlerFromArray(&_errorHandlers, id: id) {
                return true
            }
            return false
        }
        return false
    }
}
