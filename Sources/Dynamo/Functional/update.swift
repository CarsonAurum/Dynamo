//
//  update.swift
//
//
//  Carson Rau on 3/2/22
//

/// Performs a function with a given value and returns the result.
///
/// - Parameters:
///     - val: The value to be used in the function.
///     - fn: The function to perform.
///
/// - Returns: The result of the function.
///
/// # Usage:
///
/// ```swift
/// let result = with(5, { $0 * $0 }) // returns 25
/// ```
@discardableResult
public func with <A, B>(_ val: A, _ fn: @escaping (A) -> B) -> B {
    fn(val)
}
/// Updates a value by performing a series of transformations defined by functions.
///
/// - Parameters:
///     - value: The value to be updated.
///     - fns: The transformation functions.
///
/// # Usage:
///
/// ```swift
/// var number = 5
/// update(&number, { $0 += 1 }, { $0 *= 2 }) // number becomes 12
/// ```
public func update<A>(_ value: inout A, _ fns: (inout A) -> Void...) {
    fns.forEach { $0(&value) }
}
/// Updates a value by performing a series of transformations defined by functions, and returns the updated value.
///
/// - Parameters:
///     - value: The value to be updated.
///     - fns: The transformation functions.
///
/// - Returns: The updated value.
///
/// # Usage:
///
/// ```swift
/// let number = 5
/// let result = update(number, { $0 += 1 }, { $0 *= 2 }) // returns 12
/// ```
public func update<A>(_ value: A, _ fns: (inout A) -> Void...) -> A {
    var value = value
    fns.forEach { $0(&value) }
    return value
}
/// Updates an object by performing a series of transformations defined by functions, and returns the updated object.
///
/// - Parameters:
///     - value: The object to be updated.
///     - fns: The transformation functions.
///
/// - Returns: The updated object.
///
/// # Usage:
///
/// ```swift
/// let label = UILabel()
/// let updatedLabel = updateObject(label, { $0.text = "Updated" }) // label's text is now "Updated"
/// ```
public func updateObject<A: AnyObject>(_ value: A, _ fns: (A) -> Void...) -> A {
    fns.forEach { $0(value) }
    return value
}

// MARK: - Operators


// MARK: Single
/// Updates a value by performing a transformation defined by a function, and returns the updated value.
///
/// - Parameters:
///     - val: The value to be updated.
///     - fn: The transformation function.
///
/// - Returns: The updated value.
///
/// # Usage:
///
/// ```swift
/// let result = 5 |> { $0 += 1; $0 *= 2 } // returns 12
/// ```
public func |> <A>(_ val: A, _ fn: @escaping (inout A) -> Void) -> A {
   update(val, fn)
}
/// Updates a value by performing a transformation defined by a function.
///
/// - Parameters:
///     - val: The value to be updated.
///     - fn: The transformation function.
///
/// # Usage:
///
/// ```swift
/// var number = 5
/// number |> { $0 += 1; $0 *= 2 } // number becomes 12
/// ```
public func |> <A>(_ val: inout A, _ fn: @escaping (inout A) -> Void) {
    update(&val, fn)
}
/// Updates an object by performing a transformation defined by a function, and returns the updated object.
///
/// - Parameters:
///     - val: The object to be updated.
///     - fn: The transformation function.
///
/// - Returns: The updated object.
///
/// # Usage:
///  
/// ```swift
/// let label = UILabel()
/// let updatedLabel = label |> { $0.text = "Updated" } // label's text is now "Updated"
/// ```
public func |> <A: AnyObject>(_ val: A, _ fn: @escaping (A) -> Void) -> A {
    updateObject(val, fn)
}
/// Performs a function with a given value and returns the result.
///
/// - Parameters:
///     - val: The value to be used in the function.
///     - fn: The function to perform.
///
/// - Returns: The result of the function.
///
/// # Usage:
///
/// ```swift
/// let result = 5 |> { $0 * $0 } // returns 25
/// ```
@discardableResult
public func |> <A, B>(_ val: A, _ fn: @escaping (A) -> B) -> B {
    with(val, fn)
}
