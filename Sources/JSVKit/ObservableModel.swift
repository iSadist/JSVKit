import Foundation

open class ObservableModel {

    var values = [String:Observable<Any>]()
    
    public init() {}

    func add(attributeName: String, value: Observable<Any>) {
        values[attributeName] = value
    }

    func getValue(attributeName: String) -> Observable<Any>? {
        return values[attributeName]
    }

    func listenTo(attribute: String, action: @escaping (Any) -> Void) {
        let value = values[attribute]
        value?.valueChanged = action
    }

    func removeListener(for attribute: String) {
        values[attribute]?.valueChanged = nil
    }
}
