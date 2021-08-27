//
//  UINavigationController+extension.swift
//  BucketBuddy
//
//  Created by Jan Svensson on 2021-08-10.
//

import UIKit

extension UINavigationController {
    /// <#Description#>
    /// - Parameters:
    ///   - viewController: <#viewController description#>
    ///   - animated: <#animated description#>
    ///   - completion: <#completion description#>
    public func pushViewController(
            _ viewController: UIViewController,
            animated: Bool,
            _ completion: @escaping () -> Void) {
            pushViewController(viewController, animated: animated)

            guard animated, let coordinator = transitionCoordinator else {
                DispatchQueue.main.async { completion() }
                return
            }

            coordinator.animate(alongsideTransition: nil) { _ in completion() }
        }
}
