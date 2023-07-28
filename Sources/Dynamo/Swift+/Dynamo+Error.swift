//
//  Dynamo+Error.swift
//
//
//  Carson Rau - 6/25/23
//

public enum DynamoError: Error {
    case multiplex([Swift.Error])
    case multiplexOptional([Swift.Error?])
}
