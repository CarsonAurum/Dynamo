//
//  Event.swift
//  
//
//  Created by Carson Rau on 7/17/23.
//

public protocol EventProtocol: Hashable { }

extension Never: EventProtocol { }

public enum Event<E: EventProtocol>: Hashable, RawRepresentable {
    case some(E)
    case any
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .some(x):
            hasher.combine(x)
        case .any:
            hasher.combine(Int.min / 2)
        }
    }
    public var rawValue: E? {
        switch self {
        case let .some(x):
            return x
        default:
            return nil
        }
    }
    public init(rawValue: E?) {
        if let rawValue = rawValue {
            self = .some(rawValue)
        } else {
            self = .any
        }
    }
    public static func ==(lhs: Event<E>, rhs: Event<E>) -> Bool {
        switch (lhs, rhs) {
        case let (.some(x1), .some(x2)) where x1 == x2:
            return true
        case (.any, .any):
            return true
        default:
            return false
        }
    }
    public static func ==(lhs: Event<E>, rhs: E) -> Bool {
        switch lhs {
        case let .some(x):
            return x == rhs
        case .any:
            return false
        }
    }
    public static func ==(lhs: E, rhs: Event<E>) -> Bool {
        switch rhs {
        case let .some(x):
            return x == lhs
        case .any:
            return false
        }
    }
}
