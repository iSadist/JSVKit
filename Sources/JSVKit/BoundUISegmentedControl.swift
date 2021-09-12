import UIKit

final public class BoundUISegmentedControl: UISegmentedControl, BoundComponent {
    public var changeClosure: (() -> Void)?

    @objc func valueChanged() {
        changeClosure?()
    }

    public func bind(to observable: Observable<Int>) {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        changeClosure = { [weak self] in
            observable.bindingChanged(to: self?.selectedSegmentIndex ?? 0)
        }

        observable.valueChanged = { newValue in
            if let index = newValue {
                self.selectedSegmentIndex = index
            }
        }
    }
}
