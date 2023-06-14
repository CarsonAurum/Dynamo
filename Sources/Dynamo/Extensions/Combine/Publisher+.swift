//
//  Publisher+.swift
//
//  Extensions to the Combine Publisher type.
//
//  Carson Rau - 6/8/23
//

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Publisher {
    // swiftlint:disable reduce_boolean
    /// Determine if all operations in the Publisher chain have succeeded.
    ///
    /// It transforms every output of the Publisher chain into `true`, indicating that an operation has succeeded.
    /// After all the operations, it applies a logical AND operator (`&&`) to all values. If every operation in
    /// the Publisher chain has succeeded, it will return `true`.
    ///
    /// If any error occurs, this method catches the error and emits `false`, indicating that not all operations
    /// have succeeded.
    ///
    /// - Returns: A type-erased `Publosher` emitting a single Boolean value: `true` if all operations succeeded,
    /// `false` otherwise.
    /// - Note: This method will never emit an error, as all errors are caught and transformed into `false` values.
    public func succeeds() -> AnyPublisher<Bool, Never> {
        self
            .map { _ in true }
            .reduce(true) { $0 && $1 }
            .catch { _ in Just(false) }
            .eraseToAnyPublisher()
    }
    /// Determine if any operations in the Publisher chain have failed.
    ///
    /// It transforms every output of the Publisher chain into `false`, presuming that an operation has not failed.
    /// After all the operations, it applies a logical AND operator (`&&`) to all values. If every operation in the
    /// Publisher chain has not failed, it will return `false`.
    ///
    /// If any error occurs, this method catches the error and emits `true`, indicating that an operation has failed.
    ///
    /// - Returns: A type-erased `Publisher` emitting a single Boolean value: `true` if any operation failed, `false`
    /// otherwise.
    /// - Note: This method will never emit an error, as all errors are caught and transformed into `true` values.
    public func fails() -> AnyPublisher<Bool, Never> {
        self
            .map { _ in false }
            .reduce(false) { $0 && $1 }
            .catch { _ in Just(true) }
            .eraseToAnyPublisher()
    }
    // swiftlint:enable reduce_boolean
    /// Transforms a Publisher emitting `Result` values into a Publisher emitting the success or failure
    /// values directly.
    ///
    /// This method uses the `flatMap` operator to convert each `Result` in the original Publisher's
    /// output into a new Publisher. If the `Result` is a success, the new Publisher will emit the success value;
    /// if it's a failure, the new Publisher will emit an error.
    ///
    /// - Returns: A publisher which transforms the `Result` values emitted by the original Publisher into
    /// ndividual publishers that emit the success value or an error.
    ///
    /// - Note: This method is used when the Publisher chain operates on `Result` values, and we want to
    /// transform these `Result` values into success values or errors directly.
    ///
    /// - Note: The `Failure` type of the original Publisher must be `Never`, indicating that it doesn't emit
    /// any errors itself.
    /// Any error will come from a `Result.failure` value.
    @available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
    public func get<ResSuccess, ResFailure>() -> Publishers.FlatMap<
        Result<ResSuccess, ResFailure>.Publisher,
        Publishers.SetFailureType<Self, ResFailure>>
    where Output == Result<ResSuccess, ResFailure>, Failure == Never {
        self.flatMap { $0.publisher }
    }
    /// Transforms the output and error of the Publisher into another type `T` using a provided transformation function.
    ///
    /// This method applies the transformation function to each successful output of the Publisher chain, wrapping it
    /// in a `Result.success`. If any error occurs, the method catches the error, wraps it in a `Result.failure`,
    /// and applies the transformation function to it.
    ///
    /// The transformation function should be prepared to handle both success and failure cases of the `Result`.
    ///
    /// - Parameter transform: A function that transforms a `Result<Output, Failure>` into a `T`.
    ///
    /// - Returns: A `Publishers.Catch` publisher that emits the transformed values.
    ///
    /// - Note: This method allows the caller to handle both the output and error of the Publisher in a unified way,
    /// by transforming them into the same type.
    public func mapResult<T>(
        _ transform: @escaping (Result<Output, Failure>) -> T
    ) -> Publishers.Catch<Publishers.Map<Self, T>, Just<T>> {
        self
            .map { transform(Result<Output, Failure>.success($0)) }
            .catch { Just(transform(.failure($0))) }
    }
}

#endif
