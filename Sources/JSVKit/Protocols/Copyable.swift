import Foundation

protocol Copyable {
    associatedtype CopyType
    func copy() -> CopyType
}
