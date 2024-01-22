//
//  Calculator.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

enum Calculator {
    static func convertWeiToEth(weiHex: String) -> Decimal? {
        let weiHexCleaned = weiHex.hasPrefix("0x") ? String(weiHex.dropFirst(2)) : weiHex

        guard let weiUInt = UInt64(weiHexCleaned, radix: 16) else {
            return nil
        }

        let weiDecimal = Decimal(weiUInt)

        let ethValue = weiDecimal / Decimal(1_000_000_000_000_000_000)
        return ethValue
    }
}
