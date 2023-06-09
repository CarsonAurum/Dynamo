//
//  UnsafeContinuation.swift
//
//  Modifications to the _Concurrency continuation API.
//
//  Carson Rau - 6/8/23
//

#if canImport(_Concurrency)

/// Runs an asynchronous operation by calling a closure that takes an `UnsafeContinuation<U, Never>` and returns a `T` value.
/// This can be used to wrap non-async APIs into async ones, allowing them to be used with Swift's async/await syntax.
///
/// The closure `f` you provide to this function should take an `UnsafeContinuation` as a parameter and return a `T`.
/// The continuation is then resumed asynchronously, and the result of `f` and the resumed value are returned as a tuple `(T, U)`.
///
/// The continuation will not throw any errors (`Never` type is used for the error argument in `UnsafeContinuation`).
///
/// - Parameters:
///   - f: A closure that accepts `UnsafeContinuation<U, Never>` as its parameter and returns a `T`.
/// - Returns: A tuple `(T, U)`, where `T` is the result of calling `f` and `U` is the result of the continuation's resume.
/// - Note: Since this method works with an `UnsafeContinuation`, you need to ensure that the continuation is always resumed exactly once.
///
/// # Example
/// ```swift
/// let (result0, result1) = await withUnsafeContinuation { continuation in
///     DispatchQueue.global().async {
///         // Perform some long running operation
///         let result = longRunningOperation()
///         // Resume the continuation with the result of the operation
///         continuation.resume(returning: result)
///         return "Finished long running operation"
///     }
/// }
/// print(result0) // "Finished long running operation"
/// print(result1) // result of longRunningOperation
/// ```
///
/// - Warning: This is an unsafe operation. If you forget to resume the continuation, or if you attempt to resume it more than once,
/// your program may crash or exhibit undefined behavior.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func withUnsafeContinuation<T, U>(
    _ f: (UnsafeContinuation<U, Never>) -> T
) async -> (T, U) {
    var result0: T!
    let result1 = await withUnsafeContinuation { result0 = f($0) }
    return (result0, result1)
}

/// This function runs an asynchronous operation by calling a closure that takes an `UnsafeContinuation<U, Error>` and may throw an `Error`.
/// This can be used to wrap non-async APIs into async ones, allowing them to be used with Swift's async/await syntax.
///
/// The closure `fn` you provide to this function should take an `UnsafeContinuation` as a parameter and return a `T`, potentially throwing an error.
/// The continuation is then resumed asynchronously, and the result of `fn` and the resumed value are returned as a tuple `(T, U)`.
/// If `fn` throws an error, it is caught and wrapped in a `Result` type.
///
/// - Parameters:
///   - fn: A closure that accepts `UnsafeContinuation<U, Error>` as its parameter and may throw an `Error`, returning a `T`.
/// - Returns: A tuple `(T, U)`, where `T` is the result of calling `fn` and `U` is the result of the continuation's resume.
/// - Throws: An error if `fn` throws, or if the `Result` wrapping `fn`'s return value is a failure.
/// - Note: Since this method works with an `UnsafeContinuation`, you need to ensure that the continuation is always resumed exactly once.
///
/// # Example
/// ```swift
/// do {
///     let (result0, result1) = try await withUnsafeThrowingContinuation { continuation in
///         DispatchQueue.global().async {
///             do {
///                 // Perform some long running operation that might throw
///                 let result = try longRunningOperation()
///                 // Resume the continuation with the result of the operation
///                 continuation.resume(returning: result)
///                 return "Finished long running operation"
///             } catch {
///                 // If an error occurs, resume the continuation with that error
///                 continuation.resume(throwing: error)
///             }
///         }
///     }
///     print(result0) // "Finished long running operation"
///     print(result1) // result of longRunningOperation
/// } catch {
///     print("An error occurred: \(error)")
/// }
/// ```
///
/// - Warning: This is an unsafe operation. If you forget to resume the continuation, or if you attempt to resume it more than once,
/// your program may crash or exhibit undefined behavior.

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
