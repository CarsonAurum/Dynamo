//
//  Macros.swift
//
//  Definitions for custom macros to bring into new projects.
//
//  Carson Rau - 6/27/23
//

@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String)
    = #externalMacro(module: "MacroImplementations", type: "StringifyMacro")
