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
    /// - Parameters:
    ///   - priority: An optionally specified priority that the given work will execute under.
    ///   - work: An asynchronous workload capable of producing an output.
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
    /// - Parameters:
    ///   - priority: An optionally specified priority that the given work will execute under.
    ///   - work: An asynchronous throwing workload capable of producing an output.
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
    
    /// Construct a new future to return the given result.
    ///
    /// - Parameter value: The value to wrap within the newly constructed future.
    /// - Returns: The newly constructed future.
    public static func just(_ value: Result<Output, Failure>) -> Self {
        Self { $0(value) }
    }
    
    /// Attach a new result-based completion handler to this future.
    ///
    /// - Parameter receiveCompletion: The completion to execute once the future is fulfilled.
    /// - Returns: The type-erased cancellable object containing the newly attached handler.
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
    
    /// Perform a new action once this future is fulfilled.
    ///
    /// - Parameter action: The action to perform when this future is fulfilled.
    /// - Returns: The future containing the newly attached handler.
    public static func perform(_ action: @escaping () -> Void) -> Self {
        Self { $0(.success(action())) }
    }
    
    /// Perform a new action once this future is fulfilled within the context of the given scheduler.
    ///
    /// - Parameters:
    ///   - scheduler: The scheduler to use when executing the given action.
    ///   - options: The scheduler options to use when executing the given action.
    ///   - action: The action to perform when this future is fulfilled.
    /// - Returns: The future containing the newly attached handler.
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
    
    /// Creates a new `Future` that completes with a success after executing the provided closure.
    ///
    /// This method can be useful when you need to wrap synchronous, non-failing work into a `Future`.
    ///
    /// Usage:
    ///
    ///     let future = Future<Void, Never>.Error {
    ///         print("This runs immediately!")
    ///     }
    ///
    /// - Parameter action: A closure that performs work without any input.
    /// - Returns: A `Future` that represents the completion of the work.
    
    public static func Error(_ action: @escaping () -> Void) -> Self {
        Self { $0(.success(action())) }
    }
    
    /// Schedules the execution of a closure on a specified `Scheduler`, and returns a new `Future` that completes
    /// with a success after the closure has been executed.
    ///
    /// This method can be useful when you need to perform non-failing work on a specific queue or in a specific context.
    ///
    /// Usage:
    ///
    ///     let future = Future<Void, Never>.perform(on: DispatchQueue.main) {
    ///         print("This runs on the main queue!")
    ///     }
    ///
    /// - Parameters:
    ///   - scheduler: The scheduler on which to perform the work.
    ///   - options: Scheduler options to customize the execution of the closure. Defaults to `nil`.
    ///   - action: A closure that performs work without any input.
    /// - Returns: A `Future` that represents the completion of the work.
    
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
    
    /// Creates a new `Future` that completes with a success after executing the provided closure.
    ///
    /// This method can be useful when you need to wrap synchronous, non-throwing work into a `Future`.
    ///
    /// Usage:
    ///
    ///     let future = Future<Void, Error>.perform {
    ///         print("This runs immediately!")
    ///     }
    ///
    /// - Parameter action: A closure that performs work without any input.
    /// - Returns: A `Future` that represents the completion of the work.
    
    public static func perform(_ action: @escaping () -> Void) -> Self {
        Self { $0(.success(action())) }
    }
    
    /// Creates a new `Future` that completes with a success after executing the provided closure, or fails if the closure throws an error.
    ///
    /// This method can be useful when you need to wrap synchronous, potentially throwing work into a `Future`.
    ///
    /// Usage:
    ///
    ///     let future = Future<Void, Error>.perform {
    ///         if someCondition {
    ///             throw SomeError()
    ///         }
    ///     }
    ///
    /// - Parameter action: A closure that performs work without any input and can throw an error.
    /// - Returns: A `Future` that represents the completion of the work, or the error thrown.
    
    public static func perform(_ action: @escaping () throws -> Void) -> Self {
        Self {
            do {
                $0(.success(try action()))
            } catch {
                $0(.failure(error))
            }
        }
    }
    
    /// Schedules the execution of a potentially throwing closure on a specified `Scheduler`, and returns a new `Future` that completes with a success after the closure has been executed, or fails if the closure throws an error.
    ///
    /// This method can be useful when you need to perform potentially throwing work on a specific queue or in a specific context.
    ///
    /// Usage:
    ///
    ///     let future = Future<Void, Error>.perform(on: DispatchQueue.main) {
    ///         if someCondition {
    ///             throw SomeError()
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - scheduler: The scheduler on which to perform the work.
    ///   - action: A closure that performs work without any input and can throw an error.
    /// - Returns: A `Future` that represents the completion of the work, or the error thrown.
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
    
    /// Construct a new future capable of handling a throwing closure.
    ///
    /// - Parameter attemptToFulfill: The throwing closure to execute when fulfilling this promise.
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
