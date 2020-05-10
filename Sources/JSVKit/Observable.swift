import Foundation

/// An observable
public class Observable<ObservedType> {
    public typealias Callback = (ObservedType?) -> Void
    
    private var _value: ObservedType?
    private var listeners = [AnyHashable : Callback]()
    
    private let queue = DispatchQueue.main
    
    public var value: ObservedType? {
        get {
            return _value
        }
        
        set {
            self._value = newValue
            self.notifyListeners(newValue: newValue)
            self.valueChanged?(self._value)
        }
    }
    
    /// A callback function that will be called when the value of the observable is changed
    public var valueChanged: Callback?
    
    public init(value: ObservedType?) {
        _value = value
    }
    
    /// Listens to changes of the observable
    ///
    /// - Parameters:
    ///   - caller: The caller that is listening to the observable
    ///   - handler: A closure that will be called every time the value is changed
    public func listen(_ caller: AnyHashable, handler: @escaping (ObservedType?) -> Void) {
        listeners[caller] = handler
    }
    
    /// Stops listening to changes of the observable.
    ///
    /// - Parameters:
    ///   - caller: The caller that was listening to the observable
    ///   - handler: The handler
    public func stopListening(_ caller: AnyHashable, handler: @escaping (ObservedType?) -> Void) {
        listeners.removeValue(forKey: caller)
    }
    
    /// Changes the value of the observable to a new value. Note that calling this method doesn't notify the listeners.
    ///
    /// - Parameter newValue: The new value that the observable will get.
    public func bindingChanged(to newValue: ObservedType) {
        _value = newValue
    }
    
    /// Notifies all the registered listeners of the new value
    ///
    /// - Parameter newValue: The new value that the listeners will get.
    func notifyListeners(newValue: ObservedType?) {
        for listener in listeners {
            listener.value(newValue)
        }
    }
}
