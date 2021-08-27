//
//  LocalizedButton.swift
//
//  Created by Jan Svensson on 2021-04-06.
//

import UIKit

open class LocalizedButton: UIButton {
    /// The key to the localized string
    @IBInspectable
    public var translationKey: String?
    /// The corner radius of the button
    @IBInspectable
    public var cornerRadius: CGFloat = 0

    override public func awakeFromNib() {
        super.awakeFromNib()

        if let key = self.translationKey {
            self.setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        } else {
            assertionFailure("Translation not set for localized button")
        }
    }

    override public func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
