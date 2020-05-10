import ARKit

/// An action that can be executed in an ARSceneViewController. Action is a super-class and should be implemented by another class.
open class JSVAction: NSObject, NSSecureCoding {
    
    open var executeEverywhere: Bool = true

    open class var supportsSecureCoding: Bool {
        return true
    }

    open func encode(with aCoder: NSCoder) {
    }

    required open init?(coder aDecoder: NSCoder) {
    }
    
    /// Execute the action in a ARSceneViewController
    /// - Parameters:
    ///   - controller: The controller to be executed in
    ///   - callerID: The ID of the caller of the action
    ///   - completionHandler: A completion handler to be executed after the action has completed
    open func execute(in controller: UIViewController, callerID: String? = nil, completionHandler: (() -> Void)?) {
        fatalError("Execute function has not been implemented!")
    }
}
