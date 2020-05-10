import UIKit

/// A table view component that connects an observable itself so that the value of the observable and the visible value on the table cell always agrees
public class JSVTextTableViewCell: UITableViewCell, UITextFieldDelegate {
    public var title = UILabel()
    public var textField = JSVTextField()

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupSubviews() {
        textField.delegate = self
        textField.clearButtonMode = .whileEditing

        addSubview(title)
        addSubview(textField)

        title.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 15),
            textField.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 25),
            textField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -25),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    /// Connect the text field component to an observable so that the value of the observable will correspond to the state of the text field
    /// - Parameter observable: The observable to bind to the component
    public func bind(to observable: Observable<String>) {
        textField.bind(to: observable)
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
