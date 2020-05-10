//
//  JSVMultiFormatView.swift
//  Virtual Ping Pong
//
//  Created by Jan Svensson on 2020-04-25.
//  Copyright © 2020 Jan Svensson. All rights reserved.
//

import UIKit

/// A view class that supports updating constraints automatically depending on what orientation the view is in
public class JSVMultiOrientaionView: UIView {
    /// The constraints that will be active in landscape mode
    public var landscapeConstraints: [NSLayoutConstraint] {
        get {
            return lConstraints
        }
        set {
            NSLayoutConstraint.deactivate(lConstraints)
            lConstraints = newValue
            updateLayoutConstraints()
        }
    }
    /// The constraints that will be active in portrait mode
    public var portraitContraints: [NSLayoutConstraint] {
        get {
            return pConstraints
        }
        set {
            NSLayoutConstraint.deactivate(pConstraints)
            pConstraints = newValue
            updateLayoutConstraints()
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
    @objc public func updateLayoutConstraints() {
        let orientation = UIDevice.current.orientation

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
    
    public deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
}
