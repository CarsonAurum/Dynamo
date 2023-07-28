//
//  Logger.Level++.swift
//
//
//  Carson Rau - 6/24/23
//

import Logging

extension Logger.Level {
    public var uppercased: String { Self.uppercased[intValue] }
    public var initial: String { Self.initial[intValue] }
    public var lowerCased: String { rawValue }
}

extension Logger.Level {
    private static let uppercased = Logger.Level.allCases.map { $0.rawValue.uppercased() }
    private static let initial = [ "T", "D", "I", "N", "W", "E", "C"]
    private var intValue: Int {
        switch self {
        case .trace:    return 0
        case .debug:    return 1
        case .info:     return 2
        case .notice:   return 3
        case .warning:  return 4
        case .error:    return 5
        case .critical: return 6
        }
    }
}
