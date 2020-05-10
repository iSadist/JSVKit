//
//  JSVStepperTableViewCell.swift
//  Virtual Ping Pong
//
//  Created by Jan Svensson on 2020-04-26.
//  Copyright © 2020 Jan Svensson. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
public class JSVStepperTableViewCell: UITableViewCell {
    /// The title on the cell
    public var title = UILabel()
    
    /// The minimum value of the slider
    public var minValue: Float {
        get {
            return Float(stepper.minimumValue)
        }
        set {
            stepper.minimumValue = Double(newValue)
        }
    }
    /// The maximum value of the slider
    public var maxValue: Float {
        get {
            return Float(stepper.maximumValue)
        }
        set {
            stepper.maximumValue = Double(newValue)
        }
    }
    /// The current value of the slider
    public var value: Float {
        get {
            return Float(stepper.value)
        }
        set {
            stepper.value = Double(newValue)
            sliderValueChanged()
        }
    }
    
    private var stepper: BoundUIStepper = {
        let boundStepper = BoundUIStepper()
        boundStepper.stepValue = 1.0
        return boundStepper
    }()
    private var valueLabel: BoundUILabel = {
        let label = BoundUILabel()
        label.accessibilityValue = "stepperLabelValue"
        return label
    }()
    
    /// Initilalize the table cell
    /// - Parameters:
    ///   - style: The table view cell style
    ///   - reuseIdentifier: The table cell reuse identifier
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    /// Binds an observable to the BoundUISlider
    /// - Parameter observable: The observable
    public func bind(to observable: Observable<Float>) {
        stepper.bind(to: observable)
    }
    
    private func setupSubviews() {
        addSubview(title)
        addSubview(stepper)
        addSubview(valueLabel)

        title.translatesAutoresizingMaskIntoConstraints = false
        stepper.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 15),
            stepper.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            stepper.leftAnchor.constraint(equalTo: title.rightAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            valueLabel.leftAnchor.constraint(equalTo: stepper.rightAnchor, constant: 25),
            valueLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -25),
            valueLabel.widthAnchor.constraint(equalToConstant: 35),
            title.widthAnchor.constraint(equalTo: stepper.widthAnchor, multiplier: 2)
        ])
        
        stepper.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    @objc private func sliderValueChanged() {
        valueLabel.text = "\(stepper.value)"
    }
}
