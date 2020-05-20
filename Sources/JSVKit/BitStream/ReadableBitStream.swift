//
//  File.swift
//  
//
//  Created by Jan Svensson on 2020-05-18.
//

import Foundation
import simd

public struct ReadableBitStream {
    public var bytes = [UInt8]()
    public var endBitIndex: Int
    public var currentBit = 0
    public var isAtEnd: Bool { return currentBit == endBitIndex }
    
    public init(data: Data) {
        var bytes = [UInt8](data)

        if bytes.count < 4 {
            fatalError("failed to init bitstream")
        }

        var endBitIndex32 = UInt32(bytes[0])
        endBitIndex32 |= (UInt32(bytes[1]) << 8)
        endBitIndex32 |= (UInt32(bytes[2]) << 16)
        endBitIndex32 |= (UInt32(bytes[3]) << 24)
        endBitIndex = Int(endBitIndex32)

        bytes.removeSubrange(0...3)
        self.bytes = bytes
    }

    // MARK: - Read
    mutating public func readBool() throws -> Bool {
        if currentBit >= endBitIndex {
            throw BitStreamError.tooShort
        }
        return (readBit() > 0) ? true : false
    }

    mutating public func readFloat() throws -> Float {
        var result: Float = 0.0
        do {
            result = try Float(bitPattern: readUInt32())
        } catch let error {
            throw error
        }
        return result
    }

    mutating public func readUInt32() throws -> UInt32 {
        var result: UInt32 = 0
        do {
            result = try readUInt32(numberOfBits: UInt32.bitWidth)
        } catch let error {
            throw error
        }
        return result
    }

    mutating public func readUInt32(numberOfBits: Int) throws -> UInt32 {
        if currentBit + numberOfBits > endBitIndex {
            throw BitStreamError.tooShort
        }

        var bitPattern: UInt32 = 0
        for index in 0..<numberOfBits {
            bitPattern |= (UInt32(readBit()) << index)
        }

        return bitPattern
    }

    mutating public func readData() throws -> Data {
        align()
        let length = Int(try readUInt32())
        assert(currentBit % 8 == 0)
        guard currentBit + (length * 8) <= endBitIndex else {
            throw BitStreamError.tooShort
        }
        let currentByte = currentBit / 8
        let endByte = currentByte + length

        let result = Data(bytes[currentByte..<endByte])
        currentBit += length * 8
        return result
    }

    mutating public func readEnum<T>() throws -> T where T: CaseIterable & RawRepresentable, T.RawValue == UInt32 {
        let rawValue = try readUInt32(numberOfBits: T.bits)
        guard let result = T(rawValue: rawValue) else {
            throw BitStreamError.encodingError
        }
        return result
    }

    mutating private func align() {
        let mod = currentBit % 8
        if mod != 0 {
            currentBit += 8 - mod
        }
    }

    mutating private func readBit() -> UInt8 {
        let bitShift = currentBit % 8
        let byteIndex = currentBit / 8
        currentBit += 1
        return (bytes[byteIndex] >> bitShift) & 1
    }
}
