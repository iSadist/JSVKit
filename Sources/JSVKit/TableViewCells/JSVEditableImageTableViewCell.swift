import UIKit

/// A table view component that contains an editable image and can be connected to an observable so that the value of the observable and the visible value on the table cell always agrees
public class JSVEditableImageTableViewCell: UITableViewCell {
    public weak var viewController: UIViewController?
    private lazy var imagePicker = UIImagePickerController()

    fileprivate var changeClosure: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.removeAllConstraints()
        imageView?.removeAllConstraints()
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textLabel!.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 15),
            textLabel!.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel!.rightAnchor.constraint(equalTo: imageView!.leftAnchor),
            imageView!.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -25),
            imageView!.topAnchor.constraint(equalTo: topAnchor),
            imageView!.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView!.widthAnchor.constraint(equalTo: imageView!.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            fatalError("Not allowed access to photo library.")
        }

        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        viewController?.present(imagePicker, animated: true, completion: nil)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            fatalError("Not allowed access to photo library.")
        }

        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        viewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    /// Connect the image picker component to an observable so that the value of the observable will correspond to the state of the image picker
    /// - Parameter observable: The observable
    public func bind(to observable: Observable<UIImage>) {
        observable.valueChanged = { [weak self] newValue in
            self?.imageView?.image = newValue
        }

        changeClosure = { [weak self] in
            observable.bindingChanged(to: self?.imageView?.image ?? UIImage())
        }
    }
}

extension JSVEditableImageTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let croppedImage = info[.editedImage] as? UIImage {
            imageView?.image = croppedImage
            setNeedsUpdateConstraints()
            changeClosure?()
        }
        viewController?.dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
