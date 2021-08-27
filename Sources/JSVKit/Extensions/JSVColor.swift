//
//  JSVColor.swift
//
//  Created by Jan Svensson on 2020-05-03.
//  Copyright © 2020 Jan Svensson. All rights reserved.
//

import UIKit

extension UIColor {
    /// The RGBA components of the color
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - hexString: <#hexString description#>
    ///   - alpha: <#alpha description#>
    /// - Returns: <#description#>
    public static func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(Self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    /// <#Description#>
    /// - Parameter hexStr: <#hexStr description#>
    /// - Returns: <#description#>
    fileprivate static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
