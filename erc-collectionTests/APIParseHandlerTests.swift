//
//  APIParseHandlerTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class APIParseHandlerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseSuccess() {
        let jsonString = "{\"name\": \"Test Name\"}"
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from JSON string")
            return
        }

        let result: Result<TestResponse, APIParseError> = APIParseHandler.standard.parse(jsonData, keyDecodingStrategy: .useDefaultKeys, responseType: TestResponse.self)

        switch result {
        case let .success(response):
            XCTAssertEqual(response.name, "Test Name")
        case .failure:
            XCTFail("Expected successful parsing")
        }
    }

    func testDataCorruptedError() {
        let jsonString = "{This is not a valid JSON"
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from JSON string")
            return
        }

        let result: Result<TestResponse, APIParseError> = APIParseHandler.standard.parse(jsonData, keyDecodingStrategy: .useDefaultKeys, responseType: TestResponse.self)

        if case let .failure(error) = result, case .dataCorrupted = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected data corrupted error")
        }
    }

    func testKeyNotFoundError() {
        let jsonString = "{\"namee\": \"Test Name\"}"
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from JSON string")
            return
        }

        let result: Result<TestResponse, APIParseError> = APIParseHandler.standard.parse(jsonData, keyDecodingStrategy: .useDefaultKeys, responseType: TestResponse.self)

        if case let .failure(error) = result, case .keyNotFound = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected key not found error")
        }
    }

    func testValueNotFoundError() {
        let jsonString = "{\"name\": null}"
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from JSON string")
            return
        }

        let result: Result<TestResponse, APIParseError> = APIParseHandler.standard.parse(jsonData, keyDecodingStrategy: .useDefaultKeys, responseType: TestResponse.self)

        if case let .failure(error) = result, case .valueNotFound = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected value not found error")
        }
    }

    func testTypeMismatchError() {
        let jsonString = "{\"name\": 123}"
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from JSON string")
            return
        }

        let result: Result<TestResponse, APIParseError> = APIParseHandler.standard.parse(jsonData, keyDecodingStrategy: .useDefaultKeys, responseType: TestResponse.self)

        if case let .failure(error) = result, case .typeMismatch = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected type mismatch error")
        }
    }
}

struct TestResponse: Decodable {
    let name: String
}
