# WTCoreGraphicsExtensions

[![CI Status](http://img.shields.io/travis/Wagner Truppel/WTCoreGraphicsExtensions.svg?style=flat)](https://travis-ci.org/Wagner Truppel/WTCoreGraphicsExtensions)
[![Version](https://img.shields.io/cocoapods/v/WTCoreGraphicsExtensions.svg?style=flat)](http://cocoapods.org/pods/WTCoreGraphicsExtensions)
[![License](https://img.shields.io/cocoapods/l/WTCoreGraphicsExtensions.svg?style=flat)](http://cocoapods.org/pods/WTCoreGraphicsExtensions)
[![Platform](https://img.shields.io/cocoapods/p/WTCoreGraphicsExtensions.svg?style=flat)](http://cocoapods.org/pods/WTCoreGraphicsExtensions)

## What

A `Swift` collection of useful extensions to `CGPoint`, `CGVector`, and `CGGradient`.
If you need 2-dimensional vectors then you'll want this.

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
```

## Requirements

## Installation

WTCoreGraphicsExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WTCoreGraphicsExtensions"
```

## Author

Wagner Truppel, trupwl@gmail.com

## License

WTCoreGraphicsExtensions is available under the MIT license. See the LICENSE file for more info.
