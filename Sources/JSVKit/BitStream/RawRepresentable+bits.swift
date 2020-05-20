//
//  File.swift
//  
//
//  Created by Jan Svensson on 2020-05-18.
//

import Foundation

public extension RawRepresentable where Self: CaseIterable, RawValue == UInt32 {
    static var bits: Int {
        let casesCount = UInt32(allCases.count)
        return UInt32.bitWidth - casesCount.leadingZeroBitCount
    }
}
