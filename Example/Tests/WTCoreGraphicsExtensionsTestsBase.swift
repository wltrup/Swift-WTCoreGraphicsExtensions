//
//  WTCoreGraphicsExtensionsTestsBase.swift
//  WTCoreGraphicsExtensions
//
//  Created by Wagner Truppel on 2016.12.03.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import XCTest
import Foundation
import WTCoreGraphicsExtensions

class WTCoreGraphicsExtensionsTestsBase: XCTestCase
{
    var tolerance: CGFloat = 0
    var N: Int = 0

    var rangeMin: CGFloat = 0
    var rangeMax: CGFloat = 0

    // MARK: -

    var expectedValue: CGFloat = 0
    var resultedValue: CGFloat = 0

    var expectedPoint = CGPoint.zero
    var resultedPoint = CGPoint.zero

    var expectedVector = CGVector.zero
    var resultedVector = CGVector.zero

    var expectedError: WTCoreGraphicsExtensionsError!
    var resultedError: Error!

    // MARK: -

    final func assertAbsoluteDifferenceWithinTolerance()
    { XCTAssertTrue(abs(resultedValue - expectedValue) <= tolerance) }

    /// Tests that uniformly generated pseudo-random values in the range [0, 1]
    /// satisfy the properties that their average approaches 1/2 and their
    /// variance approaches 1/12.
    final func testRandomness(_ values: [CGFloat])
    {
        let n = CGFloat(values.count)
        let average = values.reduce(0, +) / n
        let variance = values
            .map { ($0 - average)*($0 - average) }
            .reduce(0, +) / n

        expectedValue = 1.0/2.0
        resultedValue = average
        assertAbsoluteDifferenceWithinTolerance()

        expectedValue = 1.0/12.0
        resultedValue = variance
        assertAbsoluteDifferenceWithinTolerance()
    }

    final func assertEqualPointsWithinTolerance()
    {
        expectedValue = expectedPoint.x
        resultedValue = resultedPoint.x
        assertAbsoluteDifferenceWithinTolerance()

        expectedValue = expectedPoint.y
        resultedValue = resultedPoint.y
        assertAbsoluteDifferenceWithinTolerance()
    }

    final func assertEqualVectorsWithinTolerance()
    {
        expectedValue = expectedVector.dx
        resultedValue = resultedVector.dx
        assertAbsoluteDifferenceWithinTolerance()

        expectedValue = expectedVector.dy
        resultedValue = resultedVector.dy
        assertAbsoluteDifferenceWithinTolerance()
    }

    final func assertEqualErrors()
    {
        XCTAssertTrue(resultedError is WTCoreGraphicsExtensionsError)
        if let resultedError = resultedError as? WTCoreGraphicsExtensionsError
        { XCTAssertEqual(resultedError, expectedError) }
    }

    // MARK: -

    override func setUp()
    {
        super.setUp()

        tolerance = 1e-10
        N = 100

        rangeMin = -10
        rangeMax =  10
    }
}
