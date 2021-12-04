# Differentiation Demo

This is a demonstration of Swift's automatic differentiation working on an iOS sample project. It is a modified version of the game from [ARHeadsetKit](https://github.com/philipturner/ARHeadsetKit) tutorial #8, where the user knocks out cubes with their hand. Automatic differentiation finds a cube's velocity from its equations of motion, then shows the velocity in text.

Differentiation is disabled in Swift release toolchains due to compiler crashes and missing features. This demonstration was enabled by a temporary workaround, the [Differentiation](https://github.com/philipturner/Differentiation) package.

## Rationale

The purpose of this project is to make a case for the resurrection of Swift for TensorFlow. Python ML libraries cannot run on iOS devices, but real-time machine learning can make apps more intelligent. With stable autodiff and a new Metal GPU backend, more opportunities and flexible workflows could be unlocked for mobile app developers.
