//
//  SelectableItem.swift
//  BucketBuddy
//
//  Created by Jan Svensson on 2021-03-08.
//

import UIKit

/// The item view for a HSelectionView component
@available(iOS 11.0, *)
open class SelectableItem: UIView {
    /// The content view that contains all content
    @IBOutlet public var contentView: UIView!
    /// The label view
    @IBOutlet public weak var label: UILabel!
    /// The background view
    @IBOutlet public weak var roundedRect: RoundedRectView!

    /// The color  selected
    public var selectedColor: UIColor? = UIColor(named: "SelectedBlue")
    /// The color when not selected
    public var deselectedColor: UIColor? = UIColor(named: "TintedBackground")

    /// An index representing which place in the selection view the item has
    public var index: Int = 0

    /// Indicator for selected state
    public var isSelected: Bool {
        return selected
    }

    /// Indicator for disable state
    public var isDisabled: Bool {
        return disabled
    }

    /// A flag indicating if the item is selected
    private var selected: Bool = false {
        didSet {
            if selected {
//                roundedRect.backgroundColor = selectedColor
            } else {
//                roundedRect.backgroundColor = deselectedColor
            }
        }
    }

    /// A flag indicating if the item is disabled
    private var disabled: Bool = false {
        didSet {
            if disabled {
                label.textColor = UIColor(named: "DarkerText")
            } else {
                label.textColor = UIColor(named: "DefaultText")
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initWithNib()
    }

    fileprivate func initWithNib() {
//        Bundle(for: Self)
//        let resourceBundlePath = Bundle.main.path(forResource: "JSVKit", ofType: "framework")!
        let bundle = Bundle(for: Self.self)
        bundle.load()

        if bundle.isLoaded ?? false {
            print("Loaded bundle with path \(bundle.bundlePath)")
        } else {
            print("Failed to load bundle with path \(bundle.bundlePath)")
        }

        bundle.loadNibNamed("SelectableItem", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }

    /// Selects the item if possible. Nothing happes if the item is disabled
    /// - Parameter select: flag for selected state
    public func setSelected(_ select: Bool) {
        if !disabled {
            selected = select
        }
    }

    /// Toggles the selected state of the item
    public func toggleSelected() {
        if !disabled {
            selected.toggle()
        }
    }

    /// Sets the disabled state on the item
    /// - Parameter disable: flag for disabled state
    public func setDisabled(_ disable: Bool) {
        disabled = disable
        selected = disable ? false : selected
    }
}
