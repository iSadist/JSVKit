//  JSVKit
//  JSVNumbers.swift
//
//  Created by Jan Svensson on 2020-04-28.
//  Copyright © 2020 Jan Svensson. All rights reserved.
//

import Foundation

infix operator **
public extension Float {
    public static func ** (left: Float, right: Float) -> Float {
        return pow(left, right)
    }
}
