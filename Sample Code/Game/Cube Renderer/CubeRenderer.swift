/*
See LICENSE.txt for this sample’s licensing information.
*/

import ARHeadsetKit

class CubeRenderer: DelegateGameRenderer {
    unowned let gameRenderer: GameRenderer
    var cubes: [Cube] = []
    
    required init(gameRenderer: GameRenderer) {
        self.gameRenderer = gameRenderer
        
        srand48(Int(Date().timeIntervalSince1970))
        
        for _ in 0..<10 {
            let newCube = makeNewCube()
            
            cubes.append(newCube)
        }
    }
    
    func makeNewCube() -> Cube {
        func frand24() -> Float {
            Float(drand48())
        }
        
        var location: simd_float3
        
        repeat {
            location = simd_float3(
                simd_mix(-0.3, 0.3, frand24()),
                simd_mix(-0.3, 0.3, frand24()),
                simd_mix(-0.6, 0.0, frand24())
            )
        } while cubes.contains(where: { cube in
            !cube.isMoving && distance(cube.location0, location) < 0.21
        })
        
        var upDirection: simd_float3
        
        repeat {
            upDirection = simd_float3(
                simd_mix(-1, 1, frand24()),
                simd_mix(-1, 1, frand24()),
                simd_mix(-1, 1, frand24())
            )
        } while length(upDirection) > 1
        
        if length(upDirection) == 0 {
            upDirection = [0, 1, 0]
        }
        
        upDirection = normalize(upDirection)
        
        let newCube = Cube(location: location,
                           orientation: simd_quatf(
                               from: [0, 1, 0],
                               to: upDirection),
                           sideLength: 0.2)
        
        return newCube
    }
}
