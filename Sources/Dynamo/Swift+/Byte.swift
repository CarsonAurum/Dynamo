//
//  Byte.swift
//
//  C-Style naming conventions for small data units.
//
//  Carson Rau - 3/25/22
//

/// A typealias for "bytes", as used in other C-based programming lanaguages.
public typealias Byte = UInt8

/// A typealias for the native word on this platform, as used in other C-based programming languages.
public typealias NativeWord = Int

/// A typealias for an unsafe pointer to a native word on this platform, as used in other C-based programming languages.
public typealias NativeWordPointer = UnsafePointer<NativeWord>
