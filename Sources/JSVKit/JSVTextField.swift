import UIKit

/// A text field component that can be bound to an observable
public class JSVTextField: UITextField, BoundComponent {
    public var changeClosure: (() -> Void)?
    
    @objc public func valueChanged() {
        changeClosure?()
    }
    
    /// Connect the text field component to an observable so that the value of the observable will correspond to the state of the text field
    /// - Parameter observable: The observable to be connected
    public func bind(to observable: Observable<String>) {
        addTarget(self, action: #selector(valueChanged), for: .editingChanged)

        changeClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }

        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
    }
}
