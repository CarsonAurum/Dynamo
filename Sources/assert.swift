//
//  File.swift
//  
//
//  Created by Carson Rau on 6/6/23.
//

import Foundation

/// A closure-based assert function.
public func assert(_ f: @escaping () -> Bool) {
    assert(f())
}

public func assert(_ f: @escaping () throws -> Bool) {
    do {
        let res = try f()
        assert(res)
    } catch {
        assert(false)
    }
}

@available(iOS 13.0.0, *)
public func assert(_ f: @escaping () async -> Bool) async {
    let res = await f()
    assert(res)
}

@available(iOS 13.0.0, *)
public func assert(_ f: @escaping () async throws -> Bool) async {
    do {
        let res = try await f()
        assert(res)
    } catch {
        assert(false)
    }
}
