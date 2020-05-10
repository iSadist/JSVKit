import ARKit

/// An action that can be executed in an ARSceneViewController. Action is a super-class and should be implemented by another class.
public class JSVAction: NSObject, NSSecureCoding {
    
    public var executeEverywhere: Bool = true

    public class var supportsSecureCoding: Bool {
        return true
    }

    public func encode(with aCoder: NSCoder) {
    }

    required public init?(coder aDecoder: NSCoder) {
    }
    
    /// Execute the action in a ARSceneViewController
    /// - Parameters:
    ///   - controller: The controller to be executed in
    ///   - callerID: The ID of the caller of the action
    ///   - completionHandler: A completion handler to be executed after the action has completed
    public func execute(in controller: UIViewController, callerID: String? = nil, completionHandler: (() -> Void)?) {
        fatalError("Execute function has not been implemented!")
    }
}
