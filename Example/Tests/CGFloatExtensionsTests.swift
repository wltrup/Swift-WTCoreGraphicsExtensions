//
//  CGFloatExtensionsTests.swift
//  WTCoreGraphicsExtensions
//
//  Created by Wagner Truppel on 2016.12.03.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import XCTest
import Foundation
import WTCoreGraphicsExtensions
import WTBoolExtensions

class CGFloatExtensionsTests: WTCoreGraphicsExtensionsTestsBase
{
    func test_radiansInDegrees()
    {
        (-720...720).forEach { i in
            let degs = CGFloat(i)
            let rads = (degs * CGFloat.pi) / 180

            expectedValue = degs
            resultedValue = rads.radiansInDegrees
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_degreesInRadians()
    {
        (-720...720).forEach { i in
            let degs = CGFloat(i)
            let rads = (degs * CGFloat.pi) / 180

            expectedValue = rads
            resultedValue = degs.degreesInRadians
            assertAbsoluteDifferenceWithinTolerance()
        }
    }

    func test_random01GeneratesValuesInTheExpectedRange()
    {
        (1...N).forEach { _ in
            let r = CGFloat.random01
            XCTAssertTrue(r >= 0 && r <= 1)
        }
    }

    func test_random01Randomness()
    {
        N = 100_000
        tolerance = 1e-2

        let values = (1...N).map { _ in CGFloat.random01 }
        testRandomness(values)
    }

    func test_randomGeneratesValuesInTheExpectedRange()
    {
        let min: CGFloat = -100
        let max: CGFloat =  100

        (1...N).forEach { _ in
            let r = CGFloat.random(min, max)
            XCTAssertTrue(r >= min && r <= max)
        }
    }

    func test_randomRandomness()
    {
        N = 100_000
        tolerance = 1e-2

        let values = (1...N).map { _ in CGFloat.random(0, 1) }
        testRandomness(values)
    }

    /// This test can only fail statistically.
    func test_randomNonZeroGeneratesNonZeroValues()
    {
        N = 100_000

        (1...N).forEach { _ in
            let r = CGFloat.randomNonZero(-1, 1)
            XCTAssertTrue(r != 0)
        }
    }

    func test_randomNonZeroGeneratesValuesInTheExpectedRange()
    {
        let min: CGFloat = -100
        let max: CGFloat =  100

        (1...N).forEach { _ in
            let r = CGFloat.randomNonZero(min, max)
            XCTAssertTrue(r >= min && r <= max)
        }
    }

    func test_randomNonZeroRandomness()
    {
        N = 100_000
        tolerance = 1e-2

        let values = (1...N).map { _ in CGFloat.randomNonZero(0, 1) }
        testRandomness(values)
    }

    /// Tests that uniform pseudo-random boolean values satisfy the
    /// properties of a uniform continuous distribution, namely,
    /// that approximately half of the generated booleans are `true`.
    func test_randomBool()
    {
        N = 100_000
        tolerance = 1e-2

        let countOfTrueValues = (1...N)
            .map { _ in Bool.random }
            .filter { $0 }
            .count

        expectedValue = 0.5
        resultedValue = CGFloat(countOfTrueValues) / CGFloat(N)
        assertAbsoluteDifferenceWithinTolerance()
    }
}
