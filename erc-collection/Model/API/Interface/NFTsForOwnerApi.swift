//
//  NFTsForOwnerApi.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Alamofire

struct NFTsForOwnerApi: AlamofireRequest, Encodable {
    var baseUrl: URL? {
        return URL(string: "https://eth-goerli.g.alchemy.com/nft")
    }

    var apiPath: String { return "\(apiKey)/getNFTsForOwner" }

    var apiVersion: APIVersion { return .v2 }

    var method: Alamofire.HTTPMethod { return .get }

    let apiKey: String

    let owner: String

    let pageSize: Int

    let pageKey: String?
}

struct NFT: Decodable {
    struct Contract: Decodable {
        let address: String
    }

    struct Metadata: Decodable {
        let name: String
        let image: String
    }

    struct ContractMetadata: Decodable {
        let name: String
    }

    struct ID: Decodable {
        let tokenId: String
    }

    let metadata: Metadata
    let contract: Contract
    let contractMetadata: ContractMetadata
    let id: ID
    let description: String

    var permalink: URL? {
        guard let tokenId = id.tokenId.hexStringToInt() else { return nil }
        return URL(string: "https://testnets.opensea.io/assets/goerli/\(contract.address)/\(tokenId)")
    }
}

struct NFTsForOwnerResponse: Decodable {
    let ownedNfts: [NFT]
    let pageKey: String?
}
