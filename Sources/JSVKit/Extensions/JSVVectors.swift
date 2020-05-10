import Foundation
import SceneKit

extension SCNVector3 {
    /// Multiplies the vectors elements with a number
    /// - Parameter number: The number to multiply with
    public func multiply(with number: Float) -> SCNVector3 {
        return SCNVector3(self.x * number,
                          self.y * number,
                          self.z * number)
    }
    
    /// Returns the scalar of the vector
    public func scalar() -> Float {
        return sqrtf(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }
    
    /// Normalizes the vector and returns that vector.
    public func normalize() -> SCNVector3 {
        return self.divided(by: self.scalar())
    }
    
    /// Returns a vector with all elements divided by num
    /// - Parameter num: The number to divide by.
    public func divided(by num: Float) -> SCNVector3 {
        var temp = self
        temp.x /= num
        temp.y /= num
        temp.z /= num

        return temp
    }
    
    /// Adds values to the vector elements and returns that vector
    /// - Parameters:
    ///   - x: The x value
    ///   - y: The y value
    ///   - z: The z value
    /// - Returns: The resulting array
    public func add(x: Float, y: Float, z: Float) -> SCNVector3 {
        return SCNVector3(self.x + x, self.y + y, self.z + z)
    }
    
    /// Subtracts the values from the elements and returns that vector
    /// - Parameters:
    ///   - x: The x value
    ///   - y: The y value
    ///   - z: The z value
    /// - Returns: The resulting array
    public func subtract(x: Float, y: Float, z: Float) -> SCNVector3 {
        return SCNVector3(self.x - x, self.y - y, self.z - z)
    }
    
    /// Converts the vector to Simd and returns it
    public func toSimd() -> vector_float3 {
        return vector_float3(x: self.x, y: self.y, z: self.z)
    }
    
    /// Add two vectors together
    /// - Parameters:
    ///   - lhs: The left hand side vector
    ///   - rhs: The right hand side vector
    static public func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    /// Subtracts two vectors
    /// - Parameters:
    ///   - lhs: The left hand side vector
    ///   - rhs: The right hand side vector
    static public func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
}

extension SCNVector3: Equatable {
    /// Compares two vectors with each other
    /// - Parameters:
    ///   - lhs: The left hand side vector
    ///   - rhs: The right hand side vector
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs.z == rhs.z
    }
}
