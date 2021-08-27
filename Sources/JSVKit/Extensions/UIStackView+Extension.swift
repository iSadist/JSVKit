import UIKit

extension UIStackView {
    /// <#Description#>
    public func removeAllSubviews() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
