import Foundation

protocol BoundComponent {
    func bind(to observable: Observable<Any>)
}
