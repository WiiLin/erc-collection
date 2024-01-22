//
//  String+Convert.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

extension String {
    func hexStringToInt() -> Int? {
        let hexString = self
        let trimmedString = hexString.hasPrefix("0x") ? String(hexString.dropFirst(2)) : hexString
        let endIndex = trimmedString.index(trimmedString.endIndex, offsetBy: -min(trimmedString.count, 16))
        let lastDigits = String(trimmedString[endIndex...])
        return Int(lastDigits, radix: 16)
    }
}
