//
//  File.swift
//  
//
//  Created by Carson Rau on 6/27/23.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
public struct Stringify: CompilerPlugin {
    public let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        AddDescription.self
    ]
    public init() { }
}
