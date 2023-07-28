//
//  File.swift
//  
//
//  Created by Carson Rau on 6/27/23.
//

public protocol LogEncoder {
    associatedtype Output
    func encode<T: Encodable>(_ value: T) throws -> Output
}
