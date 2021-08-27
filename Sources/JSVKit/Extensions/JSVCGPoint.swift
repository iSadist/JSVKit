import UIKit

extension CGPoint {
    public func subtract(_ other: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - other.x, y: self.y - other.y)
    }
    
    public func divide(by number: CGFloat) -> CGPoint {
        return CGPoint(x: self.x / number, y: self.y / number)
    }
}
