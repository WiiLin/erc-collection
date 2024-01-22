//
//  ApiRequestTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class ApiRequestTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNFTsForOwnerRequest() {
        let apiKey = "testApiKey"
        let owner = "testOwner"
        let pageSize = 20
        let pageKey: String? = "testPageKey"
        let expectedBaseUrl = "https://eth-goerli.g.alchemy.com/nft"

        let api = NFTsForOwnerApi(apiKey: apiKey, owner: owner, pageSize: pageSize, pageKey: pageKey)

        XCTAssertEqual(api.baseUrl?.absoluteString, expectedBaseUrl)

        let expectedFullPath = "\(expectedBaseUrl)/\(apiKey)/getNFTsForOwner"
        XCTAssertEqual(api.baseUrl?.appendingPathComponent(api.apiPath).absoluteString, expectedFullPath)

        XCTAssertEqual(api.method, .get)
        XCTAssertEqual(api.apiVersion, .v2)
        XCTAssertEqual(api.owner, owner)
        XCTAssertEqual(api.pageSize, pageSize)
        XCTAssertEqual(api.pageKey, pageKey)
        XCTAssertEqual(api.queryItems, nil)
    }

    func testEthereumBalanceRequest() {
        let apiKey = "testApiKey"
        let ethereumAddress = "0x123"
        let expectedBaseUrl = "https://eth-goerli.alchemyapi.io/\(apiKey)"

        let api = EthereumBalanceApi(apiKey: apiKey, ethereumAddress: ethereumAddress)

        XCTAssertEqual(api.baseUrl?.absoluteString, expectedBaseUrl)

        XCTAssertEqual(api.apiPath, apiKey)

        XCTAssertEqual(api.method, .post)

        XCTAssertEqual(api.apiVersion, .v2)

        XCTAssertEqual(api.queryItems, nil)

        let expectedParameters: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "eth_getBalance",
            "params": [ethereumAddress, "latest"],
            "id": 1,
        ]

        XCTAssertEqual(api.parameters?["jsonrpc"] as? String, expectedParameters["jsonrpc"] as? String)
        XCTAssertEqual(api.parameters?["method"] as? String, expectedParameters["method"] as? String)
        XCTAssertEqual(api.parameters?["params"] as? [String], expectedParameters["params"] as? [String])
        XCTAssertEqual(api.parameters?["id"] as? Int, expectedParameters["id"] as? Int)
    }

    func testVersionStrings() {
        XCTAssertEqual(APIVersion.v1.versionString, "v1")

        XCTAssertEqual(APIVersion.v2.versionString, "v2")
    }
}
