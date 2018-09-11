//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public typealias HTTPParameters = [String: Any]
public typealias HTTPHeaders = [String: String]
typealias JSONDictionary = [String: Any]

public enum HTTPMethod: String, Equatable {
    case GET
    case POST
    case PUT
    case DELETE

    func toString() -> String {
        return rawValue
    }
}

public struct ApiRequest: Equatable {
    
    let endpoint: String
    let method: HTTPMethod
    let parameters: HTTPParameters?
    let headers: HTTPHeaders?

    public init(endpoint: String, method: HTTPMethod, parameters: HTTPParameters? = nil, headers: HTTPHeaders? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }

    init(endpoint: String, method: HTTPMethod, headers: HTTPHeaders? = nil, object: Encodable) {
        self.init(endpoint: endpoint, method: method, parameters: object.dictionary, headers: headers)
    }
    
    public static func == (lhs: ApiRequest, rhs: ApiRequest) -> Bool {
        let equalParameters: Bool
        switch (lhs.parameters, rhs.parameters) {
            case (nil, nil):
                equalParameters = true
            case let (leftParameters?, rightParameters?):
                equalParameters = NSDictionary(dictionary: leftParameters).isEqual(to: rightParameters)
            default:
                equalParameters = false
        }
        
        return lhs.endpoint == rhs.endpoint &&
            lhs.method == rhs.method &&
            lhs.headers == rhs.headers &&
            equalParameters
    }
}

public enum ApiError: Error {
    case cannotParseData(String)
    case network
    case http(Int)
    case cannotBuildRequest
}

extension ApiError: Equatable {

    public static func ==(lhs: ApiError, rhs: ApiError) -> Bool {
        switch (lhs, rhs) {
            case (.cannotParseData(let lDescription), .cannotParseData(let rDescription)):
                return lDescription == rDescription
            case (.http(let lCode), .http(let rCode)):
                return lCode == rCode
            case (.network, .network):
                return true
            case (.cannotBuildRequest, .cannotBuildRequest):
                return true
            default:
                return false
        }
    }
}

protocol ApiDataSource {
    func send<T:Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void)
    func download(fromURL url: URL, completion: @escaping(Result<Data, ApiError>) -> Void)
}
