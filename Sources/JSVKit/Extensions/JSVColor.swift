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
}
