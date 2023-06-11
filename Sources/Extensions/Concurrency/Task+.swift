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
