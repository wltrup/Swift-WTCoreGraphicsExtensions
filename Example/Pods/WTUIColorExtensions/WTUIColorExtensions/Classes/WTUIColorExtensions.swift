/*
 WTUIColorExtensions.swift
 WTUIColorExtensions

 Created by Wagner Truppel on 2016.12.03.

 The MIT License (MIT)

 Copyright (c) 2016 Wagner Truppel.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 When crediting me (Wagner Truppel) for this work, please use one
 of the following two suggested formats:

 Uses "WTUIColorExtensions" by Wagner Truppel
 https://github.com/wltrup

 or

 WTUIColorExtensions by Wagner Truppel
 https://github.com/wltrup
 */

import Foundation
import CoreGraphics
import UIKit


public extension UIColor
{
    /// Returns a new `UIColor` instance in the **RGB color space**, with
    /// pseudo-random values for its color coordinates (red, green, blue),
    /// but with its opacity (alpha) set to 1.
    ///
    /// - SeeAlso: `UIColor.randomRGBA`.
    ///
    /// - SeeAlso: `UIColor.randomHSB`.
    /// - SeeAlso: `UIColor.randomHSBA`.
    ///
    /// - SeeAlso: `UIColor.randomWhite`.
    /// - SeeAlso: `UIColor.randomWhiteAlpha`.
    public static var randomRGB: UIColor
    {
        let r = UIColor.random01
        let g = UIColor.random01
        let b = UIColor.random01
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }

    /// Returns a new `UIColor` instance in the **RGB color space**, with
    /// pseudo-random values for all its color coordinates (red, green, blue, alpha).
    ///
    /// - SeeAlso: `UIColor.randomRGB`.
    ///
    /// - SeeAlso: `UIColor.randomHSB`.
    /// - SeeAlso: `UIColor.randomHSBA`.
    ///
    /// - SeeAlso: `UIColor.randomWhite`.
    /// - SeeAlso: `UIColor.randomWhiteAlpha`.
    public static var randomRGBA: UIColor
    {
        let r = UIColor.random01
        let g = UIColor.random01
        let b = UIColor.random01
        let a = UIColor.random01
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    // MARK: -

    /// Returns a new `UIColor` instance in the **HSB color space**,\* with
    /// pseudo-random values for its color coordinates (hue, saturation, brightness),
    /// but with its opacity (alpha) set to 1.
    ///
    /// \* NOTE: Although this computed property creates a `UIColor` instance
    ///          using HSB values, that instance is internally stored as an
    ///          RGB color so it's not actually in the HSB color space.
    ///
    /// - SeeAlso: `UIColor.randomRGB`.
    /// - SeeAlso: `UIColor.randomRGBA`.
    ///
    /// - SeeAlso: `UIColor.randomHSBA`.
    ///
    /// - SeeAlso: `UIColor.randomWhite`.
    /// - SeeAlso: `UIColor.randomWhiteAlpha`.
    public static var randomHSB: UIColor
    {
        let h = UIColor.random01
        let s = UIColor.random01
        let b = UIColor.random01
        return UIColor(hue: h, saturation: s, brightness: b, alpha: 1)
    }

    /// Returns a new `UIColor` instance in the **HSB color space**,\* with
    /// pseudo-random values for all its color coordinates
    /// (hue, saturation, brightness, alpha).
    ///
    /// \* NOTE: Although this computed property creates a `UIColor` instance
    ///          using HSB values, that instance is internally stored as an
    ///          RGB color so it's not actually in the HSB color space.
    ///
    /// - SeeAlso: `UIColor.randomRGB`.
    /// - SeeAlso: `UIColor.randomRGBA`.
    ///
    /// - SeeAlso: `UIColor.randomHSB`.
    ///
    /// - SeeAlso: `UIColor.randomWhite`.
    /// - SeeAlso: `UIColor.randomWhiteAlpha`.
    public static var randomHSBA: UIColor
    {
        let h = UIColor.random01
        let s = UIColor.random01
        let b = UIColor.random01
        let a = UIColor.random01
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }

    // MARK: -

    /// Returns a new `UIColor` instance in the **grayscale**\* color space,
    /// with a pseudo-random value for its white coordinate but with its
    /// opacity (alpha) set to 1.
    ///
    /// \* NOTE: Although this computed property creates a `UIColor` instance
    ///          using a grayscale value, that instance is internally stored
    ///          as an RGB color so it's not actually in the grayscale color
    ///          space.
    ///
    /// - SeeAlso: `UIColor.randomRGB`.
    /// - SeeAlso: `UIColor.randomRGBA`.
    ///
    /// - SeeAlso: `UIColor.randomHSB`.
    /// - SeeAlso: `UIColor.randomHSBA`.
    ///
    /// - SeeAlso: `UIColor.randomWhiteAlpha`.
    public static var randomWhite: UIColor
    {
        let w = UIColor.random01
        return UIColor(white: w, alpha: 1)
    }

    /// Returns a new `UIColor` instance in the **grayscale color space**,\*
    /// with a pseudo-random value for both its white coordinate and its
    /// opacity coordinate (alpha).
    ///
    /// \* NOTE: Although this computed property creates a `UIColor` instance
    ///          using a grayscale value, that instance is internally stored
    ///          as an RGB color so it's not actually in the grayscale color
    ///          space.
    ///
    /// - SeeAlso: `UIColor.randomRGB`.
    /// - SeeAlso: `UIColor.randomRGBA`.
    ///
    /// - SeeAlso: `UIColor.randomHSB`.
    /// - SeeAlso: `UIColor.randomHSBA`.
    ///
    /// - SeeAlso: `UIColor.randomWhite`.
    public static var randomWhiteAlpha: UIColor
    {
        let w = UIColor.random01
        let a = UIColor.random01
        return UIColor(white: w, alpha: a)
    }

    // MARK: -

    /// An enumeration describing the possible errors that can be thrown when using
    /// functions from the extended `UIColor` API provided by **WTUIColorExtensions**.
    ///
    /// - **invalidColorSpace**:
    ///            Signifies that the attempted function cannot be performed with the
    ///            color space provided.
    public enum ColorError: Error
    {
        case invalidColorSpace
    }
    
    // MARK: -
    
    /// A struct to store the RGBA components of a `UIColor` instance.
    public struct RGBAComponents
    {
        public let red: CGFloat
        public let green: CGFloat
        public let blue: CGFloat
        public let alpha: CGFloat
    }

    /// Returns the RGBA components of `self`.
    ///
    /// - Returns: the RGBA components of `self`.
    ///
    /// - Throws: `ColorError.invalidColorSpace` if somehow
    ///           the RGBA components can't be extracted from `self` (this
    ///           should never happen on iOS but...)
    public func rgbaComponents() throws -> RGBAComponents
    {
        var r: CGFloat = 0; var g: CGFloat = 0;
        var b: CGFloat = 0; var a: CGFloat = 0
        let success = getRed(&r, green: &g, blue: &b, alpha: &a)
        guard success else { throw ColorError.invalidColorSpace }
        return RGBAComponents(red: r, green: g, blue: b, alpha: a)
    }

    // MARK: -

    /// A struct to store the HSBA components of a `UIColor` instance.
    public struct HSBAComponents
    {
        public let hue: CGFloat
        public let saturation: CGFloat
        public let brightness: CGFloat
        public let alpha: CGFloat
    }

    /// Returns the HSBA components of `self`.
    ///
    /// - Returns: the HSBA components of `self`.
    ///
    /// - Throws: `Error.invalidColorSpace` if somehow
    ///           the HSBA components can't be extracted from `self` (this
    ///           should never happen on iOS but...)
    public func hsbaComponents() throws -> HSBAComponents
    {
        var h: CGFloat = 0; var s: CGFloat = 0;
        var b: CGFloat = 0; var a: CGFloat = 0
        let success = getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        guard success else { throw ColorError.invalidColorSpace }
        return HSBAComponents(hue: h, saturation: s, brightness: b, alpha: a)
    }

    // MARK: -

    /// A struct to store the white and alpha components of a `UIColor` instance
    /// in the grayscale color space.
    public struct WhiteAlphaComponents
    {
        public let white: CGFloat
        public let alpha: CGFloat
    }

    /// Returns the white and alpha components of `self`.
    ///
    /// - Returns: the white and alpha components of `self`.
    ///
    /// - Throws: `ColorError.invalidColorSpace` if `self`
    ///           is made up of different values for its RGB components,
    ///           which would make a grayscale assignment impossible.
    public func whiteAlphaComponents() throws -> WhiteAlphaComponents
    {
        let rgbaComps = try! rgbaComponents()
        guard rgbaComps.red == rgbaComps.green && rgbaComps.red == rgbaComps.blue else {
            throw ColorError.invalidColorSpace
        }

        var w: CGFloat = 0; var a: CGFloat = 0
        let success = getWhite(&w, alpha: &a)
        guard success else { throw ColorError.invalidColorSpace }

        return WhiteAlphaComponents(white: w, alpha: a)
    }

    // MARK: - Private API

    /// Returns a uniformly-distributed pseudo-random value in the
    /// **closed** interval [0, 1].
    private static var random01: CGFloat
    { return CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max - 1) }
}

