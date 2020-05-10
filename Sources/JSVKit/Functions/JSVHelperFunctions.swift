import Foundation
import UIKit
import ARKit

public protocol Boundable {}
public extension Boundable where Self: Comparable {
    func interval(_ minimum: Self, _ maximum: Self) -> Self {
        return max(min(maximum, self), minimum)
    }
}

extension CGFloat: Boundable {}


// MARK: ARKit

/// A class used to handle gesture events to move scene kit nodes
public class JSVNodeMover {
    private var panStartZ: CGFloat?
    private var panStartPosition: CGPoint?
    private var lastPanLocation: SCNVector3?
    private var draggingNode: SCNNode?
    
    /// A handler for a pan gesture event
    /// - Parameters:
    ///   - pan: The pan gesture on the screen
    ///   - sceneView: The ARKit scene view
    ///   - view: The screen view
    func move(on pan: UIPanGestureRecognizer, sceneView: ARSCNView, view: UIView) {
        let location = pan.location(in: view)

        switch pan.state {
        case .began:
            guard let hitNodeResult = sceneView.hitTest(location, options: nil).first else { return }
            lastPanLocation = hitNodeResult.worldCoordinates
            panStartZ = CGFloat(sceneView.projectPoint(lastPanLocation!).z)
            draggingNode = hitNodeResult.node // Can be used to move other nodes if needed in the future
        case .changed:
            let worldTouchPosition = sceneView.unprojectPoint(SCNVector3(location.x, location.y, panStartZ ?? 0))
            lastPanLocation = worldTouchPosition
            if let movementVector = lastPanLocation?.subtract(other: worldTouchPosition) {
                guard let draggingNode = draggingNode else { return }
                draggingNode.position = draggingNode.position.subtract(x: movementVector.x, y: 0, z: movementVector.z)
            }
        case .ended:
            panStartPosition = nil
            lastPanLocation = nil
            panStartZ = nil
            draggingNode = nil
        default:
            panStartPosition = nil
            lastPanLocation = nil
            panStartZ = nil
            draggingNode = nil
        }
    }
}
