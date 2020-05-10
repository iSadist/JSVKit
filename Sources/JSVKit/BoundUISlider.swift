import UIKit

/// A UISlider that can be connected to an Observable
public class BoundUISlider: UISlider {
    public var changeClosure: (() -> Void)?

    @objc func valueChanged() {
        changeClosure?()
    }

    /// Connect the slider component to an observable so that the value of the observable will correspond to the state of the slider
    ///
    /// - Parameter observable: The observable to be bound to the component
    public func bind(to observable: Observable<Float>) {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        changeClosure = { [weak self] in
            observable.bindingChanged(to: self?.value ?? 0)
        }

        observable.valueChanged = { [weak self] newValue in
            self?.value = newValue ?? 0
        }
    }
}
