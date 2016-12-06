/*
 CGGradient+extensions.swift
 WTCoreGraphicsExtensions

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

 Uses "WTCoreGraphicsExtensions" by Wagner Truppel
 https://github.com/wltrup

 or

 WTCoreGraphicsExtensions by Wagner Truppel
 https://github.com/wltrup
 */

import CoreGraphics
import UIKit
import WTUIColorExtensions


public extension CGGradient
{
    /// An enumeration describing the possible errors that can be thrown when using
    /// functions from the extended `CGGradient` API provided 
    /// by **WTCoreGraphicsExtensions**.
    ///
    /// - **mismatchedColorAndLocationArraySizes**:
    ///            Signifies that the function throwing the error
    ///            expected an array of colors and an array of their
    ///            locations, having the same length, but was passed
    ///            arrays of different lengths.
    ///
    /// - **invalidNumberOfColorLocationPairs**:
    ///            Signifies that the function throwing the error
    ///            expected a minimum number of color locations but
    ///            was passed a number below that.
    ///
    /// - **invalidColorLocations**:
    ///            Signifies that the function throwing the error
    ///            expected an array of color locations with at least
    ///            two distinct locations.
    public enum CGGradientError: Error
    {
        case mismatchedColorAndLocationArraySizes
        case invalidNumberOfColorLocationPairs
        case invalidColorLocations
    }
    
    /// Returns an instance (or `nil`) which represents a gradient
    /// of colors in the RGB color space, with specific color values located
    /// at particular positions along the final gradient.
    ///
    /// The locations array need **not** be sorted in ascending order **nor**
    /// need it be normalized to the closed interval [0, 1].
    ///
    /// - Parameters:
    ///   - colors: an array of the colors defining the gradient.
    ///   - locations: an array of locations for those colors.
    ///   - colorSpace: the color space to use for the gradient.
    ///
    /// - Returns: an instance (or `nil`) which represents
    ///            a gradient of colors from the given color space, with
    ///            specific color values located at particular positions
    ///            along the final gradient.
    ///
    /// - Throws: `CGGradient.CGGradientError.mismatchedColorAndLocationArraySizes`
    ///           if the `colors` and the `locations` arrays have different lengths.
    ///
    /// - Throws: `CGGradient.CGGradientError.invalidNumberOfColorLocationPairs`
    ///           if the `locations` array has a length below 2.
    ///
    /// - Throws: `CGGradient.CGGradientError.invalidColorLocations`
    ///           if the `locations` array does not have at least two distinct elements.
    ///
    /// - Throws: `UIColor.ColorError.invalidColorSpace`
    ///           if any of the provided colors is not in the RGB color space.
    public static func rgbaGradient(with colors: [UIColor], at locations: [CGFloat])
        throws -> CGGradient?
    {
        let numLocations: size_t = locations.count
        guard numLocations > 1 else {
            throw CGGradient.CGGradientError.invalidNumberOfColorLocationPairs
        }
        guard colors.count == locations.count else {
            throw CGGradient.CGGradientError.mismatchedColorAndLocationArraySizes
        }

        let sortedLocations = locations.sorted(by: <)
        let minLocation = sortedLocations.first!
        let maxLocation = sortedLocations.last!

        let locationRange = maxLocation - minLocation
        guard locationRange != 0 else {
            throw CGGradient.CGGradientError.invalidColorLocations
        }

        let normalizedLocations = locations.map { ($0 - minLocation) / locationRange }

        let pairs: [(location: CGFloat, color: UIColor)] = (0 ..< locations.count)
            .map { index in (normalizedLocations[index], colors[index]) }
            .sorted { (pair1, pair2) in pair1.location <= pair2.location }

        let sortedNormalizedLocations = pairs.map { pair in pair.location }
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let colorComponents: [CGFloat] = try pairs
            .map { (_, color) in try color.rgbaComponents() }
            .map { comps in [comps.red, comps.green, comps.blue, comps.alpha] }
            .flatMap { $0 }

        return CGGradient(colorSpace: colorSpace,
                          colorComponents: colorComponents,
                          locations: sortedNormalizedLocations,
                          count: numLocations)
    }
}
