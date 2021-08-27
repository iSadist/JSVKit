//
//  PaddedLabel.swift
//
//  Created by Jan Svensson on 2021-06-23.
//

import UIKit

@IBDesignable
open class PaddedLabel: UILabel {
    @IBInspectable
    public var topInset: CGFloat = 0

    @IBInspectable
    public var bottomInset: CGFloat = 0

    @IBInspectable
    public var leftInset: CGFloat = 0

    @IBInspectable
    public var rightInset: CGFloat = 0

    @IBInspectable
    public var radius: CGFloat = 0

    override public func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }
}
