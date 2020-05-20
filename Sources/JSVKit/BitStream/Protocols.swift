//
//  File.swift
//  
//
//  Created by Jan Svensson on 2020-05-18.
//

import Foundation

public typealias BitStreamCodable = BitStreamEncodable & BitStreamDecodable

public protocol BitStreamEncodable {
    func encode(to bitStream: inout WritableBitStream) throws
}

public protocol BitStreamDecodable {
    init(from bitStream: inout ReadableBitStream) throws
}
