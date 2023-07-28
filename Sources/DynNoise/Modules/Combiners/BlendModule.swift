//
//  BlendModule.swift
//
//  A module that performs linear interpolation on three base modules.
//
//  Carson Rau - 6/14/23
//

public struct BlendModule<Control: Module, T: Module, U: Module>: Combine3Module {
    public let baseModule: (Control, T, U)
    public init(first: Control, second: T, third: U) {
        self.baseModule = (first, second, third)
    }
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        try linearInterp(
            baseModule.1[x, y, z],
            baseModule.2[x, y, z],
            (baseModule.0[x, y, z] - 1.0) / 2.0
        )
    }
}

extension Module {
    public func blend<T: Module, U: Module>(_ first: T, _ second: U) -> some Module {
        BlendModule(first: self, second: first, third: second)
    }
    public func blend<Control: Module, T: Module>(control: Control, first: T) -> some Module {
        BlendModule(first: control, second: first, third: self)
    }
    public func blend<Control: Module, U: Module>(control: Control, second: U) -> some Module {
        BlendModule(first: control, second: self, third: second)
    }
}

extension Module {
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
}
