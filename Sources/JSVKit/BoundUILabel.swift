import UIKit

/// A UILabel that can be connected to an observable
public class BoundUILabel: UILabel, BoundComponent {
    typealias BoundType = String
    public var changeClosure: (() -> Void)?

    @objc public func valueChanged() {
        changeClosure?()
    }

    /// Connect the label component to an observable so that the value of the observable will correspond to the text of the label
    ///
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<Float>) {
        observable.valueChanged = { [weak self] newValue in
            DispatchQueue.main.async {
                self?.text = "\(String(describing: newValue?.rounded()))"
            }
        }
    }

    /// Connect the label component to an observable so that the value of the observable will correspond to the text of the label
    ///
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<Int>) {
        observable.valueChanged = { [weak self] newValue in
            DispatchQueue.main.async {
                self?.text = "\(newValue!)"
            }
        }
    }

    /// Connect the label component to an observable so that the value of the observable will correspond to the text of the label
    ///
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<(Int, Int)>) {
        observable.valueChanged = { [weak self] newValue in
            DispatchQueue.main.async {
                self?.text = "\(newValue!.0) - \(newValue!.1)"
            }
        }
    }

    /// Connect the label component to an observable so that the value of the observable will correspond to the text of the label
    ///
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<String>) {
        observable.valueChanged = { [weak self] newValue in
            DispatchQueue.main.async {
                self?.text = newValue
            }
        }
    }
}
