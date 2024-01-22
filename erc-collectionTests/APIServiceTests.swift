//
//  APIServiceTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class APIServiceTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchNFTSuccess() {
        let service = MockAPIService()
        service.shouldReturnError = false

        let expectation = self.expectation(description: "fetchNFT")

        service.fetchNFT(apikey: "apikey", owner: "owner", pageSize: 20, pageKey: nil) { result in
            switch result {
            case let .success(response):
                guard let firstNFT = response.ownedNfts.first else {
                    XCTFail("No NFTs found")
                    return
                }

                XCTAssertEqual(firstNFT.metadata.name, "NFT Name")
                XCTAssertEqual(firstNFT.metadata.image, "https://example.com/image.png")
                XCTAssertEqual(firstNFT.contract.address, "0x123")
                XCTAssertEqual(firstNFT.contractMetadata.name, "Contract Name")
                XCTAssertEqual(firstNFT.id.tokenId, "0x1")
                XCTAssertEqual(firstNFT.description, "Test Description")

            case .failure:
                XCTFail("Expected successful response")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchNFTFailure() {
        let service = MockAPIService()
        service.shouldReturnError = true

        let expectation = self.expectation(description: "fetchNFTFailure")

        service.fetchNFT(apikey: "apikey", owner: "owner", pageSize: 20, pageKey: nil) { result in
            if case let .failure(error) = result {
                switch error {
                case .apiResponseSourceError:
                    XCTAssertTrue(true)
                default:
                    XCTFail("Expected server error")
                }
            } else {
                XCTFail("Expected failure response")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchEthereumBalanceSuccess() {
        let service = MockAPIService()
        service.shouldReturnError = false

        let expectation = self.expectation(description: "fetchEthereumBalanceSuccess")

        service.fetchEthereumBalance(apikey: "apikey", ethereumAddress: "address") { result in
            switch result {
            case let .success(balance):
                XCTAssertEqual(balance.result, "0x6f6c47474c8086")
            case .failure:
                XCTFail("Expected successful response")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchEthereumBalanceFailure() {
        let service = MockAPIService()
        service.shouldReturnError = true

        let expectation = self.expectation(description: "fetchEthereumBalanceFailure")

        service.fetchEthereumBalance(apikey: "apikey", ethereumAddress: "address") { result in
            if case let .failure(error) = result {
                switch error {
                case .apiResponseSourceError:
                    XCTAssertTrue(true)
                default:
                    XCTFail("Expected server error")
                }
            } else {
                XCTFail("Expected failure response")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}

class MockAPIService: APIService {
    var shouldReturnError = false

    let successNFTJson = """
    {
        "ownedNfts": [
            {
                "metadata": { "name": "NFT Name", "image": "https://example.com/image.png" },
                "contract": { "address": "0x123" },
                "contractMetadata": { "name": "Contract Name" },
                "id": { "tokenId": "0x1" },
                "description": "Test Description"
            }
        ],
        "pageKey": "nextPageKey"
    }
    """

    let successEthereumBalanceJson = """
    {
        "result": "0x6f6c47474c8086"
    }
    """

    let failJson = """
    {
        "message": "Server error occurred"
    }
    """

    func fetchNFT(apikey: String, owner: String, pageSize: Int, pageKey: String?, completionHandler: @escaping (Result<NFTsForOwnerResponse, APIError>) -> Void) {
        let jsonData = shouldReturnError ? failJson.data(using: .utf8)! : successNFTJson.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(NFTsForOwnerResponse.self, from: jsonData)
            completionHandler(.success(response))
        } catch {
            completionHandler(.failure(APIError.apiResponseSourceError))
        }
    }

    func fetchEthereumBalance(apikey: String, ethereumAddress: String, completionHandler: @escaping (Result<EthereumBalance, APIError>) -> Void) {
        let jsonData = shouldReturnError ? failJson.data(using: .utf8)! : successEthereumBalanceJson.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let balance = try decoder.decode(EthereumBalance.self, from: jsonData)
            completionHandler(.success(balance))
        } catch {
            completionHandler(.failure(APIError.apiResponseSourceError))
        }
    }
}
