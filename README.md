# Differentiation Demo

This is a demonstration of Swift's automatic differentiation running on iOS. It is a modified version of the game from [ARHeadsetKit tutorial #8](https://github.com/philipturner/ARHeadsetKit#tutorial-series), where the user knocks out cubes with their hand. Automatic differentiation finds a cube's velocity from its equations of motion, then shows the velocity in text.

The following code segment shows how differentiation is used to find the Y component of a cube's velocity:

```swift
import Differentiation

let cube = cubes[...]

@differentiable(reverse)
func getLocationY(t: Float) -> Float {
    let acceleration: SIMD3<Float> = [0, -9.8, 0]
    let a_contribution = acceleration.y / 2 * t * t

    return a_contribution + cube.velocity0.y * t + cube.location0.y
}

let dydt = gradient(at: cube.timeSinceCollision, of: getLocationY(t:))
let velocityText = String(format: "%.1f", dydt)
let messageText = "Velocity (Y): \(velocityText) m/s"
```

Differentiation is disabled in Swift release toolchains due to compiler crashes and missing features. This demonstration was enabled by a temporary workaround, the [Differentiation](https://github.com/philipturner/Differentiation) package.

## Rationale

The purpose of this demo is to make a case for the resurrection of Swift for TensorFlow. Python ML libraries cannot run on iOS devices, yet real-time machine learning makes apps more intelligent. With stable autodiff and a Metal GPU backend, new opportunities and flexible workflows could be unlocked for mobile app developers.
