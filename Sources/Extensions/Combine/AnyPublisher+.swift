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
    
    public static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    public static func failure(_ failure: Failure) -> Self {
        Result.Publisher(failure)
            .eraseToAnyPublisher()
    }
    
    public static func empty(completeImmediately: Bool = true) -> Self {
        Empty(completeImmediately: completeImmediately)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
}
#endif
