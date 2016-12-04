# WTCoreGraphicsExtensions

[![CI Status](http://img.shields.io/travis/wltrup/Swift-WTCoreGraphicsExtensions.svg?style=flat)](https://travis-ci.org/wltrup/Swift-WTCoreGraphicsExtensions)
[![Version](https://img.shields.io/cocoapods/v/WTCoreGraphicsExtensions.svg?style=flat)](http://cocoapods.org/pods/WTCoreGraphicsExtensions)
[![License](https://img.shields.io/cocoapods/l/WTCoreGraphicsExtensions.svg?style=flat)](http://cocoapods.org/pods/WTCoreGraphicsExtensions)
[![Platform](https://img.shields.io/cocoapods/p/WTCoreGraphicsExtensions.svg?style=flat)](http://cocoapods.org/pods/WTCoreGraphicsExtensions)

## What

A `Swift` collection of useful extensions to `CGPoint`, `CGVector`, and `CGGradient`.
If you need 2-dimensional vectors then you'll probably like this library.

## Why

If you look at the definitions of `CGPoint` and `CGVector` you'll see that they leave much to be desired. In fact, if you do any two-dimensional game development then you know that `CGVector` - as defined - is no vector at all!

```swift
public struct CGPoint
{
    public var x: CGFloat
    public var y: CGFloat
    public init()
    public init(x: CGFloat, y: CGFloat)
}

extension CGPoint
{
    public static var zero: CGPoint { get }
    public init(x: Int, y: Int)
    public init(x: Double, y: Double)
    public init?(dictionaryRepresentation dict: CFDictionary)
}

extension CGPoint : Equatable {}

public struct CGVector
{
    public var dx: CGFloat
    public var dy: CGFloat
    public init()
    public init(dx: CGFloat, dy: CGFloat)
}

extension CGVector
{
    public static var zero: CGVector { get }
    public init(dx: Int, dy: Int)
    public init(dx: Double, dy: Double)
}

extension CGVector : Equatable {}
```

Well, not anymore. I've put together a comprehensive suite of methods for two-dimensional vector manipulations, everything from addition of a vector to a point, to dot and cross products, to rotations, to finding projections,
all extensively tested.

Here is the full list of API additions to these types:

```swift
public enum WTCoreGraphicsExtensionsError : Error
{
    case negativeTolerance
    case negativeMagnitude
    case notNormalizable
    case divisionByZero
}

public extension CGFloat
{
    static public let tolerance: CGFloat
}

public extension CGPoint
{
    public init(x: Float, y: Float)
    public static func random(_ a: CGFloat, _ b: CGFloat) -> CGPoint

    public func isNearlyEqual(to other: CGPoint, tolerance: CGFloat = default) throws -> Bool
    public func isNearlyZero(tolerance: CGFloat = default) throws -> Bool

    public func distance(to other: CGPoint) -> CGFloat
    public func distanceSquared(to other: CGPoint) -> CGFloat
    public func manhattanDistance(to other: CGPoint) -> CGFloat

    public func vector(to other: CGPoint) -> CGVector
    public func vector(from other: CGPoint) -> CGVector
    public static func vector(from point1: CGPoint, to point2: CGPoint) -> CGVector

    public static func +(lhs: CGPoint, rhs: CGVector) -> CGPoint
    public static func -(lhs: CGPoint, rhs: CGVector) -> CGPoint
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGVector
    public static func +=(lhs: inout CGPoint, rhs: CGVector)
    public static func -=(lhs: inout CGPoint, rhs: CGVector)
}

extension CGPoint : Hashable
{
    public var hashValue: Int { get }
}

public extension CGVector {

    public init(dx: Float, dy: Float)
    public init(from p1: CGPoint, to p2: CGPoint)

    public init(magnitude m: CGFloat, angle a: CGFloat) throws
    public init(magnitude m: CGFloat, sine sina: CGFloat, cosine cosa: CGFloat) throws

    public static func random(_ a: CGFloat, _ b: CGFloat) -> CGVector

    public static var unitVectorX: CGVector { get }
    public static var unitVectorY: CGVector { get }

    public func isNearlyEqual(to other: CGVector, tolerance: CGFloat = default) throws -> Bool
    public func isNearlyZero(tolerance: CGFloat = default) throws -> Bool

    public var magnitude: CGFloat { get }
    public var magnitudeSquared: CGFloat { get }
    public var manhattanMagnitude: CGFloat { get }

    public var isNormalizable: Bool { get }
    public mutating func normalize() throws
    public var normalized: CGVector? { get }

    public mutating func scaleMagnitude(to value: CGFloat) throws
    public func magnitudeScaled(to value: CGFloat) -> CGVector?

    public mutating func scaleMagnitudeDownToIfLarger(than maxValue: CGFloat) throws
    public func magnitudeScaledDownToIfLarger(than maxValue: CGFloat) throws -> CGVector

    public mutating func scaleMagnitudeUpToIfSmaller(than minValue: CGFloat) throws
    public func magnitudeScaledUpToIfSmaller(than minValue: CGFloat) throws -> CGVector

    public func dot(with other: CGVector) -> CGFloat
    public func cross(with other: CGVector) -> CGFloat

    public var angleFromXAxis: CGFloat { get }

    public var sinAngleFromXAxis: CGFloat { get }
    public var cosAngleFromXAxis: CGFloat { get }
    public var tanAngleFromXAxis: CGFloat { get }

    public func smallestAngle(with other: CGVector) -> CGFloat

    public func projectionParallel(to other: CGVector) -> CGVector
    public func isNearlyParallel(to other: CGVector, tolerance: CGFloat = default) throws -> Bool

    public func projectionPerpendicular(to other: CGVector) -> CGVector
    public func isNearlyPerpendicular(to other: CGVector, tolerance: CGFloat = default) throws -> Bool

    public mutating func rotateClockwise(by angle: CGFloat)
    public func rotatedClockwise(by angle: CGFloat) -> CGVector

    public mutating func rotateClockwise(sine sina: CGFloat, cosine cosa: CGFloat)
    public func rotatedClockwise(sine sina: CGFloat, cosine cosa: CGFloat) -> CGVector

    public mutating func rotateCounterClockwise(by angle: CGFloat)
    public func rotatedCounterClockwise(by angle: CGFloat) -> CGVector

    public mutating func rotateCounterClockwise(sine sina: CGFloat, cosine cosa: CGFloat)
    public func rotatedCounterClockwise(sine sina: CGFloat, cosine cosa: CGFloat) -> CGVector

    public static func +(lhs: CGVector, rhs: CGVector) -> CGVector
    public static func -(lhs: CGVector, rhs: CGVector) -> CGVector
    public static func *(lhs: CGFloat, rhs: CGVector) -> CGVector
    public static func *(lhs: CGVector, rhs: CGFloat) -> CGVector
    public static func /(lhs: CGVector, rhs: CGFloat) throws -> CGVector

    public prefix static func -(vector: CGVector) -> CGVector

    public static func +=(lhs: inout CGVector, rhs: CGVector)
    public static func -=(lhs: inout CGVector, rhs: CGVector)
    public static func *=(lhs: inout CGVector, rhs: CGFloat)
    public static func /=(lhs: inout CGVector, rhs: CGFloat) throws
}

extension CGVector : Hashable
{
    public var hashValue: Int { get }
}

public extension CGGradient
{
    public enum CGGradientError : Error
    {
        case mismatchedColorAndLocationArraySizes
        case invalidNumberOfColorLocationPairs
        case invalidColorLocations
    }

    public static func rgbaGradient(with colors: [UIColor],
                                    at locations: @autoclosure @escaping [CGFloat]) throws -> CGGradient?
}
```

## Tests

**WTCoreGraphicsExtensions** adds 68 properties and functions, all tested by 138 tests with over 92%
coverage. The missing 8% test-coverage is due to the fact that `CGGradient` is a very opaque type so once
`rgbaGradient(with:at:)` creates it, there's nothing that can be extracted from it to compare with in a test.

## Requirements

**WTCoreGraphicsExtensions** depends on two other of my libraries:

    - [**WTBinaryFloatingPointExtensions**](https://github.com/wltrup/Swift-WTBinaryFloatingPointExtensions)
    - [**WTUIColorExtensions**](https://github.com/wltrup/iOS-Swift-WTUIColorExtensions)

## Installation

**WTCoreGraphicsExtensions** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WTCoreGraphicsExtensions"
```

## Author

Wagner Truppel, trupwl@gmail.com

## License

**WTCoreGraphicsExtensions** is available under the MIT license. See the LICENSE file for more info.
