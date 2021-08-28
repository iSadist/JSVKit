//
//  TickingTimer.swift
//
//  Created by Jan Svensson on 2021-05-12.
//

import UIKit

@available(iOS 10.0, *)
@IBDesignable
open class TickingTimer: UIView {
    @IBOutlet fileprivate var contentView: UIView!
    @IBOutlet weak private var minutesLabel: UILabel!
    @IBOutlet weak private var secondsLabel: UILabel!
    @IBOutlet weak private var separatorLabel: UILabel!
    @IBOutlet weak var secondsBackground: UIView!
    @IBOutlet weak var minutesBackground: UIView!
    private(set) var seconds: Int = 0
    fileprivate var timer: Timer?
    fileprivate var startTimestamp: CFTimeInterval?

    @IBInspectable
    public var color: UIColor = .black

    @IBInspectable
    public var textColor: UIColor = .white

    public static let secondsPerMinute = 60

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initWithNib()
    }

    fileprivate func initWithNib() {
        Bundle.module.loadNibNamed("TickingTimer", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        minutesBackground.backgroundColor = color
        secondsBackground.backgroundColor = color
        minutesLabel.textColor = textColor
        secondsLabel.textColor = textColor
    }

    /// Starts the timer
    public func start() {
        if startTimestamp != nil {
            startTimestamp = CACurrentMediaTime() - Double(self.seconds)
        } else {
            startTimestamp = CACurrentMediaTime()
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let `self` = self else { return }
            guard let startTimestamp = self.startTimestamp else {
                self.reset()
                return
            }

            let currentTimestamp = CACurrentMediaTime()
            let diff = currentTimestamp - startTimestamp

            if Int(diff) > self.seconds {
                self.seconds = Int(diff)
                let minutes = self.seconds / TickingTimer.secondsPerMinute
                self.minutesLabel.text = String(format: "%02d", minutes)
                let remainingSeconds = self.seconds % TickingTimer.secondsPerMinute
                self.secondsLabel.text = String(format: "%02d", remainingSeconds)
            }
        }
    }

    /// Stops the clock from updating the model
    public func stop() {
        timer?.invalidate()
    }

    /// Resets the timer to its initial state
    public func reset() {
        stop()
        seconds = 0
        minutesLabel.text = "00"
        secondsLabel.text = "00"
        startTimestamp = nil
    }
}
