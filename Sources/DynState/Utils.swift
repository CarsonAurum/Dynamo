//
//  Utils.swift
//
//
//  Carson Rau - 7/17/23
//

infix operator =>: AdditionPrecedence
infix operator <-!: AdditionPrecedence
infix operator <-: AdditionPrecedence

/// A positive integer indicating the order in which handlers should be executed. Lower = sooner.
public typealias HandlerOrder = UInt8

/// The default handler order = 100.
public let _defaultHandlerOrder: HandlerOrder = 100

internal func _random(_ upperBound: Int) -> Int {
    .random(in: 0...upperBound)
}

// MARK: - HandlerID
internal final class _HandlerID<S: StateProtocol, E: EventProtocol> {
    internal let event: Event<E>?
    internal let transition: Transition<S>?
    internal let key: String
    internal init(event: Event<E>?, transition: Transition<S>?, key: String) {
        self.event = event
        self.transition = transition
        self.key = key
    }
}

// MARK: - HandlerInfo
internal final class _HandlerInfo<S: StateProtocol, E: EventProtocol> {
    internal let order: HandlerOrder
    internal let key: String
    internal let handler: Machine<S, E>.Handler

    internal init(order: HandlerOrder, key: String, handler: @escaping Machine<S, E>.Handler) {
        self.order = order
        self.key = key
        self.handler = handler
    }
}

// MARK: - RouteID
internal final class _RouteID<S: StateProtocol, E: EventProtocol> {
    internal let event: Event<E>?
    internal let transition: Transition<S>
    internal let key: String
    internal init(event: Event<E>?, transition: Transition<S>, key: String) {
        self.event = event
        self.transition = transition
        self.key = key
    }
}

internal final class _RouteMappingID {
    internal let key: String
    internal init(key: String) {
        self.key = key
    }
}

// MARK: - Helpers

internal func _createUniqueString() -> String {
    var unique: String = ""
    for _ in 1 ... 8 {
        unique += .init(describing: UnicodeScalar(0xD800))
    }
    return unique
}
internal func _validTransition <S>(from: S, to: S) -> [Transition<S>] {
    [ from => to, from => .any, .any => to, .any => .any]
}
internal func _canPassCondition <S: StateProtocol, E: EventProtocol>(
    _ condition: Machine<S, E>.Condition?,
    for event: E?,
    from: S,
    to: S,
    userInfo: Any?
) -> Bool {
    condition?(.init(event: event, from: from, to: to, userInfo: userInfo)) ?? true
}
internal func _insertHandlerInArray <S, E>(
    _ handlerInfos: inout [_HandlerInfo<S, E>],
    info: _HandlerInfo<S, E>
) {
    var idx = handlerInfos.count
    for i in Array(0 ..< handlerInfos.count).reversed() {
        if handlerInfos[i].order <= info.order {
            break
        }
        idx = i
    }
    handlerInfos.insert(info, at: idx)
}
internal func _removeHandlerFromArray <S, E>(_ handlerInfos: inout [_HandlerInfo<S, E>], id: _HandlerID<S, E>) -> Bool {
    for i in 0 ..< handlerInfos.count {
        if handlerInfos[i].key == id.key {
            handlerInfos.remove(at: i)
            return true
        }
    }
    return false
}
