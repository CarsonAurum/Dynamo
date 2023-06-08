//
//  UnsafeContinuation.swift
//
//  Modifications to the _Concurrency continuation API.
//
//  Carson Rau - 6/8/23
//

#if canImport(_Concurrency)

/// Add support for closures that produce a value to the unsafe continuation API.
///
/// - Parameter f: A closure that takes an `UnsafeContinuation` parameter and returns some value of a new type.
/// - Returns: A tuple containing the value of the continuation before and after the execution of the given closure.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func withUnsafeContinuation<T, U>(
    _ f: (UnsafeContinuation<U, Never>) -> T
) async -> (T, U) {
    var result0: T!
    let result1 = await withUnsafeContinuation { result0 = f($0) }
    return (result0, result1)
}

/// Add support for throwing closures that produce a value to the unsafe continuation API.
///
/// - Parameter f: A throwing closure that takes an `UnsafeContinuation` parameter and returns some value of a new type.
/// - Returns: A tuple containing the value of the continuation before and after the execution of the given closure.
/// - Throws: Any error occuring within the continuation closure.
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
