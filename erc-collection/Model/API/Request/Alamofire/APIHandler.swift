//
//  APIHandler.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

class APIHandler: APIService {
    static let shared = APIHandler()

    private(set) var requestHandler = AlamofireRequestHandler()

    func fetchNFT(apikey: String, owner: String, pageSize: Int, pageKey: String?, completionHandler: @escaping (Result<NFTsForOwnerResponse, APIError>) -> Void) {
        requestHandler.request(NFTsForOwnerApi(apiKey: apikey, owner: owner, pageSize: pageSize, pageKey: pageKey), responseType: NFTsForOwnerResponse.self, completionHandler: completionHandler)
    }

    func fetchEthereumBalance(apikey: String, ethereumAddress: String, completionHandler: @escaping (Result<EthereumBalance, APIError>) -> Void) {
        requestHandler.request(EthereumBalanceApi(apiKey: apikey, ethereumAddress: ethereumAddress), responseType: EthereumBalance.self, completionHandler: completionHandler)
    }
}
