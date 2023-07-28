//
//  File.swift
//  
//
//  Created by Carson Rau on 7/17/23.
//

import Dynamo

/// A full state machine that can be triggered by either events or states.
/// - Note: Use `Never` to ignore event-handling on this state machine.
public final class StateMachine<S: StateProtocol, E: EventProtocol>: Machine<S, E> {
    /// Closure-based route, mainly for `tryState()`
    /// - An array of preferred destination states. `.s0 => [.s1, .s2]`
    public typealias StateRouteMapping = (_ from: S, _ userInfo: Any?) -> [S]?
    /// Construct a new state machine with the given initial state and optional configuration closure.
    ///
    /// - Parameters:
    ///   - state: The initial state for this state machine.
    ///   - closure: The closure to execute to configure this state machine.
    public override init(state: S, _ closure: ((StateMachine) -> Void)? = nil) {
        super.init(state: state) {
            closure?($0 as! StateMachine<S, E>)
            return
        }
    }
    /// Provide a new closure to add new routes and handlers.
    /// - Parameter closure: The closure to modify this state machine.
    public override func configure(_ closure: (StateMachine<S, E>) -> Void) {
        closure(self)
    }
    // MARK: Has Route
    /// Check for added routes and route mappings.
    ///
    /// - Note: This method also checks for event-based routes.
    /// - Parameters:
    ///   - transition: The transition to check for.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: `true` if this route exists, either in closure or in route. `false` otherwise.
    public func hasRoute(_ transition: Transition<S>, userInfo: Any? = nil) -> Bool {
        guard let from = transition.from.rawValue, let to = transition.to.rawValue else {
            return false
        }
        return self.hasRoute(from: from, to: to, userInfo: userInfo)
    }
    /// Check for added routes and route mappings.
    ///
    /// - Note: This method also checks for event-based routes.
    /// - Parameters:
    ///   - from: The `from` state associated with the desired route.
    ///   - to: The `to` state associated with the desired route.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: `true` if this route exists, either in closure or in route. `false` otherwise.
    public func hasRoute(from: S, to: S, userInfo: Any? = nil) -> Bool {
        if _hasRouteInDict(from: from, to: to, userInfo: userInfo) {
            return true
        }
        if _hasRouteMappingInDict(from: from, to: to, userInfo: userInfo) != nil {
            return true
        }
        return super._hasRoute(event: nil, from: from, to: to, userInfo: userInfo)
    }
    
    // MARK: TryState
    /// Determine if a change to the given state is valid.
    ///
    /// - Note: This method also checks for event-based routes.
    /// - Parameters:
    ///   - to: The desired destination state.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: `true` if the route exists to the given state. `false` otherwise.
    public func canTryState(_ to: S, userInfo: Any? = nil) -> Bool {
        self.hasRoute(from: self.state, to: to, userInfo: userInfo)
    }
    /// Perform a state transition.
    ///
    /// - Note: This method also tries event-based routes.
    /// - Parameters:
    ///   - to: The destination state for the transition.
    ///   - userInfo: Optional data associated with the state change.
    /// - Returns: `true` if the state change occurs, `false` otherwise.
    @discardableResult
    public func tryState(_ to: S, userInfo: Any? = nil) -> Bool {
        let from = self.state
        if self.canTryState(to, userInfo: userInfo) {
            let validInfos = self._validHandlerInfos(from: from, to: to)
            self.state = to
            
            for info in validInfos {
                info.handler(.init(event: nil, from: from, to: to, userInfo: userInfo))
            }
            return true
        } else {
            for info in self._errorHandlers {
                info.handler(.init(event: nil, from: from, to: to, userInfo: userInfo))
            }
        }
        return false
    }
    // MARK: Add Route
    @discardableResult
    public func addRoute(_ transition: Transition<S>, condition: Condition? = nil) -> Disposable {
        let route: Route = .init(transition: transition, condition: condition)
        return self.addRoute(route)
    }
    @discardableResult
    public func addRoute(_ route: Route<S, E>) -> Disposable {
        if self._routes[route.transition] == nil {
            self._routes[route.transition] = [:]
        }
        let key = _createUniqueString()
        var keyConditionDict = self._routes[route.transition]!
        keyConditionDict[key] = route.condition
        self._routes[route.transition] = keyConditionDict
        let id: _RouteID = .init(
            event: Optional<Event<E>>.none,
            transition: route.transition,
            key: key
        )
        return ActionDisposable { [weak self] in
            self?._removeRoute(id)
        }
    }
    @discardableResult
    public func addRoute(
        _ transition: Transition<S>,
        condition: Condition? = nil,
        handler: @escaping Handler
    ) -> Disposable {
        let route: Route = .init(transition: transition, condition: condition)
        return self.addRoute(route, handler: handler)
    }
    @discardableResult
    public func addRoute(_ route: Route<S, E>, handler: @escaping Handler) -> Disposable {
        let routeDisposable = self.addRoute(route.transition, condition: route.condition)
        let handlerDisposable = self.addHandler(route.transition) {
            if _canPassCondition(
                route.condition,
                for: nil,
                from: $0.from,
                to: $0.to,
                userInfo: $0.userInfo
            ) {
                handler($0)
            }
        }
        return ActionDisposable {
            routeDisposable.dispose()
            handlerDisposable.dispose()
        }
    }
    
    // MARK: Handler
    
    @discardableResult
    public func addHandler(
        _ transition: Transition<S>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        if self._handlers[transition] == nil {
            self._handlers[transition] = []
        }
        let key = _createUniqueString()
        var infos = self._handlers[transition]!
        let newInfo: _HandlerInfo = .init(order: order, key: key, handler: handler)
        _insertHandlerInArray(&infos, info: newInfo)
        self._handlers[transition] = infos
        let id = _HandlerID<S, E>(event: nil, transition: transition, key: key)
        return ActionDisposable { [weak self] in
            self?._removeHandler(id)
        }
    }
    @discardableResult
    public func addAnyHandler(
        _ transition: Transition<S>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        let disposable1 = self.addHandler(transition, order: order, handler: handler)
        let disposable2 = self.addHandler(event: .any, order: order) {
            if (transition.from == .any || transition.from == $0.from)
                && (transition.to == .any || transition.to == $0.to) {
                handler($0)
            }
        }
        return ActionDisposable {
            disposable1.dispose()
            disposable2.dispose()
        }
    }
    
    // MARK: Route Chaining
    
    @discardableResult
    public func addRouteChain(
        _ chain: TransitionChain<S>,
        condition: Condition? = nil,
        handler: @escaping Handler
    ) -> Disposable {
        let routeChain: RouteChain = .init(transitions: chain, condition: condition)
        return self.addRouteChain(routeChain, handler: handler)
    }
    @discardableResult
    public func addRouteChain(_ chain: RouteChain<S, E>, handler: @escaping Handler) -> Disposable {
        let routeDisposables = chain.routes.map { self.addRoute($0) }
        let handlerDisposable = self.addChainHandler(chain, handler: handler)
        return ActionDisposable {
            routeDisposables.forEach { $0.dispose() }
            handlerDisposable.dispose()
        }
    }
    
    // MARK: Chain Handler
    
    @discardableResult
    public func addChainHandler(
        _ chain: TransitionChain<S>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        self.addChainHandler(.init(transitions: chain), order: order, handler: handler)
    }
    @discardableResult
    public func addChainHandler(
        _ chain: RouteChain<S, E>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
            self._addChainHandler(chain, order: order, handler: handler, isError: false)
    }
    @discardableResult
    public func addChainErrorHandler(
        _ chain: TransitionChain<S>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        self.addChainErrorHandler(.init(transitions: chain), order: order, handler: handler)
    }
    @discardableResult
    public func addChainErrorHandler(
        _ chain: RouteChain<S, E>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler
    ) -> Disposable {
        self._addChainHandler(chain, order: order, handler: handler, isError: true)
    }
    
    // MARK: State Route Mapping
    
    @discardableResult
    public func addStateRouteMapping(_ mapping: @escaping StateRouteMapping) -> Disposable {
        let key = _createUniqueString()
        self._routeMappings[key] = mapping
        let id = _RouteMappingID(key: key)
        return ActionDisposable { [weak self] in
            self?._removeStateRouteMapping(id)
        }
    }
    @discardableResult
    public func addStateRouteMapping(
        _ mapping: @escaping StateRouteMapping,
        handler: @escaping Handler
    ) -> Disposable {
        let routeDisposable = self.addStateRouteMapping(mapping)
        let handlerDisposable = self.addHandler(.any => .any) {
            guard $0.event == nil else { return }
            guard let preferredTo = mapping($0.from, $0.userInfo),
                    preferredTo.contains($0.to) else {
                return
            }
            handler($0)
        }
        return ActionDisposable {
            routeDisposable.dispose()
            handlerDisposable.dispose()
        }
    }
    
    // MARK: Operators
    
    @discardableResult
    public static func <- (machine: StateMachine<S, E>, state: S) -> StateMachine<S, E> {
        machine.tryState(state)
        return machine
    }
    @discardableResult
    public static func <- (machine: StateMachine<S, E>, tuple: (S, Any?)) -> StateMachine<S, E> {
        machine.tryState(tuple.0, userInfo: tuple.1)
        return machine
    }
    
    // MARK: - Private
    private lazy var _routes: _RouteDictionary = [:]
    private lazy var _routeMappings: [String: StateRouteMapping] = [:]
    private lazy var _handlers: [Transition<S>: [_HandlerInfo<S, E>]] = [:]
    
}
extension StateMachine {
    private func _hasRouteInDict(from: S, to: S, userInfo: Any? = nil) -> Bool {
        let validTransitions = _validTransition(from: from, to: to)
        for transition in validTransitions {
            if let keyConditionDict = self._routes[transition] {
                for (_, condition) in keyConditionDict {
                    if _canPassCondition(
                        condition,
                        for: nil,
                        from: from,
                        to: to,
                        userInfo: userInfo
                    ) {
                        return true
                    }
                }
            }
        }
        return false
    }
    private func _hasRouteMappingInDict(from: S, to: S, userInfo: Any? = nil) -> S? {
        for mapping in self._routeMappings.values {
            if let preferredTo = mapping(from, userInfo) {
                return preferredTo.contains(to) ? to : nil
            }
        }
        return nil
    }
    private func _validHandlerInfos(from: S, to: S) -> [_HandlerInfo<S, E>] {
        var result: [_HandlerInfo<S, E>] = []
        let transitions = _validTransition(from: from, to: to)
        for transition in transitions {
            if let infos = self._handlers[transition] {
                for info in infos {
                    result += info
                }
            }
        }
        result.sort { $0.order < $1.order }
        return result
    }
    @discardableResult
    private func _removeRoute(_ id: _RouteID<S, E>) -> Bool {
        guard id.event == nil else {
            return false
        }
        let transition = id.transition
        guard let keyConditionDict_ = self._routes[transition] else {
            return false
        }
        var keyConditionDict = keyConditionDict_
        let removed = keyConditionDict.removeValue(forKey: id.key) != nil
        if !keyConditionDict.isEmpty {
            self._routes[transition] = keyConditionDict
        } else {
            self._routes[transition] = nil
        }
        return removed
    }
    @discardableResult
    private func _removeHandler(_ id: _HandlerID<S, E>) -> Bool {
        if let transition = id.transition {
            if let infos_ = self._handlers[transition] {
                var infos = infos_
                if _removeHandlerFromArray(&infos, id: id) {
                    self._handlers[transition] = infos
                    return true
                }
            }
        }
        return false
    }
    @discardableResult
    private func _addChainHandler(
        _ chain: RouteChain<S, E>,
        order: HandlerOrder = _defaultHandlerOrder,
        handler: @escaping Handler,
        isError: Bool
    ) -> Disposable {
        var handlerDisposables: [Disposable] = []
        var stop = true, shouldIncrement = true
        var chainedCount = 0, allCount = 0
        
        let firstRoute = chain.routes.first!
        var handlerDisposable = self.addHandler(firstRoute.transition) {
            if _canPassCondition(
                firstRoute.condition,
                for: nil,
                from: $0.from,
                to: $0.to,
                userInfo: $0.userInfo
            ) {
                if stop {
                    stop = false
                    chainedCount = 0
                    allCount = 0
                }
            }
        }
        handlerDisposables += handlerDisposable
        for route in chain.routes {
            handlerDisposable = self.addHandler(route.transition) {
                if !shouldIncrement { return }
                if _canPassCondition(
                    route.condition,
                    for: nil,
                    from: $0.from,
                    to: $0.to,
                    userInfo: $0.userInfo
                ) {
                    if !stop {
                        chainedCount += 1
                        shouldIncrement = false
                    }
                }
            }
            handlerDisposables += handlerDisposable
        }
        handlerDisposable = self.addHandler(.any => .any, order: 150) {
            shouldIncrement = true
            if !stop {
                allCount += 1
            }
            if chainedCount < allCount {
                stop = true
                if isError {
                    handler($0)
                }
            }
        }
        handlerDisposables += handlerDisposable
        
        let lastRoute = chain.routes.last!
        handlerDisposable = self.addHandler(lastRoute.transition, order: 200) {
            if _canPassCondition(
                lastRoute.condition,
                for: nil,
                from: $0.from,
                to: $0.to,
                userInfo: $0.userInfo
            ) {
                if chainedCount == allCount
                    && chainedCount == chain.routes.count
                    && chainedCount == chain.routes.count {
                    stop = true
                    if !isError {
                        handler($0)
                    }
                }
            }
        }
        handlerDisposables += handlerDisposable
        return ActionDisposable {
            handlerDisposables.forEach { $0.dispose() }
        }
    }
    @discardableResult
    private func _removeStateRouteMapping(_ id: _RouteMappingID) -> Bool {
        if self._routeMappings[id.key] != nil {
            self._routeMappings[id.key] = nil
            return true
        } else {
            return false
        }
    }
    
}
