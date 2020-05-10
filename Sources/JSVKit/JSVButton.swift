import UIKit

/// A simple button that responds to presses in the same way UIButton does
public class JSVButton: UIButton {
    private let animationDuration = 0.2
    private var startingAlpha: CGFloat?

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        addTarget(self, action: #selector(touchDown), for: [.touchDown])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func touchDown(sender: UIButton!) {
        (_, _, _, startingAlpha) = backgroundColor?.components ?? (0, 0, 0, 0)
        
        animate(button: sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95),
                color: currentTitleColor.withAlphaComponent(0.2), background: backgroundColor?.withAlphaComponent(startingAlpha! - 0.5))
    }

    @objc private func touchUp(sender: UIButton!) {
        animate(button: sender, transform: CGAffineTransform.identity,
                color: currentTitleColor.withAlphaComponent(1),
                background: backgroundColor?.withAlphaComponent(startingAlpha ?? 0))
    }

    private func animate(button: UIButton, transform: CGAffineTransform, color: UIColor, background: UIColor?) {
        UIView.transition(with: self, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.transform = transform
            self.setTitleColor(color, for: .normal)
            self.backgroundColor = background
        }, completion: nil)
    }
}
