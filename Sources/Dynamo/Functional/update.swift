//
//  update.swift
//
//
//  Carson Rau on 3/2/22
//

@discardableResult
public func with <A, B>(_ val: A, _ fn: @escaping (A) -> B) -> B {
    fn(val)
}
public func update<A>(_ value: inout A, _ fns: (inout A) -> Void...) {
    fns.forEach { $0(&value) }
}
public func update<A>(_ value: A, _ fns: (inout A) -> Void...) -> A {
    var value = value
    fns.forEach { $0(&value) }
    return value
}
public func updateObject<A: AnyObject>(_ value: A, _ fns: (A) -> Void...) -> A {
    fns.forEach { $0(value) }
    return value
}

// MARK: - Operators


// MARK: Single
public func |> <A>(_ val: A, _ fn: @escaping (inout A) -> Void) -> A {
   update(val, fn)
}
public func |> <A>(_ val: inout A, _ fn: @escaping (inout A) -> Void) {
    update(&val, fn)
}
public func |> <A: AnyObject>(_ val: A, _ fn: @escaping (A) -> Void) -> A {
    updateObject(val, fn)
}
@discardableResult
public func |> <A, B>(_ val: A, _ fn: @escaping (A) -> B) -> B {
    with(val, fn)
}
