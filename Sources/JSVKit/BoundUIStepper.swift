import UIKit

/// A UIStepper component that can be bound to an Observable
public class BoundUIStepper: UIStepper {
    public var changeClosure: (() -> Void)?

    @objc func valueChanged() {
        changeClosure?()
    }

    /// Connect the stepper component to an observable so that the value of the observable will correspond to the state of the stepper
    ///
    /// - Parameter observable: The observable to be bound to the component
    public func bind(to observable: Observable<Float>) {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        changeClosure = { [weak self] in
            observable.bindingChanged(to: Float(self?.value ?? 0))
        }

        observable.valueChanged = { [weak self] newValue in
            self?.value = Double(newValue ?? 0)
        }
    }
}
