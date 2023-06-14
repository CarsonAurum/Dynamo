//
//  ModuleBuilder.swift
//
//  Helpers to allow construction of complex modules.
//
//  Carson Rau - 6/13/23
//

import Dynamo

/// A closure to create a module.
public typealias ModuleBuilder<T: Module> = () -> T

// MARK: Generics
extension Module {
    /// Construct a module that adds this module and another module together.
    ///
    /// - Parameter lhs: The module to add.
    /// - Returns: A composite module that will compute the added value of the two child modules.
    public func add<T: Module>(_ lhs: T) -> some Module {
        AddModule(first: self, second: lhs)
    }
    public func blend<T: Module, U: Module>(_ first: T, _ second: U) -> some Module {
        BlendModule(first: self, second: first, third: second)
    }
    public func blend<Control: Module, T: Module>(control: Control, first: T) -> some Module {
        BlendModule(first: control, second: first, third: self)
    }
    public func blend<Control: Module, U: Module>(control: Control, second: U) -> some Module {
        BlendModule(first: control, second: self, third: second)
    }
    public func clamp<T: Module, U: Module>(lower: T, upper: U) -> some Module {
        ClampedModule(first: self, second: lower, third: upper)
    }
    /// Construct a module that determines the maximum between this module and another module.
    ///
    /// - Parameter lhs: The module to compare against.
    /// - Returns: A composite module that will compute the maximum value of the two child modules.
    public func max<T: Module>(_ lhs: T) -> some Module {
        MaxModule(first: self, second: lhs)
    }
    /// Construct a module that determines the minimum between this module and another module.
    ///
    /// - Parameter lhs: The module to compare against.
    /// - Returns: A composite module that will compute the minimum value of the two child modules.
    public func min<T: Module>(_ lhs: T) -> some Module {
        MinModule(first: self, second: lhs)
    }
    public func multiply<T: Module>(_ lhs: T) -> some Module {
        MultiplyModule(first: self, second: lhs)
    }
    public func subtract<T: Module>(_ lhs: T) -> some Module {
        SubtractModule(first: self, second: lhs)
    }
}

// MARK: Builders
extension Module {
    /// Construct a module that adds this module and another module together.
    ///
    /// - Parameter fn: A closure to evaluate when computing the second module in the add operation.
    /// - Returns: A composite module that will compute the added value of the two child modules.
    public func add<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.add(fn())
    }
    public func blend<T: Module, U: Module>(
        first: @escaping ModuleBuilder<T>,
        second: @escaping ModuleBuilder<U>
    ) -> some Module {
        self.blend(first(), second())
    }
    public func blend<Control: Module, T: Module>(
        control: @escaping ModuleBuilder<Control>,
        first: @escaping ModuleBuilder<T>
    ) -> some Module {
        self.blend(control: control(), first: first())
    }
    public func blend<Control: Module, U: Module>(
        control: @escaping ModuleBuilder<Control>,
        second: @escaping ModuleBuilder<U>
    ) -> some Module {
        self.blend(control: control(), second: second())
    }
    public func clamp<T: Module, U: Module>(
        lower: @escaping ModuleBuilder<T>,
        upper: @escaping ModuleBuilder<U>
    ) -> some Module {
        self.clamp(lower: lower(), upper: upper())
    }
    /// Construct a module that determines the maximum between this module and another module.
    ///
    /// - Parameter fn: A closure to evaluate when computing the second module in the max operation.
    /// - Returns: A composite module that will compute the maximum value of the two child modules.
    public func max<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.max(fn())
    }
    /// Construct a module that determines the minimum between this module and another module.
    ///
    /// - Parameter fn: A closure to evaluate when computing the second module in the min operation.
    /// - Returns: A composite module that will compute the minimum value of the two child modules.
    public func min<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.min(fn())
    }
    public func multiply<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.multiply(fn())
    }
    public func subtract<T: Module>(_ fn: @escaping ModuleBuilder<T>) -> some Module {
        self.subtract(fn())
    }
}

// MARK: Convenience
extension Module {
    public func add(_ lhs: Double) -> some Module {
        self.add(ConstantModule(value: lhs))
    }
    public func add(_ lhs: Int) -> some Module {
        self.add(.init(lhs))
    }
    public func max(_ lhs: Double) -> some Module {
        self.max(ConstantModule(value: lhs))
    }
    public func max(_ lhs: Int) -> some Module {
        self.max(.init(lhs))
    }
    public func min(_ lhs: Double) -> some Module {
        self.min(ConstantModule(value: lhs))
    }
    public func min(_ lhs: Int) -> some Module {
        self.min(.init(lhs))
    }
    public func multiply(_ lhs: Double) -> some Module {
        self.multiply(ConstantModule(value: lhs))
    }
    public func multiply(_ lhs: Int) -> some Module {
        self.multiply(.init(lhs))
    }
    public func subtract(_ lhs: Double) -> some Module {
        self.subtract(ConstantModule(value: lhs))
    }
    public func subtract(_ lhs: Int) -> some Module {
        self.subtract(.init(lhs))
    }
}
