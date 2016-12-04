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

    // Hmm... this test never passes. Apparently UIColor instances are always backed
    // by components in the RGB space, even when initialised with HSB components.
    // TODO: investigate whether UIColor instances are always backed by components in the RGB space
//    func test_rgbaGradientThrowsInvalidColorSpace()
//    {
//        numberOfColors = numberOfColors + 2
//        numberOfLocations = numberOfColors
//
//        let colors = (0 ... numberOfColors).map { _ in
//            UIColor(hue: CGFloat.random01,
//                    saturation: CGFloat.random01,
//                    brightness: CGFloat.random01,
//                    alpha: CGFloat.random01)
//        }
//        let locations = (0 ... numberOfLocations).map { _ in CGFloat.random01 }
//
//        do {
//            let _ = try CGGradient.rgbaGradient(with: colors, at: locations)
//            XCTFail()
//        }
//        catch {
//            let expectedError = WTUIColorError.invalidColorSpace
//            let resultedError = error
//
//            XCTAssertTrue(resultedError is WTUIColorError)
//            if let resultedError = resultedError as? WTUIColorError
//            { XCTAssertEqual(resultedError, expectedError) }
//        }
//    }
}
