//
//  UInt++.swift
//
//
//  Created by Carson Rau on 6/28/23.
//

extension UInt8 {
    public func compact(with second: Self) -> UInt16 {
        UInt16(self) << 8 | UInt16(second)
    }
}

extension UInt16 {
    public func expand() -> (UInt8, UInt8) {
        (UInt8(self >> 8), UInt8(self & 0xFF))
    }
    public func compact(with second: Self) -> UInt32 {
        UInt32(self) << 16 | UInt32(second)
    }
}

extension UInt32 {
    public func expand() -> (UInt16, UInt16) {
       (UInt16(self >> 16), UInt16(self & 0xFFFF))
    }
    public func compact(with second: Self) -> UInt64 {
        UInt64(self) << 32 | UInt64(second)
    }
}

extension UInt64 {
    public func expand() -> (UInt32, UInt32) {
        (UInt32(self >> 32), UInt32(self & 0xFFFFFFFF))
    }
}
