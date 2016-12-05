/*
 WTBinaryFloatingPointExtensions.swift
 WTBinaryFloatingPointExtensions

 Created by Wagner Truppel on 2016.12.03

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

 Uses "WTBinaryFloatingPointExtensions" by Wagner Truppel
 https://github.com/wltrup

 or

 WTBinaryFloatingPointExtensions by Wagner Truppel
 https://github.com/wltrup
 */

import Foundation


/// An enumeration describing the possible errors that can be thrown when
/// using functions from the extended `BinaryFloatingPoint` APIs provided
/// by **WTBinaryFloatingPointExtensions**.
///
/// - **allArgumentsAreZero**:
///            Signifies that a function was called with its arguments
///            all equal to zero when it was meant to be called with at
///            least one non-zero argument.
public enum WTBinaryFloatingPointExtensionsError: Error
{
    case allArgumentsAreZero
}

// MARK: -

public extension BinaryFloatingPoint
{
    // MARK: - The most commonly used angles in trigonometry

    /// The value of π/4 radians (45 degrees).
    public static var piOver4: Self { return Self.pi / 4 }

    /// The value of π/2 radians (90 degrees).
    public static var piOver2: Self { return Self.pi / 2 }

    /// The value of 3π/2 radians (270 degrees).
    public static var threePiOver2: Self { return 3 * Self.piOver2 }

    /// The value of 2π radians (360 degrees).
    public static var twoPi: Self { return 2 * Self.pi }

    // MARK: - Trigonometric conversions

    /// Considers `self` to be a value in radians and returns its corresponding
    /// value in degrees.
    /// - SeeAlso: `degreesInRadians` for the transformation in the opposite direction.
    public var radiansInDegrees: Self
    { return self * Self(180 / M_PI) }

    /// Considers `self` to be a value in degrees and returns its corresponding
    /// value in radians.
    /// - SeeAlso: `radiansInDegrees` for the transformation in the opposite direction.
    public var degreesInRadians: Self
    { return self * Self(M_PI / 180) }

    // MARK: - Uniform pseudo-random distributions

    /// Returns a uniformly-distributed pseudo-random value in the **closed** 
    /// interval [0, 1].
    public static var random01: Self
    { return Self(arc4random_uniform(UInt32.max)) / Self(UInt32.max - 1) }

    /// Returns a uniformly-distributed pseudo-random value in the **closed**
    /// interval [min(a,b), max(a,b)].
    ///
    /// - Parameters:
    ///   - a: any value
    ///   - b: any value
    ///
    /// - Returns: a uniformly-distributed pseudo-random value in the **closed**
    ///            interval [min(a,b), max(a,b)].
    ///
    /// - SeeAlso: `random01` for the special case of [a, b] = [0, 1].
    /// - SeeAlso: `randomNonZero(a:b:)`.
    public static func random(_ a: Self, _ b: Self) -> Self
    { return a + (b - a) * Self.random01 }

    /// Returns a uniformly-distributed pseudo-random **non-zero** value in the
    /// **closed** interval [min(a,b), max(a,b)].
    ///
    /// - Parameters:
    ///   - a: any value
    ///   - b: any value
    ///
    /// - Returns: a uniformly-distributed **non-zero** pseudo-random value in
    ///            the **closed** interval [min(a,b), max(a,b)].
    ///
    /// - Throws: WTBinaryFloatingPointExtensionsError.allArgumentsAreZero
    ///           if both a = 0 and b = 0.
    ///
    /// - SeeAlso: `random01` for the special case of [a, b] = [0, 1].
    /// - SeeAlso: `random(a:b:)`.
    public static func randomNonZero(_ a: Self, _ b: Self) throws -> Self
    {
        guard a != 0 || b != 0 else {
            throw WTBinaryFloatingPointExtensionsError.allArgumentsAreZero
        }
        var r: Self = 0
        while r == 0 { r = Self.random(a, b) }
        return r
    }
}

