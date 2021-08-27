//
//  LocalizedSearchBar.swift
//
//  Created by Jan Svensson on 2021-04-06.
//

import UIKit

open class LocalizedSearchBar: UISearchBar {
    /// The key to the localized string
    @IBInspectable
    public var translationKey: String?

    override public func awakeFromNib() {
        super.awakeFromNib()

        if let key = self.translationKey {
            self.placeholder = NSLocalizedString(key, comment: "")
        } else {
            assertionFailure("Translation not set for localized button")
        }
    }
}
