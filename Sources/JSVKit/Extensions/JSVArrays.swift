import Foundation

extension Array where Element: Equatable {
    /// Remove a particular object from an array
    /// - Parameter object: The object to be removed
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else { return }
        remove(at: index)
    }
}
