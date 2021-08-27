//
//  JSVMultiFormatView.swift
//  Virtual Ping Pong
//
//  Created by Jan Svensson on 2020-04-25.
//  Copyright © 2020 Jan Svensson. All rights reserved.
//

import UIKit

/// A view class that supports updating constraints automatically depending on what orientation the view is in
open class JSVMultiOrientaionView: UIView {
    /// The constraints that will be active in landscape mode
    open var landscapeConstraints: [NSLayoutConstraint] {
        get {
            return lConstraints
        }
        set {
            lConstraints = newValue
            NSLayoutConstraint.deactivate(pConstraints)
            NSLayoutConstraint.activate(lConstraints)
        }
    }
    /// The constraints that will be active in portrait mode
    open var portraitContraints: [NSLayoutConstraint] {
        get {
            return pConstraints
        }
        set {
            pConstraints = newValue
            NSLayoutConstraint.deactivate(lConstraints)
            NSLayoutConstraint.activate(pConstraints)
        }
    }
    
    private var lConstraints = [NSLayoutConstraint]()
    private var pConstraints = [NSLayoutConstraint]()

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLayoutConstraints),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLayoutConstraints),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates the contraints to activate the portrait constraints if in portrait, otherwise activate the landscape constraints.
    /// Make sure to call this method after the
    @objc open func updateLayoutConstraints() {
        let orientation = UIDevice.current.orientation
        _ = UIDevice.current.userInterfaceIdiom

        switch orientation {
        case .landscapeLeft, .landscapeRight:
            NSLayoutConstraint.deactivate(pConstraints)
            NSLayoutConstraint.activate(lConstraints)
        case .portrait, .portraitUpsideDown:
            NSLayoutConstraint.deactivate(lConstraints)
            NSLayoutConstraint.activate(pConstraints)
        default:
            return
        }
        
        layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
}
