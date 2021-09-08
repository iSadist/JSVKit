//
//  HSelectionView.swift
//  BucketBuddy
//
//  Created by Jan Svensson on 2021-03-08.
//

import UIKit

/// A horizontal selection view where an item can be picked out of many
@available(iOS 11.0, *)
@IBDesignable public class HSelectionView: UIView {
    private var scrollView: UIScrollView?
    private var stackView: UIStackView?
    public private(set) var items: [SelectableItem] = []

    /// The width of an item
    @IBInspectable public var itemWidth: CGFloat = 110.0
    /// The border radius of an item
    @IBInspectable public var itemRadius: CGFloat = 5.0
    /// The color of the item when it is selected
    @IBInspectable public var selectedColor: UIColor? = UIColor(named: "SelectedBlue")
    /// The color of the item when it is not selected
    @IBInspectable public var deselectedColor: UIColor? = UIColor(named: "TintedBackground")
    /// The text label color
    @IBInspectable public var textColor: UIColor? = .white
    /// The text label color for a disabled item
    @IBInspectable public var disabledTextColor: UIColor? = .gray
    /// A flag for setting the selectable items to perfect circles
    @IBInspectable public var isItemCircle: Bool = false
    /// If true, the item width will be dynamic to the text. Otherwise itemWidth will be used
    @IBInspectable public var useDynamicItemWidth: Bool = false

    /// The index of the item that is selected
    public var selectedItemIndex: Int = 0 {
        didSet { updateSelected() }
    }

    /// An identifier for the component. Useful for separating a specific one when multiple are used in the same context
    public var identifier: String = ""

    /// A delegate for HSelectionView
    public weak var delegate: HSelectionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// <#Description#>
    public var changeClosure: (() -> Void)?

    /// <#Description#>
    /// - Parameter observable: <#observable description#>
    public func bind(to observable: Observable<Int>) {
        changeClosure = { [weak self] in
            observable.bindingChanged(to: self?.selectedItemIndex ?? 0)
        }

        observable.valueChanged = { [weak self] newValue in
            if let index = newValue {
                self?.selectedItemIndex = index
            }
        }
    }

    /// <#Description#>
    public func unbind() {
        changeClosure = nil
    }

    /// Set up the view with the items in the string array.
    /// - Parameter arr: The array of possible selections
    public func setup(_ arr: [String]) {
        items.removeAll()
        stackView?.removeFromSuperview()
        scrollView?.removeFromSuperview()

        var totalViewWidth: CGFloat = 0.0

        for (index, name) in arr.enumerated() {
            let view = SelectableItem()
            view.isUserInteractionEnabled = true
            view.index = index
            view.contentView.isUserInteractionEnabled = true
            view.label.text = name
            view.roundedRect.radius = itemRadius
            view.selectedColor = selectedColor
            view.deselectedColor = deselectedColor
            view.textColor = textColor
            view.disabledTextColor = disabledTextColor
            view.update()

            if isItemCircle {
                view.roundedRect.radius = itemWidth / 2
            }

            if useDynamicItemWidth {
                let viewWidth = name.count * 12 + 10
                totalViewWidth += CGFloat(viewWidth)
                view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 50)
            }

            items.append(view)
        }

        let widthScrollSize: CGFloat = useDynamicItemWidth ?
            totalViewWidth :
            CGFloat(arr.count) * (itemWidth + 7)

        scrollView = UIScrollView()
        scrollView?.frame = bounds
        scrollView?.contentSize = CGSize(width: widthScrollSize, height: bounds.height)
        scrollView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView?.backgroundColor = backgroundColor
        scrollView?.isUserInteractionEnabled = true

        stackView = UIStackView(arrangedSubviews: items)
        stackView?.axis = .horizontal
        stackView?.alignment = .fill
        stackView?.distribution = useDynamicItemWidth ? .fillProportionally : .fillEqually
        stackView?.frame = CGRect(x: 0, y: 0, width: widthScrollSize, height: bounds.height)
        stackView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        stackView?.isUserInteractionEnabled = true

        addSubview(scrollView!)
        scrollView!.addSubview(stackView!)

        for item in items {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            item.addGestureRecognizer(tapGesture)
        }
    }

    public func setDisabled(_ indexes: [Int]) {
        indexes.forEach {
            let item = items[$0]
            item.setDisabled(true)
        }
    }

    /// Selects the first available item
    public func selectFirst() {
        items.first { !$0.isDisabled }?.setSelected(true)
    }

    /// Updates the selection statuses on the views
    private func updateSelected() {
        items.enumerated().forEach {
            let isSelected = $0.offset == selectedItemIndex
            $0.element.setSelected(isSelected)
        }
        changeClosure?()
    }

    /// Called when a tap gesture occurs
    /// - Parameter sender: The gesture recognizer
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        if let selectableItem = sender.view as? SelectableItem {
            guard !selectableItem.isDisabled else { return }

            if delegate?.canDeselect(self) ?? true {
                selectableItem.toggleSelected()
            } else {
                selectableItem.setSelected(true)
            }

            items.forEach { (item) in
                if item != selectableItem {
                    item.setSelected(false)
                }
            }

            if selectableItem.isSelected {
                selectedItemIndex = selectableItem.index
                delegate?.didSelect(self, item: selectableItem)
            } else {
                delegate?.didDeselect(self, item: selectableItem)
            }
        }
    }
}
