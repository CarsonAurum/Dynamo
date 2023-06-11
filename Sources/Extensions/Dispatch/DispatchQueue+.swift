//
//  DispatchQueue+.swift
//
//  Extensions to the Dispatch DispatchQueue type.
//
//  Carson Rau - 6/9/22
//

#if canImport(Dispatch)
import Dispatch

#if canImport(Foundation)
import Foundation
#endif

extension DispatchQueue {
#if canImport(Foundation)
    /// Creates a new instance of a DispatchQueue with a unique label.
    ///
    /// - Parameters:
    ///   - qos: The quality of service (QoS) that you want to assign to tasks that you add to this queue.
    ///   - attributes: The behavior attributes of the queue. Default is an empty array.
    ///   - autoreleaseFrequency: The frequency with which to autorelease objects created by this queue.
    ///   - target: The target dispatch queue to which to submit tasks.
    public convenience init(
        qos: DispatchQoS = .unspecified,
        attributes: DispatchQueue.Attributes = [],
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
        target: DispatchQueue? = nil
    ) {
        self.init(
            label: UUID().uuidString,
            qos: qos,
            attributes: attributes,
            autoreleaseFrequency: autoreleaseFrequency,
            target: target
        )
    }
#endif
    /// Creates a new instance of a DispatchQueue with a unique label (Overload version with QoS class).
    ///
    /// - Parameters:
    ///   - qosClass: The quality-of-service class that determines the priority of tasks in the queue.
    ///   - attributes: The behavior attributes of the queue. Default is an empty array.
    ///   - autoreleaseFrequency: The frequency with which to autorelease objects created by this queue.
    ///   - target: The target dispatch queue to which to submit tasks.
    @_disfavoredOverload
    public convenience init(
        qosClass: DispatchQoS.QoSClass = .unspecified,
        attributes: DispatchQueue.Attributes = [],
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
        target: DispatchQueue? = nil
    ) {
        self.init(
            qos: .init(qosClass: qosClass, relativePriority: 0),
            attributes: attributes,
            autoreleaseFrequency: autoreleaseFrequency,
            target: target
        )
    }
    /// Creates a new instance of a DispatchQueue with a label derived from the input type.
    ///
    /// - Parameters:
    ///   - label: The type to use to create a string label for this queue.
    ///   - qos: The quality of service (QoS) that you want to assign to tasks that you add to this queue.
    ///   - attributes: The behavior attributes of the queue. Default is an empty array.
    ///   - autoreleaseFrequency: The frequency with which to autorelease objects created by this queue.
    ///   - target: The target dispatch queue to which to submit tasks.
    public convenience init<T>(
        label: T.Type,
        qos: DispatchQoS = .unspecified,
        attributes: DispatchQueue.Attributes = [],
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
        target: DispatchQueue? = nil
    ) {
        let labelPrefix = Bundle.current?.bundleIdentifier ?? "us.carsonrau.Dynamo"
        let label = labelPrefix + "." + String(describing: label)
        self.init(
            label: label,
            qos: qos,
            attributes: attributes,
            autoreleaseFrequency: autoreleaseFrequency,
            target: target
        )
    }
    /// Creates a new instance of a DispatchQueue with a label derived from the input type (Overload
    /// version with QoS class).
    ///
    /// - Parameters:
    ///   - label: The type to use to create a string label for this queue.
    ///   - qosClass: The quality-of-service class that determines the priority of tasks in the queue.
    ///   - attributes: The behavior attributes of the queue. Default is an empty array.
    ///   - autoreleaseFrequency: The frequency with which to autorelease objects created by this queue.
    ///   - target: The target dispatch queue to which to submit tasks.
    @_disfavoredOverload
    public convenience init<T>(
        label: T.Type,
        qosClass: DispatchQoS.QoSClass = .unspecified,
        attributes: DispatchQueue.Attributes = [],
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
        target: DispatchQueue? = nil
    ) {
        self.init(
            label: label,
            qos: .init(qosClass: qosClass, relativePriority: 0),
            attributes: attributes,
            autoreleaseFrequency: autoreleaseFrequency,
            target: target
        )
    }
}

extension DispatchQueue {
    /// A boolean value determining whether the current queue is the main queue.
    public var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return Self.getSpecific(key: Static.key) != nil
    }
}


extension DispatchQueue {
    /// Returns a boolean value indicating whether the current dispatch queue is the specified queue.
    ///
    /// - Parameter queue: The queue to compare against.
    /// - Returns: `true` if the current queue matches the specified queue, otherwise `false`.
    public static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }
        return Self.getSpecific(key: key) != nil
    }
    /// Runs a passed closure asynchronously after a certain time interval.
    ///
    /// - Parameters:
    ///   - delay: The time interval after which the closure should be executed.
    ///   - qos: Quality of service at which the work item shoulod be executed.
    ///   - flags: Flags that control the execution environment of the work item.
    ///   - work: The closure to run after certain time interval.
    public func asyncAfter(
        delay: Double,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping () -> Void
    ) {
        self.asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
    /// Adds debouncing behavior.
    ///
    /// Groups multiple consecutive calls to the same operation together, only executing after the delay condition has
    /// been satisfied.
    ///
    /// # Example
    /// Here's how you might use `debounce` to ensure that a search operation isn't performed until 1 second after
    /// the user has stopped typing:
    ///
    ///   ```swift
    ///   let debouncedSearch = debounce(delay: 1.0, action: performSearch)
    ///   searchField.onTextChanged = { searchText in
    ///       debouncedSearch()
    ///   }
    ///   ```
    ///  In this example, performSearch is a function that performs the actual search operation, and debouncedSearch
    ///  is a debounced version of this function that's created by debounce.
    ///
    /// The onTextChanged event is assumed to be an event that's fired every time the text changes
    /// in a hypothetical searchField. By assigning debouncedSearch to this event, we ensure that the search operation
    /// isn't performed more often than once per second, no matter how often the text changes.
    ///
    /// - Parameters:
    ///   - delay: The number of seconds to stall before executing the given work item.
    ///   - queue: The queue on which the work item will be executed.
    ///   - action: The closure to execute.
    /// - Returns: A function debouncing the given work item until the delay condition has been satisfied.
    /// - Important: The closure provided to this function should be a lightweight operation as it will only be executed
    /// once after the delay period. If multiple invocations occur within the delay duration, only the last invocation
    /// will be executed.
    /// - Note: The closure is executed asynchronously after the specified delay on the provided DispatchQueue.
    public func debounce(
        delay: Double,
        queue: DispatchQueue = .main,
        action: @escaping () -> Void
    ) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        var workItem: DispatchWorkItem?
        return {
            let dispatchDelay = DispatchTimeInterval.milliseconds(.init(delay * 1_000))
            workItem?.cancel()
            workItem = .init { action() }
            lastFireTime = DispatchTime.now()
            // swiftlint:disable force_unwrapping
            queue.asyncAfter(deadline: lastFireTime + dispatchDelay, execute: workItem!)
            // swiftlint:enable force_unwrapping
        }
    }
    /// Concurrently performs a task for a specific number of iterations.
    ///
    /// This method applies the `concurrentPerform` function in a synchronous manner on the current DispatchQueue.
    ///
    /// The `concurrentPerform` function executes the given work item the specified number of times and returns after
    /// all work items have completed. The system makes no guarantee about the order in which the work items execute.
    ///
    /// - Parameters:
    ///   - iterations: The number of times to execute the work item.
    ///   - work: The work item to be performed. This closure takes an index as a parameter that indicates the
    ///   current iteration.
    public func concurrentPerform(iterations: Int, execute work: @escaping (Int) -> Void) {
        self.sync { DispatchQueue.concurrentPerform(iterations: iterations, execute: work) }
    }
}

extension DispatchQueue {
    /// Accesses the value for a custom key stored in the Dispatch queue's specific data.
    ///
    /// Use this subscript to get and set values for a specific key in the Dispatch queue.
    /// The keys are defined by you, and must be instances of DispatchSpecificKey.
    ///
    /// The returned value is optional because a custom key may not have been previously set,
    /// or may have been set to nil.
    ///
    /// Example:
    ///
    ///     let myKey = DispatchSpecificKey<Int>()
    ///     myQueue[myKey] = 42
    ///     print(myQueue[myKey])  // Prints Optional(42)
    ///
    /// - Parameter key: The key to get and set in the queue's specific data.
    public subscript<T>(_ key: DispatchSpecificKey<T>) -> T? {
        get { self.getSpecific(key: key) }
        set { self.setSpecific(key: key, value: newValue) }
    }
}
#endif
