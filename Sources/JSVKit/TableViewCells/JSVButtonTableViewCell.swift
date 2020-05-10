//
//  JSVButtonTableViewCell.swift
//  Virtual Ping Pong
//
//  Created by Jan Svensson on 2020-05-02.
//  Copyright © 2020 Jan Svensson. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
public class JSVButtonTableViewCell: UITableViewCell {

    var buttonText: String? {
        get {
            return button.title(for: .normal)
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }
    var onButtonPressed: (() -> Void)?
    
    fileprivate var button = UIButton(type: .system)
    
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
    
    fileprivate func setupSubviews() {
        addSubview(button)
        
        button.titleLabel?.font = UIFont(name: "helvetica", size: 20)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc fileprivate func buttonPressed(_ sender: UIButton!) {
        onButtonPressed?()
    }
}
