import Foundation

public protocol JSVActionExecutable {
    func executeAction(_ action: JSVAction, callerID: String?, queue: DispatchQueue?, completionHandler: (() -> Void)?)
}

extension JSVActionExecutable {
    public func executeAction(_ action: JSVAction, callerID: String?, queue: DispatchQueue? = DispatchQueue.main, completionHandler: (() -> Void)? = nil) {
    }
}
