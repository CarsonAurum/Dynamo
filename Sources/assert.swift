//
//  assert.swift
//  
//  Closure-based assertions.
//
//  Carson Rau - 3/6/22
//

/// Access assert with an escaping closure to evaluate complex conditions.
/// - Parameter fn: A closure returning a boolean.
public func assert(_ fn: @escaping () -> Bool) {
    assert(fn())
}

/// Access assert with an escaping throwing closure to evaluate complex conditions.
/// - Parameter fn: A throwing closure returning a boolean.
/// - Note: If the given closure throws an exception, the assertion will fail.
public func assert(_ fn: @escaping () throws -> Bool) {
    do {
        let res = try fn()
        assert(res)
    } catch {
        assertionFailure()
    }
}

/// Access assert with an escaping async closure to evaluate complex conditions.
/// - Parameter fn: An async closure returning a boolean.
@available(iOS 13.0.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func assert(_ fn: @escaping () async -> Bool) async {
    let res = await fn()
    assert(res)
}

/// Access assert with an escaping async throwing closure to evaluate complex expressions.
/// - Parameter fn: An async throwing closure returning a boolean.
/// - Note: If the given closure throws an exception, the assertion will fail.
@available(iOS 13.0.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func assert(_ fn: @escaping () async throws -> Bool) async {
    do {
        let res = try await fn()
        assert(res)
    } catch {
        assertionFailure()
    }
}
