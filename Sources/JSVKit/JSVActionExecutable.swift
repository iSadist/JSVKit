import Foundation

internal protocol JSVActionExecutable {
    func executeAction(_ action: JSVAction, callerID: String?, queue: DispatchQueue?, completionHandler: (() -> Void)?)
}

extension JSVActionExecutable {
    internal func executeAction(_ action: JSVAction, callerID: String?, queue: DispatchQueue? = DispatchQueue.main, completionHandler: (() -> Void)? = nil) {
    }
}
