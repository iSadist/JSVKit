//
//  File.swift
//  
//
//  Created by Jan Svensson on 2020-05-18.
//

import Foundation

typealias BitStreamCodable = BitStreamEncodable & BitStreamDecodable

protocol BitStreamEncodable {
    func encode(to bitStream: inout WritableBitStream) throws
}

protocol BitStreamDecodable {
    init(from bitStream: inout ReadableBitStream) throws
}
