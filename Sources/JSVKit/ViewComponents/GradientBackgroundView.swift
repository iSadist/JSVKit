//
//  GradientBackgroundView.swift
//
//  Created by Jan Svensson on 2021-05-29.
//

import UIKit

/// A UIView with a gradient background
@available(iOS 13.0, *)
@IBDesignable
open class GradientBackgroundView: UIView {
    /// The gradient layer
    private var gradientLayer: CAGradientLayer?

    /// The color in the bottom of the view
    @IBInspectable
    public var bottomColor: UIColor = .systemBackground

    /// The color in the top of the view
    @IBInspectable
    public var topColor: UIColor = .secondarySystemBackground

    /// Updates the view with the layer
    private func update() {
        gradientLayer?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = frame
        gradient.type = .axial
        layer.insertSublayer(gradient, at: 0)
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        update()
    }
}
