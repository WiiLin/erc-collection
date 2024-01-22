//
//  APIService.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

protocol APIService {
    func fetchNFT(apikey: String, owner: String, pageSize: Int, pageKey: String?, completionHandler: @escaping (Result<NFTsForOwnerResponse, APIError>) -> Void)

    func fetchEthereumBalance(apikey: String, ethereumAddress: String, completionHandler: @escaping (Result<EthereumBalance, APIError>) -> Void)
}
