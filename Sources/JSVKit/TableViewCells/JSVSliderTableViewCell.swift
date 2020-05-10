import UIKit

///
@available(iOS 11.0, *)
public class JSVSliderTableViewCell: UITableViewCell {
    /// The title on the cell
    public var title = UILabel()
    /// The minimum value of the slider
    public var minValue: Float {
        get {
            return slider.minimumValue
        }
        set {
            slider.minimumValue = newValue
        }
    }
    /// The maximum value of the slider
    public var maxValue: Float {
        get {
            return slider.maximumValue
        }
        set {
            slider.maximumValue = newValue
        }
    }
    /// The current value of the slider
    public var value: Float {
        get {
            return slider.value
        }
        set {
            slider.value = newValue
            sliderValueChanged()
        }
    }

    private var slider = BoundUISlider()
    private var valueLabel = BoundUILabel()
    
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
        // Initialization code
        setupSubviews()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }
    
    /// Binds an observable to the BoundUISlider
    /// - Parameter observable: The observable
    public func bind(to observable: Observable<Float>) {
        slider.bind(to: observable)
    }

    private func setupSubviews() {
        addSubview(title)
        addSubview(slider)
        addSubview(valueLabel)

        title.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 15),
            slider.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            slider.leftAnchor.constraint(equalTo: title.rightAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            valueLabel.leftAnchor.constraint(equalTo: slider.rightAnchor, constant: 25),
            valueLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -25),
            valueLabel.widthAnchor.constraint(equalToConstant: 35),
            title.widthAnchor.constraint(equalTo: slider.widthAnchor)
            ])

        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    @objc private func sliderValueChanged() {
        valueLabel.text = "\(round(100*slider.value)/100)"
    }
}
