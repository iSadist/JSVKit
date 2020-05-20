import Foundation

public protocol Copyable {
    associatedtype CopyType
    func copy() -> CopyType
}
