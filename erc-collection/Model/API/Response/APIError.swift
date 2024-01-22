//
//  APIError.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Foundation

enum APIError: Error {
    case apiResponseSourceError
    case urlCreateError
    case jsonDecoderDecodeError(APIParseError)
    case serverError(message: String)

    var description: String {
        switch self {
        case .apiResponseSourceError:
            return "API response source error"
        case .urlCreateError:
            return "Could not create URL from components"
        case let .serverError(message):
            return message
        case let .jsonDecoderDecodeError(error):
            return error.errorMessage
        }
    }
}
