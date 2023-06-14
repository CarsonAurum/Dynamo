import XCTest
@testable import DynNoise

public class TestClass: XCTestCase {
    public func test() {
        let module = ConstantModule(value: 25)  // 25
            .max {
                ConstantModule(value: 15)       // 34
                    .add(3)
                    .multiply(3)
                    .subtract(20)
            }                                   // 34
            .subtract(5)
        do {
            try print(module[0, 0, 0])              // 29
        } catch { }
    }
}
