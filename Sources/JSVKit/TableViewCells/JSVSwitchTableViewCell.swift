import UIKit

/// A table view cell with a bool switch value that can be connected to an observable
@available(iOS 11.0, *)
public class JSVSwitchTableViewCell: UITableViewCell {
    public var switchButton = JSVBoundSwitch()

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Connect the switch component to an observable so that the value of the observable will correspond to the state of the switch
    /// - Parameter observable: The observable to be connected
    public func bind(to observable: Observable<Bool>) {
        switchButton.bind(to: observable)
    }
    
    fileprivate func setupSubviews() {
        addSubview(switchButton)
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20),
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
