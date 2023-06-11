//
//  Task+.swift
//
//  Extensions to the Swift _Concurrency Task type.
//
//  Carson Rau - 6/9/23
//

#if canImport(_Concurrency)
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Task {
    /// Runs given tasks concurrently, and returns the result of the first one that completes successfully.
    ///
    /// This function accepts an array of tasks. Each task is a function that returns a result of type
    /// `R` or throws an error. All tasks are started in a new `TaskGroup`. The function waits for
    /// the first task to complete successfully, then cancels all the remaining tasks and returns the
    /// result of the completed task.
    ///
    /// If all tasks fail, this function throws the error from one of the tasks.
    ///
    /// - Parameter tasks: An array of asynchronous functions that can throw errors.
    /// Each function must return a value of type `R`.
    /// - Returns: The result of the first task that completes successfully. If no tasks complete
    /// successfully, the function returns `nil`.
    /// - Throws: If all tasks throw an error, the function throws one of the errors.
    public static func firstResult<R: Sendable>(
        from tasks: [@Sendable () async throws -> R]
    ) async throws -> R? {
        try await withThrowingTaskGroup(of: R.self) {
            for task in tasks {
                $0.addTask { try await task() }
            }
            let result = try await $0.next()
            $0.cancelAll()
            return result
        }
    }
    /// Runs given tasks concurrently, and returns the result of the first one that completes successfully.
    ///
    /// This function accepts an array of `Task` objects. Each `Task` represents an asynchronous
    /// operation that produces a result of type `R` or throws an error.
    ///
    /// All tasks are added to a new `TaskGroup`. The function waits for the first task to complete successfully,
    /// then cancels all the remaining tasks and returns the result of the completed task.
    ///
    /// If all tasks fail, this function throws the error from one of the tasks.
    ///
    /// - Parameter tasks: An array of `Task` objects. Each task produces a result of type `R` or throws an error.
    /// - Returns: The result of the first task that completes successfully. If no tasks complete successfully,
    ///  the function returns `nil`.
    /// - Throws: If all tasks throw an error, the function throws one of the errors.
    public static func firstResult<R: Sendable>(
        from tasks: [Task<R, Error>]
    ) async throws -> R? {
        try await withThrowingTaskGroup(of: R.self) {
            for task in tasks { $0.addTask {
                try await withTaskCancellationHandler { try await task.value }
                onCancel: { task.cancel() }
            }}
            let result = try await $0.next()
            $0.cancelAll()
            return result
        }
    }
}

#endif
