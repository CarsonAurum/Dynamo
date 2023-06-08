//
//  Future+.swift
//
//  Extensions to the Combine Future type.
//
//  Carson Rau - 6/8/23
//

#if canImport(Combine) && canImport(Dispatch)
import Combine
import Dispatch

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Future {
    
    /// Construct a new future with an asynchronous closure payload.
    ///
    /// - Parameter priority: An optionally specified priority that the given work will execute under.
    /// - Parameter work: An asynchronous workload capable of producing an output.
    /// - Returns: The newly constructed future, with no potential error once the workload is completed.
    public static func `async`(
        priority: TaskPriority? = nil,
        @_implicitSelfCapture execute work: @escaping @Sendable () async -> Output
    ) -> Future<Output, Failure> where Failure == Never {
        self.init { fulfill in
            Task.detached(priority: priority) {
                await fulfill(.success(work()))
            }
        }
    }
    
    /// Construct a new future with an asynchronous throwing closure payload.
    ///
    /// - Parameter priority: An optionally specified priority that the given work will execute under.
    /// - Parameter work: An asynchronous throwing workload capable of producing an output.
    /// - Returns: The newly constructed future, with a potential error once the workload is completed.
    public static func `async`(
        priority: TaskPriority? = nil,
        @_implicitSelfCapture execute work: @escaping @Sendable () async throws -> Output
    ) -> Future<Output, Failure> where Failure == Error {
        self.init { fulfill in
            Task.detached(priority: priority) {
                do {
                    let res = try await work()
                    fulfill(.success(res))
                } catch {
                    fulfill(.failure(error))
                }
            }
        }
    }
    
    public static func just(_ value: Result<Output, Failure>) -> Self {
        Self { $0(value) }
    }
    
    public func sinkResult(
        _ receiveCompletion: @escaping (Result<Output, Failure>) -> Void
    ) -> AnyCancellable {
        self.sink {
            switch $0 {
            case .finished: break
            case .failure(let error): receiveCompletion(.failure(error))
            }
        } receiveValue: { receiveCompletion(.success($0)) }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Future where Output == Void {
    public static func perform(_ action: @escaping () -> Void) -> Self {
        Self { $0(.success(action())) }
    }
    public static func perform<S: Scheduler>(
        on scheduler: S,
        options: S.SchedulerOptions? = nil,
        _ action: @escaping () -> Void
    ) -> Self {
        Self { fulfill in
            scheduler.schedule(options: options) { fulfill(.success(action())) }
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Future where Output == Void, Failure == Never {
    public static func Error(_ action: @escaping () -> Void) -> Self {
        Self { $0(.success(action())) }
    }
    public static func perform<S: Scheduler>(
        on scheduler: S,
        options: S.SchedulerOptions? = nil,
        _ action: @escaping () -> Void
    ) -> Self {
        Self { fulfill in
            scheduler.schedule(options: options) { fulfill(.success(action())) }
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Future where Output == Void, Failure == Error {
    public static func perform(_ action: @escaping () -> Void) -> Self {
        Self { $0(.success(action())) }
    }
    public static func perform(_ action: @escaping () throws -> Void) -> Self {
        Self {
            do {
                $0(.success(try action()))
            } catch {
                $0(.failure(error))
            }
        }
    }
    public static func perform<S: Scheduler>(
        on scheduler: S,
        _ action: @escaping () throws -> Void
    ) -> Self {
        Self { fulfill in
            scheduler.schedule {
                do {
                    fulfill(.success(try action()))
                } catch {
                    fulfill(.failure(error))
                }
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Future where Failure == Error {
    @_disfavoredOverload
    public convenience init(_ attemptToFulfill: @escaping (Promise) throws -> Void) {
        self.init {
            do {
                try attemptToFulfill($0)
            } catch {
                $0(.failure(error))
            }
        }
    }
}
#endif
