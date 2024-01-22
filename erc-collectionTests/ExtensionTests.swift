//
//  ExtensionTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class ExtensionTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHexStringToInt() {
        XCTAssertEqual("1A".hexStringToInt(), 26)

        XCTAssertEqual("0x1A".hexStringToInt(), 26)

        XCTAssertEqual("0x000000000000000000000000000000000000000000000000000000000000001A".hexStringToInt(), 26)

        XCTAssertNil("0x123456789ABCDEF123456789ABCDEF123456789".hexStringToInt())

        XCTAssertNil("GHIJKL".hexStringToInt())
    }

    func testIsSVGUrl() {
        let svgUrl = URL(string: "https://example.com/image.svg")!
        XCTAssertTrue(svgUrl.isSVGUrl)

        let jpgUrl = URL(string: "https://example.com/image.jpg")!
        XCTAssertFalse(jpgUrl.isSVGUrl)

        let noExtensionUrl = URL(string: "https://example.com/image")!
        XCTAssertFalse(noExtensionUrl.isSVGUrl)

        let svgUrlWithParams = URL(string: "https://example.com/image.svg?param=value")!
        XCTAssertFalse(svgUrlWithParams.isSVGUrl)
    }
}
