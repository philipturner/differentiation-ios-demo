/*
See LICENSE.txt for this sample’s licensing information.
*/

import ARHeadsetKit

class CubePicker: DelegateGameRenderer {
    unowned let gameRenderer: GameRenderer
    var cubeIndex: Int?
    var trackedCubeIndex: Int?
    
    required init(gameRenderer: GameRenderer) {
        self.gameRenderer = gameRenderer
    }
    
    func getClosestCubeIndex() -> Int? {
        var closestIndex: Int?
        var closestDistance: Float = .greatestFiniteMagnitude
        var iterator = 0
        
        for cube in cubeRenderer.cubes {
            defer { iterator += 1 }
            
            guard !cube.isMoving else {
                continue
            }
            
            let object = cube.object!
            let dist = centralRenderer.getDistance(of: object)
            
            if dist < closestDistance {
                closestIndex = iterator
                closestDistance = dist
            }
        }
        
        return closestIndex
    }
}
