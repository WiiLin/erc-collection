//
//  ApiResponseTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class ApiResponseTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNFTDecoding() {
        let jsonString = """
        {
            "metadata": {
                "name": "NFT Name",
                "image": "https://example.com/image.png"
            },
            "contract": {
                "address": "0x123"
            },
            "contractMetadata": {
                "name": "Contract Name"
            },
            "id": {
                "tokenId": "0x1"
            },
            "description": "Test Description"
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from JSON string")
            return
        }

        let decoder = JSONDecoder()
        do {
            let nft = try decoder.decode(NFT.self, from: jsonData)

            XCTAssertEqual(nft.metadata.name, "NFT Name")

            XCTAssertEqual(nft.metadata.image, "https://example.com/image.png")

            XCTAssertEqual(nft.contract.address, "0x123")

            XCTAssertEqual(nft.contractMetadata.name, "Contract Name")

            XCTAssertEqual(nft.id.tokenId, "0x1")

            XCTAssertEqual(nft.description, "Test Description")

            XCTAssertEqual(nft.permalink?.absoluteString, "https://testnets.opensea.io/assets/goerli/0x123/1")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }

    func testEthereumBalanceDecoding() {
        let jsonString = """
        {
            "result": "0x6f6c47474c8086"
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from JSON string")
            return
        }

        let decoder = JSONDecoder()
        do {
            let balance = try decoder.decode(EthereumBalance.self, from: jsonData)
            XCTAssertEqual(balance.result, "0x6f6c47474c8086")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
}
