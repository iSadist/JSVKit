import Foundation

/// A button that can be connected to an observable
public class BoundJSVButton: JSVButton {
    /// Connect the button component to an observable so that the value of the observable will correspond to the state of the button
    ///
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<Bool>) {
        observable.valueChanged = { [weak self] newValue in
            if let enabled = newValue {
                DispatchQueue.main.async {
                    self?.isEnabled = enabled
                    self?.isHidden = !enabled
                }
            }
        }
    }
}
