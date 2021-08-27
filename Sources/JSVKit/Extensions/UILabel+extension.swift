//
//  UILabel+extension.swift
//  BucketBuddy
//
//  Created by Jan Svensson on 2021-04-06.
//

import UIKit

extension UILabel {
    /// A key for a localized text string
    @IBInspectable public var localizableText: String {
        set {
            self.text = NSLocalizedString(newValue, comment: "")
        }

        get {
            return self.text ?? ""
        }
    }
}
