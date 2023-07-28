//
//  FloatingPoint++.swift
//  
//
//  Carson Rau - 1/26/22
//

extension FloatingPoint {
    /// Converts a value in degrees to its equivalent in radians.
    ///
    /// This computed property is an extension of the `FloatingPoint` protocol.
    /// The value in degrees to be converted is provided as `self` which can be called on any value
    /// conforming to the `FloatingPoint` protocol.
    ///
    /// - Returns: The value in radians, as a `FloatingPoint`.
    ///
    /// This function does not throw errors, but the result can be `NaN` or `inf` if `self`
    /// is not a valid numerical value.
    ///
    /// # Example
    ///
    /// ```swift
    /// let degrees = 180.0
    /// let radians = degrees.degreesToRadian
    /// print(radians) // prints '3.141592653589793'
    /// ```
    public var degreesToRadian: Self {
        .pi * self / .init(180)
    }
}

extension FloatingPoint {
    // swiftlint:disable identifier_name
    /// Computes the square root of a value.
    ///
    /// This function is an extension of the `FloatingPoint` protocol.
    ///
    /// - Parameter value: The `FloatingPoint` value of which the square root is to be calculated.
    ///
    /// - Returns: The square root of `value` as a `FloatingPoint`.
    ///
    /// # Example
    ///
    /// ```swift
    /// let value = 9.0
    /// let sqrtValue = √value
    /// print(sqrtValue) // prints '3.0'
    /// ```
    public static prefix func √ (value: Self) -> Self {
        value.squareRoot()
    }
    // swiftlint:enable identifier_name
    /// Computes the truncating remainder of a division operation.
    ///
    /// This function is an extension of the `FloatingPoint` protocol.
    ///
    /// - Parameter lhs: The dividend, which is a `FloatingPoint` value.
    /// - Parameter rhs: The divisor, which is a `FloatingPoint` value.
    ///
    /// - Returns: The remainder of `lhs` divided by `rhs` as a `FloatingPoint`.
    ///
    /// # Example
    ///
    /// ```swift
    /// let lhs = 10.0
    /// let rhs = 3.0
    /// let remainder = lhs % rhs
    /// print(remainder) // prints '1.0'
    /// ```
    public static func % (lhs: Self, rhs: Self) -> Self {
        lhs.truncatingRemainder(dividingBy: rhs)
    }
}
