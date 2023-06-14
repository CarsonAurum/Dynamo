//
//  curry.swift
//  
//
//  Carson Rau - 10/17/22
//

// swiftlint:disable identifier_name

/// Curry function that converts a two-argument function into a function that takes its arguments one at a time.
///
/// `curry` takes a function `(A1, A2) -> R` and turns it into a function `(A1) -> (A2) -> R`
/// This allows you to pass in arguments one at a time.
///
/// Example:
/// ```swift
/// let add = { (a: Int, b: Int) in a + b }
/// let curriedAdd = curry(add)
/// let addTwo = curriedAdd(2)
/// print(addTwo(3))  // Output: 5
/// ```
///
/// - Parameter function: The function to curry.
/// - Returns: A curried version of the given function.
public func curry <A1, A2, R> (
    _ function: @escaping (A1, A2) -> R
) -> (A1) -> (A2) -> R {
   { a in { function(a, $0) } }
}
/// Curry function that converts a three-argument function into a function that takes its arguments one at a time.
///
/// `curry` takes a function `(A1, A2, A3) -> R` and turns it into a function `(A1) -> (A2) -> (A3) -> R`
/// This allows you to pass in arguments one at a time.
///
/// Example:
/// ```swift
/// let add = { (a: Int, b: Int, c: Int) in a + b + c }
/// let curriedAdd = curry(add)
/// let addTwo = curriedAdd(2)
/// let addTwoAndThree = addTwo(3)
/// print(addTwoAndThree(4))  // Output: 9
/// ```
///
/// - Parameter function: The function to curry.
/// - Returns: A curried version of the given function.
public func curry <A1, A2, A3, R> (
    _ function: @escaping (A1, A2, A3) -> R
) -> (A1) -> (A2) -> (A3) -> R {
   { a in { b in { function(a, b, $0) } } }
}
/// Curry function that converts a four-argument function into a function that takes its arguments one at a time.
///
/// `curry` takes a function `(A1, A2, A3, A4) -> R` and turns it into a function `(A1) -> (A2) -> (A3) -> (A4) -> R`
/// This allows you to pass in arguments one at a time.
///
/// Example:
/// ```swift
/// let add = { (a: Int, b: Int, c: Int, d: Int) in a + b + c + d }
/// let curriedAdd = curry(add)
/// let addTwo = curriedAdd(2)
/// let addTwoAndThree = addTwo(3)
/// let addTwoThreeAndFour = addTwoAndThree(4)
/// print(addTwoThreeAndFour(5))  // Output: 14
/// ```
///
/// - Parameter function: The function to curry.
/// - Returns: A curried version of the given function.
public func curry <A1, A2, A3, A4, R> (
    _ function: @escaping (A1, A2, A3, A4) -> R
) -> (A1) -> (A2) -> (A3) -> (A4) -> R {
   { a in { b in { c in { function(a, b, c, $0) } } } }
}

// swiftlint:enable identifier_name
