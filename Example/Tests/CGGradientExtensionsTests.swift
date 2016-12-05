//
//  CGGradientExtensionsTests.swift
//  WTCoreGraphicsExtensions
//
//  Created by Wagner Truppel on 2016.12.03.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import XCTest
import Foundation
import WTCoreGraphicsExtensions

class CGGradientExtensionsTests: WTCoreGraphicsExtensionsTestsBase
{
    private var numberOfColors: Int!
    private var numberOfLocations: Int!

    // MARK: -
    
    override func setUp() {
        super.setUp()
        numberOfColors = Int(abs(CGFloat.randomNonZero(rangeMin, rangeMax)))
        numberOfLocations = Int(abs(CGFloat.randomNonZero(rangeMin, rangeMax)))
    }

    // MARK: -
    
    func test_rgbaGradientThrowsInvalidNumberOfColorLocationPairs()
    {
        let colors = (0 ... numberOfColors).map { _ in UIColor.randomRGBA }
        let locations = [CGFloat.random01]

        do {
            let _ = try CGGradient.rgbaGradient(with: colors, at: locations)
            XCTFail()
        }
        catch {
            let expectedError = CGGradient.CGGradientError.invalidNumberOfColorLocationPairs
            let resultedError = error

            XCTAssertTrue(resultedError is CGGradient.CGGradientError)
            if let resultedError = resultedError as? CGGradient.CGGradientError
            { XCTAssertEqual(resultedError, expectedError) }
        }
    }

    func test_rgbaGradientThrowsMismatchedColorAndLocationArraySizes()
    {
        numberOfLocations = 2 * numberOfColors + 2

        let colors = (0 ... numberOfColors).map { _ in UIColor.randomRGBA }
        let locations = (0 ... numberOfLocations).map { _ in CGFloat.random01 }

        do {
            let _ = try CGGradient.rgbaGradient(with: colors, at: locations)
            XCTFail()
        }
        catch {
            let expectedError = CGGradient.CGGradientError.mismatchedColorAndLocationArraySizes
            let resultedError = error

            XCTAssertTrue(resultedError is CGGradient.CGGradientError)
            if let resultedError = resultedError as? CGGradient.CGGradientError
            { XCTAssertEqual(resultedError, expectedError) }
        }
    }

    func test_rgbaGradientThrowsInvalidColorLocations()
    {
        numberOfColors = numberOfColors + 2
        numberOfLocations = numberOfColors
        let commonLocation = CGFloat.random01

        let colors = (0 ... numberOfColors).map { _ in UIColor.randomRGBA }
        let locations = (0 ... numberOfLocations).map { _ in commonLocation }

        do {
            let _ = try CGGradient.rgbaGradient(with: colors, at: locations)
            XCTFail()
        }
        catch {
            let expectedError = CGGradient.CGGradientError.invalidColorLocations
            let resultedError = error

            XCTAssertTrue(resultedError is CGGradient.CGGradientError)
            if let resultedError = resultedError as? CGGradient.CGGradientError
            { XCTAssertEqual(resultedError, expectedError) }
        }
    }
}
