/*
See LICENSE.txt for this sample’s licensing information.
*/

import ARHeadsetKit
import Differentiation

struct Cube: Differentiable {
    @noDerivative let location0: simd_float3
    @noDerivative var location: simd_float3
    @noDerivative var orientation: simd_quatf
    @noDerivative var sideLength: Float
    
    var timeSinceCollision: Float
    var isMoving: Bool { timeSinceCollision != -2 }
    @noDerivative var velocity0: simd_float3
    @noDerivative var angularVelocity: simd_quatf?
    
    @noDerivative var isRed = false
    @noDerivative var isHighlighted = false
    @noDerivative var object: ARObject!
    @noDerivative var normalObject: ARObject!
    
    init(location: simd_float3,
         orientation: simd_quatf,
         sideLength: Float)
    {
        location0 = location
        self.location = location0
        self.orientation = orientation
        self.sideLength = sideLength
        
        timeSinceCollision = -2
        velocity0 = simd_float3(repeating: .nan)
        
        object = getObject()
    }
    
    func getObject() -> ARObject {
        var color: simd_float3
        
        if isRed {
            if isHighlighted {
                color = [1.0, 0.5, 0.4]
            } else {
                color = [0.7, 0.1, 0.1]
            }
        } else {
            if isHighlighted {
                color = [0.6, 0.8, 1.0]
            } else {
                color = [0.2, 0.5, 0.7]
            }
        }
        
        return ARObject(shapeType: .cube,
                        position: location,
                        orientation: orientation,
                        scale: .init(repeating: sideLength),
                        
                        color: color)
    }
    
    func getNormalObject(location: simd_float3,
                         normal: simd_float3) -> ARObject {
        .init(shapeType: .cylinder,
              position: location,
              orientation: simd_quatf(from: [0, 1, 0], to: normal),
              scale: [sideLength / 4, sideLength, sideLength / 4],
              
              color: .init(repeating: 0.8))
    }
    
    func render(centralRenderer: CentralRenderer) {
        guard location.y > -200 else {
            // The cube fell over 200 meters!
            return
        }
        
        centralRenderer.render(object: object)
        
        if let normalObject = normalObject {
            centralRenderer.render(object: normalObject)
        }
    }
}

extension Cube: RayTraceable {
    
    func trace(ray: RayTracing.Ray) -> Float? {
        isMoving ? nil : object.trace(ray: ray)
    }
    
    mutating func update() {
        defer {
            object = getObject()
        }
        
        guard isMoving, let angularVelocity = angularVelocity else {
            return
        }
        
        
        
        if timeSinceCollision == -1 {
            timeSinceCollision = 0
        } else {
            timeSinceCollision += 1 / 60
        }
        
        let t = timeSinceCollision
        
        let acceleration: simd_float3 = [0, -9.8, 0]
        let a_contribution = acceleration / 2 * t * t
        
        location = a_contribution + velocity0 * t + location0
        
        
        
        let angle = angularVelocity.angle / 60
        let axis  = angle == 0 ? [0, 1, 0] : angularVelocity.axis
        
        let rotation = simd_quatf(angle: angle, axis: axis)
        orientation = rotation * orientation
    }
    
}
