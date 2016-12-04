//
//  CGPointExtensionsTests.swift
//  WTCoreGraphicsExtensions
//
//  Created by Wagner Truppel on 2016.12.03.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import XCTest
import Foundation
import WTCoreGraphicsExtensions

class CGPointExtensionsTests: WTCoreGraphicsExtensionsTestsBase
{
    func test_initFromFloats()
    {
        (1...N).forEach { _ in
            let a = Float(CGFloat.random(rangeMin, rangeMax))
            let b = Float(CGFloat.random(rangeMin, rangeMax))

            let p = CGPoint(x: a, y: b)

            expectedValue = CGFloat(a)
            resultedValue = p.x
            assertAbsoluteDifferenceWithinTolerance()

            expectedValue = CGFloat(b)
            resultedValue = p.y
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_randomGeneratesValuesInTheExpectedRange()
    {
        let min = (rangeMin <= rangeMax ? rangeMin : rangeMax)
        let max = (rangeMin >= rangeMax ? rangeMin : rangeMax)

        (1...N).forEach { _ in
            let p = CGPoint.random(rangeMin, rangeMax)
            XCTAssertTrue(p.x >= min && p.x <= max)
            XCTAssertTrue(p.y >= min && p.y <= max)
        }
    }

    /// Tests that `random(a:b:)` creates a `CGPoint` with pseudo-random coordinates
    /// satisfying, independently from one another, the property that their
    /// generated values have an average approximating 1/2 and a variance
    /// approximating 1/12, when the range is [0, 1].
    func test_randomRandomness()
    {
        N = 100_000
        tolerance = 1e-2

        enum Coordinate {
            case x
            case y
        }

        func testCoordinate(_ c: Coordinate) {
            let values = (1...N).map { _ -> CGFloat in
                let p = CGPoint.random(0, 1)
                return (c == Coordinate.x ? p.x : p.y)
            }
            testRandomness(values)
        }

        testCoordinate(.x)
        testCoordinate(.y)
    }

    func test_isNearlyEqualWithNegativeToleranceThrows()
    {
        (1...N).forEach { _ in
            let p1 = CGPoint.random(rangeMin, rangeMax)
            let p2 = CGPoint.random(rangeMin, rangeMax)
            let tol = -CGFloat.randomNonZero(0, abs(rangeMax))

            do {
                let _ = try p2.isNearlyEqual(to: p1, tolerance: tol)
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
            let p1 = CGPoint.random(rangeMin, rangeMax)

            let p2 = p1

            nearlyEqual = try! p2.isNearlyEqual(to: p1, tolerance: 0.0)
            XCTAssertTrue(nearlyEqual)
            nearlyEqual = try! p1.isNearlyEqual(to: p2, tolerance: 0.0)
            XCTAssertTrue(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithZeroTolerance2()
    {
        (1...N).forEach { _ in
            var nearlyEqual: Bool
            let p1 = CGPoint.random(rangeMin, rangeMax)

            var p2 = p1
            p2.x += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyEqual = try! p2.isNearlyEqual(to: p1, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)

            nearlyEqual = try! p1.isNearlyEqual(to: p2, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithZeroTolerance3()
    {
        (1...N).forEach { _ in
            var nearlyEqual: Bool
            let p1 = CGPoint.random(rangeMin, rangeMax)

            var p2 = p1
            p2.y += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyEqual = try! p2.isNearlyEqual(to: p1, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)

            nearlyEqual = try! p1.isNearlyEqual(to: p2, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithZeroTolerance4()
    {
        (1...N).forEach { _ in
            var nearlyEqual: Bool
            let p1 = CGPoint.random(rangeMin, rangeMax)

            var p2 = p1
            p2.x += CGFloat.randomNonZero(rangeMin, rangeMax)
            p2.y += CGFloat.randomNonZero(rangeMin, rangeMax)

            nearlyEqual = try! p2.isNearlyEqual(to: p1, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)

            nearlyEqual = try! p1.isNearlyEqual(to: p2, tolerance: 0.0)
            XCTAssertFalse(nearlyEqual)
        }
    }

    func test_isNearlyEqualWithOrWithoutCustomTolerance()
    {
        func testNearlyEqual(maxDelta: CGFloat, shouldFail: Bool) {
            let usingDefaultTolerance = (tolerance == CGFloat.tolerance)

            (1...N).forEach { _ in
                let p1 = CGPoint.random(rangeMin, rangeMax)
                var p2 = p1
                if shouldFail {
                    p2.x += maxDelta
                    p2.y += maxDelta
                } else {
                    p2.x += CGFloat.random(-maxDelta, maxDelta)
                    p2.y += CGFloat.random(-maxDelta, maxDelta)
                }

                let p1NearlyEqualToP2: Bool
                let p2NearlyEqualToP1: Bool
                if usingDefaultTolerance {
                    p1NearlyEqualToP2 = try! p1.isNearlyEqual(to: p2)
                    p2NearlyEqualToP1 = try! p2.isNearlyEqual(to: p1)
                } else {
                    p1NearlyEqualToP2 = try! p1.isNearlyEqual(to: p2, tolerance: tolerance)
                    p2NearlyEqualToP1 = try! p2.isNearlyEqual(to: p1, tolerance: tolerance)
                }

                XCTAssertFalse(p1NearlyEqualToP2 == shouldFail)
                XCTAssertFalse(p2NearlyEqualToP1 == shouldFail)
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
            let p = CGPoint.random(rangeMin, rangeMax)
            let tol = -CGFloat.randomNonZero(0, abs(rangeMax))

            do {
                let _ = try p.isNearlyZero(tolerance: tol)
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
        let p = CGPoint.zero
        let nearlyZero = try! p.isNearlyZero(tolerance: 0.0)
        XCTAssertTrue(nearlyZero)
    }

    func test_isNearlyZeroWithZeroTolerance1()
    {
        (1...N).forEach { _ in
            let a = CGFloat.randomNonZero(rangeMin, rangeMax)
            let p = CGPoint(x: a, y: 0)
            let nearlyZero = try! p.isNearlyZero(tolerance: 0.0)
            XCTAssertFalse(nearlyZero)
        }
    }

    func test_isNearlyZeroWithZeroTolerance2()
    {
        (1...N).forEach { _ in
            let b = CGFloat.randomNonZero(rangeMin, rangeMax)
            let p = CGPoint(x: 0, y: b)
            let nearlyZero = try! p.isNearlyZero(tolerance: 0.0)
            XCTAssertFalse(nearlyZero)
        }
    }

    func test_isNearlyZeroWithZeroTolerance3()
    {
        (1...N).forEach { _ in
            let a = CGFloat.randomNonZero(rangeMin, rangeMax)
            let b = CGFloat.randomNonZero(rangeMin, rangeMax)
            let p = CGPoint(x: a, y: b)
            let nearlyZero = try! p.isNearlyZero(tolerance: 0.0)
            XCTAssertFalse(nearlyZero)
        }
    }

    func test_isNearlyZeroWithOrWithoutCustomTolerance()
    {
        func testNearlyZero(maxDelta: CGFloat, shouldFail: Bool) {
            let usingDefaultTolerance = (tolerance == CGFloat.tolerance)

            (1...N).forEach { _ in
                let p: CGPoint
                if shouldFail {
                    p = CGPoint(x: maxDelta, y: maxDelta)
                } else {
                    let a = CGFloat.random(-maxDelta, maxDelta)
                    let b = CGFloat.random(-maxDelta, maxDelta)
                    p = CGPoint(x: a, y: b)
                }

                let pNearlyZero: Bool
                if usingDefaultTolerance {
                    pNearlyZero = try! p.isNearlyZero()
                } else {
                    pNearlyZero = try! p.isNearlyZero(tolerance: tolerance)
                }

                XCTAssertFalse(pNearlyZero == shouldFail)
            }
        }

        tolerance = CGFloat.tolerance // default tolerance
        testNearlyZero(maxDelta: tolerance / 2, shouldFail: false)
        testNearlyZero(maxDelta: 10 * tolerance, shouldFail: true)

        tolerance = 1e-4 // custom non-zero tolerance
        testNearlyZero(maxDelta: tolerance / 2, shouldFail: false)
        testNearlyZero(maxDelta: 10 * tolerance, shouldFail: true)
    }

    func test_distanceTo()
    {
        (1...N).forEach { _ in
            let x1 = CGFloat.random(rangeMin, rangeMax)
            let y1 = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x1, y: y1)

            let x2 = CGFloat.random(rangeMin, rangeMax)
            let y2 = CGFloat.random(rangeMin, rangeMax)
            let p2 = CGPoint(x: x2, y: y2)

            let dx = x1 - x2
            let dy = y1 - y2
            expectedValue = CGFloat(sqrt(dx*dx + dy*dy))

            resultedValue = p1.distance(to: p2)
            assertAbsoluteDifferenceWithinTolerance()

            resultedValue = p2.distance(to: p1)
            assertAbsoluteDifferenceWithinTolerance()
        }
    }


    func test_distanceSquaredTo()
    {
        (1...N).forEach { _ in
            let x1 = CGFloat.random(rangeMin, rangeMax)
            let y1 = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x1, y: y1)

            let x2 = CGFloat.random(rangeMin, rangeMax)
            let y2 = CGFloat.random(rangeMin, rangeMax)
            let p2 = CGPoint(x: x2, y: y2)

            let dx = x1 - x2
            let dy = y1 - y2
            expectedValue = (dx*dx + dy*dy)

            resultedValue = p1.distanceSquared(to: p2)
            assertAbsoluteDifferenceWithinTolerance()

            resultedValue = p2.distanceSquared(to: p1)
            assertAbsoluteDifferenceWithinTolerance()
        }
    }


    func test_manhattanDistanceTo()
    {
        (1...N).forEach { _ in
            let x1 = CGFloat.random(rangeMin, rangeMax)
            let y1 = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x1, y: y1)

            let x2 = CGFloat.random(rangeMin, rangeMax)
            let y2 = CGFloat.random(rangeMin, rangeMax)
            let p2 = CGPoint(x: x2, y: y2)

            let dx = x1 - x2
            let dy = y1 - y2
            expectedValue = abs(dx) + abs(dy)

            resultedValue = p1.manhattanDistance(to: p2)
            assertAbsoluteDifferenceWithinTolerance()

            resultedValue = p2.manhattanDistance(to: p1)
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_vectorTo()
    {
        (1...N).forEach { _ in
            let x1 = CGFloat.random(rangeMin, rangeMax)
            let y1 = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x1, y: y1)

            let x2 = CGFloat.random(rangeMin, rangeMax)
            let y2 = CGFloat.random(rangeMin, rangeMax)
            let p2 = CGPoint(x: x2, y: y2)

            let dx = x2 - x1
            let dy = y2 - y1

            expectedVector = CGVector(dx: dx, dy: dy)
            resultedVector = p1.vector(to: p2)
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_vectorFrom()
    {
        (1...N).forEach { _ in
            let x1 = CGFloat.random(rangeMin, rangeMax)
            let y1 = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x1, y: y1)

            let x2 = CGFloat.random(rangeMin, rangeMax)
            let y2 = CGFloat.random(rangeMin, rangeMax)
            let p2 = CGPoint(x: x2, y: y2)

            let dx = x2 - x1
            let dy = y2 - y1

            expectedVector = CGVector(dx: dx, dy: dy)
            resultedVector = p2.vector(from: p1)
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_vectorFromTo()
    {
        (1...N).forEach { _ in
            let x1 = CGFloat.random(rangeMin, rangeMax)
            let y1 = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x1, y: y1)

            let x2 = CGFloat.random(rangeMin, rangeMax)
            let y2 = CGFloat.random(rangeMin, rangeMax)
            let p2 = CGPoint(x: x2, y: y2)

            let dx = x2 - x1
            let dy = y2 - y1

            expectedVector = CGVector(dx: dx, dy: dy)
            resultedVector = CGPoint.vector(from: p1, to: p2)
            assertEqualVectorsWithinTolerance()

            expectedVector = CGVector(dx: -dx, dy: -dy)
            resultedVector = CGPoint.vector(from: p2, to: p1)
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorPointPlusVector()
    {
        (1...N).forEach { _ in
            let x = CGFloat.random(rangeMin, rangeMax)
            let y = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x, y: y)

            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let p2 = p1 + v

            expectedPoint = CGPoint(x: p1.x + v.dx, y: p1.y + v.dy)
            resultedPoint = p2
            assertEqualPointsWithinTolerance()
        }
    }

    func test_operatorPointMinusVector()
    {
        (1...N).forEach { _ in
            let x = CGFloat.random(rangeMin, rangeMax)
            let y = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x, y: y)

            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            let p2 = p1 - v

            expectedPoint = CGPoint(x: p1.x - v.dx, y: p1.y - v.dy)
            resultedPoint = p2
            assertEqualPointsWithinTolerance()
        }
    }

    func test_operatorPointMinusPoint()
    {
        (1...N).forEach { _ in
            let x1 = CGFloat.random(rangeMin, rangeMax)
            let y1 = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x1, y: y1)

            let x2 = CGFloat.random(rangeMin, rangeMax)
            let y2 = CGFloat.random(rangeMin, rangeMax)
            let p2 = CGPoint(x: x2, y: y2)

            let dx = x2 - x1
            let dy = y2 - y1

            expectedVector = CGVector(dx: dx, dy: dy)
            resultedVector = p2 - p1
            assertEqualVectorsWithinTolerance()
        }
    }

    func test_operatorPlusEqual()
    {
        (1...N).forEach { _ in
            let x = CGFloat.random(rangeMin, rangeMax)
            let y = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x, y: y)

            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            var p2 = p1
            p2 += v

            expectedPoint = CGPoint(x: p1.x + v.dx, y: p1.y + v.dy)
            resultedPoint = p2
            assertEqualPointsWithinTolerance()
        }
    }

    func test_operatorMinusEqual()
    {
        (1...N).forEach { _ in
            let x = CGFloat.random(rangeMin, rangeMax)
            let y = CGFloat.random(rangeMin, rangeMax)
            let p1 = CGPoint(x: x, y: y)

            let dx = CGFloat.random(rangeMin, rangeMax)
            let dy = CGFloat.random(rangeMin, rangeMax)
            let v = CGVector(dx: dx, dy: dy)

            var p2 = p1
            p2 -= v

            expectedPoint = CGPoint(x: p1.x - v.dx, y: p1.y - v.dy)
            resultedPoint = p2
            assertEqualPointsWithinTolerance()
        }
    }

    func test_hashValue()
    {
        (1...N).forEach { _ in
            let x = CGFloat.random(rangeMin, rangeMax)
            let y = CGFloat.random(rangeMin, rangeMax)

            let p = CGPoint(x: x, y: y)

            let expectedHash = "\(x)\(y)".hashValue
            let resultedHash = p.hashValue
            XCTAssertEqual(resultedHash, expectedHash)
        }
    }
}
