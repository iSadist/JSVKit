import Foundation

public struct Job {
    var function: (() -> Void)
    var queue: DispatchQueue
}
