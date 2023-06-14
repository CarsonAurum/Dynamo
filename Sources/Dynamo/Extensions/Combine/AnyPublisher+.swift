//
//  AnyPublisher+.swift
//
//  Extensions to the Combine AnyPublisher type.
//
//  Carson Rau - 6/8/23
//

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension AnyPublisher {
    /// Construct a new type-erased publisher around the given result.
    ///
    /// - Parameter result: The result value to wrap within a type-erased publisher.
    /// - Returns: The newly-created type-erased publisher containing the given `Result`.
    public static func result(_ result: Result<Output, Failure>) -> Self {
        switch result {
        case .failure(let failure):
            return Fail(error: failure)
                .eraseToAnyPublisher()
        case .success(let output):
            return Just(output)
                .setFailureType(to: Failure.self)
                .eraseToAnyPublisher()
        }
    }
    /// Construct a new type-erased value publisher with the given value.
    ///
    /// - Parameter output: The value to wrap within a type-erased publisher.
    /// - Returns: The newly-created type-erased publisher containing the given `Result`.
    public static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    /// Construct a new type-erased failure publisher with the given failure.
    ///
    /// - Parameter failure: The failure to wrap within a type-erased publisher.
    /// - Returns: The newly-created type-erased publisher containing the given failure.
    public static func failure(_ failure: Failure) -> Self {
        Result.Publisher(failure)
            .eraseToAnyPublisher()
    }
    /// Construct a new empty publisher that can optionally be fulfilled immediately.
    ///
    /// - Parameter completeImmediately: A flag to determine if this publisher should complete immediately on
    /// return of this function.
    /// - Returns: The newly-created type-erased publisher.
    public static func empty(completeImmediately: Bool = true) -> Self {
        Empty(completeImmediately: completeImmediately)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
}
#endif
