//
//  DispatchQoS.QoSClass+.swift
//
//
//  Created by Carson Rau on 6/9/23.
//

#if canImport(Dispatch)
import Dispatch

#if canImport(Foundation)
import Foundation
#endif

extension DispatchQoS.QoSClass {
    public static var current: Self {
        Self(rawValue: qos_class_self()) ?? .unspecified
    }
    
    #if canImport(Foundation)
    public init(qos: QualityOfService) {
        switch qos {
        case .userInteractive:
            self = .userInteractive
        case .userInitiated:
            self = .userInitiated
        case .utility:
            self = .utility
        case .background:
            self = .background
        case .default:
            self = .default
        @unknown default:
            self = .default
        }
    }
    #endif
}
#endif
