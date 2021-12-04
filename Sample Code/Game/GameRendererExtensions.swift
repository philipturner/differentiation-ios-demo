/*
See LICENSE.txt for this sample’s licensing information.
*/

import ARHeadsetKit
import Differentiation

extension GameRenderer: CustomRenderer {
    
    func updateResources() {
        cubePicker.updateResources()
        
        if let cubeIndex = cubePicker.cubeIndex {
            cubes[cubeIndex].isRed = true
        }
        
        cubeRenderer.updateResources()
        
        if let cubeIndex = cubePicker.cubeIndex {
            if cubes[cubeIndex].isMoving {
                cubePicker.trackedCubeIndex = cubeIndex
                cubePicker.cubeIndex = nil
            }
            
            cubes[cubeIndex].isRed = false
        }
        
        if cubePicker.trackedCubeIndex != nil {
            setVelocityYLabel()
        }
        
        gameInterface.updateResources()
    }
    
    func setVelocityYLabel() {
        let cube = cubes[cubePicker.trackedCubeIndex!]
        let location = cube.location0
        
        @differentiable(reverse)
        func getLocationY(t: Float) -> Float {
            let acceleration: simd_float3 = [0, -9.8, 0]
            let a_contribution = acceleration.y / 2 * t * t
            
            return a_contribution + cube.velocity0.y * t + cube.location0.y
        }
        
        let dydt = gradient(at: cube.timeSinceCollision, of: getLocationY(t:))
        
        let velocity_String = String(format: "%.1f", dydt)
        let message = "Velocity (Y): \(velocity_String) m/s"
        
        gameInterface.reactionParams = (message, location)
        gameInterface.updateReactionMessage()
    }
    
    func drawGeometry(renderEncoder: ARMetalRenderCommandEncoder) {
        
    }
    
}
