//
//  LoadingScreenViewController.swift
//
//  Created by Jan Svensson on 2021-08-03.
//

import UIKit

@available(iOS 13.0, *)
open class LoadingScreenViewController: UIViewController {
    public var nextScreen: UIViewController?

    lazy public var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return activity
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        activity.startAnimating()
    }

    public func complete() {
        if let viewController = nextScreen {
            navigationController?.pushViewController(viewController, animated: true)
        }

        activity.stopAnimating()
    }
}
