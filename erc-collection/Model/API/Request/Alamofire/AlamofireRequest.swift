//
//  AlamofireRequest.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Alamofire

protocol AlamofireRequest {
    var baseUrl: URL? { get }

    var apiPath: String { get }

    var apiVersion: APIVersion { get }

    var url: URL? { get }

    var KeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }

    var method: Alamofire.HTTPMethod { get }

    var headers: Alamofire.HTTPHeaders? { get }

    var encoding: ParameterEncoding { get }

    var parameters: Parameters? { get }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

extension AlamofireRequest where Self: Encodable {
    var parameters: Parameters? {
        return self.parameters(keyEncodingStrategy: KeyEncodingStrategy)
    }
}

extension AlamofireRequest {
    var queryItems: [URLQueryItem]? { return nil }

    var encoding: ParameterEncoding {
        method == .get ? URLEncoding.default : JSONEncoding.default
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }

    var KeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return .useDefaultKeys
    }

    var headers: HTTPHeaders? {
        var headers = HTTPHeaders()
        headers.add(HTTPHeader.contentType("application/json"))
        headers.add(HTTPHeader.accept("Accept"))
        return headers
    }

    var url: URL? {
        guard let baseUrl = baseUrl else {
            return nil
        }

        if var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) {
            urlComponents.path = "/\(apiVersion.versionString)/\(apiPath)"
            return urlComponents.url
        } else {
            return nil
        }
    }
}

// MARK: - Extensions

extension Encodable {
    func parameters(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy? = nil) -> Parameters? {
        if let data = data(keyEncodingStrategy: keyEncodingStrategy) {
            return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? Parameters }
        } else {
            return nil
        }
    }

    func data(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy? = nil) -> Data? {
        let jsonEncoder = JSONEncoder()
        if let keyEncodingStrategy = keyEncodingStrategy {
            jsonEncoder.keyEncodingStrategy = keyEncodingStrategy
        }
        return try? jsonEncoder.encode(self)
    }
}
