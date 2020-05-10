import UIKit

/// A Slider component that contains the slider, a title and the current value of the slider
public class JSVSlider: UIControl {

    /// The title of the slider. Usually a short description of
    /// what the slider changes.
    public var titleText: String? {
        get {
            return title.text
        }
        set {
            title.text = newValue
        }
    }

    let slider = BoundUISlider()
    private let title = UILabel()
    private let valueLabel = BoundUILabel()

    /// Standard initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 5
        backgroundColor = UIColor.blue
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Make an observable be
    ///
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<Float>) {

    }

    private func setupSubviews() {
        addSubview(slider)
        addSubview(title)
        addSubview(valueLabel)

        slider.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        title.text = "Some title"
        valueLabel.text = "0"

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leftAnchor.constraint(equalTo: leftAnchor),
            slider.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 25),
            slider.leftAnchor.constraint(equalTo: leftAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            valueLabel.leftAnchor.constraint(equalTo: slider.rightAnchor, constant: 25),
            valueLabel.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }
}
