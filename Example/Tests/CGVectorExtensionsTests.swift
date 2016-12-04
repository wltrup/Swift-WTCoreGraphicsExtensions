//
//  CGVectorExtensionsTests.swift
//  WTCoreGraphicsExtensions
//
//  Created by Wagner Truppel on 2016.12.03.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import XCTest
import Foundation
import WTCoreGraphicsExtensions

class CGVectorExtensionsTests: WTCoreGraphicsExtensionsTestsBase
{
    func test_initFromFloats()
    {
        (1...N).forEach { _ in
            let dx = Float(CGFloat.random(rangeMin, rangeMax))
            let dy = Float(CGFloat.random(rangeMin, rangeMax))

            let v = CGVector(dx: dx, dy: dy)

            expectedValue = CGFloat(dx)
            resultedValue = v.dx
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = CGFloat(dy)
            resultedValue = v.dy
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_initFromPointToPoint()
    {
        (1...N).forEach { _ in
            let p1 = CGPoint.random(rangeMin, rangeMax)
            let p2 = CGPoint.random(rangeMin, rangeMax)

            let v = CGVector(from: p1, to: p2)

            expectedValue = (p2.x - p1.x)
            resultedValue = v.dx
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = (p2.y - p1.y)
            resultedValue = v.dy
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_initFromMagnitudeAndAngleThrowsOnNegativeMagnitude()
    {
        (1...N).forEach { _ in
            let m = -CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians

            do {
                let _ = try CGVector(magnitude: m, angle: a)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeMagnitude
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_initFromMagnitudeAndAngle()
    {
        (1...N).forEach { _ in
            let m = CGFloat.random(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a)

            expectedValue = m * CGFloat(cos(a))
            resultedValue = v.dx
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = m * CGFloat(sin(a))
            resultedValue = v.dy
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_initFromMagnitudeAndAngleCreatesTheSameVectorsForAnglesThatDifferBy2pi()
    {
        (1...N).forEach { _ in
            let m = CGFloat.random(0, abs(rangeMax))
            let k: CGFloat = CGFloat(Int(CGFloat.random(-100, 100)))
            let a1 = CGFloat.random(0, 360).degreesInRadians
            let a2 = a1 + (k * 360).degreesInRadians

            let v1 = try! CGVector(magnitude: m, angle: a1)
            let v2 = try! CGVector(magnitude: m, angle: a2)

            expectedValue = 0

            resultedValue = (v1.dx - v2.dx)
            assertAbsoluteDifferenceWithinTolerance()

            resultedValue = (v1.dy - v2.dy)
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_initFromMagnitudeAndSineCosineThrowsOnNegativeMagnitude()
    {
        (1...N).forEach { _ in
            let m = -CGFloat.randomNonZero(0, abs(rangeMax))
            let sina = CGFloat.random(-1, 1)
            let cosa = CGFloat.random(-1, 1)

            do {
                let _ = try CGVector(magnitude: m, sine: sina, cosine: cosa)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeMagnitude
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_initFromMagnitudeAndSineCosine()
    {
        (1...N).forEach { _ in
            let m = CGFloat.random(0, abs(rangeMax))
            let sina = CGFloat.random(-1, 1)
            let cosa = CGFloat.random(-1, 1)

            let v = try! CGVector(magnitude: m, sine: sina, cosine: cosa)

            expectedValue = m * cosa
            resultedValue = v.dx
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = m * sina
            resultedValue = v.dy
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_initFromMagnitudeAndRandomAngleThrowsOnNegativeMagnitude()
    {
        (1...N).forEach { _ in
            let m = -CGFloat.randomNonZero(0, abs(rangeMax))
            let mina = CGFloat.random(0, 360).degreesInRadians
            let maxa = CGFloat.random(0, 360).degreesInRadians

            do {
                let _ = try CGVector(magnitude: m, minAngle: mina, maxAngle: maxa)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeMagnitude
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_randomGeneratesValuesInTheExpectedRange()
    {
        let min = (rangeMin <= rangeMax ? rangeMin : rangeMax)
        let max = (rangeMin >= rangeMax ? rangeMin : rangeMax)

        (1...N).forEach { _ in
            let v = CGVector.random(rangeMin, rangeMax)
            XCTAssertTrue(v.dx >= min && v.dx <= max)
            XCTAssertTrue(v.dy >= min && v.dy <= max)
        }
    }

    /// Tests that `random(a:b:)` creates a `CGVector` with pseudo-random coordinates
    /// satisfying, independently from one another, the property that their
    /// generated values have an average approximating 1/2 and a variance
    /// approximating 1/12, when the range is [0, 1].
    func test_random()
    {
        N = 100_000
        tolerance = 1e-2

        enum Coordinate {
            case dx
            case dy
        }

        func testCoordinate(_ c: Coordinate) {
            let values = (1...N).map { _ -> CGFloat in
                let v = CGVector.random(0, 1)
                return (c == Coordinate.dx ? v.dx : v.dy)
            }
            testRandomness(values)
        }

        testCoordinate(.dx)
        testCoordinate(.dy)
    }

    func test_unitVectorX()
    {
        let v = CGVector.unitVectorX

        expectedValue = 1
        resultedValue = v.dx
        assertAbsoluteDifferenceWithinTolerance()

        expectedValue = 0
        resultedValue = v.dy
        assertAbsoluteDifferenceWithinTolerance()
    }

    func test_unitVectorY()
    {
        let v = CGVector.unitVectorY

        expectedValue = 0
        resultedValue = v.dx
        assertAbsoluteDifferenceWithinTolerance()

        expectedValue = 1
        resultedValue = v.dy
        assertAbsoluteDifferenceWithinTolerance()
    }

    func test_isNearlyEqualWithNegativeToleranceThrows()
    {
        (1...N).forEach { _ in
            let v1 = CGVector.random(rangeMin, rangeMax)
            let v2 = CGVector.random(rangeMin, rangeMax)
            let tol = -CGFloat.randomNonZero(0, abs(rangeMax))

            do {
                let _ = try v2.isNearlyEqual(to: v1, tolerance: tol)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeTolerance
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_isNearlyEqualWithZeroTolerance1()
    {
        (1...N).forEach { _ in
            var nearlyEqual: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            let v2 = v1

            nearlyEqual = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertTrue(nearlyEqual)

            nearlyEqual = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertTrue(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithZeroTolerance2()
    {
        (1...N).forEach { _ in
            var nearlyEqual: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dx += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyEqual = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)

            nearlyEqual = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithZeroTolerance3()
    {
        (1...N).forEach { _ in
            var nearlyEqual: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dy += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyEqual = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)

            nearlyEqual = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithZeroTolerance4()
    {
        (1...N).forEach { _ in
            var nearlyEqual: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dx += CGFloat.randomNonZero(rangeMin, rangeMax)
            v2.dy += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyEqual = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)

            nearlyEqual = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithOrWithoutCustomTolerance()
    {
        func testNearlyEqual(maxDelta: CGFloat, shouldFail: Bool) {
            let usingDefaultTolerance = (tolerance == CGFloat.tolerance)

            (1...N).forEach { _ in
                let v1 = CGVector.random(rangeMin, rangeMax)
                var v2 = v1
                if shouldFail {
                    v2.dx += maxDelta
                    v2.dy += maxDelta
                } else {
                    v2.dx += CGFloat.random(-maxDelta, maxDelta)
                    v2.dy += CGFloat.random(-maxDelta, maxDelta)
                }

                let v1NearlyEqualToV2: Bool
                let v2NearlyEqualToV1: Bool
                if usingDefaultTolerance {
                    v1NearlyEqualToV2 = try! v1.isNearlyEqual(to: v2)
                    v2NearlyEqualToV1 = try! v2.isNearlyEqual(to: v1)
                } else {
                    v1NearlyEqualToV2 = try! v1.isNearlyEqual(to: v2, tolerance: tolerance)
                    v2NearlyEqualToV1 = try! v2.isNearlyEqual(to: v1, tolerance: tolerance)
                }

                XCTAssertFalse(v1NearlyEqualToV2 == shouldFail)
                XCTAssertFalse(v2NearlyEqualToV1 == shouldFail)
            }
        }

        tolerance = CGFloat.tolerance // default tolerance
        testNearlyEqual(maxDelta: tolerance / 2, shouldFail: false)
        testNearlyEqual(maxDelta: 10 * tolerance, shouldFail: true)

        tolerance = 1e-4 // custom non-zero tolerance
        testNearlyEqual(maxDelta: tolerance / 2, shouldFail: false)
        testNearlyEqual(maxDelta: 10 * tolerance, shouldFail: true)
    }

    func test_isNearlyZeroWithNegativeToleranceThrows()
    {
        (1...N).forEach { _ in
            let v = CGVector.random(rangeMin, rangeMax)
            let tol = -CGFloat.randomNonZero(0, abs(rangeMax))

            do {
                let _ = try v.isNearlyZero(tolerance: tol)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeTolerance
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_isNearlyZeroWithZeroTolerance0()
    {
        let v = CGVector.zero
        let nearlyZero = try! v.isNearlyZero(tolerance: 0.0)
        XCTAssertTrue(nearlyZero)
    }

    func test_isNearlyZeroWithZeroTolerance1()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.randomNonZero(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: 0)

            let nearlyZero = try! v.isNearlyZero(tolerance: 0.0)
            XCTAssertFalse(nearlyZero)
        }
    }

    func test_isNearlyZeroWithZeroTolerance2()
    {
        (1...N).forEach { _ in
            let dy = CGFloat.randomNonZero(rangeMin, rangeMax)
            let v = CGVector(dx: 0, dy: dy)

            let nearlyZero = try! v.isNearlyZero(tolerance: 0.0)
            XCTAssertFalse(nearlyZero)
        }
    }

    func test_isNearlyZeroWithZeroTolerance3()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.randomNonZero(rangeMin, rangeMax)
            let dy = CGFloat.randomNonZero(rangeMin, rangeMax)

            let v = CGVector(dx: dx, dy: dy)
            let nearlyZero = try! v.isNearlyZero(tolerance: 0.0)
            XCTAssertFalse(nearlyZero)
        }
    }

    func test_isNearlyZeroWithOrWithoutCustomTolerance()
    {
        func testNearlyZero(maxDelta: CGFloat, shouldFail: Bool) {
            let usingDefaultTolerance = (tolerance == CGFloat.tolerance)

            (1...N).forEach { _ in
                let v: CGVector
                if shouldFail {
                    v = CGVector(dx: maxDelta, dy: maxDelta)
                } else {
                    let dx = CGFloat.random(-maxDelta, maxDelta)
                    let dy = CGFloat.random(-maxDelta, maxDelta)
                    v = CGVector(dx: dx, dy: dy)
                }

                let vNearlyZero: Bool
                if usingDefaultTolerance {
                    vNearlyZero = try! v.isNearlyZero()
                } else {
                    vNearlyZero = try! v.isNearlyZero(tolerance: tolerance)
                }

                XCTAssertFalse(vNearlyZero == shouldFail)
            }
        }

        tolerance = CGFloat.tolerance // default tolerance
        testNearlyZero(maxDelta: tolerance / 2, shouldFail: false)
        testNearlyZero(maxDelta: 10 * tolerance, shouldFail: true)

        tolerance = 1e-4 // custom non-zero tolerance
        testNearlyZero(maxDelta: tolerance / 2, shouldFail: false)
        testNearlyZero(maxDelta: 10 * tolerance, shouldFail: true)
    }

    func test_magnitude()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            expectedValue = CGFloat(sqrt(dx*dx + dy*dy))
            resultedValue = v.magnitude
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_magnitudeSquared()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            expectedValue = (dx*dx + dy*dy)
            resultedValue = v.magnitudeSquared
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_isNormalizableReturnsFalseForZeroVector()
    {
        let v = CGVector.zero
        XCTAssertFalse(v.isNormalizable)
    }

    func test_isNormalizableReturnsTrueForNonZeroVector1()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.randomNonZero(rangeMin, rangeMax)
            let dy = CGFloat(0)
            let v = CGVector(dx: dx, dy: dy)
            XCTAssertTrue(v.isNormalizable)
        }
    }

    func test_isNormalizableReturnsTrueForNonZeroVector2()
    {
        (1...N).forEach { _ in
            let dx = CGFloat(0)
            let dy = CGFloat.randomNonZero(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)
            XCTAssertTrue(v.isNormalizable)
        }
    }

    func test_isNormalizableReturnsTrueForNonZeroVector3()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.randomNonZero(rangeMin, rangeMax)
            let dy = CGFloat.randomNonZero(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)
            XCTAssertTrue(v.isNormalizable)
        }
    }

    func test_normalizeThrowsOnZeroVector()
    {
        var v = CGVector.zero
        do {
            try v.normalize()
            XCTFail()
        }
        catch {
            expectedError = WTCoreGraphicsExtensionsError.notNormalizable
            resultedError = error
            assertEqualErrors()
        }
    }

    func test_normalize()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)

            var v = CGVector(dx: dx, dy: dy)
            try! v.normalize()

            let mag = CGFloat(sqrt(dx*dx + dy*dy))
            if mag > 0.0 {
                expectedValue = dx / mag
                resultedValue = v.dx
                assertAbsoluteDifferenceWithinTolerance()

                expectedValue = dy / mag
                resultedValue = v.dy
                assertAbsoluteDifferenceWithinTolerance()
            }
        }
    }

    func test_normalizedReturnsNilForZeroVector()
    {
        let v = CGVector.zero
        XCTAssertTrue(v.normalized == nil)
    }

    func test_normalized()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)

            let u = CGVector(dx: dx, dy: dy)
            let v = u.normalized

            let mag = CGFloat(sqrt(dx*dx + dy*dy))
            if let v = v, mag > 0.0 {
                expectedValue = dx / mag
                resultedValue = v.dx
                assertAbsoluteDifferenceWithinTolerance()

                expectedValue = dy / mag
                resultedValue = v.dy
                assertAbsoluteDifferenceWithinTolerance()
            }
        }
    }

    func test_scaleMagnitudeToThrowsOnZeroVector()
    {
        let s = CGFloat.random(rangeMin, rangeMax)
        var v = CGVector.zero
        do {
            try v.scaleMagnitude(to: s)
            XCTFail()
        }
        catch {
            expectedError = WTCoreGraphicsExtensionsError.notNormalizable
            resultedError = error
            assertEqualErrors()
        }
    }

    func test_scaleMagnitudeTo()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let s = CGFloat.random(rangeMin, rangeMax)

            var v = CGVector(dx: dx, dy: dy)

            let mag = CGFloat(sqrt(dx*dx + dy*dy))
            if mag > 0.0 {
                try! v.scaleMagnitude(to: s)

                expectedValue = s * (dx / mag)
                resultedValue = v.dx
                assertAbsoluteDifferenceWithinTolerance()

                expectedValue = s * (dy / mag)
                resultedValue = v.dy
                assertAbsoluteDifferenceWithinTolerance()
            }
        }
    }

    func test_magnitudeScaledToReturnsNilForZeroVector()
    {
        let v = CGVector.zero
        let s = CGFloat.random(rangeMin, rangeMax)
        XCTAssertTrue(v.magnitudeScaled(to: s) == nil)
    }

    func test_magnitudeScaledTo()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let u = CGVector(dx: dx, dy: dy)

            let s = CGFloat.random(rangeMin, rangeMax)
            let v = u.magnitudeScaled(to: s)

            let mag = CGFloat(sqrt(dx*dx + dy*dy))
            if let v = v, mag > 0.0 {
                expectedValue = s * (dx / mag)
                resultedValue = v.dx
                assertAbsoluteDifferenceWithinTolerance()

                expectedValue = s * (dy / mag)
                resultedValue = v.dy
                assertAbsoluteDifferenceWithinTolerance()
            }
        }
    }

    func test_scaleMagnitudeDownToIfLargerThanThrowsOnNegativeArgument()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)

            var v = CGVector(dx: dx, dy: dy)
            let s = -CGFloat.randomNonZero(0, abs(rangeMax))
            do {
                try v.scaleMagnitudeDownToIfLarger(than: s)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeMagnitude
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_scaleMagnitudeDownToIfLargerThanReturnsZeroVectorForZeroScalar()
    {
        let dx = CGFloat.random(rangeMin, rangeMax)
        let dy = CGFloat.random(rangeMin, rangeMax)
        let u = CGVector(dx: dx, dy: dy)

        var v = u
        try! v.scaleMagnitudeDownToIfLarger(than: 0.0)

        expectedVector = CGVector.zero
        resultedVector = v
        assertEqualVectorsWithinTolerance()
    }

    func test_scaleMagnitudeDownToIfLargerThan()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let mag = CGFloat(sqrt(dx*dx + dy*dy))

            let s = CGFloat.randomNonZero(0, abs(rangeMax))

            var v = CGVector(dx: dx, dy: dy)
            let m = v.magnitude

            let expectedDx: CGFloat
            let expectedDy: CGFloat
            if m > s {
                expectedDx = s * (dx / mag)
                expectedDy = s * (dy / mag)
            } else {
                expectedDx = dx
                expectedDy = dy
            }

            try! v.scaleMagnitudeDownToIfLarger(than: s)

            expectedValue = expectedDx
            resultedValue = v.dx
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = expectedDy
            resultedValue = v.dy
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_scaleMagnitudeUpToIfSmallerThanThrowsOnNegativeArgument()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)

            var v = CGVector(dx: dx, dy: dy)
            let s = -CGFloat.randomNonZero(0, abs(rangeMax))
            do {
                try v.scaleMagnitudeUpToIfSmaller(than: s)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeMagnitude
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_scaleMagnitudeUpToIfSmallerThanThrowsOnZeroVector()
    {
        let s = CGFloat.randomNonZero(0, abs(rangeMax))
        var v = CGVector.zero
        do {
            try v.scaleMagnitudeUpToIfSmaller(than: s)
            XCTFail()
        }
        catch {
            expectedError = WTCoreGraphicsExtensionsError.notNormalizable
            resultedError = error
            assertEqualErrors()
        }
    }

    func test_scaleMagnitudeUpToIfSmallerThanReturnsSameVectorForZeroScalar()
    {
        let dx = CGFloat.random(rangeMin, rangeMax)
        let dy = CGFloat.random(rangeMin, rangeMax)

        let u = CGVector(dx: dx, dy: dy)
        var v = u

        try! v.scaleMagnitudeUpToIfSmaller(than: 0.0)

        expectedVector = u
        resultedVector = v
        assertEqualVectorsWithinTolerance()
    }

    func test_scaleMagnitudeUpToIfSmallerThan()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let mag = CGFloat(sqrt(dx*dx + dy*dy))

            let s = CGFloat.randomNonZero(0, abs(rangeMax))

            var v = CGVector(dx: dx, dy: dy)
            let m = v.magnitude

            let expectedDx: CGFloat
            let expectedDy: CGFloat
            if mag > 0.0 {
                if m < s {
                    expectedDx = s * (dx / mag)
                    expectedDy = s * (dy / mag)
                } else {
                    expectedDx = dx
                    expectedDy = dy
                }

                try! v.scaleMagnitudeUpToIfSmaller(than: s)

                expectedValue = expectedDx
                resultedValue = v.dx
                assertAbsoluteDifferenceWithinTolerance()

                expectedValue = expectedDy
                resultedValue = v.dy
                assertAbsoluteDifferenceWithinTolerance()
            }
        }
    }

    func test_magnitudeScaledDownToIfLargerThanThrowsOnNegativeArgument()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)

            let v = CGVector(dx: dx, dy: dy)
            let s = -CGFloat.randomNonZero(0, abs(rangeMax))
            do {
                _ = try v.magnitudeScaledDownToIfLarger(than: s)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeMagnitude
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_magnitudeScaledDownToIfLargerThanReturnsZeroVectorForZeroScalar()
    {
        let dx = CGFloat.random(rangeMin, rangeMax)
        let dy = CGFloat.random(rangeMin, rangeMax)
        let u = CGVector(dx: dx, dy: dy)

        let v = try! u.magnitudeScaledDownToIfLarger(than: 0.0)

        expectedVector = CGVector.zero
        resultedVector = v
        assertEqualVectorsWithinTolerance()
    }

    func test_magnitudeScaledDownToIfLargerThan()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let mag = CGFloat(sqrt(dx*dx + dy*dy))

            let u = CGVector(dx: dx, dy: dy)
            let m = u.magnitude
            let s = CGFloat.randomNonZero(0, abs(rangeMax))

            let expectedDx: CGFloat
            let expectedDy: CGFloat
            if m > s {
                expectedDx = s * (dx / mag)
                expectedDy = s * (dy / mag)
            } else {
                expectedDx = dx
                expectedDy = dy
            }

            let v = try! u.magnitudeScaledDownToIfLarger(than: s)

            expectedValue = expectedDx
            resultedValue = v.dx
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = expectedDy
            resultedValue = v.dy
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_magnitudeScaledUpToIfSmallerThanThrowsOnNegativeArgument()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)

            let v = CGVector(dx: dx, dy: dy)
            let s = -CGFloat.randomNonZero(0, abs(rangeMax))
            do {
                _ = try v.magnitudeScaledUpToIfSmaller(than: s)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeMagnitude
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_magnitudeScaledUpToIfSmallerThrowsOnZeroVector()
    {
        let v = CGVector.zero
        let s = CGFloat.randomNonZero(0, abs(rangeMax))
        do {
            _ = try v.magnitudeScaledUpToIfSmaller(than: s)
            XCTFail()
        }
        catch {
            expectedError = WTCoreGraphicsExtensionsError.notNormalizable
            resultedError = error
            assertEqualErrors()
        }
    }

    func test_magnitudeScaledUpToIfSmallerThanReturnsSameVectorForZeroScalar()
    {
        let dx = CGFloat.random(rangeMin, rangeMax)
        let dy = CGFloat.random(rangeMin, rangeMax)

        let u = CGVector(dx: dx, dy: dy)
        let v = try! u.magnitudeScaledUpToIfSmaller(than: 0.0)

        expectedVector = u
        resultedVector = v
        assertEqualVectorsWithinTolerance()
    }

    func test_magnitudeScaledUpToIfSmallerThan()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let mag = CGFloat(sqrt(dx*dx + dy*dy))

            let u = CGVector(dx: dx, dy: dy)
            let m = u.magnitude
            let s = CGFloat.randomNonZero(0, abs(rangeMax))

            let expectedDx: CGFloat
            let expectedDy: CGFloat
            if m < s {
                expectedDx = s * (dx / mag)
                expectedDy = s * (dy / mag)
            } else {
                expectedDx = dx
                expectedDy = dy
            }

            let v = try! u.magnitudeScaledUpToIfSmaller(than: s)

            expectedValue = expectedDx
            resultedValue = v.dx
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = expectedDy
            resultedValue = v.dy
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_dotProduct()
    {
        (1...N).forEach { _ in
            let dx1 = CGFloat.random(rangeMin, rangeMax)
            let dy1 = CGFloat.random(rangeMin, rangeMax)
            let u = CGVector(dx: dx1, dy: dy1)

            let dx2 = CGFloat.random(rangeMin, rangeMax)
            let dy2 = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx2, dy: dy2)

            expectedValue = (dx1*dx2 + dy1*dy2)

            resultedValue = u.dot(with: v)
            assertAbsoluteDifferenceWithinTolerance()

            resultedValue = v.dot(with: u)
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_crossProduct()
    {
        (1...N).forEach { _ in
            let dx1 = CGFloat.random(rangeMin, rangeMax)
            let dy1 = CGFloat.random(rangeMin, rangeMax)
            let u = CGVector(dx: dx1, dy: dy1)

            let dx2 = CGFloat.random(rangeMin, rangeMax)
            let dy2 = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx2, dy: dy2)

            expectedValue = (dx1*dy2 - dy1*dx2)

            resultedValue = u.cross(with: v)
            assertAbsoluteDifferenceWithinTolerance()

            resultedValue = -v.cross(with: u)
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_angleFromXAxisReturnsZeroForZeroVector()
    {
        let v = CGVector.zero

        expectedValue = 0
        resultedValue = v.angleFromXAxis
        assertAbsoluteDifferenceWithinTolerance()
    }

    func test_angleFromXAxis()
    {
        (-720...720).forEach { angleInDegs in
            var reducedAngleInDegs = (angleInDegs % 360)
            if  reducedAngleInDegs < 0 { reducedAngleInDegs += 360 }
            let reducedAngleInRads = CGFloat(reducedAngleInDegs).degreesInRadians

            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat(angleInDegs).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a)

            let expectedAngleInRads1 = reducedAngleInRads
            let expectedAngleInRads2 = reducedAngleInRads + CGFloat.twoPi
            let resultedAngleInRads = v.angleFromXAxis

            let pass1 = abs(resultedAngleInRads - expectedAngleInRads1) <= tolerance
            let pass2 = abs(resultedAngleInRads - expectedAngleInRads2) <= tolerance
            XCTAssertTrue(pass1 || pass2)
        }
    }

    func test_sinAngleFromXAxisReturnsValueInTheExpectedRange()
    {
        (1...N).forEach { _ in
            let v = CGVector.random(rangeMin, rangeMax)
            let value: CGFloat = abs(v.sinAngleFromXAxis)
            XCTAssertTrue(value >= 0 && value <= 1)
        }
    }

    func test_sinAngleFromXAxisReturnsZeroForZeroVector()
    {
        let v = CGVector.zero

        expectedValue = 0
        resultedValue = v.sinAngleFromXAxis
        assertAbsoluteDifferenceWithinTolerance()
    }

    func test_sinAngleFromXAxis()
    {
        (-720...720).forEach { angleInDegs in
            let angleInRads = CGFloat(angleInDegs).degreesInRadians
            let m = CGFloat.randomNonZero(0, abs(rangeMax))

            let v = try! CGVector(magnitude: m, angle: angleInRads)

            expectedValue = CGFloat(sin(angleInRads))
            resultedValue = v.sinAngleFromXAxis
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_cosAngleFromXAxisReturnsValueInTheExpectedRange()
    {
        (1...N).forEach { _ in
            let v = CGVector.random(rangeMin, rangeMax)
            let value: CGFloat = abs(v.cosAngleFromXAxis)
            XCTAssertTrue(value >= 0 && value <= 1)
        }
    }

    func test_cosAngleFromXAxisReturnsOneForZeroVector()
    {
        let v = CGVector.zero

        expectedValue = 1
        resultedValue = v.cosAngleFromXAxis
        assertAbsoluteDifferenceWithinTolerance()
    }

    func test_cosAngleFromXAxis()
    {
        (-720...720).forEach { angleInDegs in
            let angleInRads = CGFloat(angleInDegs).degreesInRadians
            let m = CGFloat.randomNonZero(0, abs(rangeMax))

            let v = try! CGVector(magnitude: m, angle: angleInRads)

            expectedValue = CGFloat(cos(angleInRads))
            resultedValue = v.cosAngleFromXAxis
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_tanAngleFromXAxisReturnsZeroForZeroVector()
    {
        let v = CGVector.zero

        expectedValue = 0
        resultedValue = v.tanAngleFromXAxis
        assertAbsoluteDifferenceWithinTolerance()
    }

    func test_tanAngleFromXAxisReturnsPositiveInfinityForPositiveUnitVectorY()
    {
        let v = CGVector.unitVectorY

        expectedValue = CGFloat.infinity
        resultedValue = v.tanAngleFromXAxis
        XCTAssertEqual(resultedValue, expectedValue)
    }

    func test_tanAngleFromXAxisReturnsNegativeInfinityForNegativeUnitVectorY()
    {
        let v = -CGVector.unitVectorY

        expectedValue = -CGFloat.infinity
        resultedValue = v.tanAngleFromXAxis
        XCTAssertEqual(resultedValue, expectedValue)
    }

    func test_tanAngleFromXAxis()
    {
        (-720...720).forEach { angleInDegs in
            let angleInRads = CGFloat(angleInDegs).degreesInRadians
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let v = try! CGVector(magnitude: m, angle: angleInRads)

            expectedValue = CGFloat(tan(angleInRads))
            resultedValue = v.tanAngleFromXAxis

            let shouldResultInVeryLargeValues =
                (angleInDegs % 90 == 0) && ((angleInDegs / 90) % 2 != 0)
            if shouldResultInVeryLargeValues { tolerance = 10 }

            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_smallestAngleWith()
    {
        (-720...720).forEach { angleInDegs in
            let angleInRads = CGFloat(angleInDegs).degreesInRadians

            let m1 = CGFloat.randomNonZero(0, abs(rangeMax))
            let a1 = CGFloat.random(0, 360).degreesInRadians
            let v1 = try! CGVector(magnitude: m1, angle: a1)

            let m2 = CGFloat.randomNonZero(0, abs(rangeMax))
            let a2 = a1 + angleInRads
            let v2 = try! CGVector(magnitude: m2, angle: a2)

            var expectedAngleInDegs = abs(angleInDegs) % 360
            if expectedAngleInDegs > 180 { expectedAngleInDegs = 360 - expectedAngleInDegs }

            expectedValue = CGFloat(expectedAngleInDegs).degreesInRadians

            resultedValue = v1.smallestAngle(with: v2)
            assertAbsoluteDifferenceWithinTolerance()

            resultedValue = v2.smallestAngle(with: v1)
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_smallestAngleWithReturnsResultInTheExpectedRange()
    {
        (-720...720).forEach { angleInDegs in
            let angleInRads = CGFloat(angleInDegs).degreesInRadians

            let m1 = CGFloat.randomNonZero(0, abs(rangeMax))
            let a1 = CGFloat.random(0, 360).degreesInRadians
            let v1 = try! CGVector(magnitude: m1, angle: a1)

            let m2 = CGFloat.randomNonZero(0, abs(rangeMax))
            let a2 = a1 + angleInRads
            let v2 = try! CGVector(magnitude: m2, angle: a2)

            resultedValue = v1.smallestAngle(with: v2)
            XCTAssertTrue(resultedValue >= 0 && resultedValue <= CGFloat.pi)
        }
    }

    func test_projectionParallelToReturnsTheZeroVectorWhenBothVectorsAreTheZeroVector()
    {
        let u = CGVector.zero
        let v = CGVector.zero

        expectedVector = CGVector.zero
        resultedVector = u.projectionParallel(to : v)
        assertEqualVectorsWithinTolerance()
    }

    func test_projectionParallelToReturnsSelfWhenEitherVectorIsTheZeroVector()
    {
        let u = CGVector.zero
        let v = CGVector.random(rangeMin, rangeMax)

        expectedVector = u
        resultedVector = u.projectionParallel(to : v)
        assertEqualVectorsWithinTolerance()

        expectedVector = v
        resultedVector = v.projectionParallel(to : u)
        assertEqualVectorsWithinTolerance()
    }

    func test_projectionParallelToUnitVectorX()
    {
        let m = CGFloat.randomNonZero(0, abs(rangeMax))
        let a = CGFloat.random(0, 360).degreesInRadians
        let u = try! CGVector(magnitude: m, angle: a)

        let v = CGVector.unitVectorX
        expectedVector = try! CGVector(magnitude: m, sine: 0, cosine: cos(a))
        resultedVector = u.projectionParallel(to : v)
        assertEqualVectorsWithinTolerance()
    }

    func test_projectionParallelToUnitVectorY()
    {
        let m = CGFloat.randomNonZero(0, abs(rangeMax))
        let a = CGFloat.random(0, 360).degreesInRadians
        let u = try! CGVector(magnitude: m, angle: a)

        let v = CGVector.unitVectorY
        expectedVector = try! CGVector(magnitude: m, sine: sin(a), cosine: 0)
        resultedVector = u.projectionParallel(to : v)
        assertEqualVectorsWithinTolerance()
    }

    func test_isNearlyParallelToWithNegativeToleranceThrows()
    {
        (1...N).forEach { _ in
            let v1 = CGVector.random(rangeMin, rangeMax)
            let v2 = CGVector.random(rangeMin, rangeMax)
            let tol = -CGFloat.randomNonZero(0, abs(rangeMax))

            do {
                let _ = try v2.isNearlyParallel(to: v1, tolerance: tol)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeTolerance
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_isNearlyParallelToWithZeroTolerance1()
    {
        (1...N).forEach { _ in
            var nearlyParallel: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            let v2 = v1

            nearlyParallel = try! v2.isNearlyParallel(to: v1, tolerance: 0.0)
            XCTAssertTrue(nearlyParallel)

            nearlyParallel = try! v1.isNearlyParallel(to: v2, tolerance: 0.0)
            XCTAssertTrue(nearlyParallel)
        }
    }

    func test_isNearlyParallelToWithZeroTolerance2()
    {
        (1...N).forEach { _ in
            var nearlyParallel: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dx += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyParallel = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyParallel)

            nearlyParallel = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyParallel)
        }
    }

    func test_isNearlyParallelToWithZeroTolerance3()
    {
        (1...N).forEach { _ in
            var nearlyParallel: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dy += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyParallel = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyParallel)

            nearlyParallel = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyParallel)
        }
    }

    func test_isNearlyParallelToWithZeroTolerance4()
    {
        (1...N).forEach { _ in
            var nearlyParallel: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dx += CGFloat.randomNonZero(rangeMin, rangeMax)
            v2.dy += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyParallel = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyParallel)

            nearlyParallel = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyParallel)
        }
    }

    func test_isNearlyParallelToWithOrWithoutCustomTolerance()
    {
        func testNearlyParallel(shouldFail: Bool) {
            let usingDefaultTolerance = (tolerance == CGFloat.tolerance)

            (1...N).forEach { _ in
                let m = CGFloat.random(1, 2)
                let maxAngleDelta: CGFloat = tolerance / (m * m)

                let a1 = CGFloat.random(0, 360).degreesInRadians
                let v1 = try! CGVector(magnitude: m, angle: a1)

                var a2 = a1
                if shouldFail {
                    a2 += (1.1 * maxAngleDelta)
                } else {
                    let r = 0.9 * maxAngleDelta
                    a2 += CGFloat.random(-r, r)
                }
                let v2 = try! CGVector(magnitude: m, angle: a2)

                let v1NearlyParallelToV2: Bool
                let v2NearlyParallelToV1: Bool
                if usingDefaultTolerance {
                    v1NearlyParallelToV2 = try! v1.isNearlyParallel(to: v2)
                    v2NearlyParallelToV1 = try! v2.isNearlyParallel(to: v1)
                } else {
                    v1NearlyParallelToV2 = try! v1.isNearlyParallel(to: v2, tolerance: tolerance)
                    v2NearlyParallelToV1 = try! v2.isNearlyParallel(to: v1, tolerance: tolerance)
                }

                XCTAssertFalse(v1NearlyParallelToV2 == shouldFail)
                XCTAssertFalse(v2NearlyParallelToV1 == shouldFail)
            }
        }

        tolerance = CGFloat.tolerance // default tolerance
        testNearlyParallel(shouldFail: false)
        testNearlyParallel(shouldFail: true)

        tolerance = 1e-4 // custom non-zero tolerance
        testNearlyParallel(shouldFail: false)
        testNearlyParallel(shouldFail: true)
    }

    func test_projectionPerpendicularToReturnsTheZeroVectorWhenBothVectorsAreTheZeroVector()
    {
        let u = CGVector.zero
        let v = CGVector.zero

        expectedVector = CGVector.zero
        resultedVector = u.projectionPerpendicular(to : v)
        assertEqualVectorsWithinTolerance()
    }

    func test_projectionPerpendicularToReturnsSelfWhenEitherVectorIsTheZeroVector()
    {
        let u = CGVector.zero
        let v = CGVector.random(rangeMin, rangeMax)

        expectedVector = u
        resultedVector = u.projectionPerpendicular(to : v)
        assertEqualVectorsWithinTolerance()

        expectedVector = v
        resultedVector = v.projectionPerpendicular(to : u)
        assertEqualVectorsWithinTolerance()
    }

    func test_projectionPerpendicularToUnitVectorX()
    {
        let m = CGFloat.randomNonZero(0, abs(rangeMax))
        let a = CGFloat.random(0, 360).degreesInRadians
        let u = try! CGVector(magnitude: m, angle: a)

        let v = CGVector.unitVectorX
        expectedVector = try! CGVector(magnitude: m, sine: sin(a), cosine: 0)
        resultedVector = u.projectionPerpendicular(to : v)
        assertEqualVectorsWithinTolerance()
    }

    func test_projectionPerpendicularToUnitVectorY()
    {
        let m = CGFloat.randomNonZero(0, abs(rangeMax))
        let a = CGFloat.random(0, 360).degreesInRadians
        let u = try! CGVector(magnitude: m, angle: a)

        let v = CGVector.unitVectorY
        expectedVector = try! CGVector(magnitude: m, sine: 0, cosine: cos(a))
        resultedVector = u.projectionPerpendicular(to : v)
        assertEqualVectorsWithinTolerance()
    }

    func test_isNearlyPerpendicularToWithNegativeToleranceThrows()
    {
        (1...N).forEach { _ in
            let v1 = CGVector.random(rangeMin, rangeMax)
            let v2 = CGVector.random(rangeMin, rangeMax)
            let tol = -CGFloat.randomNonZero(0, abs(rangeMax))

            do {
                let _ = try v2.isNearlyPerpendicular(to: v1, tolerance: tol)
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.negativeTolerance
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_isNearlyPerpendicularToWithZeroTolerance1()
    {
        (1...N).forEach { _ in
            var nearlyPerpendicular: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            let v2 = v1

            nearlyPerpendicular = try! v2.isNearlyPerpendicular(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)

            nearlyPerpendicular = try! v1.isNearlyPerpendicular(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)
        }
    }

    func test_isNearlyPerpendicularToWithZeroTolerance2()
    {
        (1...N).forEach { _ in
            var nearlyPerpendicular: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dx += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyPerpendicular = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)

            nearlyPerpendicular = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)
        }
    }

    func test_isNearlyPerpendicularToWithZeroTolerance3()
    {
        (1...N).forEach { _ in
            var nearlyPerpendicular: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dy += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyPerpendicular = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)

            nearlyPerpendicular = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)
        }
    }

    func test_isNearlyPerpendicularToWithZeroTolerance4()
    {
        (1...N).forEach { _ in
            var nearlyPerpendicular: Bool
            let v1 = CGVector.random(rangeMin, rangeMax)

            var v2 = v1
            v2.dx += CGFloat.randomNonZero(rangeMin, rangeMax)
            v2.dy += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyPerpendicular = try! v2.isNearlyEqual(to: v1, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)

            nearlyPerpendicular = try! v1.isNearlyEqual(to: v2, tolerance: 0.0)
            XCTAssertFalse(nearlyPerpendicular)
        }
    }

    func test_isNearlyPerpendicularToWithOrWithoutCustomTolerance()
    {
        func testNearlyPerpendicular(shouldFail: Bool) {
            let usingDefaultTolerance = (tolerance == CGFloat.tolerance)

            (1...N).forEach { _ in
                let m = CGFloat.random(1, 2)
                let maxAngleDelta: CGFloat = tolerance / (m * m)

                let a1 = CGFloat.random(0, 360).degreesInRadians
                let v1 = try! CGVector(magnitude: m, angle: a1)

                let randomOddInt = 2 * Int(abs(rangeMax) * CGFloat.random(-1, 1)) + 1
                var a2 = a1 + CGFloat(randomOddInt) * CGFloat.pi/2
                if shouldFail {
                    a2 += (1.1 * maxAngleDelta)
                } else {
                    let r = 0.9 * maxAngleDelta
                    a2 += CGFloat.random(-r, r)
                }
                let v2 = try! CGVector(magnitude: m, angle: a2)

                let v1NearlyPerpToV2: Bool
                let v2NearlyPerpToV1: Bool
                if usingDefaultTolerance {
                    v1NearlyPerpToV2 = try! v1.isNearlyPerpendicular(to: v2)
                    v2NearlyPerpToV1 = try! v2.isNearlyPerpendicular(to: v1)
                } else {
                    v1NearlyPerpToV2 = try! v1.isNearlyPerpendicular(to: v2, tolerance: tolerance)
                    v2NearlyPerpToV1 = try! v2.isNearlyPerpendicular(to: v1, tolerance: tolerance)
                }

                XCTAssertFalse(v1NearlyPerpToV2 == shouldFail)
                XCTAssertFalse(v2NearlyPerpToV1 == shouldFail)
            }
        }

        tolerance = CGFloat.tolerance // default tolerance
        testNearlyPerpendicular(shouldFail: false)
        testNearlyPerpendicular(shouldFail: true)

        tolerance = 1e-4 // custom non-zero tolerance
        testNearlyPerpendicular(shouldFail: false)
        testNearlyPerpendicular(shouldFail: true)
    }

    func test_rotateClockwiseBy()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            var u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a - rotAngle)

            u.rotateClockwise(by: rotAngle)

            expectedVector = v
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_rotateClockwiseSineCosine()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            var u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a - rotAngle)

            let sinRotAngle: CGFloat = sin(rotAngle)
            let cosRotAngle: CGFloat = cos(rotAngle)

            u.rotateClockwise(sine: sinRotAngle, cosine: cosRotAngle)

            expectedVector = v
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_rotatedClockwiseBy()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            let u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a - rotAngle)

            expectedVector = v
            resultedVector = u.rotatedClockwise(by: rotAngle)
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_rotatedClockwiseSineCosine()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            let u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a - rotAngle)

            let sinRotAngle: CGFloat = sin(rotAngle)
            let cosRotAngle: CGFloat = cos(rotAngle)

            expectedVector = v
            resultedVector = u.rotatedClockwise(sine: sinRotAngle, cosine: cosRotAngle)
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_rotateCounterClockwiseBy()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            var u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a + rotAngle)

            u.rotateCounterClockwise(by: rotAngle)

            expectedVector = v
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_rotateCounterClockwiseSineCosine()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            var u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a + rotAngle)

            let sinRotAngle: CGFloat = sin(rotAngle)
            let cosRotAngle: CGFloat = cos(rotAngle)

            u.rotateCounterClockwise(sine: sinRotAngle, cosine: cosRotAngle)

            expectedVector = v
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_rotatedCounterClockwiseBy()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            let u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a + rotAngle)

            expectedVector = v
            resultedVector = u.rotatedCounterClockwise(by: rotAngle)
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_rotatedCounterClockwiseSineCosine()
    {
        (1...N).forEach { _ in
            let m = CGFloat.randomNonZero(0, abs(rangeMax))
            let a = CGFloat.random(0, 360).degreesInRadians
            let u = try! CGVector(magnitude: m, angle: a)

            let rotAngle = CGFloat.random(0, 360).degreesInRadians
            let v = try! CGVector(magnitude: m, angle: a + rotAngle)

            let sinRotAngle: CGFloat = sin(rotAngle)
            let cosRotAngle: CGFloat = cos(rotAngle)

            expectedVector = v
            resultedVector = u.rotatedCounterClockwise(sine: sinRotAngle, cosine: cosRotAngle)
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorPlus()
    {
        (1...N).forEach { _ in
            let dx1 = CGFloat.random(rangeMin, rangeMax)
            let dy1 = CGFloat.random(rangeMin, rangeMax)
            let v1 = CGVector(dx: dx1, dy: dy1)

            let dx2 = CGFloat.random(rangeMin, rangeMax)
            let dy2 = CGFloat.random(rangeMin, rangeMax)
            let v2 = CGVector(dx: dx2, dy: dy2)

            let u = v1 + v2

            expectedVector = CGVector(dx: v1.dx + v2.dx, dy: v1.dy + v2.dy)
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorMinus()
    {
        (1...N).forEach { _ in
            let dx1 = CGFloat.random(rangeMin, rangeMax)
            let dy1 = CGFloat.random(rangeMin, rangeMax)
            let v1 = CGVector(dx: dx1, dy: dy1)

            let dx2 = CGFloat.random(rangeMin, rangeMax)
            let dy2 = CGFloat.random(rangeMin, rangeMax)
            let v2 = CGVector(dx: dx2, dy: dy2)

            let u = v1 - v2

            expectedVector = CGVector(dx: v1.dx - v2.dx, dy: v1.dy - v2.dy)
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorsScalarTimesVectorAndVectorTimesScalar()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let s = CGFloat.random(rangeMin, rangeMax)
            expectedVector = CGVector(dx: s * v.dx, dy: s * v.dy)

            resultedVector = v * s
            assertEqualVectorsWithinTolerance()

            resultedVector = s * v
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorVectorDividedByScalarThrowsOnZeroScalar()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let s: CGFloat = 0
            do {
                let _ = try v / s
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.divisionByZero
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_operatorVectorDividedByScalar()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let s = CGFloat.randomNonZero(rangeMin, rangeMax)

            expectedVector = CGVector(dx: v.dx / s, dy: v.dy / s)
            resultedVector = try! v / s
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorUnaryMinus()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            expectedVector = CGVector(dx: -v.dx, dy: -v.dy)
            resultedVector = -v
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorPlusEqual()
    {
        (1...N).forEach { _ in
            let dx1 = CGFloat.random(rangeMin, rangeMax)
            let dy1 = CGFloat.random(rangeMin, rangeMax)
            let v1 = CGVector(dx: dx1, dy: dy1)

            let dx2 = CGFloat.random(rangeMin, rangeMax)
            let dy2 = CGFloat.random(rangeMin, rangeMax)
            let v2 = CGVector(dx: dx2, dy: dy2)

            var u = v1
            u += v2

            expectedVector = CGVector(dx: v1.dx + v2.dx, dy: v1.dy + v2.dy)
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorMinusEqual()
    {
        (1...N).forEach { _ in
            let dx1 = CGFloat.random(rangeMin, rangeMax)
            let dy1 = CGFloat.random(rangeMin, rangeMax)
            let v1 = CGVector(dx: dx1, dy: dy1)

            let dx2 = CGFloat.random(rangeMin, rangeMax)
            let dy2 = CGFloat.random(rangeMin, rangeMax)
            let v2 = CGVector(dx: dx2, dy: dy2)

            var u = v1
            u -= v2

            expectedVector = CGVector(dx: v1.dx - v2.dx, dy: v1.dy - v2.dy)
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorTimesEqual()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let s = CGFloat.random(rangeMin, rangeMax)

            var u = v
            u *= s

            expectedVector = CGVector(dx: s * v.dx, dy: s * v.dy)
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorDivideEqualThrowsOnZeroScalar()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let s: CGFloat = 0
            var u = v
            do {
                try u /= s
                XCTFail()
            }
            catch {
                expectedError = WTCoreGraphicsExtensionsError.divisionByZero
                resultedError = error
                assertEqualErrors()
            }
        }
    }

    func test_operatorDivideEqual()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let s = CGFloat.randomNonZero(rangeMin, rangeMax)

            var u = v
            try! u /= s

            expectedVector = CGVector(dx: v.dx / s, dy: v.dy / s)
            resultedVector = u
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_hashValue()
    {
        (1...N).forEach { _ in
            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)

            let v = CGVector(dx: dx, dy: dy)

            let expectedHashValue = "\(dx)\(dy)".hashValue
            let resultedHashValue = v.hashValue
            XCTAssertEqual(resultedHashValue, expectedHashValue)
        }
    }
}
