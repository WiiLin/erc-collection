//
//  CollectionListLayoutTests.swift
//  erc-collectionTests
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import XCTest

@testable import erc_collection

final class CollectionListLayoutTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLayoutConfiguration() {
        let layout = CollectionListLayout()

        layout.prepare()

        XCTAssertEqual(layout.scrollDirection, .vertical)

        XCTAssertEqual(layout.minimumInteritemSpacing, 20)
        XCTAssertEqual(layout.minimumLineSpacing, 20)

        XCTAssertEqual(layout.sectionInset, UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))

        XCTAssertEqual(layout.column, 2)

        let totalPadding: CGFloat = layout.minimumInteritemSpacing * (layout.column - 1)
        var width: CGFloat = UIScreen.main.bounds.width
        width -= totalPadding
        width -= layout.sectionInset.left
        width -= layout.sectionInset.right
        width -= 1
        width /= layout.column
        let expectedItemSize = CGSize(width: width, height: 200)

        XCTAssertEqual(layout.itemSize, expectedItemSize)
    }
}
