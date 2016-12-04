/*
 WTCoreGraphicsExtensions.swift
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

import Foundation
import CoreGraphics
import UIKit

import WTBinaryFloatingPointExtensions
import WTUIColorExtensions


/// An enumeration describing the possible errors that can be thrown when
/// using functions from the extended `CGPoint` and `CGVector` APIs provided
/// by **WTCoreGraphicsExtensions**.
///
/// - **negativeTolerance**:
///            Signifies that the function throwing the error expected
///            a non-negative `tolerance` value but was provided with
///            a negative one.
///
/// - **notNormalizable**:
///            Signifies that the attempted function could not be performed
///            because the `CGVector` instance on which it would operate is
///            not normalizable (ie, is the zero vector).
///
/// - **negativeMagnitude**:
///            Signifies that the attempted function expected a non-negative
///            value for the `magnitude` argument but was passed a negative one.
///
/// - **divisionByZero**:
///            Signifies that an attempt was performed to divide a value by zero.
public enum WTCoreGraphicsExtensionsError: Error
{
    case negativeTolerance
    case negativeMagnitude
    case notNormalizable
    case divisionByZero
}

// MARK: -

// ================================================= //
// ==================== CGFloat ==================== //
// ================================================= //

public extension CGFloat
{
    /// A small positive value used in floating-point comparisons.
    public static let tolerance: CGFloat = 1e-12
}

// MARK: -

// ================================================= //
// ==================== CGPoint ==================== //
// ================================================= //

public extension CGPoint
{
    /// Initializes `self` with the given `Float` components.
    ///
    /// - Parameters:
    ///   - x: any `Float` value.
    ///   - y: any `Float` value.
    public init(x: Float, y: Float)
    {
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }

    /// Returns an instance where each component is a uniform pseudo-random 
    /// number in the **closed** interval [min(a,b), max(a,b)].
    ///
    /// - Parameters:
    ///   - a: any `CGFloat` value.
    ///   - b: any `CGFloat` value.
    ///
    /// - Returns: an instance where each component is a uniform pseudo-random
    ///            number in the **closed** interval [min(a,b), max(a,b)].
    public static func random(_ a: CGFloat, _ b: CGFloat) -> CGPoint
    {
        let x = CGFloat.random(a, b)
        let y = CGFloat.random(a, b)
        return CGPoint(x: x, y: y)
    }

    /// Returns whether or not `self` equals another point, within a given
    /// tolerance. More specifically, returns whether or not the magnitude
    /// of the difference between the two points is within the given tolerance.
    /// For exact comparisons, pass `0` for the `tolerance` value, or use the
    /// `==` operator.
    ///
    /// - Parameters:
    ///   - other: any `CGPoint` instance.
    ///   - tolerance: a small non-negative value.
    ///                The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` equals another point, within the
    ///            given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `isNearlyZero(tolerance:)`.
    public func isNearlyEqual(to other: CGPoint,
                              tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    {
        if tolerance == 0 { return (self == other) }
        guard tolerance > 0 else { throw WTCoreGraphicsExtensionsError.negativeTolerance }
        return distanceSquared(to: other) <= tolerance*tolerance
    }

    /// Returns whether or not `self` equals the zero point, within a given
    /// tolerance. More specifically, returns whether or not the magnitude
    /// of `self` is within the given tolerance. For exact comparisons, pass
    /// `0` for the `tolerance` value, or use the `==` operator.
    ///
    /// - Parameter tolerance: a small non-negative value.
    ///                        The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` equals the zero point, within the
    ///            given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `isNearlyEqual(to:tolerance:)`.
    public func isNearlyZero(tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    { return try isNearlyEqual(to: CGPoint.zero, tolerance: tolerance) }

    /// Returns the
    /// [**Euclidean distance**](https://en.wikipedia.org/wiki/Euclidean_distance)
    /// between `self` and another point.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the Euclidean distance between `self` and another point.
    ///
    /// - SeeAlso: `distanceSquared(to:)`.
    public func distance(to other: CGPoint) -> CGFloat
    { return vector(to: other).magnitude }

    /// Returns the **square** of the
    /// [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance)
    /// between `self` and another point. This is more efficient than calling
    /// `distance(to:)` and then squaring.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the square of the Euclidean distance between `self`
    ///            and another point.
    ///
    /// - SeeAlso: `distance(to:)`.
    public func distanceSquared(to other: CGPoint) -> CGFloat
    { return vector(to: other).magnitudeSquared }

    /// Returns the
    /// [**Manhattan distance**](https://en.wikipedia.org/wiki/Taxicab_geometry)
    /// between `self` and another point. The Manhattan distance is also known as
    /// the **Taxicab distance**.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the Manhattan distance between `self` and another point.
    ///
    /// - SeeAlso: `distance(to:)`.
    /// - SeeAlso: `distanceSquared(to:)`.
    public func manhattanDistance(to other: CGPoint) -> CGFloat
    { return vector(to: other).manhattanMagnitude }

    /// Returns the vector pointing from `self` to another point.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the vector pointing **from** `self` **to** another point.
    ///
    /// - SeeAlso: `vector(from:)`.
    /// - SeeAlso: `CGPoint.vector(from:to:)`.
    public func vector(to other: CGPoint) -> CGVector
    {
        let dx = other.x - self.x
        let dy = other.y - self.y
        return CGVector(dx: dx, dy: dy)
    }

    /// Returns the vector pointing to `self` from another point.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the vector pointing **to** `self` **from** another point.
    ///
    /// - SeeAlso: `vector(to:)`.
    /// - SeeAlso: `CGPoint.vector(from:to:)`.
    public func vector(from other: CGPoint) -> CGVector
    { return other.vector(to: self) }

    /// Returns the vector from one point to another.
    ///
    /// - Parameters:
    ///   - point1: any `CGPoint` instance.
    ///   - point2: any `CGPoint` instance.
    ///
    /// - Returns: the vector from one point to another.
    ///
    /// - SeeAlso: `vector(to:)`.
    /// - SeeAlso: `vector(from:)`.
    public static func vector(from point1: CGPoint, to point2: CGPoint) -> CGVector
    { return point1.vector(to: point2) }

    // MARK: -

    /// Adds a vector to a point, resulting in a point.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    ///
    /// - Returns: the point resulting from adding the vector to the point.
    public static func +(lhs: CGPoint, rhs: CGVector) -> CGPoint
    {
        let x = lhs.x + rhs.dx
        let y = lhs.y + rhs.dy
        return CGPoint(x: x, y: y)
    }

    /// Subtracts a vector from a point, resulting in a point.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    ///
    /// - Returns: the point resulting from subtracting the vector from the point.
    public static func -(lhs: CGPoint, rhs: CGVector) -> CGPoint
    {
        let x = lhs.x - rhs.dx
        let y = lhs.y - rhs.dy
        return CGPoint(x: x, y: y)
    }

    /// Subtracts two points, resulting in a vector pointing from `rhs` to `lhs`.
    ///
    /// - Parameters:
    ///   - lhs: any `CGPoint` instance.
    ///   - rhs: any `CGPoint` instance.
    ///
    /// - Returns: the vector resulting from subtracting a point from another point.
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGVector
    { return rhs.vector(to: lhs) }

    /// Adds a vector to the point `self`.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    public static func +=(lhs: inout CGPoint, rhs: CGVector)
    { lhs = lhs + rhs }

    /// Subtracts a vector from the point `self`.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    public static func -=(lhs: inout CGPoint, rhs: CGVector)
    { lhs = lhs - rhs }
}

// MARK: -

extension CGPoint: Hashable
{
    /// Probably not a great hashing method but simple and useful enough.
    public var hashValue: Int { return "\(x)\(y)".hashValue }
}

// MARK: -

// ================================================== //
// ==================== CGVector ==================== //
// ================================================== //

public extension CGVector
{
    /// Initializes `self` with the given `Float` components.
    ///
    /// - Parameters:
    ///   - dx: any `Float` value.
    ///   - dy: any `Float` value.
    public init(dx: Float, dy: Float)
    {
        self.dx = CGFloat(dx)
        self.dy = CGFloat(dy)
    }

    /// Initializes `self` with the components from a vector going from
    /// point p1 to point p2.
    ///
    /// - Parameters:
    ///   - p1: any `CGPoint` instance.
    ///   - p2: any `CGPoint` instance.
    public init(from p1: CGPoint, to p2: CGPoint)
    {
        dx = p2.x - p1.x
        dy = p2.y - p1.y
    }

    /// Initializes `self` with a magnitude and an angle (in radians)
    /// measured counter-clockwise from the positive X axis.
    ///
    /// - Parameters:
    ///   - m: the desired magnitude, which must be a non-negative number.
    ///   - a: the desired angle (in radians).
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeMagnitude` if `m` is negative.
    ///
    /// - SeeAlso: `init(magnitude:sine:cosine:)`.
    public init(magnitude m: CGFloat, angle a: CGFloat) throws
    {
        guard m >= 0 else { throw WTCoreGraphicsExtensionsError.negativeMagnitude }
        dx = m * cos(a)
        dy = m * sin(a)
    }

    /// Initializes `self` with a magnitude and an angle (in radians)
    /// measured counter-clockwise from the positive X axis, given the
    /// angle's sine and cosine. This is more efficient than using
    /// `init(magnitude:angle:)` when the sine and cosine of the
    /// vector's angle are already known.
    ///
    /// - Parameters:
    ///   - m: the desired magnitude, which must be a non-negative number.
    ///   - sina: the sine of the vector's desired angle.
    ///   - cosa: the cosine of the vector's desired angle.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeMagnitude` if `m` is negative.
    ///
    /// - SeeAlso: `init(magnitude:angle:)`.
    public init(magnitude m: CGFloat, sine sina: CGFloat, cosine cosa: CGFloat) throws
    {
        guard m >= 0 else { throw WTCoreGraphicsExtensionsError.negativeMagnitude }
        dx = m * cosa
        dy = m * sina
    }

    // MARK: -

    /// Returns an instance where each component is a uniform pseudo-random number
    /// in the **closed** interval [min(a,b), max(a,b)].
    ///
    /// - Parameters:
    ///   - a: any `CGFloat` value.
    ///   - b: any `CGFloat` value.
    ///
    /// - Returns: an instance where each component is a uniform pseudo-random
    ///            number in the **closed** interval [min(a,b), max(a,b)].
    public static func random(_ a: CGFloat, _ b: CGFloat) -> CGVector
    {
        let dx = CGFloat.random(a, b)
        let dy = CGFloat.random(a, b)
        return CGVector(dx: dx, dy: dy)
    }

    /// Returns a unit vector along the positive X direction.
    /// SeeAlso: `CGVector.unitVectorY`.
    public static var unitVectorX: CGVector
    { return CGVector(dx: 1, dy: 0) }

    /// Returns a unit vector along the positive Y direction.
    /// SeeAlso: `CGVector.unitVectorX`.
    public static var unitVectorY: CGVector
    { return CGVector(dx: 0, dy: 1) }

    // MARK: -

    /// Returns whether or not `self` equals another vector, within a given
    /// tolerance. More specifically, returns whether or not the magnitude
    /// of the difference between the two vectors is within the given tolerance.
    /// For exact comparisons, pass `0` for the `tolerance` value, or use the
    /// `==` operator.
    ///
    /// - Parameters:
    ///   - other: any `CGVector` instance.
    ///   - tolerance: a small non-negative value.
    ///                The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` equals another vector, within the
    ///            given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `isNearlyZero(tolerance:)`.
    public func isNearlyEqual(to other: CGVector,
                              tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    {
        if tolerance == 0 { return (self == other) }
        guard tolerance > 0 else { throw WTCoreGraphicsExtensionsError.negativeTolerance }
        return (self - other).magnitudeSquared <= tolerance*tolerance
    }

    /// Returns whether or not `self` equals the zero vector, within a given
    /// tolerance. More specifically, returns whether or not the magnitude
    /// of `self` is within the given tolerance. For exact comparisons,
    /// pass `0` for the `tolerance` value, or use the `==` operator.
    ///
    /// - Parameter tolerance: a small non-negative value.
    ///                        The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` equals the zero vector, within the
    ///            given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `isNearlyEqual(to:tolerance:)`.
    public func isNearlyZero(tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    { return try isNearlyEqual(to: CGVector.zero, tolerance: tolerance) }

    // MARK: -

    /// Returns the
    /// [(Eucliden) **magnitude**](https://en.wikipedia.org/wiki/Euclidean_distance)
    /// of `self`.
    ///
    /// - SeeAlso: `magnitudeSquared`.
    public var magnitude: CGFloat { return sqrt(magnitudeSquared) }

    /// Returns the **square** of the
    /// [(Euclidean) magnitude](https://en.wikipedia.org/wiki/Euclidean_distance)
    /// of `self`. This is more efficient than accessing `magnitude` and then
    /// squaring it.
    ///
    /// - SeeAlso: `magnitude`.
    public var magnitudeSquared: CGFloat { return (dx*dx + dy*dy) }

    /// Returns the
    /// [**Manhattan magnitude**](https://en.wikipedia.org/wiki/Taxicab_geometry)
    /// of `self`. The Manhattan magnitude is also known as the **Taxicab magnitude**.
    ///
    /// - SeeAlso: `magnitude`.
    public var manhattanMagnitude: CGFloat
    { return abs(dx) + abs(dy) }

    // MARK: -

    /// Returns whether or not the vector can be normalized.
    ///
    /// - SeeAlso: `normalize()`.
    /// - SeeAlso: `normalized`.
    public var isNormalizable: Bool { return (self != CGVector.zero) }

    /// Attempts to normalize `self`.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.notNormalizable` if the vector
    ///           cannot be normalized (ie, it's the zero vector).
    ///
    /// - SeeAlso: `isNormalizable`.
    /// - SeeAlso: `normalized`.
    public mutating func normalize() throws
    {
        guard isNormalizable else { throw WTCoreGraphicsExtensionsError.notNormalizable }
        let m = magnitude
        dx /= m
        dy /= m
    }

    /// Attempts to return a unit vector along the same direction as
    /// that of `self`. Returns a new vector if `self` is normalizable,
    /// or `nil`, if not.
    ///
    /// - SeeAlso: `isNormalizable`.
    /// - SeeAlso: `normalize()`.
    public var normalized: CGVector?
    {
        var newVector = self
        do { try newVector.normalize() }
        catch { return nil }
        return newVector
    }

    // MARK: -

    /// Maintains the direction of `self` but changes its magnitude to
    /// the absolute value of the argument. If the argument is negative,
    /// reverses `self`'s direction.
    ///
    /// - Parameter value: the magnitude to scale the vector to.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.notNormalizable` if the vector
    ///           cannot be normalized (ie, it's the zero vector).
    ///
    /// - SeeAlso: `magnitudeScaled(to:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeDownToIfLarger(than:)`.
    /// - SeeAlso: `magnitudeScaledDownToIfLarger(than:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeUpToIfSmaller(than:)`.
    /// - SeeAlso: `magnitudeScaledUpToIfSmaller(than:)`.
    public mutating func scaleMagnitude(to value: CGFloat) throws
    {
        try self.normalize()
        self *= value
    }

    /// Returns a new vector with `self`'s direction but with a magnitude equal
    /// to the absolute value of the argument. If the argument is negative, the
    /// returned vector has a direction opposite to that of `self`. If `self` is
    /// not normalizable, returns `nil`.
    ///
    /// - Parameter value: the magnitude to scale the vector to.
    ///
    /// - Returns: a new vector with `self`'s direction but with a magnitude
    ///            equal to the absolute value of the argument, or `nil` if
    ///            the `self` cannot be normalized.
    ///
    /// - SeeAlso: `scaleMagnitude(to:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeDownToIfLarger(than:)`.
    /// - SeeAlso: `magnitudeScaledDownToIfLarger(than:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeUpToIfSmaller(than:)`.
    /// - SeeAlso: `magnitudeScaledUpToIfSmaller(than:)`.
    public func magnitudeScaled(to value: CGFloat) -> CGVector?
    {
        var newVector = self
        do { try newVector.scaleMagnitude(to: value) }
        catch { return nil }
        return newVector
    }

    // MARK: -

    /// If the magnitude of `self` is larger than `maxValue`, then scale it
    /// back down to `maxValue`. Otherwise, do nothing.
    ///
    /// - Parameter maxValue: the magnitude to set the vector to if its
    ///                       current magnitude is above `maxValue`.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeMagnitude`
    ///           if `maxValue` is negative.
    ///
    /// - SeeAlso: `scaleMagnitude(to:)`.
    /// - SeeAlso: `magnitudeScaled(to:)`.
    ///
    /// - SeeAlso: `magnitudeScaledDownToIfLarger(than:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeUpToIfSmaller(than:)`.
    /// - SeeAlso: `magnitudeScaledUpToIfSmaller(than:)`.
    public mutating func scaleMagnitudeDownToIfLarger(than maxValue: CGFloat) throws
    {
        guard maxValue >= 0 else { throw WTCoreGraphicsExtensionsError.negativeMagnitude }
        guard maxValue != 0 else { self = CGVector.zero; return }
        let m = magnitude
        if m > maxValue { self *= (maxValue / m) }
    }

    /// If the magnitude of `self` is larger than `maxValue`, return a new
    /// vector in the same direction of `self` but with a magnitude scaled
    /// down to `maxValue`. Otherwise, return `self`.
    ///
    /// - Parameter maxValue: the magnitude to set the new vector to if its
    ///                       current magnitude is above `maxValue`.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeMagnitude`
    ///           if `maxValue` is negative.
    ///
    /// - SeeAlso: `scaleMagnitude(to:)`.
    /// - SeeAlso: `magnitudeScaled(to:)`.
    ///
    /// - SeeAlso: `magnitudeScaledDownToIfLarger(than:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeUpToIfSmaller(than:)`.
    /// - SeeAlso: `magnitudeScaledUpToIfSmaller(than:)`.
    public func magnitudeScaledDownToIfLarger(than maxValue: CGFloat) throws -> CGVector
    {
        var newVector = self
        try newVector.scaleMagnitudeDownToIfLarger(than: maxValue)
        return newVector
    }

    // MARK: -

    /// If the magnitude of `self` is smaller than `minValue`, then scale it
    /// up to `minValue`. Otherwise, do nothing.
    ///
    /// - Parameter minValue: the magnitude to set the vector to if its
    ///                       current magnitude is below `minValue`.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeMagnitude`
    ///           if `minValue`  is negative.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.notNormalizable` if `self` is not
    ///           normalizable (ie, it's the zero vector).
    ///
    /// - SeeAlso: `scaleMagnitude(to:)`.
    /// - SeeAlso: `magnitudeScaled(to:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeDownToIfLarger(than:)`.
    /// - SeeAlso: `magnitudeScaledDownToIfLarger(than:)`.
    ///
    /// - SeeAlso: `magnitudeScaledUpToIfSmaller(than:)`.
    public mutating func scaleMagnitudeUpToIfSmaller(than minValue: CGFloat) throws
    {
        guard minValue >= 0 else { throw WTCoreGraphicsExtensionsError.negativeMagnitude }
        guard minValue != 0 else { return }
        guard isNormalizable else { throw WTCoreGraphicsExtensionsError.notNormalizable }
        let m = magnitude
        if m < minValue { self *= (minValue / m) }
    }

    /// If the magnitude of `self` is smaller than `minValue`, return a new
    /// vector in the same direction of `self` but with a magnitude scaled
    /// up to `minValue`. Otherwise, return `self`.
    ///
    /// - Parameter minValue: the magnitude to set the new vector to if its
    ///                       current magnitude is below `minValue`.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeMagnitude`
    ///           if `minValue`  is negative.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.notNormalizable` if `self` is not
    ///           normalizable (ie, it's the zero vector).
    ///
    /// - SeeAlso: `scaleMagnitude(to:)`.
    /// - SeeAlso: `magnitudeScaled(to:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeDownToIfLarger(than:)`.
    /// - SeeAlso: `magnitudeScaledDownToIfLarger(than:)`.
    ///
    /// - SeeAlso: `scaleMagnitudeUpToIfSmaller(than:)`.
    public func magnitudeScaledUpToIfSmaller(than minValue: CGFloat) throws -> CGVector
    {
        var newVector = self
        try newVector.scaleMagnitudeUpToIfSmaller(than: minValue)
        return newVector
    }

    // MARK: -

    /// Returns the **dot product** of `self` with another vector.
    ///
    /// - Parameter other: any `CGVector` instance.
    ///
    /// - Returns: the dot product of `self` with another vector.
    ///
    /// - SeeAlso: `cross(with:)`.
    public func dot(with other: CGVector) -> CGFloat
    { return (dx * other.dx + dy * other.dy) }

    /// Returns the **cross product** of `self` with another vector.
    ///
    /// - Parameter other: any `CGVector` instance.
    ///
    /// - Returns: the cross product of `self` with another vector.
    ///
    /// - SeeAlso: `dot(with:)`.
    public func cross(with other: CGVector) -> CGFloat
    { return (dx * other.dy - dy * other.dx) }

    // MARK: -

    /// Returns the oriented angle (in radians) measured from the
    /// positive X axis to `self` (ie, the vector's **argument**),
    /// in the **semi-closed** interval [0, 2π). For consistency
    /// and by convention, returns 0 if `self` is the zero vector.
    ///
    /// - SeeAlso: `sinAngleFromXAxis`.
    /// - SeeAlso: `cosAngleFromXAxis`.
    /// - SeeAlso: `tanAngleFromXAxis`.
    /// - SeeAlso: `smallestAngle(with:)`.
    public var angleFromXAxis: CGFloat
    {
        guard isNormalizable else { return 0 }
        var a = atan2(dy, dx).truncatingRemainder(dividingBy: CGFloat.twoPi)
        if a < 0 { a += CGFloat.twoPi }
        return a
    }

    /// Returns the **sine** of the oriented angle measured counter-clockwise
    /// from the positive X axis to `self`. Returns 0 if `self` is the zero
    /// vector. This is more efficient than invoking `angleFromXAxis` and
    /// then computing its sine. Returns 0 if `self` is the zero vector.
    ///
    /// - SeeAlso: `angleFromXAxis`.
    /// - SeeAlso: `cosAngleFromXAxis`.
    /// - SeeAlso: `tanAngleFromXAxis`.
    /// - SeeAlso: `smallestAngle(with:)`.
    public var sinAngleFromXAxis: CGFloat
    {
        guard isNormalizable else { return 0 }
        return dy/magnitude
    }

    /// Returns the **cosine** of the oriented angle measured counter-clockwise
    /// from the positive X axis to `self`. Returns 0 if `self` is the zero
    /// vector. This is more efficient than invoking `angleFromXAxis` and
    /// then computing its sine. Returns 1 if `self` is the zero vector.
    ///
    /// - SeeAlso: `angleFromXAxis`.
    /// - SeeAlso: `sinAngleFromXAxis`.
    /// - SeeAlso: `tanAngleFromXAxis`.
    /// - SeeAlso: `smallestAngle(with:)`.
    public var cosAngleFromXAxis: CGFloat
    {
        guard isNormalizable else { return 1 }
        return dx/magnitude
    }

    /// Returns the **tangent** of the oriented angle measured counter-clockwise
    /// from the positive X axis to `self`. This is more efficient than invoking
    /// `angleFromXAxis` and then computing its tangent.  Returns the value
    /// `sign(Y component) * CGFloat.infinity` if `self` has a Y component but
    /// no X component. Returns 0 if `self` is the zero vector.
    ///
    /// - SeeAlso: `angleFromXAxis`.
    /// - SeeAlso: `sinAngleFromXAxis`.
    /// - SeeAlso: `cosAngleFromXAxis`.
    /// - SeeAlso: `smallestAngle(with:)`.
    public var tanAngleFromXAxis: CGFloat
    {
        guard isNormalizable else { return 0 }
        guard dx != 0 else { return (dy > 0 ? 1 : -1) * CGFloat.infinity }
        return dy/dx
    }

    // MARK: -

    /// Returns the magnitude of the **smallest angle** (in radians) between
    /// `self` and another vector, in the **closed** interval [0, π].
    ///
    /// - SeeAlso: `angleFromXAxis`.
    /// - SeeAlso: `sinAngleFromXAxis`.
    /// - SeeAlso: `cosAngleFromXAxis`.
    /// - SeeAlso: `tanAngleFromXAxis`.
    public func smallestAngle(with other: CGVector) -> CGFloat
    {
        let thisAngle =  self.angleFromXAxis
        let thatAngle = other.angleFromXAxis
        let delta: CGFloat = abs(thisAngle - thatAngle)
        if delta > CGFloat(180).degreesInRadians { return CGFloat.twoPi - delta }
        return delta
    }

    // MARK: -

    /// Returns a vector whose magnitude is the projection of `self` onto
    /// the given vector and whose direction is the direction of the given
    /// vector. In other words, this method extracts from self a vector that's
    /// **parallel** to the given vector. If either vector is the zero vector,
    /// then returns `self` since, by convention, the zero vector is parallel
    /// to any vector.
    ///
    /// - Parameter other: any `CGVector` instance.
    ///
    /// - Returns: the projection of `self` parallel to the given vector.
    ///
    /// - SeeAlso: `isNearlyParallel(to:tolerance:)`.
    ///
    /// - SeeAlso: `projectionPerpendicular(to:)`.
    /// - SeeAlso: `isNearlyPerpendicular(to:tolerance:)`.
    public func projectionParallel(to other: CGVector) -> CGVector
    {
        if self == CGVector.zero || other == CGVector.zero { return self }
        return (self.dot(with: other) / other.magnitudeSquared) * other
    }

    /// Returns `true` when `self` and the given vector are **parallel** to
    /// each other, within a given tolerance, by comparing the magnitude of
    /// their *cross* product with the given tolerance. Always returns `true`
    /// if either vector is the zero vector since, by convention, any vector
    /// is parallel to the zero vector. For exact comparisons, pass `0` for
    /// the `tolerance` value.
    ///
    /// - Parameters:
    ///   - other: any `CGVector` instance.
    ///   - tolerance: a small non-negative value.
    ///                The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` and the given vector are paralell to
    ///            each other, within the given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `projectionParallel(to:)`.
    ///
    /// - SeeAlso: `projectionPerpendicular(to:)`.
    /// - SeeAlso: `isNearlyPerpendicular(to:tolerance:)`.
    public func isNearlyParallel(to other: CGVector,
                                 tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    {
        guard tolerance >= 0 else { throw WTCoreGraphicsExtensionsError.negativeTolerance }
        return (abs(self.cross(with: other)) <= tolerance)
    }

    // MARK: -

    /// Returns a vector whose magnitude is the projection of `self` onto
    /// a direction perpendicular to the given vector. In other words, this
    /// method extracts from self a vector that's **perpendicular** to the
    /// given vector. If either vector is the zero vector, then returns
    /// `self` since, by convention, the zero vector is perpendicular to
    /// any vector.
    ///
    /// - Parameter other: any `CGVector` instance.
    ///
    /// - Returns: the projection of `self` perpendicular to the given vector.
    ///
    /// - SeeAlso: `projectionParallel(to:)`.
    /// - SeeAlso: `isNearlyParallel(to:tolerance:)`.
    ///
    /// - SeeAlso: `isNearlyPerpendicular(to:tolerance:)`.
    public func projectionPerpendicular(to other: CGVector) -> CGVector
    {
        if self == CGVector.zero || other == CGVector.zero { return self }
        return (self - self.projectionParallel(to: other))
    }

    /// Returns `true` when `self` and the given vector are **perpendicular** to
    /// each other, within a given tolerance, by comparing the magnitude of
    /// their *dot* product with the given tolerance. Always returns `true`
    /// if either vector is the zero vector since, by convention, any vector
    /// is perpendicular to the zero vector. For exact comparisons, pass `0`
    /// for the `tolerance` value.
    ///
    /// - Parameters:
    ///   - other: any `CGVector` instance.
    ///   - tolerance: a small non-negative value.
    ///                The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` and the given vector are perpendicular
    ///            to each other, within the given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `projectionParallel(to:)`.
    /// - SeeAlso: `isNearlyParallel(to:tolerance:)`.
    ///
    /// - SeeAlso: `projectionPerpendicular(to:)`.
    public func isNearlyPerpendicular(to other: CGVector,
                                      tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    {
        guard tolerance >= 0 else { throw WTCoreGraphicsExtensionsError.negativeTolerance }
        return (abs(self.dot(with: other)) <= tolerance)
    }

    // MARK: -

    /// Rotates `self` **clockwise** around the z axis by the given
    /// angle (in radians).
    ///
    /// - Parameter angle: the angle (in radians) to rotate the vector by.
    ///
    /// - SeeAlso: `rotatedClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(by:)`.
    /// - SeeAlso: `rotatedCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedCounterClockwise(sine:cosine:)`.
    public mutating func rotateClockwise(by angle: CGFloat)
    { rotateClockwise(sine: sin(angle), cosine: cos(angle)) }

    /// Returns a new vector equal to `self` rotated **clockwise** around
    /// the z axis by the given angle (in radians).
    ///
    /// - Parameter angle: the angle (in radians) to rotate the vector by.
    ///
    /// - SeeAlso: `rotateClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(by:)`.
    /// - SeeAlso: `rotatedCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedCounterClockwise(sine:cosine:)`.
    public func rotatedClockwise(by angle: CGFloat) -> CGVector
    {
        var newVector = self
        newVector.rotateClockwise(by: angle)
        return newVector
    }

    // MARK: -

    /// Rotates `self` **clockwise** around the z axis by an angle whose
    /// sine and cosine are the given values. This is more efficient when
    /// the sine and cosine of the angle by which to rotate the vector are
    /// already known.
    ///
    /// - Parameters:
    ///   - sina: the sine of the angle by which to rotate the vector.
    ///   - cosa: the cosine of the angle by which to rotate the vector
    ///
    /// - SeeAlso: `rotateClockwise(by:)`.
    /// - SeeAlso: `rotatedClockwise(by:)`.
    ///
    /// - SeeAlso: `rotatedClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(by:)`.
    /// - SeeAlso: `rotatedCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedCounterClockwise(sine:cosine:)`.
    public mutating func rotateClockwise(sine sina: CGFloat, cosine cosa: CGFloat)
    { rotateCounterClockwise(sine: -sina, cosine: cosa) }

    /// Returns a new vector equal to `self` rotated **clockwise** around
    /// the z axis by an angle whose sine and cosine are the given values.
    /// This is more efficient when the sine and cosine of the angle by
    /// which to rotate the vector are already known.
    ///
    /// - Parameters:
    ///   - sina: the sine of the angle by which to rotate the vector.
    ///   - cosa: the cosine of the angle by which to rotate the vector
    ///
    /// - SeeAlso: `rotateClockwise(by:)`.
    /// - SeeAlso: `rotatedClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(by:)`.
    /// - SeeAlso: `rotatedCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedCounterClockwise(sine:cosine:)`.
    public func rotatedClockwise(sine sina: CGFloat, cosine cosa: CGFloat) -> CGVector
    {
        var newVector = self
        newVector.rotateClockwise(sine: sina, cosine: cosa)
        return newVector
    }

    // MARK: -

    /// Rotates `self` **counter-clockwise** around the z axis by the given
    /// angle (in radians).
    ///
    /// - Parameter angle: the angle (in radians) to rotate the vector by.
    ///
    /// - SeeAlso: `rotateClockwise(by:)`.
    /// - SeeAlso: `rotatedClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotatedCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedCounterClockwise(sine:cosine:)`.
    public mutating func rotateCounterClockwise(by angle: CGFloat)
    { rotateCounterClockwise(sine: sin(angle), cosine: cos(angle)) }

    /// Returns a new vector equal to `self` rotated **counter-clockwise**
    /// around the z axis by the given angle (in radians).
    ///
    /// - Parameter angle: the angle (in radians) to rotate the vector by.
    ///
    /// - SeeAlso: `rotateClockwise(by:)`.
    /// - SeeAlso: `rotatedClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedCounterClockwise(sine:cosine:)`.
    public func rotatedCounterClockwise(by angle: CGFloat) -> CGVector
    {
        var newVector = self
        newVector.rotateCounterClockwise(by: angle)
        return newVector
    }

    // MARK: -

    /// Rotates `self` **counter-clockwise** around the z axis by an angle
    /// whose sine and cosine are the given values. This is more efficient
    /// when the sine and cosine of the angle by which to rotate the vector
    /// are already known.
    ///
    /// - Parameters:
    ///   - sina: the sine of the angle by which to rotate the vector.
    ///   - cosa: the cosine of the angle by which to rotate the vector
    ///
    /// - SeeAlso: `rotateClockwise(by:)`.
    /// - SeeAlso: `rotatedClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(by:)`.
    /// - SeeAlso: `rotatedCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotatedCounterClockwise(sine:cosine:)`.
    public mutating func rotateCounterClockwise(sine sina: CGFloat, cosine cosa: CGFloat)
    {
        let tx = dx * cosa - dy * sina
        let ty = dy * cosa + dx * sina
        dx = tx
        dy = ty
    }

    /// Returns a new vector equal to `self` rotated **counter-clockwise**
    /// around the z axis by an angle whose sine and cosine are the given
    /// values. This is more efficient when the sine and cosine of the angle
    /// by which to rotate the vector are already known.
    ///
    /// - Parameters:
    ///   - sina: the sine of the angle by which to rotate the vector.
    ///   - cosa: the cosine of the angle by which to rotate the vector
    ///
    /// - SeeAlso: `rotateClockwise(by:)`.
    /// - SeeAlso: `rotatedClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateClockwise(sine:cosine:)`.
    /// - SeeAlso: `rotatedClockwise(sine:cosine:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(by:)`.
    /// - SeeAlso: `rotatedCounterClockwise(by:)`.
    ///
    /// - SeeAlso: `rotateCounterClockwise(sine:cosine:)`.
    public func rotatedCounterClockwise(sine sina: CGFloat, cosine cosa: CGFloat) -> CGVector
    {
        var newVector = self
        newVector.rotateCounterClockwise(sine: sina, cosine: cosa)
        return newVector
    }

    // MARK: -

    /// Adds two vectors, resulting in a vector.
    ///
    /// - Parameters:
    ///   - lhs: any `CGVector` instance.
    ///   - rhs: any `CGVector` instance.
    ///
    /// - Returns: the vector resulting from adding the two operands.
    public static func +(lhs: CGVector, rhs: CGVector) -> CGVector
    {
        let dx = lhs.dx + rhs.dx
        let dy = lhs.dy + rhs.dy
        return CGVector(dx: dx, dy: dy)
    }

    /// Subtracts two vectors, resulting in a vector.
    ///
    /// - Parameters:
    ///   - lhs: any `CGVector` instance.
    ///   - rhs: any `CGVector` instance.
    ///
    /// - Returns: the vector resulting from subtracting the two operands.
    public static func -(lhs: CGVector, rhs: CGVector) -> CGVector
    {
        let dx = lhs.dx - rhs.dx
        let dy = lhs.dy - rhs.dy
        return CGVector(dx: dx, dy: dy)
    }

    /// Multiplies a scalar value and a vector, resulting in a vector.
    ///
    /// - Parameters:
    ///   - lhs: any `CGFloat` instance.
    ///   - rhs: any `CGVector` instance.
    ///
    /// - Returns: the vector resulting from multiplying the two operands.
    public static func *(lhs: CGFloat, rhs: CGVector) -> CGVector
    {
        let dx = lhs * rhs.dx
        let dy = lhs * rhs.dy
        return CGVector(dx: dx, dy: dy)
    }

    /// Multiplies a vector and a scalar value, resulting in a vector.
    ///
    /// - Parameters:
    ///   - lhs: any `CGVector` instance.
    ///   - rhs: any `CGFloat` instance.
    ///
    /// - Returns: the vector resulting from multiplying the two operands.
    public static func *(lhs: CGVector, rhs: CGFloat) -> CGVector
    {
        let dx = lhs.dx * rhs
        let dy = lhs.dy * rhs
        return CGVector(dx: dx, dy: dy)
    }

    /// Divides a vector by a scalar value, resulting in a vector.
    ///
    /// - Parameters:
    ///   - lhs: any `CGVector` instance.
    ///   - rhs: any `CGFloat` instance.
    ///
    /// - Returns: the vector resulting from dividing the vector by the scalar.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.divisionByZero` if `rhs` is zero.
    public static func /(lhs: CGVector, rhs: CGFloat) throws -> CGVector
    {
        guard rhs != 0 else { throw WTCoreGraphicsExtensionsError.divisionByZero }
        let dx = lhs.dx / rhs
        let dy = lhs.dy / rhs
        return CGVector(dx: dx, dy: dy)
    }

    /// Negates a vector (in the arithmetic sense), ie, reflects the vector
    /// through the origin of its coordinate system.
    ///
    /// - Parameter vector: the vector to negate.
    ///
    /// - Returns: the vector resulting from negating the given vector.
    public static prefix func -(vector: CGVector) -> CGVector
    { return CGFloat(-1) * vector }

    /// Adds a vector to `self`.
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: the vector to add to `self`.
    public static func +=(lhs: inout CGVector, rhs: CGVector)
    { lhs = lhs + rhs }

    /// Subtracts a vector from `self`.
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: the vector to subtract from `self`.
    public static func -=(lhs: inout CGVector, rhs: CGVector)
    { lhs = lhs - rhs }

    /// Multiplies `self` by a scalar value.
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: the scalar to multiply `self` by.
    public static func *=(lhs: inout CGVector, rhs: CGFloat)
    { lhs = lhs * rhs }

    /// Divides `self` by a scalar value.
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: the scalar to divide `self` by.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.divisionByZero` if `rhs` is zero.
    public static func /=(lhs: inout CGVector, rhs: CGFloat) throws
    {
        guard rhs != 0 else { throw WTCoreGraphicsExtensionsError.divisionByZero }
        lhs = try lhs / rhs
    }
}

// MARK: -

extension CGVector: Hashable
{
    /// Probably not a great hashing method but simple and useful enough.
    public var hashValue: Int { return "\(dx)\(dy)".hashValue }
}

// MARK: -

// ==================================================== //
// ==================== CGGradient ==================== //
// ==================================================== //

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
