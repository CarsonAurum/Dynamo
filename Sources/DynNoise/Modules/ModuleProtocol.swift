//
//  ModuleProtocol.swift
//
//
//  Carson Rau - 6/13/23
//

/// A parent protocol representing any kind of Module.
///
/// This type should be used to add extensions that are applicable to all kinds of modules.
public protocol Module {
    /// Access the value computed by this module.
    ///
    /// - Parameters:
    ///   - x: The x value for the point whose noise value should be returned.
    ///   - y: The y value for the point whose noise value should be returned.
    ///   - z: The z value for the point whose noise value should be returned.
    /// - Returns: The computed noise value for the given 3 dimensional point.
    /// - Throws: Any errors thrown by the computation of the noise value.
    func getValue(x: Double, y: Double, z: Double) throws -> Double
}

extension Module {
    /// A shorthand subscript to access the value computed by this module.
    /// 
    /// - Parameters:
    ///   - x: The x value for the point whose noise value should be returned.
    ///   - y: The y value for the point whose noise value should be returned.
    ///   - z: The z value for the point whose noise value should be returned.
    /// - Returns: The computed noise value for the given 3 dimensional point.
    /// - Throws: Any errors thrown by the computation of the noise value.
    public subscript(x: Double, y: Double, z: Double) -> Double {
        get throws { try self.getValue(x: x, y: y, z: z) }
    }
}

/// A protocol representing a module that generates values without reliance on any other Module.
public protocol SourceModule: Module { }

/// A protocol representing a module that generates values by modifying the result of another Module.
public protocol ModifierModule: Module {
    /// The module from which this modifier draws its base value.
    associatedtype BaseModule
    /// A container for the underlying source module.
    ///
    /// This should not be mutable.
    var baseModule: BaseModule { get }
    /// Construct a new modifier by providing the underlying source module.
    ///
    /// - Parameter base: The module from which this modifier draws its base value.
    init(_ base: BaseModule)
}

/// A protocol representing a module that generates values by combining the values of two other modules.
public protocol Combine2Module: Module {
    /// The first module from which this modifier draws its base value.
    associatedtype Base1Module
    /// The second module from which this modifier draws its base value.
    associatedtype Base2Module
    /// A container for the underlying source modules.
    ///
    /// This should not be mutable.
    var baseModule: (Base1Module, Base2Module) { get }
    /// Construct a new modifier by providing the underlying source modules.
    ///
    /// - Parameters:
    ///   - first: The first module from which this modifier draws its base value.
    ///   - second: The second module from which this modifier draws its base value.
    init(first: Base1Module, second: Base2Module)
}

/// A protocol representing a module that generates values by combining the values of three other modules.
public protocol Combine3Module: Module {
    /// The first module from which this modifier draws its base value.
    associatedtype Base1Module
    /// The second module from which this modifier draws its base value.
    associatedtype Base2Module
    /// The third module from which this modifier draws its base value.
    associatedtype Base3Module
    /// A container for the underlying source modules.
    ///
    /// This should not be mutable.
    var baseModule: (Base1Module, Base2Module, Base3Module) { get }
    /// Construct a new modifier by providing the underlying source modules.
    ///
    /// - Parameters:
    ///   - first: The first module from which this modifier draws its base value.
    ///   - second: The second module from which this modifier draws its base value.
    ///   - third: The third module from which this modifier draws its base value.
    init(first: Base1Module, second: Base2Module, third: Base3Module)
}

/// A protocol representing a module that generates values by combining the values of four other modules.
public protocol Combine4Module: Module {
    /// The first module from which this modifier draws its base value.
    associatedtype Base1Module
    /// The second module from which this modifier draws its base value.
    associatedtype Base2Module
    /// The third module from which this modifier draws its base value.
    associatedtype Base3Module
    /// The fourth module from which this modifier draws its base value.
    associatedtype Base4Module
    /// A container for the underlying source modules.
    ///
    /// This should not be mutable.
    var baseModule: (Base1Module, Base2Module, Base3Module, Base4Module) { get }
    /// Construct a new modifier by providing the underlying source modules.
    ///
    /// - Parameters:
    ///   - first: The first module from which this modifier draws its base value.
    ///   - second: The second module from which this modifier draws its base value.
    ///   - third: The third module from which this modifier draws its base value.
    ///   - fourth: The fourth module from which this modifier draws its base value.
    init(first: Base1Module, second: Base2Module, third: Base3Module, fourth: Base4Module)
}
