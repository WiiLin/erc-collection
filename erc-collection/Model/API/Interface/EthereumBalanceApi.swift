//
//  EthereumBalanceApi.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Alamofire
import Foundation

struct EthereumBalanceApi: AlamofireRequest, Encodable {
    var baseUrl: URL? {
        return URL(string: "https://eth-goerli.alchemyapi.io/\(apiKey)")
    }

    var apiPath: String { return "\(apiKey)" }

    var apiVersion: APIVersion { return .v2 }

    var method: Alamofire.HTTPMethod { return .post }

    let apiKey: String

    let ethereumAddress: String

    var parameters: Parameters? {
        return [
            "jsonrpc": "2.0",
            "method": "eth_getBalance",
            "params": [ethereumAddress, "latest"],
            "id": 1,
        ]
    }
}

struct EthereumBalance: Decodable {
    let result: String
}
