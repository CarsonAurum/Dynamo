//
//  UnsafeContinuation.swift
//
//
//  Created by Carson Rau on 6/8/23.
//

#if canImport(_Concurrency)

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func withUnsafeContinuation<T, U>(
    _ f: (UnsafeContinuation<U, Never>) -> T
) async -> (T, U) {
    var result0: T!
    let result1 = await withUnsafeContinuation { result0 = f($0) }
    return (result0, result1)
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func withUnsafeThrowingContinuation<T, U>(
    _ fn: (UnsafeContinuation<U, Error>) throws -> T
) async throws -> (T, U) {
    var result0: Result<T, Error>?
    let result1 = try await withUnsafeThrowingContinuation { continuation in
        result0 = Result { try fn(continuation) }
    }
    
    assert(result0 != nil)
    return (try result0.unwrap().get(), result1)
}
#endif
