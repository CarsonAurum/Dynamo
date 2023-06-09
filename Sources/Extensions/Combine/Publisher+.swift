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
    
    public func succeeds() -> AnyPublisher<Bool, Never> {
        self
            .map { _ in true }
            .reduce(true) { $0 && $1 }
            .catch { _ in Just(false) }
            .eraseToAnyPublisher()
    }
    
    public func fails() -> AnyPublisher<Bool, Never> {
        self
            .map { _ in false }
            .reduce(false) { $0 && $1 }
            .catch { _ in Just(true) }
            .eraseToAnyPublisher()
    }
    
    @available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
    public func get<ResSuccess, ResFailure>() -> Publishers.FlatMap<
        Result<ResSuccess, ResFailure>.Publisher,
        Publishers.SetFailureType<Self, ResFailure>>
            where Output == Result<ResSuccess, ResFailure>, Failure == Never {
            self.flatMap { $0.publisher }
    }
    
    public func mapResult<T>(
        _ transform: @escaping (Result<Output, Failure>) -> T
    ) -> Publishers.Catch<Publishers.Map<Self, T>, Just<T>> {
        self
            .map { transform(Result<Output, Failure>.success($0)) }
            .catch { Just(transform(.failure($0))) }
        
    }
}

#endif
