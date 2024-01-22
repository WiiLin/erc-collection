//
//  AlamofireRequestHandler.swift
//  erc-collection
//
//  Created by SHI-BO LIN on 2024/1/22.
//

import Alamofire
import Foundation
import PromiseKit

public typealias ProgressHandler = (Progress) -> Void

class AlamofireRequestHandler {
    private lazy var parseHandler = APIParseHandler()

    private let sessionManager: Session = {
        let session = Session.default
        session.session.configuration.timeoutIntervalForRequest = 60
        return session
    }()

    func request<ApiRequest: AlamofireRequest, ApiResponse: Swift.Decodable>(_ apiRequest: ApiRequest,
                                                                             responseType: ApiResponse.Type,
                                                                             uploadProgress: ProgressHandler? = nil,
                                                                             completionHandler: @escaping (Swift.Result<ApiResponse, APIError>) -> Void) {
        firstly {
            self.generateDataRequest(apiRequest: apiRequest)
        }
        .then { dataRequest in
            self.shotRequest(apiRequest, responseType: responseType, dataRequest: dataRequest)
        }
        .done { obj in
            completionHandler(.success(obj))
        }
        .catch { error in
            completionHandler(.failure(error as! APIError))
        }
        .finally {}
    }
}

// MARK: - Private

private extension AlamofireRequestHandler {
    func generateDataRequest(apiRequest: AlamofireRequest) -> Promise<DataRequest> {
        guard let url = apiRequest.url else {
            return .init(error: APIError.urlCreateError)
        }

        let headers: HTTPHeaders = apiRequest.headers ?? HTTPHeaders()

        let request: DataRequest = sessionManager.request(url,
                                                          method: apiRequest.method,
                                                          parameters: apiRequest.parameters,
                                                          encoding: apiRequest.encoding,
                                                          headers: headers,
                                                          interceptor: self)

        return .value(request)
    }

    func shotRequest<ApiRequest: AlamofireRequest, ApiResponse: Swift.Decodable>(_ apiRequest: ApiRequest,
                                                                                 responseType: ApiResponse.Type,
                                                                                 dataRequest: DataRequest) -> Promise<ApiResponse> {
        var apiLog: String?

        return Promise { real in

            firstly {
                self.request(dataRequest: dataRequest, apiRequest: apiRequest, uploadProgress: { _ in },
                             responseRawData: { [weak self] data in
                                 apiLog = self?.apiLog(response: data, apiRequest: apiRequest)
                             })
            }
            .then { data in
                self.handleResponseData(apiRequest, responseType: responseType, data: data)
            }
            .done { obj in
                real.fulfill(obj)
            }
            .catch { error in
                real.reject(error)
            }
            .finally {
                if let apiLog = apiLog {
                    print(apiLog)
                }
            }
        }
    }

    func request(dataRequest: DataRequest, apiRequest: AlamofireRequest, uploadProgress: @escaping ProgressHandler, responseRawData: ((AFDataResponse<Data?>) -> Void)?) -> Promise<Data?> {
        return Promise { real in
            dataRequest
                .validate(statusCode: 200 ..< 400)
                .uploadProgress(closure: uploadProgress)
                .response { [weak self] response in
                    guard let self = self else { return }
                    responseRawData?(response)
                    switch response.result {
                    case let .success(response):
                        real.fulfill(response)
                    case let .failure(error):
                        real.reject(errorResponseParse(data: response.data, code: response.response?.statusCode, apiRequest: apiRequest) ?? APIError.error(error: error))
                    }
                }
        }
    }

    func handleResponseData<ApiRequest: AlamofireRequest, ApiResponse: Swift.Decodable>(_ apiRequest: ApiRequest,
                                                                                        responseType: ApiResponse.Type,
                                                                                        data: Data?) -> Promise<ApiResponse> {
        if let data = data {
            let parseResult = parseHandler.parse(data, keyDecodingStrategy: apiRequest.keyDecodingStrategy, responseType: responseType)
            switch parseResult {
            case let .success(decodable):
                return .value(decodable)
            case let .failure(parseResponseTypeError):
                return .init(error: APIError.jsonDecoderDecodeError(parseResponseTypeError))
            }
        } else if responseType is String.Type {
            return .value("" as! ApiResponse)
        } else if responseType is EmptyResponse.Type {
            return .value(EmptyResponse() as! ApiResponse)
        } else {
            return .init(error: APIError.apiResponseSourceError)
        }
    }

    func errorResponseParse(data: Data?, code: Int?, apiRequest: AlamofireRequest) -> APIError? {
        if let data = data {
            let parseResult = parseHandler.parse(data, keyDecodingStrategy: apiRequest.keyDecodingStrategy, responseType: String.self)
            switch parseResult {
            case let .success(object):
                let error: APIError = .serverError(message: object)
                return error
            case let .failure(error):
                return .jsonDecoderDecodeError(error)
            }
        } else {
            return nil
        }
    }

    @discardableResult
    func apiLog(response: AFDataResponse<Data?>, apiRequest: AlamofireRequest) -> String {
        var logs: [String] = []
        logs.append("🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻")
        logs.append("✈️ \(response.request?.url?.absoluteString ?? "")")
        logs.append("⚙️ \(apiRequest.method.rawValue)")
        let allHTTPHeaderFields = response.request?.allHTTPHeaderFields ?? [:]
        logs.append("📇 \(allHTTPHeaderFields)")

        let parameters = apiRequest.parameters ?? [:]
        logs.append("🎒 \(parameters)")

        let statusCode = response.response?.statusCode
        if let statusCode = statusCode {
            logs.append("🚥 \(statusCode)")
        } else {
            logs.append("🚥 unknown")
        }

        if let data = response.data {
            logs.append("🎁 \(String(decoding: data, as: UTF8.self))")
        }
        logs.append("🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻")
        let string = logs.joined(separator: "\n")
        return string
    }
}

// MARK: - RequestInterceptor

extension AlamofireRequestHandler: RequestInterceptor {
    public func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }

    public func retry(_ request: Alamofire.Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetryWithError(error))
    }
}

private extension APIError {
    static func error(error: Error) -> APIError {
        if let error = error.asAFError {
            return afError(error: error)
        } else {
            return Self.nsError(error: error as NSError)
        }
    }

    static func nsError(error: NSError) -> APIError {
        return .serverError(message: error.localizedDescription)
    }

    static func afError(error: AFError) -> APIError {
        if let urlError = error.underlyingError as? URLError {
            let code = urlError.code
            return .serverError(message: "urlError(\(code.rawValue)")
        } else {
            let message = error.errorDescription ?? error.localizedDescription
            return .serverError(message: message)
        }
    }
}
