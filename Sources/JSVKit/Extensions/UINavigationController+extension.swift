//
//  UINavigationController+extension.swift
//
//  Created by Jan Svensson on 2021-08-10.
//

import UIKit

extension UINavigationController {
    /// Same as pushViewController but with a copmletion handler
    /// - Parameters:
    ///   - viewController: the view controller to push
    ///   - animated: flag for animation
    ///   - completion: the completion handler
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
