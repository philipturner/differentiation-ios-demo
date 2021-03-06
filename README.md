# Differentiation Demo

This is an example of Swift's automatic differentiation running on iOS. It is a modified version of the game from [ARHeadsetKit tutorial #8](https://github.com/philipturner/ARHeadsetKit#tutorial-series), where the user knocks out cubes with their hand. Automatic differentiation computes a cube's velocity from its equations of motion, then shows the velocity in text.

Differentiation is disabled in the Swift 5.5 toolchain due to compiler instability, but can be activated by importing the [Differentiation](https://github.com/philipturner/Differentiation) package. The following code segment shows how differentiation is used to find the vertical component of a cube's velocity:

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
_The complete implementation is located in `Sample Code/Game/GameRendererExtensions.swift`._

## Rationale

The purpose of this demo is to make a case for the resurrection of Swift for TensorFlow, which relies on differentiation. Python ML libraries cannot run on iOS devices, yet real-time machine learning makes apps more intelligent. With stable automatic differentiation and a Metal GPU backend, new opportunities and flexible workflows could be unlocked for mobile app developers.

## Video of App

https://user-images.githubusercontent.com/71743241/144722618-e9dc7e1c-e6ef-44cb-8c4b-dc0160f9e8e4.mp4

For those with a slow internet connection:

![Text in augmented reality showing that Y velocity is -17.7 meters per second](./differentiation-image.jpg)

If you have any insights or suggestions about this project, please comment on the [Swift Forums post](https://forums.swift.org/t/swift-for-tensorflow-resurrection-differentiation-running-on-ios/53841).
