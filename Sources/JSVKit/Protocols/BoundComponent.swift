import Foundation
import UIKit

protocol BoundComponent: AnyObject {
    associatedtype BoundType
    func bind(to observable: Observable<BoundType>)
    var changeClosure: (() -> Void)? { get set }
}

extension BoundComponent where Self: UIControl {
    func bind(to observable: Observable<BoundType>) {
//        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
//
//        changeClosure = { [weak self] in
//        }
//
//        observable.valueChanged = { [weak self] newValue in
//        }
    }
}
