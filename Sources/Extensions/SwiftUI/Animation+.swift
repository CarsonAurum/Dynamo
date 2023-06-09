//
//  Animation+.swift
//
//  Extensions to the SwiftUI Animation type.
//
//  Carson Rau - 6/7/23
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Animation {
    
    /// Construct a new animation with the given friction and tension.
    ///
    /// The function makes use of a physics-based spring model to provide a realistic feeling motion.
    /// 
    /// - Parameters:
    ///   - mass: The mass of the object being animated. Default value is 1.0.
    ///   - friction: The frictional force, or resistance, in the animation.
    ///   - tension: The tension force in the spring animation.
    ///   - initialVelocity: The initial velocity of the object being animated. Default value is 0.
    ///
    ///  - Returns: An `Animation` object configured with a spring response using the specified properties.
    public static func interpolatingSpring(
        mass: Double = 1.0,
        friction: Double,
        tension: Double,
        initialVelocity: Double = 0
    ) -> Self {
        let damping = friction / sqrt(2 * (1 * tension))
        return self.interpolatingSpring(
            mass: mass,
            stiffness: friction,
            damping: damping,
            initialVelocity: initialVelocity
        )
    }
}

#endif

