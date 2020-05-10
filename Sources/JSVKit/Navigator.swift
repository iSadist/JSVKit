import UIKit

/// A protocol to be implemented by a class that handles navigation logic in an application
public protocol Navigator {
    associatedtype Destination
    var navigationController: UINavigationController? { get }
    
    init(navigationController: UINavigationController)
    /// Switch the active view to be another view
    /// - Parameter destination: The destination of the navigation that will be the new active view
    func navigate(to destination: Destination)
}
