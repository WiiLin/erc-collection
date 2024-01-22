//
//  APIParseHandler.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

enum APIParseError: Error {
    case dataCorrupted(String)
    case keyNotFound(String, [CodingKey])
    case valueNotFound(String, [CodingKey])
    case typeMismatch(String, [CodingKey])
    case custom(String)

    var errorMessage: String {
        switch self {
        case let .dataCorrupted(description):
            return "Data corrupted: \(description)"
        case let .keyNotFound(key, codingPath):
            return "Key '\(key)' not found at \(codingPath.description)"
        case let .valueNotFound(value, codingPath):
            return "Value '\(value)' not found at \(codingPath.description)"
        case let .typeMismatch(type, codingPath):
            return "Type mismatch for '\(type)' at \(codingPath.description)"
        case let .custom(message):
            return "Custom error: \(message)"
        }
    }
}

class APIParseHandler {
    static let standard = APIParseHandler()

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    func parse<ApiResponse: Swift.Decodable>(_ data: Data?,
                                             keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy,
                                             responseType: ApiResponse.Type) -> Result<ApiResponse, APIParseError> {
        jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
        if let data = data {
            if responseType is String.Type {
                let string = String(decoding: data, as: UTF8.self)
                return .success(string as! ApiResponse)
            } else {
                do {
                    let response = try jsonDecoder.decode(responseType, from: data)
                    return .success(response)
                } catch let DecodingError.dataCorrupted(context) {
                    return .failure(APIParseError.dataCorrupted("\(context.debugDescription)"))
                } catch let DecodingError.keyNotFound(key, context) {
                    return .failure(APIParseError.keyNotFound("\(key)", context.codingPath))
                } catch let DecodingError.valueNotFound(value, context) {
                    return .failure(APIParseError.valueNotFound("\(value)", context.codingPath))
                } catch let DecodingError.typeMismatch(type, context) {
                    return .failure(APIParseError.typeMismatch("\(type)", context.codingPath))
                } catch {
                    return .failure(APIParseError.custom("Unknown parsing error"))
                }
            }
        } else {
            return .failure(APIParseError.custom("No data to parse"))
        }
    }
}
