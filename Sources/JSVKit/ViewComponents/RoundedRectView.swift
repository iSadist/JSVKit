//
//  RoundedRectView.swift
//  BucketBuddy
//
//  Created by Jan Svensson on 2021-02-05.
//

import UIKit

@IBDesignable
public class RoundedRectView: UIView {
    @IBInspectable
    public var radius: CGFloat = 5

    public override func draw(_ rect: CGRect) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
