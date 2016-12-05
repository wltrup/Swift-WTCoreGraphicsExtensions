# WTUIColorExtensions

[![CI Status](http://img.shields.io/travis/Wagner Truppel/WTUIColorExtensions.svg?style=flat)](https://travis-ci.org/Wagner Truppel/WTUIColorExtensions)
[![Version](https://img.shields.io/cocoapods/v/WTUIColorExtensions.svg?style=flat)](http://cocoapods.org/pods/WTUIColorExtensions)
[![License](https://img.shields.io/cocoapods/l/WTUIColorExtensions.svg?style=flat)](http://cocoapods.org/pods/WTUIColorExtensions)
[![Platform](https://img.shields.io/cocoapods/p/WTUIColorExtensions.svg?style=flat)](http://cocoapods.org/pods/WTUIColorExtensions)

## What

**WTUIColorExtensions** adds to `UIColor` the ability to generate pseudo-random color instances,
given their RGBA, HSBA, or white/alpha components, as well as methods to extract those color
components in a more direct way than using `inout` arguments and the default `get...` methods.
Here's the full set of API additions:

```swift
    public static var randomRGB: UIColor { get }
    public static var randomRGBA: UIColor { get }

    public static var randomHSB: UIColor { get }
    public static var randomHSBA: UIColor { get }

    public static var randomWhite: UIColor { get }
    public static var randomWhiteAlpha: UIColor { get }

    public enum ColorError : Error {
        case invalidColorSpace
    }

    public struct RGBAComponents {
        public let red: CGFloat
        public let green: CGFloat
        public let blue: CGFloat
        public let alpha: CGFloat
    }
    public func rgbaComponents() throws -> RGBAComponents

    public struct HSBAComponents {
        public let hue: CGFloat
        public let saturation: CGFloat
        public let brightness: CGFloat
        public let alpha: CGFloat
    }
    public func hsbaComponents() throws -> HSBAComponents

    public struct WhiteAlphaComponents {
        public let white: CGFloat
        public let alpha: CGFloat
    }
    public func whiteAlphaComponents() throws -> WhiteAlphaComponents
```

## Why

Because generating random colors is a common enough need and because having to use `inout`
arguments to extract color components is annoying.

## Tests

**WTUIColorExtensions** adds 9 extensions, all tested by 21 tests with over 95% coverage.
The missing 5% test-coverage is due to the fact that `rgbaComponents()` and `hsbaComponents()`
don't actually `throw` any invalid color space errors on iOS, although in theory they could.
In order to future-proof this library, I've assumed that those methods might fail but I can't
currently test that code path.

## Installation

**WTUIColorExtensions** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WTUIColorExtensions"
```

## Author

Wagner Truppel, trupwl@gmail.com

## License

**WTUIColorExtensions** is available under the MIT license. See the LICENSE file for more info.
