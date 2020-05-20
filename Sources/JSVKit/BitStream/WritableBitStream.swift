//
//  File.swift
//  
//
//  Created by Jan Svensson on 2020-05-18.
//

import Foundation
import simd

public struct WritableBitStream {
    public var bytes = [UInt8]()
    public var endBitIndex = 0
    
    public init() {}
    
    mutating private func appendBit(_ value: UInt8) {
        let bitShift = endBitIndex % 8
        let byteIndex = endBitIndex / 8
        if bitShift == 0 {
            bytes.append(UInt8(0))
        }

        bytes[byteIndex] |= UInt8(value << bitShift)
        endBitIndex += 1
    }
    
    mutating private func align() {
        // skip over any remaining bits in the current byte
        endBitIndex = bytes.count * 8
    }
    
    mutating public func appendBool(_ value: Bool) {
        appendBit(UInt8(value ? 1 : 0))
    }
    
    mutating public func appendUInt32(_ value: UInt32) {
        appendUInt32(value, numberOfBits: value.bitWidth)
    }

    mutating public func appendUInt32(_ value: UInt32, numberOfBits: Int) {
        var tempValue = value
        for _ in 0..<numberOfBits {
            appendBit(UInt8(tempValue & 1))
            tempValue >>= 1
        }
    }
    
    mutating public func appendEnum<T>(_ value: T) where T: CaseIterable & RawRepresentable, T.RawValue == UInt32 {
        appendUInt32(value.rawValue, numberOfBits: type(of: value).bits)
    }

    mutating public func appendFloat(_ value: Float) {
        appendUInt32(value.bitPattern)
    }
    mutating public func appendString(_ value: String) {
        for char in value {
            bytes.append(char.asciiValue!)
            endBitIndex += 8
        }
    }

    mutating public func append(_ value: Data) {
        align()
        let length = UInt32(value.count)
        appendUInt32(length)
        bytes.append(contentsOf: value)
        endBitIndex += Int(length * 8)
    }
    
    public func packData() -> Data {
        let endBitIndex32 = UInt32(endBitIndex)
        let endBitIndexBytes = [UInt8(truncatingIfNeeded: endBitIndex32),
                                UInt8(truncatingIfNeeded: endBitIndex32 >> 8),
                                UInt8(truncatingIfNeeded: endBitIndex32 >> 16),
                                UInt8(truncatingIfNeeded: endBitIndex32 >> 24)]
        return Data(endBitIndexBytes + bytes)
    }
}
