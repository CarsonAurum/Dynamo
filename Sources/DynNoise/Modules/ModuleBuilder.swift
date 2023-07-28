//
//  ModuleBuilder.swift
//
//  Helpers to allow construction of complex modules.
//
//  Carson Rau - 6/13/23
//

import Dynamo

/// A closure to create a module.QDA
public typealias ModuleBuilder<T: Module> = () -> T
