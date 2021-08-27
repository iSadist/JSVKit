import UIKit

extension UIStackView {
    /// Removes all subviews from the stack
    public func removeAllSubviews() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
