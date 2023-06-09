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
    /// - Parameters:
    ///   - mass: The mass to associate with the body within this animation.
    ///   - friction: The friction to associate with this spring animation.
    ///   - tension: The tension to associate with this spring animation.
    ///   - initialVelocity: The initial velocity to assign to this animation.
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

