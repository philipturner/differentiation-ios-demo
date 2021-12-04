/*
See LICENSE.txt for this sample’s licensing information.
*/

import ARHeadsetKit

extension GameInterface {
    
    func updateResources() {
        Self.interfaceScale = gameRenderer.interfaceScale
        
        if buttons == nil {
            buttons = .init()
        } else if gameRenderer.interfaceScaleChanged {
            buttons.resetSize()
        }
        
        adjustInterface()
        
        
        
        var selectedButton: CachedParagraph?
        let renderer = gameRenderer.renderer
        
        if let interactionRay = renderer.interactionRay,
           let traceResult = buttons.trace(ray: interactionRay) {
            selectedButton = traceResult.elementID
        }
        
        if let selectedButton = selectedButton {
            buttons[selectedButton].isHighlighted = true
            
            if renderer.shortTappingScreen {
                executeAction(for: selectedButton)
            }
        }
        
        interfaceRenderer.render(elements: buttons.elements)
        
        if let selectedButton = selectedButton {
            buttons[selectedButton].isHighlighted = false
        }
    }
    
    func executeAction(for button: CachedParagraph) {
        var cubes: [Cube] {
            get { cubeRenderer.cubes }
            set { cubeRenderer.cubes = newValue }
        }
        
        switch button {
        case .resetButton:
            reactionParams = nil
            cubePicker.cubeIndex = nil
            cubePicker.trackedCubeIndex = nil
            cubes.removeAll(keepingCapacity: true)
            
            for _ in 0..<10 {
                cubes.append(cubeRenderer.makeNewCube())
            }
        case .extendButton:
            for i in 0..<10 where i != cubePicker.trackedCubeIndex && cubes[i].isMoving {
                cubes[i] = cubeRenderer.makeNewCube()
            }
        default:
            break
        }
    }
    
    func adjustInterface() {
        let cameraTransform = gameRenderer.cameraToWorldTransform
        let cameraDirection4 = -cameraTransform.columns.2
        let cameraDirection = simd_make_float3(cameraDirection4)
        
        var rotation = simd_quatf(from: [0, 1, 0], to: cameraDirection)
        var axis = rotation.axis
        
        if rotation.angle == 0 {
            axis = [0, 1, 0]
        }
        
        func adjustButton(_ button: CachedParagraph, angleDegrees: Float) {
            let angleRadians = degreesToRadians(angleDegrees)
            rotation = simd_quatf(angle: angleRadians, axis: axis)
            
            let backwardDirection = rotation.act([0, 1, 0])
            let upDirection = cross(backwardDirection, axis)
            
            let orientation = ARInterfaceElement.createOrientation(
                forwardDirection: -backwardDirection,
                orthogonalUpDirection: upDirection
            )
            
            var position = gameRenderer.interfaceCenter
            let depth = type(of: renderer).interfaceDepth
            position += backwardDirection * depth
            
            buttons[button].setProperties(position: position,
                                          orientation: orientation)
        }
        
        let separationDegrees = 10 * Self.interfaceScale
        let extendAngleDegrees = 135 + separationDegrees
        
        adjustButton(.resetButton,  angleDegrees: 135)
        adjustButton(.extendButton, angleDegrees: extendAngleDegrees)
        
        
        
        if let position = reactionParams?.location {
            buttons[.velocityYLabel].hidden = false
            
            var forwardDirection = gameRenderer.interfaceCenter
            forwardDirection -= position
            
            if length(forwardDirection) == 0 {
                forwardDirection = [0, 0, 1]
            } else {
                forwardDirection = normalize(forwardDirection)
            }
            
            
            
            var renderingAsHeadsetMode: Bool
            
            if renderer.usingHeadsetMode {
                renderingAsHeadsetMode = true
            } else {
                let coordinator = renderer.coordinator as! Coordinator
                renderingAsHeadsetMode = coordinator.renderARLabelsHorizontally
            }
            
            let cameraX4 = renderingAsHeadsetMode
            /*   +Y   */ ?  cameraTransform.columns.1
            /*   -X   */ : -cameraTransform.columns.0
            var upDirection = simd_make_float3(cameraX4)
            
            var crossProduct = cross(upDirection, forwardDirection)
            crossProduct = cross(forwardDirection, crossProduct)
            
            if length(crossProduct) == 0 {
                upDirection = [0, 1, 0]
            } else {
                upDirection = normalize(crossProduct)
            }
            
            
            
            let orientation = ARInterfaceElement.createOrientation(
                forwardDirection: forwardDirection,
                orthogonalUpDirection: upDirection
            )
            
            let label = CachedParagraph.velocityYLabel
            buttons[label].setProperties(position: position,
                                         orientation: orientation)
        } else {
            buttons[.velocityYLabel].hidden = true
        }
    }
    
}
