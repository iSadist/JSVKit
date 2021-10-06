//
//  CircleProgressView.swift
//
//  Created by Jan Svensson on 2021-02-04.
//

import UIKit

@IBDesignable
public class CircleProgressView: UIView {
    /// The maximum achievable score
    @IBInspectable
    public var maxScore: CGFloat = 0

    /// The total score
    @IBInspectable
    public var score: CGFloat = 0

    /// The part of the score that is the current progress
    @IBInspectable
    public var progress: CGFloat = 0

    /// The radius of the circle
    @IBInspectable
    public var radius: CGFloat = 1

    /// The width of the circle line
    @IBInspectable
    public var lineWidth: CGFloat = 1

    /// The color of the unfilled circle background
    @IBInspectable
    public var circleBackgroundColor: UIColor = .black

    /// The color of the filled part of the circle
    @IBInspectable
    public var primaryFilledColor: UIColor = .white

    /// The duration for the animation to complete
    @IBInspectable
    public var duration: Double = 2

    /// The color of the secondary filled circle part
    @IBInspectable
    public var secondaryFilledColor: UIColor = .blue

    private var circleLayer = CAShapeLayer()
    private var backgroundLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    override public func draw(_ rect: CGRect) {
        defer {
            removeSublayers()
            addSublayers()
            addAnimations()
        }

        let computedRadius = (rect.height - lineWidth) / 2
        let midPoint = CGPoint(x: rect.midX, y: rect.midY)

        let backgroundCircle = UIBezierPath(arcCenter: midPoint,
                                            radius: computedRadius,
                                            startAngle: 0,
                                            endAngle: .pi * 2,
                                            clockwise: true)
        backgroundLayer = setLayer(with: backgroundCircle, color: circleBackgroundColor)

        // Check max score
        guard maxScore >= 1 else {
            print("Invalid maxScore set for ProgressCircle. Needs to be greater or equal to one.")
            return
        }

        let endAngle = CGFloat((score-progress)/maxScore) * 360
        let progressAngle = CGFloat(progress/maxScore) * 360

        let startAngleRadian = (-90 / 180.0) * CGFloat.pi
        let endAndleRadian = ((endAngle - 90) / 180.0) * CGFloat.pi
        let progressEndAndleRadian = ((endAngle - 90 + progressAngle) / 180.0) * CGFloat.pi

        let circlePath = UIBezierPath(arcCenter: midPoint,
                                      radius: computedRadius,
                                      startAngle: startAngleRadian,
                                      endAngle: endAndleRadian,
                                      clockwise: endAngle > 0)

        let progressPath = UIBezierPath(arcCenter: midPoint,
                                        radius: computedRadius,
                                        startAngle: endAndleRadian,
                                        endAngle: progressEndAndleRadian,
                                        clockwise: true)

        circleLayer = setLayer(with: circlePath, color: primaryFilledColor)
        progressLayer = setLayer(with: progressPath, color: secondaryFilledColor)
        progressLayer.strokeEnd = 0 // Needed so that the progress circle is not shown at start
    }

    private func setLayer(with path: UIBezierPath, color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.lineWidth = lineWidth
        layer.strokeColor = color.cgColor
        layer.path = path.cgPath
        layer.fillColor = nil
        return layer
    }

    private func addSublayers() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }

    private func removeSublayers() {
        backgroundLayer.removeFromSuperlayer()
        circleLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
    }

    private func addAnimations() {
        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleAnimation.duration = duration
        circleAnimation.fromValue = 0
        circleAnimation.toValue = 1
        circleLayer.add(circleAnimation, forKey: "strokeEnd")

        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.duration = duration
        progressAnimation.fromValue = 0
        progressAnimation.toValue = 1
        progressAnimation.beginTime = CACurrentMediaTime() + duration
        progressAnimation.isRemovedOnCompletion = false
        progressAnimation.fillMode = .forwards
        progressLayer.add(progressAnimation, forKey: "strokeEnd")
    }

    /// Prepare the animation
    public func prepareAnimation() {
        progressLayer.strokeEnd = 0
    }

    /// Start the animation
    public func startAnimation() {
        setNeedsDisplay()
        addAnimations()
    }
}
