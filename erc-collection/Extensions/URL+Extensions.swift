//
//  URL+Extensions.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

extension URL {
    var isSVGUrl: Bool {
        return absoluteString.hasSuffix("svg")
    }
}
