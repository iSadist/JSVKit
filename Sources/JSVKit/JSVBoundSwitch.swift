import UIKit

/// A switch component that can be bound to an observable
public class JSVBoundSwitch: UISwitch, BoundComponent {
    public var changeClosure: (() -> Void)?
    
    @objc private func valueChanged() {
        changeClosure?()
    }
    
    /// Connect the switch component to an observable so that the value of the observable will correspond to the state of the switch
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<Bool>) {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        changeClosure = { [weak self] in
            observable.bindingChanged(to: self?.isOn ?? false)
        }
        
        observable.valueChanged = { [weak self] newValue in
            guard let isOn = newValue else { return }
            self?.setOn(isOn, animated: true)
        }
    }
}
