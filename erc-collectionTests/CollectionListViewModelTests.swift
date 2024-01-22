//
//  CollectionListViewModelTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class CollectionListViewModelTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNextPageExist() {
        let viewModel = CollectionListViewModel(apiServcie: APIHandler())

        viewModel.pageKey = nil
        XCTAssertFalse(viewModel.nextPageExist())

        viewModel.pageKey = "nextPageKey"
        XCTAssertTrue(viewModel.nextPageExist())
    }

    func testAppendIndexPath() {
        let viewModel = CollectionListViewModel(apiServcie: APIHandler())

        let testData: [(oldCount: Int, newCount: Int)] = [
            (oldCount: 0, newCount: 5),
            (oldCount: 3, newCount: 6),
            (oldCount: 5, newCount: 10),
            (oldCount: 10, newCount: 10),
        ]

        for (oldCount, newCount) in testData {
            let indexPaths = viewModel.appendIndexPath(oldCount: oldCount, newCount: newCount)

            XCTAssertEqual(indexPaths.count, max(0, newCount - oldCount))
            for (index, indexPath) in indexPaths.enumerated() {
                XCTAssertEqual(indexPath, IndexPath(item: oldCount + index, section: 0))
            }
        }
    }
}
