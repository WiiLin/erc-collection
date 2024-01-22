//
//  APIResponse.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

struct EmptyResponse: Decodable {}

struct APISuccessResponse<E: Decodable>: Decodable {
    let data: E
}
