//
//  CalculatorTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class CalculatorTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConvertWeiToEth() {
        let validHex = "1BC16D674EC80000"
        let expectedEthForValidHex = Decimal(2)
        XCTAssertEqual(Calculator.convertWeiToEth(weiHex: validHex), expectedEthForValidHex)

        let prefixedHex = "0x1BC16D674EC80000"
        XCTAssertEqual(Calculator.convertWeiToEth(weiHex: prefixedHex), expectedEthForValidHex)

        let invalidHex = "ABCDEFGH"
        XCTAssertNil(Calculator.convertWeiToEth(weiHex: invalidHex))

        let oversizedHex = "1BC16D674EC800001BC16D674EC80000"
        XCTAssertNil(Calculator.convertWeiToEth(weiHex: oversizedHex))
    }
}
